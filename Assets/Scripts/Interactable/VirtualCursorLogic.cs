using Sirenix.OdinInspector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class VirtualCursorLogic : SerializedMonoBehaviour
{
    string inputMouseX = "Mouse X";
    string inputMouseY = "Mouse Y";
    string inputJoyX = "Horizontal";
    string inputJoyY = "Vertical";
    string inputValidate = "Submit";

    [SerializeField] float m_mouseSensibility = 1;
    [SerializeField] float m_controlerSensibility = 1;
    [SerializeField] Vector2 m_mouseArea = new Vector2(1900, 1060);
    [SerializeField] Dictionary<string, Sprite> m_textures = new Dictionary<string, Sprite>();
    [SerializeField] Sprite m_defaultTexture;

    SubscriberList m_subscriberList = new SubscriberList();

    Vector2 m_position;

    RectTransform m_rectTransform;

    Image m_image;

    Vector2 m_baseSize;

    private void Awake()
    {
        m_rectTransform = GetComponent<RectTransform>();
        m_image = GetComponent<Image>();
        m_image.sprite = m_defaultTexture;
        m_baseSize = GetComponent<RectTransform>().sizeDelta;

        m_subscriberList.Add(new Event<EnableCursorEvent>.Subscriber(onEnableEvent));
        m_subscriberList.Add(new Event<ChangeCursorTextureEvent>.Subscriber(onChangeTextureEvent));
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

    void onChangeTextureEvent(ChangeCursorTextureEvent e)
    {
        if (e.useDefaultTexture)
            m_image.sprite = m_defaultTexture;
        else
        {
            if (!m_textures.ContainsKey(e.textureName))
                m_image.sprite = m_defaultTexture;
            else m_image.sprite = m_textures[e.textureName];
        }
        if (m_image.sprite != null)
            m_image.SetNativeSize();
        else GetComponent<RectTransform>().sizeDelta = m_baseSize;
        m_image.color = e.color;
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
