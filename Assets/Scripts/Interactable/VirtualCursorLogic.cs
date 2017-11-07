using Sirenix.OdinInspector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class VirtualCursorLogic : SerializedMonoBehaviour
{
    string inputMouseX = "Mouse X";
    string inputMouseY = "Mouse Y";
    string inputJoyX = "Horizontal";
    string inputJoyY = "Vertical";
    string inputValidate = "Interact";

    [SerializeField] float m_mouseSensibility = 1;
    [SerializeField] float m_controlerSensibility = 1;
    [SerializeField] Vector2 m_mouseArea = new Vector2(1900, 1060);
    [SerializeField] Dictionary<string, Sprite> m_textures = new Dictionary<string, Sprite>();
    [SerializeField] Sprite m_defaultTexture;
    [SerializeField] LayerMask m_interactableMask;
    [SerializeField] float m_maxRayDistance = 10;

    SubscriberList m_subscriberList = new SubscriberList();

    Vector2 m_position;

    RectTransform m_rectTransform;
    Image m_image;
    Vector2 m_baseSize;
    Camera m_camera;

    InteractableBaseLogic m_hoveredInteractable;
    InteractableBaseLogic m_selectedInteractable;
    Vector3 m_localHitPos;

    Vector3 m_oldPosition;

    private void Awake()
    {
        m_rectTransform = GetComponent<RectTransform>();
        m_image = GetComponent<Image>();
        m_image.sprite = m_defaultTexture;
        m_baseSize = m_rectTransform.sizeDelta;
        m_camera = Camera.main;
        m_oldPosition = transform.position;

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

        checkInteractables();
        checkPress();
    }

    void updatePosition()
    {
        var scale = m_rectTransform.lossyScale;
        var screen = new Vector2(Screen.width, Screen.height);
        Vector2 pos = new Vector2(m_position.x * scale.x, m_position.y * scale.y);
        pos += screen / 2.0f;
        m_oldPosition = m_rectTransform.position;
        m_rectTransform.position = new Vector3(pos.x, pos.y, m_rectTransform.position.z);
    }

    void checkInteractables()
    {
        List<RaycastResult> raycastResults = new List<RaycastResult>();
        if (EventSystem.current != null)
        {
            PointerEventData ped = new PointerEventData(EventSystem.current);
            ped.position = transform.position;
            EventSystem.current.RaycastAll(ped, raycastResults);
        }

        if (raycastResults.Count != 0)
            onRaycastUI(raycastResults);
        else
        {
            Ray ray = m_camera.ScreenPointToRay(transform.position);
            RaycastHit hitInfo;
            if (Physics.Raycast(ray, out hitInfo, m_maxRayDistance, m_interactableMask))
                changeCurrentInteractable(hitInfo.transform.GetComponent<InteractableBaseLogic>(), hitInfo.point);
            else changeCurrentInteractable(null);
        }
    }

    void onRaycastUI(List<RaycastResult> raycastResults)
    {
        float bestDist = float.MaxValue;
        InteractableBaseLogic bestinteractable = null;
        Vector3 bestHit = Vector3.zero;
        foreach (var r in raycastResults)
        {
            if (r.distance >= bestDist)
                continue;
            if ((m_interactableMask.value & (1 << r.gameObject.layer)) == 0)
                continue;
            var interactable = r.gameObject.GetComponent<InteractableBaseLogic>();
            if (interactable == null)
                continue;
            bestDist = r.distance;
            bestinteractable = interactable;
            bestHit = r.worldPosition;
        }

        changeCurrentInteractable(bestinteractable, bestHit);
    }

    void changeCurrentInteractable(InteractableBaseLogic interactable)
    {
        changeCurrentInteractable(interactable, Vector3.zero);
    }

    void changeCurrentInteractable(InteractableBaseLogic interactable, Vector3 hitposition)
    {
        if (interactable != null)
            hitposition = interactable.transform.InverseTransformPoint(hitposition);
        m_localHitPos = hitposition;

        if (m_hoveredInteractable != null)
        {
            if (m_hoveredInteractable != interactable)
            {
                m_hoveredInteractable.onExit(InteractableBaseLogic.OrigineType.CURSOR);
                if (interactable != null)
                    interactable.onEnter(InteractableBaseLogic.OrigineType.CURSOR, hitposition);
                m_hoveredInteractable = interactable;
            }
        }
        else if (interactable != null)
        {
            interactable.onEnter(InteractableBaseLogic.OrigineType.CURSOR, hitposition);
            m_hoveredInteractable = interactable;
        }
    }

    void checkPress()
    {
        if(Input.GetButtonDown(inputValidate) && m_hoveredInteractable != null)
        {
            if (m_selectedInteractable != null)
                m_selectedInteractable.onInteractEnd(InteractableBaseLogic.OrigineType.CURSOR);
            m_selectedInteractable = m_hoveredInteractable;
            m_selectedInteractable.onInteract(InteractableBaseLogic.OrigineType.CURSOR, m_localHitPos);
        }

        if(Input.GetButtonUp(inputValidate) && m_selectedInteractable != null)
        {
            if (m_selectedInteractable != null)
                m_selectedInteractable.onInteractEnd(InteractableBaseLogic.OrigineType.CURSOR);
            m_selectedInteractable = null;
        }

        if((m_rectTransform.position - m_oldPosition).magnitude > 0.01f && m_selectedInteractable != null)
        {
            Vector2 dir = new Vector2(m_rectTransform.position.x - m_oldPosition.x, m_rectTransform.position.y - m_oldPosition.y);
            m_selectedInteractable.onDrag(dir, InteractableBaseLogic.OrigineType.CURSOR);
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
        else m_rectTransform.sizeDelta = m_baseSize;
        m_image.color = e.color;
    }
}
