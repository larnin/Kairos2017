using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
class NavMeshFPSCharacterLogic : BaseCharacterLogic
{
    [SerializeField] float m_moveSpeed = 1f;
    [SerializeField] float m_accelerationSpeed = 10f;
    [SerializeField] float m_sideMoveMultiplier = 0.5f;

    NavMeshAgent m_agent;

    bool m_moving = false;
    float m_turnAmount = 0;
    float m_targetForwardAmont = 0;
    float m_forwardAmount = 0;
    float m_currentDelay;

    float m_currentSpeed = 0;
    Vector2 m_oldDir = new Vector2(); 

    Camera m_camera;

    void Awake()
    {
        m_agent = GetComponent<NavMeshAgent>();
        m_camera = Camera.main;
    }

    public override void move(Vector3 move)
    {
        var move2D = new Vector2(move.x, move.z);

        var cameraDir = new Vector2(m_camera.transform.forward.x, m_camera.transform.forward.z).normalized;
        var cameraDirOrt = new Vector2(cameraDir.y, -cameraDir.x);
        var forwardValue = Vector2.Dot(cameraDir, move2D);
        var ortValue = Vector2.Dot(cameraDirOrt, move2D) * m_sideMoveMultiplier;
        if (forwardValue < 0)
            forwardValue *= m_sideMoveMultiplier;
        move2D = cameraDir * forwardValue + cameraDirOrt * ortValue;

        var s = Mathf.Min(move2D.magnitude * m_moveSpeed, m_moveSpeed);
        if (s > m_currentSpeed)
            m_currentSpeed = Mathf.Min(m_currentSpeed + m_accelerationSpeed * Time.deltaTime, s);
        if (s < m_currentSpeed)
            m_currentSpeed = Mathf.Max(m_currentSpeed - m_accelerationSpeed * Time.deltaTime, 0);

        if (move2D.magnitude < 0.01f)
            move2D = m_oldDir;

        m_oldDir = move2D;

        m_agent.velocity = new Vector3(move2D.x * m_currentSpeed, m_agent.velocity.y, move2D.y * m_currentSpeed);
    }

    public bool moving { get { return m_moving; } }

    public void OnAnimatorMove()
    {
        //fuck your animator controls
    }
}