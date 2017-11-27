using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class InventoryBookLogic : MonoBehaviour
{
    string leftPageButton = "Page Left";
    string rightPageButton = "Page Right";
    string returnButton = "Cancel";

    [SerializeField] float m_selectedOffset = 10;

    List<BookTabButton> m_buttons = new List<BookTabButton>();
    int m_currentIndex = -1;

    public bool blockCancel = false;

    private void Awake()
    {
        var tabs = transform.Find("Tabs");
        for (int i = 0 ; i < tabs.childCount; i++)
        {
            var item = tabs.GetChild(i);
            var buttonitem = item.GetComponent<BookTabButton>();
            if (buttonitem == null)
                continue;

            buttonitem.callback = onClickButton;
            m_buttons.Add(buttonitem);
        }

        initializePages();
    }

    void initializePages()
    {
        foreach(var b in m_buttons)
            b.page.SetActive(false);
        selectButton(0);
    }

    private void Update()
    {
        int index = m_currentIndex;
        if (Input.GetButtonDown(returnButton) && !blockCancel)
            resume();
        if (Input.GetButtonDown(rightPageButton))
            index += 1;
        if (Input.GetButtonDown(leftPageButton))
            index += -1;
        if (index < 0)
            index += m_buttons.Count;
        if (index >= m_buttons.Count)
            index -= m_buttons.Count;
        selectButton(index);
    }

    void resume()
    {
        Event<PauseEvent>.Broadcast(new PauseEvent(false));
        Destroy(gameObject);
    }

    void onClickButton(BookTabButton b)
    {
        selectButton(m_buttons.IndexOf(b));
    }

    void selectButton(int index)
    {
        if (index < 0 || index == m_currentIndex)
            return;
        if (m_currentIndex >= 0)
        {
            m_buttons[m_currentIndex].page.SetActive(false);
            m_buttons[m_currentIndex].transform.position += new Vector3(m_selectedOffset, 0, 0) * transform.lossyScale.x;
        }
        m_currentIndex = index;
        m_buttons[m_currentIndex].page.SetActive(true);
        m_buttons[m_currentIndex].transform.position += new Vector3(-m_selectedOffset, 0, 0) * transform.lossyScale.x;
    }
}