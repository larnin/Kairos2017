using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public abstract class MenuSubmenu
{
    private MenuPageLogic m_menu;

    public MenuSubmenu(MenuPageLogic menu)
    {
        m_menu = menu;
    }

    public void enable()
    {
        onEnable();
    }

    protected abstract void onEnable();

    public void disable()
    {
        m_menu.disableSubmenu(this);
        onDisable();
    }

    protected abstract void onDisable();

    public void update()
    {
        onUpdate();
    }

    protected abstract void onUpdate();
}
