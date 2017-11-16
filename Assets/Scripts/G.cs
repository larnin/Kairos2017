using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public sealed class G
{
    private static volatile G m_instance;
    private SaveSystem m_saveSystem = new SaveSystem();

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
}