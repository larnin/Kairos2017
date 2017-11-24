using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;
using System;

public class BookTabButton : MonoBehaviour, IPointerClickHandler
{
    [SerializeField] GameObject m_page;

    Action<BookTabButton> m_callbackAction;

    public void OnPointerClick(PointerEventData eventData)
    {
        if (m_callbackAction != null)
            m_callbackAction(this);
    }

    public Action<BookTabButton> callback { set { m_callbackAction = value; } }
    public GameObject page { get { return m_page; } }
}
