using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using UnityEngine;

public sealed class G
{
    private static volatile G m_instance;
    private SaveSystem m_saveSystem = new SaveSystem();
    private List<CardData> m_cards = null;
    private List<StoryCategory> m_story = null;

    public static G sys
    {
        get
        {
            if (G.m_instance == null)
                G.m_instance = new G();
            return G.m_instance;
        }
    }

    public G()
    {
        initCards();
        initStory();
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
            else Debug.LogError("Can't parse story asset !");
        }
        else Debug.LogError("Can't load story asset !");
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

    public SaveSystem saveSystem { get { return m_saveSystem; } }

    public ReadOnlyCollection<CardData> getDefaultCardsList()
    {
        return new ReadOnlyCollection<CardData>(m_cards);
    }

    public ReadOnlyCollection<StoryCategory> getDefaultStory()
    {
        return new ReadOnlyCollection<StoryCategory>(m_story);
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

    public StoryItem.VisibilityState getStoryItemState(string category, string itemName, StoryItem.VisibilityState defaultValue = StoryItem.VisibilityState.HIDDEN)
    {
        return (StoryItem.VisibilityState)saveSystem.getInt("Story." + category + "." + itemName, (int)defaultValue);
    }

    public void setStoryItemState(string category, string itemName, StoryItem.VisibilityState state)
    {
        saveSystem.set("Story." + category + "." + itemName, (int)state);
    }

    public CardData.VisibilityState getCardState(string cardName, CardData.VisibilityState defaultValue = CardData.VisibilityState.HIDDEN)
    {
        return (CardData.VisibilityState)saveSystem.getInt("Card." + cardName, (int)defaultValue);
    }

    public void setCardState(string cardName, CardData.VisibilityState state)
    {
        saveSystem.set("Card." + cardName, (int)state);
    }
}