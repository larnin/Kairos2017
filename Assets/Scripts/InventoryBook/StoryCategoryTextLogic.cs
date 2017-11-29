using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class StoryCategoryTextLogic : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler
{
    [SerializeField] Color m_hoveredColor;
    [SerializeField] Color m_selectedColor;

    string m_categoryName = "";
    bool m_selected = false;
    bool m_hovered = false;

    Text m_text;
    Outline m_outline;

    Action<string> m_clickAction;
    Action<string> m_hoverAction;
    Action<string> m_hoverExitAction;
   
    private void Awake()
    {
        m_text = GetComponent<Text>();
        m_outline = GetComponent<Outline>();
        selected = false;
        hovered = false;
    }

    public void setText(string category, string fancyText)
    {
        m_text.text = fancyText;
        m_categoryName = category;
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (m_clickAction != null)
            m_clickAction(m_categoryName);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        if (m_hoverAction != null)
            m_hoverAction(m_categoryName);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        if (m_hoverExitAction != null)
            m_hoverExitAction(m_categoryName);
    }

    public string categoryName { get { return m_categoryName; } }

    public Action<string> clickAction { set { m_clickAction = value; } }
    public Action<string> hoverAction { set { m_hoverAction = value; } }
    public Action<string> hoverExitAction { set { m_hoverExitAction = value; } }

    public bool selected
    {
        get { return m_selected; }
        set
        {
            m_selected = value;
            if (!m_selected)
                hovered = m_hovered;
            else
                m_outline.effectColor = m_selectedColor;
        }
    }

    public bool hovered
    {
        get { return m_hovered; }
        set
        {
            m_hovered = value;
            if (m_selected)
                return;
            if (m_hovered)
                m_outline.effectColor = m_hoveredColor;
            else m_outline.effectColor = new Color(0, 0, 0, 0);
        }
    }
}