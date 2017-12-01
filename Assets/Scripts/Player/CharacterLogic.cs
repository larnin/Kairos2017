using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
[RequireComponent(typeof(Animator))]
public class CharacterLogic : BaseCharacterLogic
{
    [SerializeField] float m_moveSpeed = 1f;
    [SerializeField] float m_movingTurnSpeed = 360f;
    [SerializeField] float m_stationaryTurnSpeed = 180f;
    [SerializeField] float m_groundCheckDistance = 0.2f;
    [SerializeField] float m_gravityMultiplier = 1f;
    [SerializeField] float m_animSpeedMultiplier = 1f;
    [SerializeField] float m_accelerationSpeed = 10f;
    [SerializeField] float m_delayMoveAfterRotation = 0.2f;

    [SerializeField] float m_groundCastRadius = 0.25f;
    [SerializeField] LayerMask m_raycastsMask = 0;

    Rigidbody m_rigidbody;
    Animator m_animator;

    bool m_moving = false;
    bool m_grounded = true;
    Vector3 m_groundNormal = Vector3.up;
    float m_turnAmount = 0;
    float m_targetForwardAmont = 0;
    float m_forwardAmount = 0;
    float m_currentDelay;

    void Awake ()
    {
        m_rigidbody = GetComponent<Rigidbody>();
        m_animator = GetComponent<Animator>();

        m_rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY | RigidbodyConstraints.FreezeRotationZ;
    }

    public override void move(Vector3 move)
    {
        const float maxFullAngle = Mathf.PI / 3;
        const float minZeroAngle = 2 * Mathf.PI / 3;

        m_currentDelay += Time.deltaTime;

        move = transform.InverseTransformDirection(move);
        checkGroundStatus();
        move = Vector3.ProjectOnPlane(move, m_groundNormal);
        m_turnAmount = Mathf.Atan2(move.x, move.z);
        m_targetForwardAmont = new Vector2(move.x, move.z).magnitude;
        if (Mathf.Abs(m_turnAmount) > maxFullAngle)
        {
            var normalizedAngle = Mathf.Abs(m_turnAmount) - (maxFullAngle);
            normalizedAngle = Mathf.Max(1 - (normalizedAngle / (minZeroAngle - maxFullAngle)), 0);

            m_currentDelay = normalizedAngle * m_delayMoveAfterRotation;
        }

        if (m_currentDelay < m_delayMoveAfterRotation)
            m_targetForwardAmont = 0;

        if (m_forwardAmount < m_targetForwardAmont)
        {
            m_forwardAmount += m_accelerationSpeed * Time.deltaTime;
            if (m_forwardAmount > m_targetForwardAmont)
                m_forwardAmount = m_targetForwardAmont;
        }
        else
        {
            m_forwardAmount -= m_accelerationSpeed * Time.deltaTime;
            if (m_forwardAmount < m_targetForwardAmont)
                m_forwardAmount = m_targetForwardAmont;
        }

        applyExtraTurnRotation();

        updateAnimator(move);

        if (m_grounded)
        {
            Vector3 v = m_forwardAmount * transform.forward * m_moveSpeed;
            v.y = m_rigidbody.velocity.y;
            m_rigidbody.velocity = v;
        }
        else
            handleAirborneMovement();
    }

    public bool moving { get { return m_moving; } }

    public bool grounded { get { return m_grounded; } }

    void checkGroundStatus()
    {
        RaycastHit hitInfo;

        if (Physics.SphereCast(transform.position + (Vector3.up * (0.1f + m_groundCastRadius)), m_groundCastRadius, Vector3.down, out hitInfo, m_groundCheckDistance, m_raycastsMask))
        {
            m_groundNormal = hitInfo.normal;
            m_grounded = true;
            m_animator.applyRootMotion = true;
        }
        else
        {
            m_grounded = false;
            m_groundNormal = Vector3.up;
            m_animator.applyRootMotion = false;
        }
    }

    void applyExtraTurnRotation()
    {
        float turnSpeed = Mathf.Lerp(m_stationaryTurnSpeed, m_movingTurnSpeed, Mathf.Clamp(m_forwardAmount, 0, 1));
        transform.Rotate(0, m_turnAmount * turnSpeed * Time.deltaTime, 0);
    }
    
    void handleAirborneMovement()
    {
        Vector3 extraGravityForce = (Physics.gravity * m_gravityMultiplier) - Physics.gravity;
        m_rigidbody.AddForce(extraGravityForce);
    }

    void updateAnimator(Vector3 move)
    {
        m_animator.SetFloat("Forward", m_forwardAmount, 0.1f, Time.deltaTime);
        m_animator.SetFloat("Turn", m_turnAmount, 0.1f, Time.deltaTime);
        m_animator.SetBool("OnGround", m_grounded);
        if (!m_grounded)
        {
            m_animator.SetFloat("Jump", m_rigidbody.velocity.y);
        }
    
        if (m_grounded && move.sqrMagnitude > 0)
            m_animator.speed = m_animSpeedMultiplier;
        else
            m_animator.speed = 1;
    }

   public void OnAnimatorMove()
    {
        //fuck your animator controls
    }
}
