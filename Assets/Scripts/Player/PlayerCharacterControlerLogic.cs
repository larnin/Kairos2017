using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(BaseCharacterLogic))]
class PlayerCharacterControlerLogic : MonoBehaviour
{
    const string moveXAxis = "Horizontal";
    const string moveYAxis = "Vertical";

    BaseCharacterLogic m_character;
    Transform m_camera;

    SubscriberList m_subscriberList = new SubscriberList();

    bool m_controlesLocked = false;

    private void Awake()
    {
        m_character = GetComponent<BaseCharacterLogic>();
        m_camera = Camera.main.transform;

        m_subscriberList.Add(new Event<LockPlayerControlesEvent>.Subscriber(onLockControles));
        m_subscriberList.Add(new Event<ChangeControlerViewEvent>.Subscriber(onChangeControlerView));
        m_subscriberList.Add(new Event<PauseEvent>.Subscriber(onPause));
        m_subscriberList.Subscribe();
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }
    
    private void Update()
    {
        var dir = new Vector2(Input.GetAxisRaw(moveXAxis), Input.GetAxisRaw(moveYAxis));

        if (m_controlesLocked)
            dir = Vector2.zero;

        var camDir = m_camera.forward;
        var camDir2D = new Vector2(camDir.x, camDir.z).normalized;
        var camDir2DOthro = new Vector2(camDir2D.y, -camDir2D.x);
        dir = dir.y * camDir2D + dir.x * camDir2DOthro;

        m_character.move(new Vector3(dir.x, 0, dir.y));
    }

    void onLockControles(LockPlayerControlesEvent e)
    {
        m_controlesLocked = e.locked;
    }

    void onChangeControlerView(ChangeControlerViewEvent e)
    {

    }

    void onPause(PauseEvent e)
    {
        onLockControles(new LockPlayerControlesEvent(e.paused));
    }
}