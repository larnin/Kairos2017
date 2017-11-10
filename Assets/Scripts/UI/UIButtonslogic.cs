using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class UIButtonslogic : MonoBehaviour
{
    List<GameObject> m_buttons = new List<GameObject>();
    SubscriberList m_subscriberList = new SubscriberList();

    private void Start()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            var button = transform.GetChild(i).gameObject;
            m_buttons.Add(button);
            button.SetActive(false);
        }

        m_subscriberList.Add(new Event<ShowUIButtonsEvent>.Subscriber(onShowButton));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    void onShowButton(ShowUIButtonsEvent e)
    {
        foreach(var b in m_buttons)
        {
            bool found = false;
            foreach(var bInfo in e.buttonsInfos)
            {
                if(bInfo.buttonName == b.name)
                {
                    found = true;
                    changeButton(b, bInfo.buttonText, bInfo.enabled);
                    break;
                }
            }
            if (!found && e.hideOthersButtons && b.activeSelf)
                b.SetActive(false);
        }
    }

    void changeButton(GameObject button, string text, bool enabled)
    {
        if (button.activeSelf != enabled)
            button.SetActive(enabled);

        if (!enabled)
            return;
        
        var textComp = gameObject.GetComponentInChildren<Text>();
        if (textComp != null)
            textComp.text = text;
    }
}
