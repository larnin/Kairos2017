using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

class CardPageLogic : MonoBehaviour
{
    [SerializeField] GameObject m_cardPrefab;
    [SerializeField] Vector2 m_cardListOrigine;
    [SerializeField] Vector2 m_cardOffset;

    List<CardData> m_cards = new List<CardData>();
    List<GameObject> m_cardsObjects = new List<GameObject>();

    Text m_cardTitle;
    Image m_cardRender;
    Text m_cardDescription;

    private void Start()
    {
        
    }

    void loadCardData()
    {

    }

    void instanciateAllCards()
    {

    }
}
