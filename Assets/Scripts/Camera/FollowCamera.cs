using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class FollowCamera : MonoBehaviour
{
    public enum UpdateType
    {
        UPDATE,
        LATE_UPDATE,
        FIXED_UPDATE,
    }

    string joysticNameAxisCamX = "Joystic X";
    string joysticNameAxisCamY = "Joystic Y";
    string mouseNameAxisCamX = "Mouse X";
    string mouseNameAxisCamY = "Mouse Y";
    string nameRecenterCam = "Joystic Recenter";

    string fpsMouseProperty = "FirstPersonMouse";
    string fpsControlerProperty = "FirstPersonControler";
    string thirdMouseProperty = "ThirdPersonMouse";
    string thirdControlerProperty = "ThirdPersonControler";
    string verticalMouseProperty = "VerticalAxisMouse";
    string verticalControlerProperty = "VerticalAxisControler";

    [SerializeField] bool m_FPSMode = false;
    [SerializeField] float m_FPSCameraHeight = 1.5f;
    [SerializeField] UpdateType m_updateType = UpdateType.UPDATE;
    [SerializeField] Transform m_target = null;
    //[SerializeField] bool m_inverseVerticalAxis = false;
    [SerializeField] float m_manualCameraSpeedMultiplier = 2;
    [SerializeField] float m_manualCameraVerticalSpeedMultiplier = 2;
    [SerializeField] float m_manualCameraDeadZone = 0.1f;
    [SerializeField] float m_manualCameraAcceleration = 1;
    [SerializeField] float m_mouseSensibility = 1;
    [SerializeField] float m_mouseSmoothDeadzoneSpeed = 5;
    [SerializeField] float m_mouseSmoothDeadzonePow = 2;
    [SerializeField] float m_minVerticaloffset = 1;
    [SerializeField] float m_clampVerticalRotationTop = 85;
    [SerializeField] float m_clampVerticalRotationBottom = -85;
    [SerializeField] float m_clampVerticalRotationTopFPS = 85;
    [SerializeField] float m_clampVerticalRotationBottomFPS = -85;
    [SerializeField] float m_startSpeedRotationDecreaseDestance = 20;
    [SerializeField] float m_distanceReduction = 1;
    [SerializeField] float m_cameraRotSpeed = 2;

    [SerializeField] float m_distanceMultiplierEffect = 1;
    [SerializeField] float m_distanceMultiplierSpeed = 1;
    [SerializeField] int m_distanceMultiplierTestCount = 16;
    [SerializeField] float m_distanceMultiplierMaxDistanceTest = 10;
    [SerializeField] float m_distanceMultiplierTestHeight = 1;
    [SerializeField] float m_distanceMultiplierPow = 1;

    [SerializeField] float m_verticalRecenterSpeed = 1;
    [SerializeField] float m_recenterMaxTime = 1;
    [SerializeField] float m_recenterDelay = 1;
    [SerializeField] float m_groundAngleMultiplier = 0.2f;

    [SerializeField] float m_cameraRayRadius = 0.5f;
    [SerializeField] float m_blockedComeSpeed = 20f;
    [SerializeField] float m_blockedBackSpeed = 1;

    [SerializeField] float m_recenterTime = 0.5f;

    [SerializeField] LayerMask m_raycastsMask = 0;

    Camera m_camera;

    Vector3 m_targetOldposition;
    bool m_targetMoving = false;
    bool m_targetOldMoving = false;

    Vector3 m_originalOffset;
    Vector3 m_originalOrientation;

    Vector3 m_currentOffset;
    Vector3 m_currentCameraOrientation;
    Vector3 m_currentCenter;

    Vector2 m_manualCameraSpeed;

    float m_cameraTargetRecenterFromSurface = 0;
    float m_recenterSpeed = 0;
    float m_timeFromLastInput = 0;

    float m_rotationSpeed = 0;

    float m_distanceMultiplier = 0f;
    float m_distanceMultiplierTarget = 0f;

    float m_targetBlockedDistance;
    float m_lastBlockedDistance;

    bool m_controlesLocked = false;

    Vector2 m_mouseRotValue;

    bool m_onTransform = false;

    SubscriberList m_subscriberList = new SubscriberList();

    float m_fpsMousePropertyValue = 1;
    float m_fpsControlerPropertyValue = 1;
    float m_thirdMousePropertyValue = 1;
    float m_thirdControlerPropertyValue = 1;
    bool m_verticalMousePropertyValue = false;
    bool m_verticalControlerPropertyValue = false;

    public bool FPSMode { get { return m_FPSMode; } }
    public Transform target { get { return m_target; } }

    private void Awake()
    {
        m_camera = GetComponent<Camera>();

        m_subscriberList.Add(new Event<LockPlayerControlesEvent>.Subscriber(onControlesLock));
        m_subscriberList.Add(new Event<ChangeControlerViewEvent>.Subscriber(onChangeViewType));
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
        m_currentOffset = m_originalOffset;
        m_currentCenter = Vector3.zero;
        m_lastBlockedDistance = m_currentOffset.magnitude;
    }

    private void OnEnable()
    {
        m_targetOldposition = m_target.position;
        m_currentCameraOrientation = m_originalOrientation;
        m_currentOffset = m_originalOffset;
        m_currentCenter = Vector3.zero;
        m_lastBlockedDistance = m_currentOffset.magnitude;

        updateSavedProperties();
    }

    private void Update()
    {
        if (Time.deltaTime > 0 && m_updateType == UpdateType.UPDATE)
            onUpdate();
    }

    private void FixedUpdate()
    {
        if (Time.deltaTime > 0 && m_updateType == UpdateType.FIXED_UPDATE)
            onUpdate();
    }

    private void LateUpdate()
    {
        if (Time.deltaTime > 0 && m_updateType == UpdateType.LATE_UPDATE)
            onUpdate();
    }

    void onUpdate()
    {
        m_timeFromLastInput += Time.deltaTime * m_currentCenter.magnitude;

        updateTargetinformations();

        updateCameraInputs();

        checkDistanceMultiplier();
        checkground();

        updateCameraRotationSpeed();

        updateCameraTransform();

        m_targetOldposition = m_target.position;

        if (Input.GetButtonDown(nameRecenterCam))
            recenter();
    }

    void updateTargetinformations()
    {
        m_targetOldMoving = m_targetMoving;
        m_targetMoving = (m_target.position - m_targetOldposition).magnitude > 0.01f;

        m_currentCenter += m_targetOldposition - m_target.position;
    }

    void updateCameraTransform()
    {
        m_currentCameraOrientation.x += m_manualCameraSpeed.y * Time.deltaTime;
        m_currentCameraOrientation.y += m_manualCameraSpeed.x * Time.deltaTime;
        if(Mathf.Abs(m_manualCameraSpeed.x) < 0.01f)
            m_currentCameraOrientation.y += m_rotationSpeed * Time.deltaTime;
        if (Mathf.Abs(m_manualCameraSpeed.y) < 0.01f)
            m_currentCameraOrientation.x += m_recenterSpeed * Time.deltaTime;
        m_currentCameraOrientation.z = 0;
        m_currentCameraOrientation.x = Mathf.Clamp(m_currentCameraOrientation.x, m_FPSMode ? m_clampVerticalRotationBottomFPS : m_clampVerticalRotationBottom, m_FPSMode ? m_clampVerticalRotationTopFPS : m_clampVerticalRotationTop);
        m_currentCameraOrientation.y = m_currentCameraOrientation.y % 360f;

        updateOffsetFromVerticalRotation();

        var cameraOrientation = Quaternion.Euler(m_currentCameraOrientation);
        Vector3 cameraDir = cameraOrientation * m_currentOffset;

        var centerDist = m_currentCenter.magnitude;
        centerDist *= Mathf.Max(1 - (m_distanceReduction * Time.deltaTime), 0);
        m_currentCenter = m_currentCenter.normalized * centerDist;

        var pos = m_target.position;
        if(!m_FPSMode)
            pos += m_currentCenter;
        Vector3 cameraTarget = pos;
        cameraTarget.y += m_originalOffset.y;

        if (!m_FPSMode)
            pos += cameraDir;
        else pos += new Vector3(0, m_FPSCameraHeight, 0);
        transform.position = pos;

        transform.rotation = cameraOrientation;

        Debug.DrawRay(cameraTarget, Vector3.up, Color.cyan);

        updateCameraVisibility(cameraTarget);
    }

    void updateCameraVisibility(Vector3 targetpos)
    {
        RaycastHit hit = new RaycastHit();
        Vector3 dir = transform.position - targetpos;

        if (!Physics.SphereCast(targetpos, m_cameraRayRadius, dir, out hit, dir.magnitude, m_raycastsMask))
            m_targetBlockedDistance = dir.magnitude;
        else
        {
            m_targetBlockedDistance = hit.distance;
            Debug.DrawLine(targetpos, hit.point);
        }

        if (m_targetBlockedDistance > m_lastBlockedDistance)
            m_lastBlockedDistance = Mathf.Min(m_lastBlockedDistance + m_blockedBackSpeed * Time.deltaTime, m_targetBlockedDistance);
        else if (m_targetBlockedDistance < m_lastBlockedDistance)
            m_lastBlockedDistance = Mathf.Max(m_lastBlockedDistance - m_blockedComeSpeed * Time.deltaTime, m_targetBlockedDistance);

        transform.position -= dir;
        transform.position += dir.normalized * m_lastBlockedDistance;
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
        dir.x *= m_manualCameraSpeedMultiplier * (m_FPSMode ? m_fpsControlerPropertyValue : m_thirdControlerPropertyValue);
        dir.y *= m_manualCameraVerticalSpeedMultiplier * (m_FPSMode ? m_fpsControlerPropertyValue : m_thirdControlerPropertyValue);

        if (dir.magnitude > 0.01f || mouseDir.magnitude > 0.01f)
        {
            m_timeFromLastInput = 0;
            m_recenterSpeed = 0;
        }

        if (m_verticalControlerPropertyValue)
            mouseDir.y *= -1;
        if (m_verticalControlerPropertyValue)
            dir.y *= -1;

        float clampVerticalRotationTop = m_FPSMode ? m_clampVerticalRotationTopFPS : m_clampVerticalRotationTop;
        float clampVerticalRotationBottom = m_FPSMode ? m_clampVerticalRotationBottomFPS : m_clampVerticalRotationBottom;

        float multiplier = 1;
        if(m_manualCameraSpeed.y > 0 && m_currentCameraOrientation.x > clampVerticalRotationTop - m_startSpeedRotationDecreaseDestance)
            multiplier = 1 - (m_currentCameraOrientation.x - (clampVerticalRotationTop - m_startSpeedRotationDecreaseDestance)) / m_startSpeedRotationDecreaseDestance;
        if (m_manualCameraSpeed.y < 0 && m_currentCameraOrientation.x < clampVerticalRotationBottom + m_startSpeedRotationDecreaseDestance)
            multiplier = 1 - ((clampVerticalRotationBottom + m_startSpeedRotationDecreaseDestance) - m_currentCameraOrientation.x) / m_startSpeedRotationDecreaseDestance;

        dir.y *= multiplier;

        float verticalAcceleration = m_manualCameraVerticalSpeedMultiplier / m_manualCameraSpeedMultiplier * m_manualCameraAcceleration * (m_FPSMode ? m_fpsControlerPropertyValue : m_thirdControlerPropertyValue);
        float horisontalAcceleration = m_manualCameraAcceleration * (m_FPSMode ? m_fpsControlerPropertyValue : m_thirdControlerPropertyValue);

        if (m_manualCameraSpeed.x < dir.x)
            m_manualCameraSpeed.x = Mathf.Min(m_manualCameraSpeed.x + horisontalAcceleration * Time.deltaTime, dir.x);
        if (m_manualCameraSpeed.x > dir.x)
            m_manualCameraSpeed.x = Mathf.Max(m_manualCameraSpeed.x - horisontalAcceleration * Time.deltaTime, dir.x);
        if (m_manualCameraSpeed.y < dir.y)
            m_manualCameraSpeed.y = Mathf.Min(m_manualCameraSpeed.y + verticalAcceleration * Time.deltaTime, dir.y);
        if (m_manualCameraSpeed.y > dir.y)
            m_manualCameraSpeed.y = Mathf.Max(m_manualCameraSpeed.y - verticalAcceleration * Time.deltaTime, dir.y);

        float verticalMouseSensibility = m_mouseSensibility * m_manualCameraVerticalSpeedMultiplier;
        if (mouseDir.y > 0 && m_currentCameraOrientation.x > clampVerticalRotationTop - m_startSpeedRotationDecreaseDestance)
            verticalMouseSensibility = 1 - (m_currentCameraOrientation.x - (clampVerticalRotationTop - m_startSpeedRotationDecreaseDestance)) / m_startSpeedRotationDecreaseDestance;
        if (mouseDir.y < 0 && m_currentCameraOrientation.x < clampVerticalRotationBottom + m_startSpeedRotationDecreaseDestance)
            verticalMouseSensibility = 1 - ((clampVerticalRotationBottom + m_startSpeedRotationDecreaseDestance) - m_currentCameraOrientation.x) / m_startSpeedRotationDecreaseDestance;

        m_mouseRotValue.x += mouseDir.x * m_mouseSensibility * m_manualCameraSpeedMultiplier * Time.deltaTime * (m_FPSMode ? m_fpsMousePropertyValue : m_thirdMousePropertyValue);
        m_mouseRotValue.y += mouseDir.y * verticalMouseSensibility * Time.deltaTime * (m_FPSMode ? m_fpsMousePropertyValue : m_thirdMousePropertyValue);

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

    void updateOffsetFromVerticalRotation()
    {
        m_currentOffset = Vector3.zero;

        m_currentOffset.x = m_originalOffset.x;
        m_currentOffset.y = m_originalOffset.y * Mathf.Cos(Mathf.Deg2Rad * m_currentCameraOrientation.x);
        if (m_currentCameraOrientation.x > 0)
            m_currentOffset.z = m_originalOffset.z * (m_distanceMultiplier * Mathf.Cos(Mathf.Deg2Rad * m_currentCameraOrientation.x) + 1);
        else
            m_currentOffset.z = Mathf.Lerp(m_originalOffset.z * (m_distanceMultiplier * Mathf.Cos(Mathf.Deg2Rad * m_currentCameraOrientation.x) + 1), m_minVerticaloffset, m_currentCameraOrientation.x / (m_FPSMode ? m_clampVerticalRotationBottomFPS : m_clampVerticalRotationBottom));
    }

    void updateCameraRotationSpeed()
    {
        var distNorm = m_currentCenter.magnitude;

        var currentDir = transform.forward;
        var orthoDir = new Vector3(-currentDir.z, currentDir.y, currentDir.x);

        float cameraRotSpeed = m_FPSMode ? 0 : m_cameraRotSpeed;

        var targetRot = -Vector3.Dot(orthoDir, m_target.forward) * cameraRotSpeed;

        float delta = targetRot - m_rotationSpeed;
        var oldRotSpeed = m_rotationSpeed;
        m_rotationSpeed += delta * cameraRotSpeed * Time.deltaTime;
        if (Math.Sign(oldRotSpeed) != 0 && Math.Sign(m_rotationSpeed) != Math.Sign(oldRotSpeed))
            m_rotationSpeed = 0;
        m_rotationSpeed *= distNorm;
        
        float recenterDistance = m_cameraTargetRecenterFromSurface - m_currentCameraOrientation.x;
        float recenterSpeed = Mathf.Max(Mathf.Min(m_timeFromLastInput - m_recenterDelay, m_recenterMaxTime) / m_recenterMaxTime, 0) * m_verticalRecenterSpeed * recenterDistance;
        m_recenterSpeed = recenterSpeed;

        float multiplierDistance = m_distanceMultiplierTarget - m_distanceMultiplier;
        multiplierDistance *= Mathf.Max(1 - (m_distanceMultiplierSpeed * Time.deltaTime), 0);
        m_distanceMultiplier = m_distanceMultiplierTarget - multiplierDistance;
    }

    void checkDistanceMultiplier()
    {
        Quaternion angle = Quaternion.Euler(0, 360f / m_distanceMultiplierTestCount , 0);
        Vector3 line = Vector3.forward;
        Vector3 pos = m_target.position + Vector3.up * m_distanceMultiplierTestHeight;

        RaycastHit hit = new RaycastHit();

        List<float> hitDistances = new List<float>();

        for(int i = 0; i < m_distanceMultiplierTestCount; i++)
        {
            if (!Physics.Raycast(pos, line, out hit, m_distanceMultiplierMaxDistanceTest, m_raycastsMask))
            {
                Debug.DrawRay(pos, line * m_distanceMultiplierMaxDistanceTest, Color.red);
                hitDistances.Add(m_distanceMultiplierMaxDistanceTest);
            }
            else
            {
                Debug.DrawRay(pos, line * hit.distance, Color.red);
                hitDistances.Add(hit.distance);
            }

            line = angle * line;
        }

        hitDistances.Sort();

        float sum = 0;
        for (int i = 0; i < m_distanceMultiplierTestCount / 2; i++)
            sum += hitDistances[i];

        sum /= (m_distanceMultiplierTestCount / 2) * m_distanceMultiplierMaxDistanceTest;
        sum = Mathf.Pow(sum, m_distanceMultiplierPow);
        sum *= m_distanceMultiplierEffect;
        m_distanceMultiplierTarget = sum;
    }

    void checkground()
    {
        var pos = m_target.position + Vector3.up * m_distanceMultiplierTestHeight;
        RaycastHit hit = new RaycastHit();

        Vector3 normal = Vector3.up;

        if (Physics.Raycast(pos, -Vector3.up, out hit, m_distanceMultiplierTestHeight + 0.5f, m_raycastsMask))
            normal = hit.normal;

        Debug.DrawRay(m_target.position, normal, Color.green);

        normal = Vector3.ProjectOnPlane(normal, transform.right);
        normal = transform.InverseTransformDirection(normal);
        float angle = - Mathf.Deg2Rad * m_currentCameraOrientation.x;

        normal = new Vector3(0, Mathf.Cos(angle) * normal.y + Mathf.Sin(angle) * normal.z, Mathf.Sin(angle) * normal.y - Mathf.Cos(angle) * normal.z);

        angle = Mathf.Rad2Deg * Mathf.Atan2(normal.z, normal.y);
        m_cameraTargetRecenterFromSurface = -angle * m_groundAngleMultiplier;
    }

    void recenter()
    {
        if(!m_onTransform)
        { 
            m_onTransform = true;
            StartCoroutine(recenterCoroutine(m_recenterTime));
        }
    }

    IEnumerator recenterCoroutine(float time)
    {
        m_onTransform = true;
        float currentTime = 0;

        Quaternion currentAngle = transform.rotation;

        while(currentTime < time)
        {
            yield return new WaitForEndOfFrame();
            currentTime += Time.deltaTime;
            m_currentCameraOrientation = Quaternion.Slerp(currentAngle, m_target.rotation, Mathf.Clamp(currentTime / time, 0, 1)).eulerAngles;
            if (m_currentCameraOrientation.x > 180)
                m_currentCameraOrientation.x -= 360f;
        }

        m_currentCameraOrientation = m_target.rotation.eulerAngles;
        if (m_currentCameraOrientation.x > 180)
            m_currentCameraOrientation.x -= 360f;
        m_onTransform = false;
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

    void onChangeViewType(ChangeControlerViewEvent e)
    {
        if(e.viewType == ChangeControlerViewEvent.ControlerViewType.FPS_VIEW)
        {
            m_FPSMode = true;
        }
        else
        {
            m_FPSMode = false;
            m_target.rotation = Quaternion.Euler(0, m_currentCameraOrientation.y, 0);
        }
    }

    void updateSavedProperties()
    {
        float maxValue = 100;
        float maxmultiplier = 5;

        m_fpsMousePropertyValue = G.sys.saveSystem.getFloat(fpsMouseProperty, 0);
        m_fpsControlerPropertyValue = G.sys.saveSystem.getFloat(fpsControlerProperty, 0);
        m_thirdMousePropertyValue = G.sys.saveSystem.getFloat(thirdMouseProperty, 0);
        m_thirdControlerPropertyValue = G.sys.saveSystem.getFloat(thirdControlerProperty, 0);
        m_verticalMousePropertyValue = G.sys.saveSystem.getBool(verticalMouseProperty, m_verticalMousePropertyValue);
        m_verticalControlerPropertyValue = G.sys.saveSystem.getBool(verticalControlerProperty, m_verticalControlerPropertyValue);

        m_fpsMousePropertyValue = m_fpsMousePropertyValue > 0 ? (maxmultiplier - 1) * m_fpsMousePropertyValue / maxValue + 1 : m_fpsMousePropertyValue / (maxValue * (1 + 1 / (maxmultiplier - 1))) + 1;
        m_fpsControlerPropertyValue = m_fpsControlerPropertyValue > 0 ? (maxmultiplier - 1) * m_fpsControlerPropertyValue / maxValue + 1 : m_fpsControlerPropertyValue / (maxValue * (1 + 1 / (maxmultiplier - 1))) + 1;
        m_thirdMousePropertyValue = m_thirdMousePropertyValue > 0 ? (maxmultiplier - 1) * m_thirdMousePropertyValue / maxValue + 1 : m_thirdMousePropertyValue / (maxValue * (1 + 1 / (maxmultiplier - 1))) + 1;
        m_thirdControlerPropertyValue = m_thirdControlerPropertyValue > 0 ? (maxmultiplier - 1) * m_thirdControlerPropertyValue / maxValue + 1 : m_thirdControlerPropertyValue / (maxValue * (1 + 1 / (maxmultiplier - 1))) + 1;
    }
}
