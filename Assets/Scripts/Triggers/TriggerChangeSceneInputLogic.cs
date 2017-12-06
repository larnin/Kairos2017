﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;

class TriggerChangeSceneInputLogic : TriggerBaseLogic
{
    string submitButton = "Submit";

    [SerializeField] string m_validInputName;
    [SerializeField] string m_validInputText;
    [SerializeField] string m_scenename;
    [SerializeField] float m_fadeTime;
    [SerializeField] string m_newScenePlayerTag;
    [SerializeField] string m_newScenePlayerSpawnTag;

    bool m_validatedInput = false;
    bool m_isOnTrigger = false;

    public override void onEnter(TriggerInteractionLogic entity)
    {
        m_isOnTrigger = true;
        StartCoroutine(checkInputsCoroutine());
        Event<ShowUIButtonsEvent>.Broadcast(new ShowUIButtonsEvent(new List<ShowUIButtonsEvent.ButtonInfos> { new ShowUIButtonsEvent.ButtonInfos(m_validInputName, m_validInputText) }));
    }

    public override void onExit(TriggerInteractionLogic entity)
    {
        m_isOnTrigger = false;
        m_validatedInput = false;
        Event<ShowUIButtonsEvent>.Broadcast(new ShowUIButtonsEvent());
    }


    IEnumerator checkInputsCoroutine()
    {
        while(m_isOnTrigger)
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
        movePlayerToNewLocation();
        Event<FadeEvent>.Broadcast(new FadeEvent(Color.black));
        Event<FadeEvent>.Broadcast(new FadeEvent(new Color(0, 0, 0, 0), m_fadeTime));
    }

    void movePlayerToNewLocation()
    {
        var p = GameObject.FindGameObjectWithTag(m_newScenePlayerTag);
        var spawn = GameObject.FindGameObjectWithTag(m_newScenePlayerSpawnTag);

        Debug.Log(p + " * " + spawn);

        if (p == null || spawn == null)
            return;
        Debug.Log("Poop");
        p.transform.position = spawn.transform.position;
        p.transform.rotation = spawn.transform.rotation;
    }
}