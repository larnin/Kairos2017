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
    private RessourcesData m_ressourcesData = new RessourcesData();
    private LoopSystem m_loopSystem = new LoopSystem();
    private GameManagerLogic m_gameManager = null;

    public static G sys
    {
        get
        {
            if (G.m_instance == null)
                G.m_instance = new G();
            return G.m_instance;
        }
    }

    public SaveSystem saveSystem { get { return m_saveSystem; } }
    public RessourcesData ressourcesData { get { return m_ressourcesData; } }
    public LoopSystem loopSystem { get { return m_loopSystem; } }

    public GameManagerLogic gameManager
    {
        get { return m_gameManager; }
        set
        {
            if (m_gameManager != null)
                Debug.LogError("2 GameManager instanciated !");
            m_gameManager = value;
        }
    }
}