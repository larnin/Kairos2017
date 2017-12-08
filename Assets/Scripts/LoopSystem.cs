using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class LoopSystem
{
    int m_loop = 0;

    public int currentLoop { get { return m_loop; } }

    public int essentialCardsFoundCount()
    {
        if (m_loop == 0)
            return 0;

        if (G.sys.ressourcesData.loops.Count <= m_loop - 1)
            return 0;

        var cards = G.sys.ressourcesData.loops[m_loop - 1].essentialCards;
        int count = 0;
        foreach (var c in cards)
            if (SaveAttributes.getCardState(c, CardData.VisibilityState.HIDDEN) == CardData.VisibilityState.VISIBLE)
                count++;
        return count;
    }

    public int essentialCardsCount()
    {
        if (m_loop == 0)
            return 0;

        if (G.sys.ressourcesData.loops.Count <= m_loop - 1)
            return 0;
        return G.sys.ressourcesData.loops[m_loop - 1].essentialCards.Count;
    }

    public void startNextLoop()
    {
        startLoop(m_loop + 1);
    }

    public void startLoop(int loop)
    {
        if (loop-1 >= G.sys.ressourcesData.loops.Count)
        {
            Debug.LogError("Can't load loop " + loop + ". There are only " + G.sys.ressourcesData.loops.Count + " loops configured.");
            return;
        }
        Event<LoadSceneEvent>.Broadcast(new LoadSceneEvent(G.sys.ressourcesData.loops[loop - 1].baseSceneName, ()=> { onSceneLoaded(loop); }));
    }

    void onSceneLoaded(int loop)
    {
        SaveAttributes.setCurrentLoopIndex(loop);
        m_loop = loop;
    }
}
