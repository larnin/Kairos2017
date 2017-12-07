using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


static class SaveAttributes
{
    public static StoryItem.VisibilityState getStoryItemState(string category, string itemName, StoryItem.VisibilityState defaultValue = StoryItem.VisibilityState.HIDDEN)
    {
        return (StoryItem.VisibilityState)G.sys.saveSystem.getInt("Story." + category + "." + itemName, (int)defaultValue);
    }

    public static void setStoryItemState(string category, string itemName, StoryItem.VisibilityState state)
    {
        G.sys.saveSystem.set("Story." + category + "." + itemName, (int)state);
    }

    public static CardData.VisibilityState getCardState(string cardName, CardData.VisibilityState defaultValue = CardData.VisibilityState.HIDDEN)
    {
        return (CardData.VisibilityState)G.sys.saveSystem.getInt("Card." + cardName, (int)defaultValue);
    }

    public static void setCardState(string cardName, CardData.VisibilityState state)
    {
        G.sys.saveSystem.set("Card." + cardName, (int)state);
    }

    public static int getCurrentLoopIndex()
    {
        return G.sys.saveSystem.getInt("GameLoop", 0);
    }

    public static void setCurrentLoopIndex(int value)
    {
        G.sys.saveSystem.set("GameLoop", value);
    }
}
