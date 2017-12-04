using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShadowTriggerSelectionLogic : TriggerBaseLogic
{
    private RumorsOfShadowsManager m_rumorsOfShadowsManager;
    private bool m_playerIsInside = false;
    public bool playerIsInside { get { return m_playerIsInside; } }

    private bool m_selected = false;
    public bool shadowIsSelected
    {
        get
        {
            return m_selected;
        }

        set
        {
            m_selected = value;
        }
    }

    private bool m_matched = false;
    public bool shadowIsMatched
    {
        get
        {
            return m_matched;
        }

        set
        {
            m_matched = value;
        }
    }
    
    public override void onEnter(TriggerInteractionLogic entity)
    {
       if(entity.tag == "Player")
       {
            m_playerIsInside = true;

            if (!m_matched && !m_selected)
            {
                m_rumorsOfShadowsManager.hoverShadow(transform, true);
            }
        }
    }

    public override void onExit(TriggerInteractionLogic entity)
    {
        if (entity.tag == "Player")
        {
            m_playerIsInside = false;
            if (!m_matched && !m_selected)
            {
                m_rumorsOfShadowsManager.hoverShadow(transform, false);
            }
        }
    }

    void Start()
    {
        m_rumorsOfShadowsManager = transform.GetComponentInParent<RumorsOfShadowsManager>();
    }

    void Update()
    {
        if (m_playerIsInside && Input.GetButtonDown("Interact") && !m_matched)
            m_selected = m_rumorsOfShadowsManager.selectShadow(transform);
    }
}
