using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateGameObjectOnEnter : TriggerBaseLogic
{
    [SerializeField]
    private FloatingPhraseGeneratorLogic m_toActivate = null;
    [SerializeField]
    private RumorsOfShadowsManager m_rumorsOfShadowsManager = null;
    
    public override void onEnter(TriggerInteractionLogic entity)
    {
        m_toActivate.appearing();
    }

    public override void onExit(TriggerInteractionLogic entity)
    {
        m_toActivate.disappearing(m_rumorsOfShadowsManager.UnMtachedAttributes, m_rumorsOfShadowsManager.timeTransitionBetweenAttribute);
    }
}
