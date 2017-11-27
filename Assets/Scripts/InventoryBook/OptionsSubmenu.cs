using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class OptionsSubmenu : MenuSubmenu
{
    string returnButton = "Cancel";

    GameObject m_item;

    public OptionsSubmenu(MenuPageLogic menu, GameObject item) : base(menu)
    {
        m_item = item;
        loadProperties();
        m_item.SetActive(false);
    }

    void loadProperties()
    {

    }

    void saveProperties()
    {

    }

    protected override void onDisable()
    {
        saveProperties();
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
