using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class CardData
{
    public CardData(string _name, string _description)
    {
        name = _name;
        description = _description;
    }

    public string name;
    public string description;
}

public class StoryData
{

}


public class InventoryData
{
    private List<CardData> m_cards;
    private List<StoryData> m_story;


}