using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public sealed class G2
{
    private static volatile G2 m_instance;

    private TrailerManager m_trailerManager;

    public static G2 sys
    {
        get
        {
            if (G2.m_instance == null)
                G2.m_instance = new G2();
            return G2.m_instance;
        }
    }

    public TrailerManager trailerManager
    {
        get { return m_trailerManager; }
        set
        {
            if (m_trailerManager != null)
                Debug.LogError("2 TrailerManager instanciated !");
            m_trailerManager = value;
        }
    }
}
