﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class BossTextLogic : Interactable
{
    [SerializeField] string m_text = "Name";

    [SerializeField] Color m_hoveredColor = new Color(1, 0.5f, 0);
    [SerializeField] Color m_basicColor = new Color(1, 1, 1);
    [SerializeField] Color m_selectedColor = new Color(0, 1, 0);

    bool m_hovered = false;
    Text m_textComp = null;
    TextMeshProUGUI m_textTMPComp = null;

    bool m_selected = false;

    public bool hovered
    {
        get { return m_hovered; }
        set
        {
            m_hovered = value;
            if (!m_selected)
            {
                if (m_textComp != null)
                    m_textComp.color = m_hovered ? m_hoveredColor : m_basicColor;
                if (m_textTMPComp != null)
                    m_textTMPComp.color = m_hovered ? m_hoveredColor : m_basicColor;
            }

        }
    }

    public bool selected
    {
        get { return m_selected; }
        set
        {
            m_selected = value;
            if (m_textComp != null)
                m_textComp.color = m_selected ? m_selectedColor : hovered ? m_hoveredColor : m_basicColor ;
            if (m_textTMPComp != null)
                m_textTMPComp.color = m_selected ? m_selectedColor : hovered ? m_hoveredColor : m_basicColor;

            if (m_selected)
                Event<SelectSentenseEvent>.Broadcast(new SelectSentenseEvent(this));
        }
    }

    public string text
    {
        get { return m_text; }
        set
        {
            m_text = value;
            if (m_textComp != null)
                m_textComp.text = m_text;
            else if (m_textTMPComp != null)
                m_textTMPComp.text = m_text;
        }
    }

    public override void hoverEnter()
    {
        hovered = true;
    }

    public override void hoverExit()
    {
        hovered = false;
    }

    public override void select()
    {
        selected = true;
    }

    void Awake()
    {
        m_textComp = transform.GetComponent<Text>();
        m_textTMPComp = GetComponent<TextMeshProUGUI>();
        if (m_textComp != null)
            m_textComp.text = m_text;
        else if(m_textTMPComp != null)
            m_textTMPComp.text = m_text;
    }

    private void OnValidate()
    {
        var textComp = transform.GetComponent<Text>();
        if (textComp != null)
            textComp.text = m_text;
        else
        {
            var textComp2 = transform.GetComponent<TextMeshProUGUI>();
            if (textComp2 != null)
                textComp2.text = m_text;
        }
    }
}