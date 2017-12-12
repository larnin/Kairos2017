using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;
using Sirenix.OdinInspector;
using System.Reflection;



public class HackBehavior : MonoBehaviour
{
    [Serializable]
    class Data
    {
        public string attributeName;
        public bool privateAttribute;
        public float startValue;
        public float endValue;
        public float time;
    }

    [SerializeField] MonoBehaviour m_behavior;
    [SerializeField] List<Data> m_datas;
    float m_currentTime = 0;

    private void Update()
    {
        if (m_behavior == null)
            return;

        m_currentTime += Time.deltaTime;

        foreach(var d in m_datas)
        {
            float value = m_currentTime > d.time ? d.endValue : Mathf.Lerp(d.startValue, d.endValue, m_currentTime / d.time);
            var attribute = !d.privateAttribute ? m_behavior.GetType().GetField(d.attributeName, BindingFlags.Instance | BindingFlags.Public) : m_behavior.GetType().GetField(d.attributeName, BindingFlags.NonPublic | BindingFlags.Instance);
            attribute.SetValue(m_behavior, value);
        }
    }
}