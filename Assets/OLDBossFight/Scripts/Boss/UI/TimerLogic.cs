using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class TimerLogic : MonoBehaviour
{
    Color fullColor = new Color(1, 1, 1);
    Color emptyColor = new Color(1, 0, 0);

    bool m_started = false;
    float m_totalTime = 1;
    float m_currentTime = 1;

    Transform m_fillTimerObject;
    Image m_timerImage;

    private void Awake()
    {
        m_fillTimerObject = transform.Find("TimerFill");
        m_timerImage = m_fillTimerObject.GetComponent<Image>();
    }

    private void Update()
    {
        if (!m_started || m_totalTime == 0)
            return;

        m_currentTime = Mathf.Max(0, m_currentTime - Time.deltaTime);

        if (m_currentTime == 0)
            Event<TimerTimeoutEvent>.Broadcast(new TimerTimeoutEvent());

        float normalizedTime = m_currentTime / m_totalTime;

        m_fillTimerObject.localScale = new Vector3(normalizedTime, 1, 1);
        if (m_timerImage != null)
            m_timerImage.color = fullColor * normalizedTime + emptyColor * (1 - normalizedTime);
    }

    public void startTimer(float totalTime)
    {
        m_totalTime = totalTime;
        m_currentTime = totalTime;
        m_started = true;
    }

    public bool started
    {
        get { return m_started; }
        set { m_started = value; }
    }
}