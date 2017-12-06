using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

class CardPageLogic : MonoBehaviour
{
    string verticalAxis = "Vertical";
    string horizontalAxis = "Horizontal";
    float axisThreshold = 0.6f;

    [SerializeField] GameObject m_cardPrefab;
    [SerializeField] Vector2 m_cardListOrigine;
    [SerializeField] Vector2 m_cardOffset;
    [SerializeField] int m_nbRow;
    [SerializeField] int m_nbColumn;

    List<CardData> m_cards = new List<CardData>();
    List<CardItemLogic> m_cardsObjects = new List<CardItemLogic>();
    List<CardItemLogic> m_currentObjects = new List<CardItemLogic>();

    GameObject m_upButton;
    GameObject m_downButton;

    Text m_cardTitle;
    Image m_cardRender;
    Text m_cardDescription;

    int m_currentRow = 0;
    int m_currentCardIndex = 0;

    Vector2 m_oldInput = Vector2.zero;

    private void Awake()
    {
        m_upButton = transform.Find("Up").gameObject;
        m_downButton = transform.Find("Down").gameObject;

        m_cardTitle = transform.Find("CardName").GetComponent<Text>();
        m_cardRender = transform.Find("CardVisual").GetComponent<Image>();
        m_cardDescription = transform.Find("CardDescription").GetComponent<Text>();
    }

    private void Start()
    {
        loadCardData();
        instanciateAllCards();
        if (m_cardsObjects.Count == 0)
            return;
        showCards(0);
        selectCard(m_cardsObjects[0].cardName);
    }

    private void Update()
    {
        if (m_cardsObjects.Count == 0)
            return;

        if (Input.mouseScrollDelta.y < 0)
            moveRow(1);
        else if (Input.mouseScrollDelta.y > 0)
            moveRow(-1);

        var value = new Vector2(Input.GetAxisRaw(horizontalAxis), Input.GetAxisRaw(verticalAxis));
        int x = value.x > axisThreshold && m_oldInput.x < axisThreshold ? 1 : value.x < -axisThreshold && m_oldInput.x > -axisThreshold ? -1 : 0;
        int y = value.y > axisThreshold && m_oldInput.y < axisThreshold ? -1 : value.y < -axisThreshold && m_oldInput.y > -axisThreshold ? 1 : 0;
        m_oldInput = value;

        if(x != 0 || y != 0)
        {
            exitHover();
            var iMod = m_currentCardIndex % m_nbColumn + x;
            if (iMod >= 0 && iMod < m_nbColumn)
                m_currentCardIndex += x;
            var iY = m_currentCardIndex + y * m_nbColumn;
            if (iY >= 0 && iY < m_cardsObjects.Count)
                m_currentCardIndex = iY;
            if (iY >= m_cardsObjects.Count)
                m_currentCardIndex = m_cardsObjects.Count - 1;
            selectCard(m_cardsObjects[m_currentCardIndex].cardName);
            var row = m_currentCardIndex / m_nbColumn;
            if (row < m_currentRow)
                moveRow(-1);
            if (row >= m_currentRow + m_nbRow)
                moveRow(1);
        }
    }

    void exitHover()
    {
        foreach (var c in m_cardsObjects)
            c.hovered = false;
    }


    void loadCardData()
    {
        string assetName = "InventoryBook/Cards";

        var text = Resources.Load<TextAsset>(assetName);
        if (text != null)
        {
            var items = JsonUtility.FromJson<CardsSerializer>(text.text);
            if (items != null)
                m_cards = items.cards;
            else Debug.LogError("Can't parse story asset !");
        }
        else Debug.LogError("Can't load story asset !");

        foreach (var c in m_cards)
            c.visibility = (CardData.VisibilityState)G.sys.saveSystem.getInt("Card." + c.name, (int)c.visibility);
    }

    void instanciateAllCards()
    {
        foreach(var c in m_cards)
        {
            if (c.visibility == CardData.VisibilityState.HIDDEN)
                continue;

            var card = Instantiate(m_cardPrefab, transform);
            var cardItem = card.GetComponent<CardItemLogic>();
            cardItem.set(c.textureName, c.name);
            cardItem.clickAction = selectCard;
            cardItem.hoverAction = onCardHover;
            cardItem.hoverExitAction = onCardHoverExit;
            card.SetActive(false);
            m_cardsObjects.Add(cardItem);
        }
    }

    public void moveRow(int offset)
    {
        showCards(m_currentRow + offset);
    }

    void showCards(int rowIndex)
    {
        if (m_cardsObjects.Count == 0)
            return;

        foreach (var card in m_currentObjects)
            card.gameObject.SetActive(false);
        m_currentObjects.Clear();
        m_currentRow = Mathf.Clamp(rowIndex, 0, maxRow());
        int begin = m_currentRow * m_nbColumn;
        int end = Mathf.Min(begin + m_nbRow * m_nbColumn, m_cardsObjects.Count);

        for(int i = 0; i < end - begin; i++)
        {
            int x = i % m_nbColumn;
            int y = i / m_nbColumn;
            var card = m_cardsObjects[i + begin];
            var pos = m_cardListOrigine - new Vector2(m_cardOffset.x * (m_nbColumn-1) / 2.0f, -m_cardOffset.y * (m_nbRow-1) / 2.0f)  + new Vector2(m_cardOffset.x * x, -m_cardOffset.y * y);
            card.transform.localPosition = pos;
            card.gameObject.SetActive(true);
            card.hovered = false;
            card.selected = false;
            m_currentObjects.Add(card);
        }
        m_cardsObjects[m_currentCardIndex].selected = true;

        updateArrows();
    }

    void updateArrows()
    {
        m_upButton.gameObject.SetActive(m_currentRow > 0);
        m_downButton.gameObject.SetActive(m_currentRow < maxRow());
    }

    void onCardHover(string cardName)
    {
        foreach (var c in m_currentObjects)
        {
            if (c.cardName == cardName)
                c.hovered = true;
            else c.hovered = false;
        }
    }

    void onCardHoverExit(string cardName)
    {
        foreach (var c in m_currentObjects)
        {
            if (c.cardName == cardName)
                c.hovered = false;
        }
    }

    void selectCard(string cardName)
    {
        for(int i = 0; i < m_cardsObjects.Count; i++)
        {
            var card = m_cardsObjects[i];
            if (card.cardName == cardName)
            {
                m_currentCardIndex = i;
                card.selected = true;

                foreach (var c in m_cards)
                    if (c.name == cardName)
                        updateBigCardRender(c, card);
            }
            else card.selected = false;
        }
    }

    void updateBigCardRender(CardData card, CardItemLogic item)
    {
        m_cardTitle.text = card.fancyName.Count() == 0 ? card.name : card.fancyName;
        m_cardRender.sprite = item.image;
        m_cardDescription.text = card.description;
    }

    int maxRow()
    {
        return Mathf.Max((m_cardsObjects.Count-1) / m_nbColumn - m_nbRow + 1, 0);
    }
}
