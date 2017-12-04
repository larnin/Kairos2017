using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class MouseLockerLogic : MonoBehaviour
{
    bool m_locked = true;
    SubscriberList m_subscriberList = new SubscriberList();

    private void Awake()
    {
        m_subscriberList.Add(new Event<PauseEvent>.Subscriber(onPause));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    private void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.L))
        {
            Cursor.lockState = m_locked ? CursorLockMode.None : CursorLockMode.Locked;
            m_locked = !m_locked;
        }
    }

    void onPause(PauseEvent e)
    {
        if (e.paused)
            Cursor.lockState = CursorLockMode.None;
        else Cursor.lockState = CursorLockMode.Locked;
    }
}