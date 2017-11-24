using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using UnityEngine.Events;
using UnityEngine.UI;

public class MenuButtonLogic : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler
{
    [SerializeField] UnityEvent m_clickEvent;
    [SerializeField] Color m_selectedColor = Color.green;
    [SerializeField] Color m_hoveredColor = new Color(1, 0.5f, 0);

    bool m_selected = false;
    bool m_hovered = false;

    Outline m_outline;

    private void Awake()
    {
        m_outline = GetComponent<Outline>();
        selected = false;
        hovered = false;
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        select();
    }

    public void select()
    {
        selected = true;
        for (int i = 0; i < transform.parent.childCount; i++)
        {
            var t = transform.parent.GetChild(i);
            if (t == transform)
                continue;
            var script = t.GetComponent<MenuButtonLogic>();
            if (script != null)
                script.Unselect();
        }
        m_clickEvent.Invoke();
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        hovered = true;
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        hovered = false;
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

    public void Unselect()
    {
        selected = false;
    }
}
