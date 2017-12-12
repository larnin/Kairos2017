using UnityEngine;
using System.Collections;
using System;

public class FPSCameraLogic : BaseCameraLogic
{
    string joysticNameAxisCamX = "Joystic X";
    string joysticNameAxisCamY = "Joystic Y";
    string mouseNameAxisCamX = "Mouse X";
    string mouseNameAxisCamY = "Mouse Y";

    string fpsMouseProperty = "FirstPersonMouse";
    string fpsControlerProperty = "FirstPersonControler";
    string verticalMouseProperty = "VerticalAxisMouse";
    string verticalControlerProperty = "VerticalAxisControler";

    [SerializeField] float m_cameraHeight = 1.5f;
    [SerializeField] float m_manualCameraSpeedMultiplier = 2;
    [SerializeField] float m_manualCameraVerticalSpeedMultiplier = 2;
    [SerializeField] float m_manualCameraDeadZone = 0.1f;
    [SerializeField] float m_manualCameraAcceleration = 1;
    [SerializeField] float m_mouseSensibility = 1;
    [SerializeField] float m_mouseSmoothDeadzoneSpeed = 5;
    [SerializeField] float m_mouseSmoothDeadzonePow = 2;
    [SerializeField] float m_clampVerticalRotationTop = 85;
    [SerializeField] float m_clampVerticalRotationBottom = -85;
    [SerializeField] float m_startSpeedRotationDecreaseDestance = 20;
    [SerializeField] float m_distanceReduction = 1;
    [SerializeField] float m_verticalRecenterSpeed = 1;
    [SerializeField] float m_recenterMaxTime = 1;
    [SerializeField] float m_recenterDelay = 1;
    [SerializeField] float m_groundAngleMultiplier = 0.2f;

    [SerializeField] LayerMask m_raycastsMask = 0;

    SubscriberList m_subscriberList = new SubscriberList();

    Vector3 m_targetOldposition;

    Vector3 m_originalOffset;
    Vector3 m_originalOrientation;
    
    Vector3 m_currentCameraOrientation;
    Vector3 m_currentCenter;

    Vector2 m_manualCameraSpeed;

    float m_cameraTargetRecenterFromSurface = 0;
    float m_recenterSpeed = 0;
    float m_timeFromLastInput = 0;

    float m_rotationSpeed = 0;
    

    bool m_controlesLocked = false;

    Vector2 m_mouseRotValue;

    float m_fpsMousePropertyValue = 1;
    float m_fpsControlerPropertyValue = 1;
    bool m_verticalMousePropertyValue = false;
    bool m_verticalControlerPropertyValue = false;

    public override bool FPSMode { get { return true; } }

