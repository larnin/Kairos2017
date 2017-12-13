using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;

public class TriggerStartBossInputLogic : TriggerBaseLogic
{
    string submitButton = "Submit";

    [SerializeField] string m_validInputName;
    [SerializeField] string m_validInputText;
    [SerializeField] string m_scenename;
    [SerializeField] float m_fadeTime;

    bool m_validatedInput = false;
    bool m_isOnTrigger = false;

    public override void onEnter(TriggerInteractionLogic entity)
    {
        m_isOnTrigger = true;
        if(haveAllneddedCards())
        {
            StartCoroutine(checkInputsCoroutine());
            Event<ShowUIButtonsEvent>.Broadcast(new ShowUIButtonsEvent(new List<ShowUIButtonsEvent.ButtonInfos> { new ShowUIButtonsEvent.ButtonInfos(m_validInputName, m_validInputText) }));
        }
    }

    public override void onExit(TriggerInteractionLogic entity)
    {
        m_isOnTrigger = false;
        m_validatedInput = false;
        Event<ShowUIButtonsEvent>.Broadcast(new ShowUIButtonsEvent());
    }
    
    IEnumerator checkInputsCoroutine()
    {
        while (m_isOnTrigger)
        {
            if (Input.GetButton(submitButton) && !m_validatedInput)
            {
                onInputValidate();
                m_validatedInput = true;
            }
            yield return new WaitForEndOfFrame();
        }
        m_validatedInput = false;
    }

    void onInputValidate()
    {
        Event<LockPlayerControlesEvent>.Broadcast(new LockPlayerControlesEvent(true));
        Event<FadeEvent>.Broadcast(new FadeEvent(Color.black, m_fadeTime));
        DOVirtual.DelayedCall(m_fadeTime, () => { Event<LoadSceneEvent>.Broadcast(new LoadSceneEvent(m_scenename, onSceneLoaded)); });
    }

    void onSceneLoaded()
    {
        Event<FadeEvent>.Broadcast(new FadeEvent(Color.black));
        Event<FadeEvent>.Broadcast(new FadeEvent(new Color(0, 0, 0, 0), m_fadeTime));
    }

    bool haveAllneddedCards()
    {
        return G.sys.loopSystem.essentialCardsFoundCount() >= G.sys.loopSystem.essentialCardsCount();
    }
}
