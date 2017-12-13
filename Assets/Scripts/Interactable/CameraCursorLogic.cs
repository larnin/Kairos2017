using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[RequireComponent(typeof(BaseCameraLogic))]

class CameraCursorLogic : MonoBehaviour
{
    string inputValidate = "Interact";

    [SerializeField] LayerMask m_interactableMask;
    [SerializeField] float m_maxRayDistance = 10;
    
    SubscriberList m_subscriberList = new SubscriberList();

    BaseCameraLogic m_camera;

    bool m_controlesLocked = false;

    InteractableBaseLogic m_hoveredInteractable;
    InteractableBaseLogic m_selectedInteractable;

    Vector3 m_localHitPos;
    Vector3 m_targetOldPosition;
    Quaternion m_oldRotation;

    Vector3 m_localInteractablePosition;
    Quaternion m_startInteractableRotation;
    Quaternion m_startCameraRotation;

    private void Awake()
    {
        m_camera = GetComponent<BaseCameraLogic>();

        m_subscriberList.Add(new Event<LockPlayerControlesEvent>.Subscriber(onControlesLock));
        m_subscriberList.Subscribe();
        
        m_oldRotation = transform.rotation;
    }

    private void Start()
    {
        m_targetOldPosition = m_camera.target.position;
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
        
        m_oldRotation = transform.rotation;
        m_targetOldPosition = m_camera.target.position;
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
        InteractableBaseLogic.OrigineType type = m_camera.FPSMode ? InteractableBaseLogic.OrigineType.FIRST_PERSON_CAMERA : InteractableBaseLogic.OrigineType.THIRD_PERSON_CAMERA;

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
        InteractableBaseLogic.OrigineType type = m_camera.FPSMode ? InteractableBaseLogic.OrigineType.FIRST_PERSON_CAMERA : InteractableBaseLogic.OrigineType.THIRD_PERSON_CAMERA;

        if (Input.GetButtonDown(inputValidate) && m_hoveredInteractable != null)
        {
            if (m_selectedInteractable != null)
                m_selectedInteractable.onInteractEnd(type);
            m_selectedInteractable = m_hoveredInteractable;

            m_localInteractablePosition = m_selectedInteractable.transform.position - m_camera.target.position;
            m_localInteractablePosition = transform.forward * m_localInteractablePosition.magnitude;
            m_startInteractableRotation = m_selectedInteractable.transform.rotation;
            m_startCameraRotation = transform.rotation;

            m_selectedInteractable.onInteract(type, m_localHitPos);
        }

        if (Input.GetButtonUp(inputValidate) && m_selectedInteractable != null)
        {
            m_selectedInteractable.onInteractEnd(type);
            m_selectedInteractable = null;
        }

        if (m_selectedInteractable != null)
            dragObject();
    }

    void dragObject()
    {
        InteractableBaseLogic.OrigineType type = m_camera.FPSMode ? InteractableBaseLogic.OrigineType.FIRST_PERSON_CAMERA : InteractableBaseLogic.OrigineType.THIRD_PERSON_CAMERA;

        var newRot = transform.rotation  * Quaternion.Inverse(m_startCameraRotation) * m_startInteractableRotation;
        var dir = (transform.rotation * Quaternion.Inverse(m_oldRotation)).eulerAngles;
        if (dir.x > 180)
            dir.x -= 360;
        if (dir.y > 180)
            dir.y -= 360;

        var distance = m_localInteractablePosition.magnitude;
        var newLocalPos = transform.forward * distance;
        var posOffset = m_camera.target.position - m_targetOldPosition;
        
        m_selectedInteractable.onDrag(new InteractableBaseLogic.DragData(new Vector2(dir.y, dir.x), posOffset + newLocalPos - m_localInteractablePosition,  Quaternion.Inverse(m_selectedInteractable.transform.rotation) * newRot, m_camera.target), type);
        m_localInteractablePosition = newLocalPos;
    }

    void exitInteractables()
    {
        changeCurrentInteractable(null);
        if (m_selectedInteractable != null)
            m_selectedInteractable.onExit(m_camera.FPSMode ? InteractableBaseLogic.OrigineType.FIRST_PERSON_CAMERA : InteractableBaseLogic.OrigineType.THIRD_PERSON_CAMERA);
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