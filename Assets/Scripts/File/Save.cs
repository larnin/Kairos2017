using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[Serializable]
public class Save
{
    [Serializable]
    public class StoryBookItem
    {
        public StoryBookItem(string _category, string _story, StoryItem.VisibilityState _state)
        {
            category = _category;
            story = _story;
            state = _state;
        }

        public string category = "";
        public string story = "";
        public StoryItem.VisibilityState state = StoryItem.VisibilityState.HIDDEN;
    }

    [Serializable]
    public class CardBookItem
    {
        public CardBookItem(string _name, CardData.VisibilityState _state)
        {
            name = _name;
            state = _state;
        }

        public string name = "";
        public CardData.VisibilityState state = CardData.VisibilityState.HIDDEN;
    }

    public int version = 0;
    public List<StoryBookItem> storyItems = new List<StoryBookItem>();
    public List<CardBookItem> cardDatas = new List<CardBookItem>();

    public Save()
    {
        initializeStoryBookItem();
        initializeCardDatas();
    }

    void initializeStoryBookItem()
    {
        string assetName = "InventoryBook/Story";

        var text = Resources.Load<TextAsset>(assetName);
        if(text != null)
        {
            var items = JsonUtility.FromJson<StorySerializer>(text.text);
            if(items != null)
            {
                storyItems = new List<StoryBookItem>();
                foreach(var i in items.categories)
                    foreach (var j in i.items)
                        storyItems.Add(new StoryBookItem(i.categoryName, j.name, j.visibility));
            }
        }
    }

    void initializeCardDatas()
    {
        string assetName = "InventoryBook/Cards";

        var text = Resources.Load<TextAsset>(assetName);
        if(text != null)
        {
            var items = JsonUtility.FromJson<CardsSerializer>(text.text);
            if(items != null)
            {
                cardDatas = new List<CardBookItem>();
                foreach (var i in items.cards)
                    cardDatas.Add(new CardBookItem(i.name, i.visibility));
            }
        }
    }
}
