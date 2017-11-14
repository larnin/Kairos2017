using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public sealed class G
{
    private static volatile G m_instance;
    private InventoryData m_inventory = new InventoryData();

    public static G sys
    {
        get
        {
            if (G.m_instance == null)
                G.m_instance = new G();
            return G.m_instance;
        }
    }

    public InventoryData inventory { get { return m_inventory; } }
}