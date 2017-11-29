using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ControlesSubmenu : MenuSubmenu
{
    string returnButton = "Cancel";

    GameObject m_item;

    public ControlesSubmenu(MenuPageLogic menu, GameObject item) : base(menu)
    {
        m_item = item;
        m_item.SetActive(false);
    }

    protected override void onDisable()
    {
        m_item.SetActive(false);
    }

    protected override void onEnable()
    {
        m_item.SetActive(true);
    }

    protected override void onUpdate()
    {
        if (Input.GetButtonDown(returnButton))
            disable();
    }
}
