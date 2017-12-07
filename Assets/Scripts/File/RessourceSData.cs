using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class RessourcesData
{
    private List<CardData> m_cards = null;
    private List<StoryCategory> m_story = null;
    private List<LoopInfo> m_loops = null;

    public List<CardData> defaultCardsList { get { return m_cards; } }
    public List<StoryCategory> defaultStory { get { return m_story; } }
    public List<LoopInfo> loops { get { return m_loops; } }

    public RessourcesData()
    {
        initCards();
        initStory();
        initLoops();
    }

    void initCards()
    {
        string assetName = "InventoryBook/Cards";

        var text = Resources.Load<TextAsset>(assetName);
        if (text != null)
        {
            var items = JsonUtility.FromJson<CardsSerializer>(text.text);
            if (items != null)
                m_cards = items.cards;
            else Debug.LogError("Can't parse cards asset !");
        }
        else Debug.LogError("Can't load cards asset !");
    }

    void initStory()
    {
        string assetName = "InventoryBook/Story";

        var text = Resources.Load<TextAsset>(assetName);
        if (text != null)
        {
            var items = JsonUtility.FromJson<StorySerializer>(text.text);
            if (items != null)
                m_story = items.categories;
            else Debug.LogError("Can't parse story asset !");
        }
        else Debug.LogError("Can't load story asset !");
    }

    void initLoops()
    {
        string assetName = "Loops";

        var text = Resources.Load<TextAsset>(assetName);
        if (text != null)
        {
            var items = JsonUtility.FromJson<LoopSerializer>(text.text);
            if (items != null)
                m_loops = items.loops;
            else Debug.LogError("Can't parse loops asset !");
        }
        else Debug.LogError("Can't load loops asset !");
    }
    
    public CardData getCard(string name)
    {
        return m_cards.Find(x => { return x.name == name; });
    }

    public StoryCategory getStoryCategory(string category)
    {
        return m_story.Find(x => { return x.categoryName == category; });
    }

    public StoryItem GetStoryItem(string category, string item)
    {
        var c = getStoryCategory(category);
        if (c == null)
            return null;
        return c.items.Find(x => { return x.name == item; });
    }
}
