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

    public List<StoryBookItem> storyItems = new List<StoryBookItem>();

    public Save()
    {
        initializeStoryBookItem();
    }

    void initializeStoryBookItem()
    {
        string assetPath = "InventoryBook/";
        string assetName = "Story.json";

        var text = Resources.Load<TextAsset>(assetPath + assetName);
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
}
