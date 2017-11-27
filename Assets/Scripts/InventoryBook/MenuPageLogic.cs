using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MenuPageLogic : MonoBehaviour
{
    string verticalAxis = "Vertical";
    string acceptButton = "Submit";
    float axisThreshold = 0.6f;

    string controlsMenuName = "Controls";
    string optionsMenuName = "Options";

    List<MenuButtonLogic> m_buttons = new List<MenuButtonLogic>();
    float m_oldVerticalAxisValue = 0;
    InventoryBookLogic m_inventoryBook;
    Dictionary<string, MenuSubmenu> m_submenus = new Dictionary<string, MenuSubmenu>();
    MenuSubmenu m_currentSubmenu = null;

    private void Awake()
    {
        var buttons = transform.Find("Buttons");
        for (int i = 0; i < buttons.childCount; i++)
        {
            var comp = buttons.GetChild(i).GetComponent<MenuButtonLogic>();
            if (comp != null)
                m_buttons.Add(comp);
        }

        m_inventoryBook = transform.parent.GetComponent<InventoryBookLogic>();
        initializeSubmenus();
    }

    void initializeSubmenus()
    {
        m_submenus.Add(controlsMenuName, new ControlesSubmenu(this, transform.Find("Submenus").Find(controlsMenuName).gameObject));
        m_submenus.Add(optionsMenuName, new OptionsSubmenu(this, transform.Find("Submenus").Find(optionsMenuName).gameObject));

    }

    private void Update()
    {
        if (m_currentSubmenu != null)
        {
            m_currentSubmenu.update();
        }
        else
        {
            var value = Input.GetAxisRaw(verticalAxis);
            var direction = value > axisThreshold && m_oldVerticalAxisValue < axisThreshold ? -1 : value < -axisThreshold && m_oldVerticalAxisValue > -axisThreshold ? 1 : 0;
            m_oldVerticalAxisValue = value;
            if (direction != 0)
            {
                var old = getCurrentSelected();
                var current = Mathf.Clamp(old + direction, 0, m_buttons.Count - 1);
                if (old >= 0)
                    m_buttons[old].hovered = false;
                m_buttons[current].hovered = true;
            }

            if (Input.GetButtonDown(acceptButton))
            {
                var current = getCurrentSelected();
                if (current >= 0)
                    m_buttons[current].select();
            }
        }
    }

    public void onResume()
    {
        disableCurrentSubmenu();
        Event<PauseEvent>.Broadcast(new PauseEvent(false));
        Destroy(transform.parent.gameObject);
    }

    public void onOptions()
    {
        openSubmenu(optionsMenuName);
    }

    public void onControles()
    {
        openSubmenu(controlsMenuName);
    }

    public void onQuit()
    {
        disableCurrentSubmenu();
        Application.Quit();
    }

    int getCurrentSelected()
    {
        for (int i = 0; i < m_buttons.Count; i++)
            if (m_buttons[i].hovered)
                return i;
        return -1;
    }

    void openSubmenu(string name)
    {
        if (!m_submenus.ContainsKey(name))
        {
            Debug.LogError("There are no " + name + " submenu !");
            return;
        }
        var menu = m_submenus[name];
        if (menu == m_currentSubmenu)
            return;
        if (m_currentSubmenu != null)
            m_currentSubmenu.disable();
        m_inventoryBook.blockCancel = true;
        m_currentSubmenu = menu;
        m_currentSubmenu.enable();
    }

    void disableCurrentSubmenu()
    {
        if (m_currentSubmenu != null)
            m_currentSubmenu.disable();
    }

    public void disableSubmenu(MenuSubmenu menu)
    {
        if (menu != m_currentSubmenu)
            return;
        m_currentSubmenu = null;
        m_inventoryBook.blockCancel = false;

        foreach (var b in m_buttons)
            b.Unselect();
    }
}
