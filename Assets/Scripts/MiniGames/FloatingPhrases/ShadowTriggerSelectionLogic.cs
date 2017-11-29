using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShadowTriggerSelectionLogic : TriggerBaseLogic
{
    RumorsOfShadowsManager m_rumorsOfShadowsManager;
    bool m_playerIsInside = false;

    public override void onEnter(TriggerInteractionLogic entity)
    {
       if(entity.tag == "Player")
       {
            print("EEEEEEE");
            m_playerIsInside = true;
            m_rumorsOfShadowsManager.hoverShadow(transform);
       }
    }

    public override void onExit(TriggerInteractionLogic entity)
    {
        if (entity.tag == "Player")
        {
            m_playerIsInside = false;
        }
    }

    void Start()
    {
        m_rumorsOfShadowsManager = transform.GetComponentInParent<RumorsOfShadowsManager>();
        print(m_rumorsOfShadowsManager);
    }

    void Update()
    {
        if(Input.GetButtonDown("Interact"))
        {
            print("HELLO WORLD");
        }
    }
}
