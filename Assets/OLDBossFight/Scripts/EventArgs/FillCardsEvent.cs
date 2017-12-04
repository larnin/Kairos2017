using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class FillCardsEvent : EventArgs
{
    public FillCardsEvent(List<CardData> _cards)
    {
        cards = _cards;
    }

    public List<CardData> cards;
}
