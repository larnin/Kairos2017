using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SelectablePlaceLogic : InteractableBaseLogic
{
    private Color m_baseColor;
    private bool m_isSelected = false;
    private FindTheWayOnMap m_findTheWayOnMap;
    private Text m_textUI;
    private Renderer m_renderer;

    public override void onDrag(DragData data, OrigineType type)
    {
       // no used for this class
    }

    public override void onEnter(OrigineType type, Vector3 localPosition)
    {
        if (m_findTheWayOnMap.isMaxNotReached() && !m_isSelected)
        {
            m_renderer.material.color = m_findTheWayOnMap.m_selectableColor;
        }
    }

    public override void onExit(OrigineType type)
    {
        if (m_findTheWayOnMap.isMaxNotReached() && !m_isSelected)
        {
            m_renderer.material.color = m_baseColor;
        }
    }

    public override void onInteract(OrigineType type, Vector3 localPosition)
    {
        int number = m_findTheWayOnMap.addPlace(this);
        if (number != -1)
        {
            m_renderer.material.color = m_findTheWayOnMap.m_selectedColor;
            m_isSelected = true;
            m_textUI.enabled = true;
            m_textUI.text = number.ToString();
        }
    }

    public override void onInteractEnd(OrigineType type)
    {
        // no used for this class
    }

    public void reset()
    {
        if (m_renderer.material.color == m_findTheWayOnMap.m_selectedColor)
        {
            m_renderer.material.color = m_baseColor;
        }

        m_isSelected = false;
        m_textUI.enabled = false;
    }

    // Use this for initialization
    void Start()
    {
        m_renderer = GetComponent<Renderer>();
        m_baseColor = m_renderer.material.color;
        m_findTheWayOnMap = transform.parent.GetComponent<FindTheWayOnMap>();
        m_textUI = transform.GetChild(0).GetComponent<Text>();
        m_textUI.enabled = false;
    }
}
