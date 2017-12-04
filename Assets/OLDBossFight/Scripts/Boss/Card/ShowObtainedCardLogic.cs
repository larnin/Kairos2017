using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

class ShowObtainedCardLogic : MonoBehaviour
{
    [SerializeField] GameObject m_cardTemplate;
    [SerializeField] float m_cardShowTime = 3f;

    Text m_description;

    SubscriberList m_subscriberList = new SubscriberList();

    private void Awake()
    {
        m_description = transform.Find("Description").GetComponent<Text>();

        m_subscriberList.Add(new Event<CardObtainedEvent>.Subscriber(onShowCard));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    void onShowCard(CardObtainedEvent e)
    {
        var obj =  Instantiate(m_cardTemplate, transform, false);
        var comp = obj.GetComponent<CardLogic>();
        comp.description = e.cardDescription;
        comp.text = e.cardName;
        Destroy(obj, m_cardShowTime);

        m_description.text = e.cardDescription;
        DOVirtual.DelayedCall(m_cardShowTime, () => { m_description.text = ""; });
    }
}