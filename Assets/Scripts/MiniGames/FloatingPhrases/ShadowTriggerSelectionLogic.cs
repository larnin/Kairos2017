using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShadowTriggerSelectionLogic : TriggerBaseLogic
{
    private RumorsOfShadowsManager m_rumorsOfShadowsManager;
    private bool m_playerIsInside = false;
    public bool playerIsInside { get { return m_playerIsInside; } }

    [NonSerialized] public bool m_selected = false;
    [NonSerialized] public bool m_matched = false;
    
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
