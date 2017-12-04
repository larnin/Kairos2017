using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
 
public class CardItemLogic : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler
{
    [SerializeField] Color m_selectColor = Color.green;
    [SerializeField] Color m_hoverColor = new Color(1, 0.5f, 0);

    Image m_outline;
    Image m_image;
    string m_cardName;
    bool m_selected = false;
    bool m_hovered = false;

    Action<string> m_clickAction;
    Action<string> m_hoverAction;
    Action<string> m_hoverExitAction;

    private void Awake()
    {
        m_outline = GetComponent<Image>();
        m_image = transform.Find("Render").GetComponent<Image>();
        selected = false;
        hovered = false;
    }

    public void set(string textureName, string name)
    {
        m_cardName = name;

        string imagePath = "InventoryBook/Cards/";
        Sprite s = Resources.Load<Sprite>(imagePath + textureName);
        m_image.sprite = s;
    }

    public Action<string> clickAction { set { m_clickAction = value; } }
    public Action<string> hoverAction { set { m_hoverAction = value; } }
    public Action<string> hoverExitAction { set { m_hoverExitAction = value; } }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (m_clickAction != null)
            m_clickAction(m_cardName);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        if (m_hoverAction != null)
            m_hoverAction(m_cardName);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        if (m_hoverExitAction != null)
            m_hoverExitAction(m_cardName);
    }
    public bool selected
    {
        get { return m_selected; }
        set
        {
            m_selected = value;
            if (!m_selected)
                hovered = m_hovered;
            else
                m_outline.color = m_selectColor;
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
                m_outline.color = m_hoverColor;
            else m_outline.color = new Color(0, 0, 0, 0);
        }
    }

    public string cardName { get { return m_cardName; } }

    public Sprite image { get { return m_image.sprite; } }
}