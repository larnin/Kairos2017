using System;
using UnityEngine;

public class CardObtainedEvent : EventArgs
{
    public string cardName;
    public string cardDescription;

    public CardObtainedEvent(string _cardName, string _cardDescription)
    {
        cardName = _cardName;
        cardDescription = _cardDescription;
    }
}

