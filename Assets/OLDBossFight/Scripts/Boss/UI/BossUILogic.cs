using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class BossUILogic : MonoBehaviour
{
    [SerializeField] float m_feedbackTimer = 2;

    TimerLogic m_timer;
    PowFeedbackLogic m_pow;
    Text m_bossLifeText;
    Text m_playerLifeText;

    SubscriberList m_subscriberList = new SubscriberList();

    private void Awake()
    {
        //m_timer = transform.Find("Timer").GetComponent<TimerLogic>();
        m_pow = transform.Find("Feedback").GetComponent<PowFeedbackLogic>();
        m_bossLifeText = transform.Find("BossLife").GetComponent<Text>();
        m_playerLifeText = transform.Find("PlayerLife").GetComponent<Text>();
        m_pow.gameObject.SetActive(false);

        m_subscriberList.Add(new Event<UpdateBossUIEvent>.Subscriber(onUpdateUI));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    public void setLifes(int playerLife, int bossLife)
    {
        m_playerLifeText.text = playerLife.ToString();
        m_bossLifeText.text = bossLife.ToString();
    }

    public void setTimer(float time)
    {
        //m_timer.startTimer(time);
    }

    public void showFeedback(PowFeedbackLogic.FeedbackType type, string text)
    {
        m_pow.show(type, m_feedbackTimer, text);
    }

    void onUpdateUI(UpdateBossUIEvent e)
    {
        setLifes(e.playerLife, e.bossLife);
        if (e.startTimer)
            setTimer(e.timerTime);
        if (e.showFeedback)
            showFeedback(e.feedbackType, e.feedbackText);
        //if (e.stopTimer)
        //    m_timer.started = false;
    }
}