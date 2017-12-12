using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class distanceBetweenCharEffect : MonoBehaviour {

    [SerializeField]
    private float m_targetValue = 2f;
    [SerializeField]
    private float m_speed = 2f;

    private float m_internalTarget;

    TextMeshPro m_textMeshPro;

    void Start()
    {
        m_textMeshPro = GetComponent<TextMeshPro>();
        m_internalTarget = m_targetValue;
    }

	// Update is called once per frame
	void Update ()
    {
        float currentValue = m_textMeshPro.characterSpacing;
        Mathf.MoveTowards(currentValue, m_internalTarget, Time.deltaTime * m_speed);
        m_textMeshPro.characterSpacing = Mathf.MoveTowards(currentValue, m_internalTarget, Time.deltaTime * m_speed);
        if(currentValue == m_internalTarget)
        {
            m_internalTarget = m_targetValue == m_internalTarget ? 0f : m_targetValue;
        }
    }
}
