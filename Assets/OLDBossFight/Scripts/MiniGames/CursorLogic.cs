using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class CursorLogic : MonoBehaviour
{
    [SerializeField]
    private float m_speed = 1000f;
    [SerializeField]
    private int m_borderOffset = 50;
    [SerializeField]
    private LayerMask m_layerMask;
    
    private const float m_rayDistance = 100.0f;

    private const string m_horizontalInputName = "Horizontal";
    private const string m_VerticalInputName = "Vertical";
    private const string m_CursorClickInputName = "Submit";

    private Interactable m_hoveredInteractable = null;

    private Camera m_camera;

    private void OnEnable()
    {
        m_camera = Camera.main;
    }

    private void OnDisable()
    {
        if (m_hoveredInteractable)
        {
            m_hoveredInteractable.hoverExit();
        }
        m_hoveredInteractable = null;
    }
    
    void Update()
    {
        moveCursor();

        

        
        List<RaycastResult> raycastResults = new List<RaycastResult>();
        if(EventSystem.current != null)
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
            RaycastHit HitInfo;
            if (Physics.Raycast(ray, out HitInfo, m_rayDistance, m_layerMask))
                changeCurrentInteractable(HitInfo.transform.GetComponent<Interactable>());
            else changeCurrentInteractable(null);
        }
    }
    
    void moveCursor()
    {
        float HorizontalInputValue = Input.GetAxis(m_horizontalInputName);
        float VerticalInputValue = Input.GetAxis(m_VerticalInputName);
        Vector3 currentScreenPosition = transform.position;
        
        if (HorizontalInputValue != 0 || VerticalInputValue != 0)
        {
            Vector3 newScreenPosition = currentScreenPosition + (new Vector3(HorizontalInputValue, VerticalInputValue)) * m_speed * Time.deltaTime;

            newScreenPosition.x = Mathf.Clamp(newScreenPosition.x, 0f + m_borderOffset, Screen.width - m_borderOffset);
            newScreenPosition.y = Mathf.Clamp(newScreenPosition.y, 0f + m_borderOffset, Screen.height - m_borderOffset);

            transform.position = newScreenPosition;
        }
    }

    void onRaycastUI(List<RaycastResult> raycastResults)
    {
        float bestDist = float.MaxValue;
        Interactable bestinteractable = null;
        foreach (var r in raycastResults)
        {
            if (r.distance >= bestDist)
                continue;
            if ((m_layerMask.value & (1 << r.gameObject.layer)) == 0)
                continue;
            var interactable = r.gameObject.GetComponent<Interactable>();
            if (interactable == null)
                continue;
            bestDist = r.distance;
            bestinteractable = interactable;
        }

        changeCurrentInteractable(bestinteractable);
    }

    void changeCurrentInteractable(Interactable interactable)
    {
        if (m_hoveredInteractable != null)
        {
            if (m_hoveredInteractable != interactable)
            {
                m_hoveredInteractable.hoverExit();
                if (interactable != null)
                    interactable.hoverEnter();
                m_hoveredInteractable = interactable;
            }
            if (m_hoveredInteractable != null && Input.GetButtonDown(m_CursorClickInputName))
                    m_hoveredInteractable.select();
        }
        else if (interactable != null)
        {
            interactable.hoverEnter();
            m_hoveredInteractable = interactable;
        }
    }
}