    private void Awake()
    {
        //m_camera = GetComponent<Camera>();

        m_subscriberList.Add(new Event<LockPlayerControlesEvent>.Subscriber(onControlesLock));
        m_subscriberList.Add(new Event<PauseEvent>.Subscriber(onPause));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    private void Start()
    {
        m_targetOldposition = m_target.position;
        m_originalOffset = m_target.InverseTransformDirection(transform.position - m_target.position);
        m_originalOrientation = (transform.rotation).eulerAngles;

        m_currentCameraOrientation = m_originalOrientation;
        m_currentCenter = Vector3.zero;
    }

    private void OnEnable()
    {
        m_targetOldposition = m_target.position;
        m_currentCameraOrientation = m_originalOrientation;
        m_currentCenter = Vector3.zero;

        updateSavedProperties();
    }

    protected override void onUpdate()
    {
        updateTargetinformations();

        m_timeFromLastInput += Time.deltaTime * m_currentCenter.magnitude;

        updateCameraInputs();
        
        checkground();

        updateCameraRotationSpeed();

        updateCameraTransform();

        m_targetOldposition = m_target.position;
    }

    void updateTargetinformations()
    {
        m_currentCenter += m_targetOldposition - m_target.position;
    }

    void updateCameraTransform()
    {
        m_currentCameraOrientation.x += m_manualCameraSpeed.y * Time.deltaTime;
        m_currentCameraOrientation.y += m_manualCameraSpeed.x * Time.deltaTime;
        if (Mathf.Abs(m_manualCameraSpeed.x) < 0.01f)
            m_currentCameraOrientation.y += m_rotationSpeed * Time.deltaTime;
        if (Mathf.Abs(m_manualCameraSpeed.y) < 0.01f)
            m_currentCameraOrientation.x += m_recenterSpeed * Time.deltaTime * m_currentCenter.magnitude;
        m_currentCameraOrientation.z = 0;
        m_currentCameraOrientation.x = Mathf.Clamp(m_currentCameraOrientation.x, m_clampVerticalRotationBottom, m_clampVerticalRotationTop);
        m_currentCameraOrientation.y = m_currentCameraOrientation.y % 360f;

        var cameraOrientation = Quaternion.Euler(m_currentCameraOrientation);

        var centerDist = m_currentCenter.magnitude;
        centerDist *= Mathf.Max(1 - (m_distanceReduction * Time.deltaTime), 0);
        m_currentCenter = m_currentCenter.normalized * centerDist;
        Debug.DrawRay(m_currentCenter + transform.position, Vector3.up);

        var pos = m_target.position;
        Vector3 cameraTarget = pos;
        cameraTarget.y += m_originalOffset.y;

        pos += new Vector3(0, m_cameraHeight, 0);
        transform.position = pos;

        transform.rotation = cameraOrientation;

        Debug.DrawRay(cameraTarget, Vector3.up, Color.cyan);
    }


    void updateCameraInputs()
    {
        Vector2 dir = new Vector2(Input.GetAxisRaw(joysticNameAxisCamX), Input.GetAxisRaw(joysticNameAxisCamY));
        Vector2 mouseDir = new Vector2(Input.GetAxisRaw(mouseNameAxisCamX), Input.GetAxisRaw(mouseNameAxisCamY));
        if (m_controlesLocked)
        {
            mouseDir = Vector2.zero;
            dir = Vector2.zero;
        }

        if (dir.y < 0)
            dir.y = Mathf.Min(dir.y + m_manualCameraDeadZone, 0);
        else if (dir.y > 0)
            dir.y = Mathf.Max(dir.y - m_manualCameraDeadZone, 0);
        if (dir.x < 0)
            dir.x = Mathf.Min(dir.x + m_manualCameraDeadZone, 0);
        else if (dir.x > 0)
            dir.x = Mathf.Max(dir.x - m_manualCameraDeadZone, 0);
        dir.x *= m_manualCameraSpeedMultiplier * m_fpsControlerPropertyValue;
        dir.y *= m_manualCameraVerticalSpeedMultiplier * m_fpsControlerPropertyValue;

        if (dir.magnitude > 0.01f || mouseDir.magnitude > 0.01f)
        {
            m_timeFromLastInput = 0;
            m_recenterSpeed = 0;
        }

        if (m_verticalMousePropertyValue)
            mouseDir.y *= -1;
        if (m_verticalControlerPropertyValue)
            dir.y *= -1;

        float multiplier = 1;
        if (m_manualCameraSpeed.y > 0 && m_currentCameraOrientation.x > m_clampVerticalRotationTop - m_startSpeedRotationDecreaseDestance)
            multiplier = 1 - (m_currentCameraOrientation.x - (m_clampVerticalRotationTop - m_startSpeedRotationDecreaseDestance)) / m_startSpeedRotationDecreaseDestance;
        if (m_manualCameraSpeed.y < 0 && m_currentCameraOrientation.x < m_clampVerticalRotationBottom + m_startSpeedRotationDecreaseDestance)
            multiplier = 1 - ((m_clampVerticalRotationBottom + m_startSpeedRotationDecreaseDestance) - m_currentCameraOrientation.x) / m_startSpeedRotationDecreaseDestance;

        dir.y *= multiplier;

        float verticalAcceleration = m_manualCameraVerticalSpeedMultiplier / m_manualCameraSpeedMultiplier * m_manualCameraAcceleration * m_fpsControlerPropertyValue;
        float horisontalAcceleration = m_manualCameraAcceleration * m_fpsControlerPropertyValue;

        if (m_manualCameraSpeed.x < dir.x)
            m_manualCameraSpeed.x = Mathf.Min(m_manualCameraSpeed.x + horisontalAcceleration * Time.deltaTime, dir.x);
        if (m_manualCameraSpeed.x > dir.x)
            m_manualCameraSpeed.x = Mathf.Max(m_manualCameraSpeed.x - horisontalAcceleration * Time.deltaTime, dir.x);
        if (m_manualCameraSpeed.y < dir.y)
            m_manualCameraSpeed.y = Mathf.Min(m_manualCameraSpeed.y + verticalAcceleration * Time.deltaTime, dir.y);
        if (m_manualCameraSpeed.y > dir.y)
            m_manualCameraSpeed.y = Mathf.Max(m_manualCameraSpeed.y - verticalAcceleration * Time.deltaTime, dir.y);

        float verticalMouseSensibility = m_mouseSensibility * m_manualCameraVerticalSpeedMultiplier;
        if (mouseDir.y > 0 && m_currentCameraOrientation.x > m_clampVerticalRotationTop - m_startSpeedRotationDecreaseDestance)
            verticalMouseSensibility = 1 - (m_currentCameraOrientation.x - (m_clampVerticalRotationTop - m_startSpeedRotationDecreaseDestance)) / m_startSpeedRotationDecreaseDestance;
        if (mouseDir.y < 0 && m_currentCameraOrientation.x < m_clampVerticalRotationBottom + m_startSpeedRotationDecreaseDestance)
            verticalMouseSensibility = 1 - ((m_clampVerticalRotationBottom + m_startSpeedRotationDecreaseDestance) - m_currentCameraOrientation.x) / m_startSpeedRotationDecreaseDestance;

        m_mouseRotValue.x += mouseDir.x * m_mouseSensibility * m_manualCameraSpeedMultiplier * Time.deltaTime * m_fpsMousePropertyValue;
        m_mouseRotValue.y += mouseDir.y * verticalMouseSensibility * Time.deltaTime * m_fpsMousePropertyValue;

        float smoothValueX = Mathf.Sign(m_mouseRotValue.x) * Mathf.Pow(Mathf.Abs(m_mouseRotValue.x), m_mouseSmoothDeadzonePow) * Time.deltaTime * m_mouseSmoothDeadzoneSpeed;
        if (Mathf.Abs(smoothValueX) > Mathf.Abs(m_mouseRotValue.x))
            smoothValueX = m_mouseRotValue.x;
        m_mouseRotValue.x -= smoothValueX;
        m_currentCameraOrientation.y += smoothValueX;

        float smoothValueY = Mathf.Sign(m_mouseRotValue.y) * Mathf.Pow(Mathf.Abs(m_mouseRotValue.y), m_mouseSmoothDeadzonePow) * Time.deltaTime * m_mouseSmoothDeadzoneSpeed;
        if (Mathf.Abs(smoothValueY) > Mathf.Abs(m_mouseRotValue.y))
            smoothValueY = m_mouseRotValue.y;
        m_mouseRotValue.y -= smoothValueY;
        m_currentCameraOrientation.x += smoothValueY;
    }

    void updateCameraRotationSpeed()
    {
        float recenterDistance = m_cameraTargetRecenterFromSurface - m_currentCameraOrientation.x;
        float recenterSpeed = Mathf.Max(Mathf.Min(m_timeFromLastInput - m_recenterDelay, m_recenterMaxTime) / m_recenterMaxTime, 0) * m_verticalRecenterSpeed * recenterDistance;
        m_recenterSpeed = recenterSpeed;
    }

    void checkground()
    {
        var pos = m_target.position + Vector3.up;
        RaycastHit hit = new RaycastHit();

        Vector3 normal = Vector3.up;

        if (Physics.Raycast(pos, -Vector3.up, out hit, 1.5f, m_raycastsMask))
            normal = hit.normal;

        Debug.DrawRay(m_target.position, normal, Color.green);

        normal = Vector3.ProjectOnPlane(normal, transform.right);
        normal = transform.InverseTransformDirection(normal);
        float angle = -Mathf.Deg2Rad * m_currentCameraOrientation.x;

        normal = new Vector3(0, Mathf.Cos(angle) * normal.y + Mathf.Sin(angle) * normal.z, Mathf.Sin(angle) * normal.y - Mathf.Cos(angle) * normal.z);

        angle = Mathf.Rad2Deg * Mathf.Atan2(normal.z, normal.y);
        m_cameraTargetRecenterFromSurface = -angle * m_groundAngleMultiplier;
    }

    void onControlesLock(LockPlayerControlesEvent e)
    {
        m_controlesLocked = e.locked;
    }

    void onPause(PauseEvent e)
    {
        onControlesLock(new LockPlayerControlesEvent(e.paused));
        if (!e.paused)
            updateSavedProperties();
    }

    void updateSavedProperties()
    {
        float maxValue = 100;
        float maxmultiplier = 5;

        m_fpsMousePropertyValue = G.sys.saveSystem.getFloat(fpsMouseProperty, 0);
        m_fpsControlerPropertyValue = G.sys.saveSystem.getFloat(fpsControlerProperty, 0);
        m_verticalMousePropertyValue = G.sys.saveSystem.getBool(verticalMouseProperty, m_verticalMousePropertyValue);
        m_verticalControlerPropertyValue = G.sys.saveSystem.getBool(verticalControlerProperty, m_verticalControlerPropertyValue);

        m_fpsMousePropertyValue = m_fpsMousePropertyValue > 0 ? (maxmultiplier - 1) * m_fpsMousePropertyValue / maxValue + 1 : m_fpsMousePropertyValue / (maxValue * (1 + 1 / (maxmultiplier - 1))) + 1;
        m_fpsControlerPropertyValue = m_fpsControlerPropertyValue > 0 ? (maxmultiplier - 1) * m_fpsControlerPropertyValue / maxValue + 1 : m_fpsControlerPropertyValue / (maxValue * (1 + 1 / (maxmultiplier - 1))) + 1;
    }
}
