using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class InputManagerLogic : MonoBehaviour
{
    [SerializeField] List<string> m_inputsNames = new List<string>();
    [SerializeField] float m_treshold = 0.5f;

    List<float> m_oldInputsValues = new List<float>();

    private void Awake()
    {
        foreach (var name in m_inputsNames)
            m_oldInputsValues.Add(Input.GetAxisRaw(name));
    }

    private void Update()
    {
        if (m_inputsNames.Count != m_oldInputsValues.Count)
        {
            Debug.LogError("Don't change input name list in play mode !");
            return;
        }

        for(int i = 0; i < m_inputsNames.Count; i++)
        {
            var value = Input.GetAxisRaw(m_inputsNames[i]);
            if(Mathf.Abs(value) > m_treshold && (Mathf.Abs(m_oldInputsValues[i]) < m_treshold || Math.Sign(value) != Mathf.Sign(m_oldInputsValues[i])))
            {
                m_oldInputsValues[i] = value;
                Event<InputEvent>.Broadcast(new InputEvent(m_inputsNames[i], Math.Sign(value), InputEvent.InputType.PRESSED));
            }
            if(Mathf.Abs(value) < m_treshold && Mathf.Abs(m_oldInputsValues[i]) > m_treshold)
            {
                m_oldInputsValues[i] = value;
                Event<InputEvent>.Broadcast(new InputEvent(m_inputsNames[i], Math.Sign(value), InputEvent.InputType.RELEASED));
            }
        }
    }
}