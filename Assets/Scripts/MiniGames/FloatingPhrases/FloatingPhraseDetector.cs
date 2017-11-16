using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloatingPhraseDetector : MonoBehaviour
{
    public Action onNoMoreFloatingPhrase;

    private int m_floatingPhaseCount = 0;

    public bool isThereFloatingPhrases()
    {
        return m_floatingPhaseCount > 0;
    }

    void OnTriggerEnter(Collider collider)
    {
        if (collider.GetComponent<FloatingPhraseLogic>())
        {
            m_floatingPhaseCount++;
        }
    }
    
    void OnTriggerExit(Collider collider)
    {
        if (collider.GetComponent<FloatingPhraseLogic>())
        {
            m_floatingPhaseCount--;
        }
    }
}
