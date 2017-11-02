using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class FadeLogic : MonoBehaviour
{
    Image m_image;
    SubscriberList m_subscriberList = new SubscriberList();
    Tweener m_tween;

    private void Awake()
    {
        m_image = GetComponent<Image>();

        m_subscriberList.Add(new Event<FadeEvent>.Subscriber(onFade));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    void onFade(FadeEvent e)
    {
        if (m_tween != null && m_tween.IsActive())
            m_tween.Kill();
        if(e.instant)
        {
            m_image.color = e.targetColor;
            return;
        }

        m_tween = m_image.DOColor(e.targetColor, e.time);
    }
}