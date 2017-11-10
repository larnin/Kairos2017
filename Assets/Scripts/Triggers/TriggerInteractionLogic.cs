using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class TriggerInteractionLogic : MonoBehaviour
{
    [SerializeField] LayerMask m_triggerMask;

    private void OnTriggerEnter(Collider other)
    {
        if ((1 << other.gameObject.layer & m_triggerMask.value) == 0)
            return;

        var trigger = other.GetComponent<TriggerBaseLogic>();
        if (trigger != null)
            trigger.onEnter(this);
    }

    private void OnTriggerExit(Collider other)
    {
        if ((1 << other.gameObject.layer & m_triggerMask.value) == 0)
            return;

        var trigger = other.GetComponent<TriggerBaseLogic>();
        if (trigger != null)
            trigger.onExit(this);
    }
}