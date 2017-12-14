using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using NRand;
using TMPro;
using DG.Tweening;

public class CardManagerLogic : MonoBehaviour
{
    const string horisontalAxisName = "Horizontal";
    const string selectButtonName = "Fire1";
    const string abortButtonName = "Fire2";

    [SerializeField] GameObject m_cardTemplate;
    [SerializeField] GameObject m_bossTextTemplate;
    [SerializeField] float m_maxCardDelta = 400f;
    [SerializeField] float m_maxCardWidth = 1500f;
    [SerializeField] float m_cardOffset = 0f;
    [SerializeField] float m_maxSentensesWidth = 500f;
    [SerializeField] float m_maxSentensesHeight = 500f;
    [SerializeField] float m_sentensesOffset = 500f;

    List<CardLogic> m_cards = new List<CardLogic>();
    List<BossTextLogic> m_bossText = new List<BossTextLogic>();
    Text m_descriptionComp = null;

    int m_hoveredCardIndex = 0;
    int m_hoveredSentenseIndex = -1;
    bool m_cardSelected = false;
    bool m_sentenseSelected = false;

    uint m_currentTry = 1;

    SubscriberList m_subscriberList = new SubscriberList();

    private void Awake()
    {
        m_descriptionComp = transform.Find("Description").GetComponent<Text>();

        //m_subscriberList.Add(new Event<InputEvent>.Subscriber(onInputEvent));
        m_subscriberList.Add(new Event<FillCardsEvent>.Subscriber(onFillCards));
        m_subscriberList.Add(new Event<ShowBossSentensesEvent>.Subscriber(onBossSentensesShow));
        m_subscriberList.Add(new Event<HideSentensesAndCardsEvent>.Subscriber(onHideCardsAndSentenses));
        m_subscriberList.Add(new Event<SelectCardEvent>.Subscriber(onSelectCard));
        m_subscriberList.Add(new Event<SelectSentenseEvent>.Subscriber(onSelectSentense));
        m_subscriberList.Add(new Event<ShowCardDescriptionEvent>.Subscriber(onShowDescription));
		m_subscriberList.Add(new Event<AnimateSentenceEvent>.Subscriber(onAnimateSentence));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    private void Start()
    {
        /*showCards(G.sys.inventory);
        showSentenses(new List<string>
        {
            "1, 2, 3 ...",
            "Il etait une fois",
            "Un fruit jaune et long",
            "Le president des etats unis",
            "Un doux kiwi"
        });*/
    }

    void showCards(List<CardData> cards)
    {
        m_currentTry++;
        foreach (var c in m_cards)
            Destroy(c.gameObject);
        m_cards.Clear();

        var delta = Mathf.Min(cards.Count <= 1 ? 0 : m_maxCardWidth / (cards.Count - 1), m_maxCardDelta);
        var offset = - (cards.Count - 1) * delta / 2;

        for (int i = 0; i < cards.Count; i++)
        {
            var card = GameObject.Instantiate(m_cardTemplate, Vector3.Scale(new Vector3(offset + delta * i, m_cardOffset, 0), transform.lossyScale) + transform.position, Quaternion.identity, transform);
            var cardlogic = card.GetComponent<CardLogic>();
            if(cardlogic == null)
            {
                Destroy(card);
                Debug.LogError("The card don't have a CardLogic !");
                continue;
            }
            cardlogic.text = cards[i].name;
            cardlogic.description = cards[i].description;
            m_cards.Add(cardlogic);
        }

        m_cardSelected = false;
        m_sentenseSelected = false;

        //hoverCard(0);
    }

    void showSentenses(List<string> sentenses)
    {
        foreach (var s in m_bossText)
            Destroy(s.gameObject);
        m_bossText.Clear();

        var delta = sentenses.Count <= 1 ? 0 : m_maxSentensesWidth / (sentenses.Count - 1);
        var offset = -(sentenses.Count - 1) * delta / 2;

        for (int i = 0; i < sentenses.Count; i++)
        {
            var posX = offset + delta * i;
            var posY = heightFromIndex(i, sentenses.Count);

            var sentense = GameObject.Instantiate(m_bossTextTemplate, Vector3.Scale(new Vector3(posX, posY + m_sentensesOffset, 0), transform.lossyScale) + transform.position, Quaternion.identity, transform);
            var textLogic = sentense.GetComponent<BossTextLogic>();
            if (textLogic == null)
            {
                Destroy(sentense);
                Debug.LogError("The boss sentense don't have a BossTextLogic !");
                continue;
            }
            textLogic.text = sentenses[i];
            m_bossText.Add(textLogic);
        }
    }

    void hoverCard(int index)
    {
        if (index < 0 || index >= m_cards.Count)
            return;

        foreach (var c in m_cards)
            c.hovered = false;
        m_cards[index].hovered = true;
        m_descriptionComp.text = m_cards[index].description;
        m_hoveredCardIndex = index;
    }

    void hoverSentense(int index)
    {
        foreach (var s in m_bossText)
            s.hovered = false;

        if (index < 0 || index >= m_bossText.Count)
        {
            m_hoveredSentenseIndex = -1;
            return;
        }

        m_bossText[index].hovered = true;
        m_hoveredSentenseIndex = index;
    }

    void onInputEvent(InputEvent e)
    {
        if (e.inputType == InputEvent.InputType.PRESSED)
        {
            if (e.inputName == horisontalAxisName)
            {
                if (!m_cardSelected)
                    hoverCard(Mathf.Clamp(m_hoveredCardIndex + e.inputSign, 0, m_cards.Count - 1));
                else if (!m_sentenseSelected)
                    hoverSentense(Mathf.Clamp(m_hoveredSentenseIndex + e.inputSign, 0, m_bossText.Count - 1));
            }
        }

        if(e.inputType == InputEvent.InputType.RELEASED)
        {
            if(e.inputName == selectButtonName)
            {
                if(!m_cardSelected)
                {
                    if (m_cards.Count > 0)
                    {
                        m_cardSelected = true;
                        hoverSentense(0);
                    }
                }
                else if(!m_sentenseSelected)
                {
                    if(m_bossText.Count > 0)
                    {
                        m_sentenseSelected = true;
                        Event<CardAndSentenseSelectedEvent>.Broadcast(new CardAndSentenseSelectedEvent(m_cards[m_hoveredCardIndex].text, m_bossText[m_hoveredSentenseIndex].text, m_hoveredCardIndex, m_hoveredSentenseIndex));
                    }
                }
            }
            else if(e.inputName == abortButtonName)
            {
                if (m_sentenseSelected)
                    return;
                if(m_cardSelected)
                {
                    m_cardSelected = false;
                    hoverSentense(-1);
                }
            }
        }
    }

    void onFillCards(FillCardsEvent e)
    {
        showCards(e.cards);
    }

    void onBossSentensesShow(ShowBossSentensesEvent e)
    {
        showSentenses(e.sentenses);
    }

    void onHideCardsAndSentenses(HideSentensesAndCardsEvent e)
    {
        foreach (var c in m_cards)
            Destroy(c.gameObject);
        m_cards.Clear();

        foreach (var s in m_bossText)
            Destroy(s.gameObject);
        m_bossText.Clear();

        m_hoveredCardIndex = -1;
        m_hoveredSentenseIndex = -1;
    }

    void onSelectCard(SelectCardEvent e)
    {
        foreach(var c in m_cards)
        {
            if (c == e.card)
                continue;
            c.selected =false;
        }

        if (m_cardSelected && m_sentenseSelected)
            return;

        m_cardSelected = true;

        if (m_cardSelected && m_sentenseSelected)
            endRound();
    }

    void onSelectSentense(SelectSentenseEvent e)
    {
        foreach (var s in m_bossText)
        {
            if (s == e.sentense)
                continue;
            s.selected = false;
        }

        if (m_cardSelected && m_sentenseSelected)
            return;

        m_sentenseSelected = true;

        if (m_cardSelected && m_sentenseSelected)
            endRound();
    }

    void onShowDescription(ShowCardDescriptionEvent e)
    {
        m_descriptionComp.text = e.description;
    }

    void endRound()
    {
        int cardIndex = -1;
        int sentenseIndex = -1;

        for (int i = 0; i < m_cards.Count; i++)
            if (m_cards[i].selected)
                cardIndex = i;

        for (int i = 0; i < m_bossText.Count; i++)
            if (m_bossText[i].selected)
                sentenseIndex = i;

        if (cardIndex < 0 || sentenseIndex < 0)
            return;

        Event<CardAndSentenseSelectedEvent>.Broadcast(new CardAndSentenseSelectedEvent(m_cards[cardIndex].text, m_bossText[sentenseIndex].text, cardIndex, sentenseIndex));
    }

    private float heightFromIndex(int value, int max)
    {
        List<int> indexs = new List<int>();
        for (int i = 0; i < max; i++)
            indexs.Add(i);

        MT19937 rand = new MT19937(m_currentTry);
        UniformIntDistribution distrib = new UniformIntDistribution(0, max-1);

        for(int i = 0; i < max ; i++)
        {
            var a = distrib.Next(rand);
            var temp = indexs[a];
            indexs[a] = indexs[i];
            indexs[i] = temp;
        }

        return indexs[value] / (float)max * m_maxSentensesHeight;

        /*bool maxpair = max % 2 == 0;
        bool valueMoreThanHalfMax = false;
        value++;
        if (maxpair)
            max++;

        int halfMax = max / 2 + 1;

        if (value >= halfMax)
        {
            valueMoreThanHalfMax = true;
            value = value - halfMax;
        }

        float valueNormalized = 1 - ((float)value / halfMax);
        if (valueMoreThanHalfMax)
            valueNormalized -= 1f / max;

        float sign = (value % 2) == 0 ? -1f : 1f;

        return sign * valueNormalized * m_maxSentensesHeight / 2;*/
    }

	void onAnimateSentence(AnimateSentenceEvent e)
	{
		var sentense = m_bossText[e.sentenseIndex];
		if (e.type == PowFeedbackLogic.FeedbackType.RIGHT)
		{
			sentense.GetComponent<HackBehavior>().enabled = true;
			}
		else
		{
			sentense.GetComponent<TextMeshProUGUI>().color = Color.red;
		}
	}
}