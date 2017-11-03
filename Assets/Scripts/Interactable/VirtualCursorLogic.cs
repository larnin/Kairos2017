using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class VirtualCursorLogic : MonoBehaviour
{
    string inputMouseX = "Mouse X";
    string inputMouseY = "Mouse Y";
    string inputJoyX = "Horizontal";
    string inputJoyY = "Vertical";
    string inputValidate = "Submit";

    [SerializeField] float m_mouseSensibility = 1;
    [SerializeField] float m_controlerSensibility = 1;
    [SerializeField] Vector2 m_mouseArea = new Vector2(1900, 1060);

    SubscriberList m_subscriberList = new SubscriberList();

    Vector2 m_position;

    RectTransform m_rectTransform;

    private void Awake()
    {
        m_rectTransform = GetComponent<RectTransform>();

        m_subscriberList.Add(new Event<EnableCursorEvent>.Subscriber(onEnableEvent));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    private void Update()
    {
        var dir = new Vector2(Input.GetAxisRaw(inputMouseX), Input.GetAxisRaw(inputMouseY)) * m_mouseSensibility
            + new Vector2(Input.GetAxis(inputJoyX), Input.GetAxis(inputJoyY)) * m_controlerSensibility;

        if (dir.magnitude > 0.01f)
        {
            m_position += dir;
            m_position = new Vector2(Mathf.Clamp(m_position.x, -m_mouseArea.x / 2, m_mouseArea.x / 2), Mathf.Clamp(m_position.y, -m_mouseArea.y / 2, m_mouseArea.y / 2));
            updatePosition();
        }
    }

    void onEnableEvent(EnableCursorEvent e)
    {
        gameObject.SetActive(e.enable);
        if(e.recenter)
        {
            m_position = Vector2.zero;
            updatePosition();
        }
    }

    void updatePosition()
    {
        var scale = m_rectTransform.lossyScale;
        var screen = new Vector2(Screen.width, Screen.height);
        Vector2 pos = new Vector2(m_position.x * scale.x, m_position.y * scale.y);
        pos += screen / 2.0f;
        m_rectTransform.position = new Vector3(pos.x, pos.y, m_rectTransform.position.z);
    }
}
