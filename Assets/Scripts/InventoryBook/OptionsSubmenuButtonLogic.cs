using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

class OptionsSubmenuButtonLogic : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler
{
    [SerializeField] Color m_hoveredColor;
    
    bool m_hovered = false;
    
    Outline m_outline;

    Action m_clickAction;

    private void Awake()
    {
        m_outline = GetComponent<Outline>();
        hovered = false;
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (m_clickAction != null)
            m_clickAction();
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        hovered = true;
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        hovered = false;
    }

    public Action clickAction { set { m_clickAction = value; } }

    public bool hovered
    {
        get { return m_hovered; }
        set
        {
            m_hovered = value;
            if (m_hovered)
                m_outline.effectColor = m_hoveredColor;
            else m_outline.effectColor = new Color(0, 0, 0, 0);
        }
    }
}
