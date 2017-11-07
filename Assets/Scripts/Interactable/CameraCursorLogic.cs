using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[RequireComponent(typeof(FollowCamera))]

class CameraCursorLogic : MonoBehaviour
{
    string inputValidate = "Interact";

    [SerializeField] LayerMask m_interactableMask;
    [SerializeField] float m_maxRayDistance = 10;
    
    SubscriberList m_subscriberList = new SubscriberList();

    FollowCamera m_followCamera;
    Camera m_camera;

    bool m_controlesLocked = false;

    InteractableBaseLogic m_hoveredInteractable;
    InteractableBaseLogic m_selectedInteractable;

    Vector3 m_localHitPos;
    Vector3 m_oldPosition;
    Quaternion m_oldRotation;

    private void Awake()
    {
        m_followCamera = GetComponent<FollowCamera>();
        m_camera = Camera.main;

        m_subscriberList.Add(new Event<LockPlayerControlesEvent>.Subscriber(onControlesLock));
        m_subscriberList.Subscribe();

        m_oldPosition = transform.position;
        m_oldRotation = transform.rotation;
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    private void Update()
    {
        if (m_controlesLocked)
            return;

        checkHoveredinteractables();
        checkPress();

        m_oldPosition = transform.position;
        m_oldRotation = transform.rotation;
    }

    void checkHoveredinteractables()
    {
        RaycastHit hitInfo;
        if (Physics.Raycast(transform.position, transform.forward, out hitInfo, m_maxRayDistance, m_interactableMask))
            changeCurrentInteractable(hitInfo.transform.GetComponent<InteractableBaseLogic>(), hitInfo.point);
        else changeCurrentInteractable(null);
    }

    void changeCurrentInteractable(InteractableBaseLogic interactable)
    {
        changeCurrentInteractable(interactable, Vector3.zero);
    }

    void changeCurrentInteractable(InteractableBaseLogic interactable, Vector3 hitposition)
    {
        InteractableBaseLogic.OrigineType type = m_followCamera.FPSMode ? InteractableBaseLogic.OrigineType.FIRST_PERSON_CAMERA : InteractableBaseLogic.OrigineType.THIRD_PERSON_CAMERA;

        if (interactable != null)
            hitposition = interactable.transform.InverseTransformPoint(hitposition);
        m_localHitPos = hitposition;

        if (m_hoveredInteractable != null)
        {
            if (m_hoveredInteractable != interactable)
            {
                m_hoveredInteractable.onExit(type);
                if (interactable != null)
                    interactable.onEnter(type, hitposition);
                m_hoveredInteractable = interactable;
            }
        }
        else if (interactable != null)
        {
            interactable.onEnter(type, hitposition);
            m_hoveredInteractable = interactable;
        }
    }

    void checkPress()
    {
        InteractableBaseLogic.OrigineType type = m_followCamera.FPSMode ? InteractableBaseLogic.OrigineType.FIRST_PERSON_CAMERA : InteractableBaseLogic.OrigineType.THIRD_PERSON_CAMERA;

        if (Input.GetButtonDown(inputValidate) && m_hoveredInteractable != null)
        {
            if (m_selectedInteractable != null)
                m_selectedInteractable.onInteractEnd(type);
            m_selectedInteractable = m_hoveredInteractable;
            m_selectedInteractable.onInteract(type, m_localHitPos);
        }

        if (Input.GetButtonUp(inputValidate) && m_selectedInteractable != null)
        {
            if (m_selectedInteractable != null)
                m_selectedInteractable.onInteractEnd(type);
            m_selectedInteractable = null;
        }

        if (m_selectedInteractable != null)
            dragObject();
    }

    void dragObject()
    {
        InteractableBaseLogic.OrigineType type = m_followCamera.FPSMode ? InteractableBaseLogic.OrigineType.FIRST_PERSON_CAMERA : InteractableBaseLogic.OrigineType.THIRD_PERSON_CAMERA;

        var pos = m_selectedInteractable.transform.position - 2 * m_oldPosition + transform.position;
        pos = transform.rotation * Quaternion.Inverse(m_oldRotation) * pos;
        pos += transform.position;
        m_selectedInteractable.onDrag(pos - m_selectedInteractable.transform.position, type);
    }

    void exitInteractables()
    {
        changeCurrentInteractable(null);
        if (m_selectedInteractable != null)
            m_selectedInteractable.onExit(m_followCamera.FPSMode ? InteractableBaseLogic.OrigineType.FIRST_PERSON_CAMERA : InteractableBaseLogic.OrigineType.THIRD_PERSON_CAMERA);
        m_selectedInteractable = null;
    }

    void enterInteractables()
    {
        checkHoveredinteractables();
    }

    void onControlesLock(LockPlayerControlesEvent e)
    {
        m_controlesLocked = e.locked;

        if (m_controlesLocked)
            exitInteractables();
        else enterInteractables();
    }
}