using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class InteractableMiniGameByCursorLogic : InteractableBaseLogic
{
    [SerializeField]
    private MiniGameBaseLogic m_miniGame;

    public Renderer m_renderer;

    private Vector3 baseCameraPosition;
    private Vector3 baseCameraRotation;


    public override void onDrag(DragData data, OrigineType type)
    {
        // no used for this class
    }

    public override void onEnter(OrigineType type, Vector3 localPosition)
    {
        m_renderer.enabled = true;
    }

    public override void onExit(OrigineType type)
    {
        m_renderer.enabled = false;
    }

    public override void onInteract(OrigineType type, Vector3 localPosition)
    {
        beginMiniGame();
    }

    public override void onInteractEnd(OrigineType type)
    {
        // no used for this class
    }
    
    void beginMiniGame()
    {
        Event<EnableCursorEvent>.Broadcast(new EnableCursorEvent(true, true));
        Event<LockPlayerControlesEvent>.Broadcast(new LockPlayerControlesEvent(true));
        gameObject.SetActive(false);
        m_miniGame.activate();
    }

    void StopMiniGame()
    {
        gameObject.SetActive(true);
        Event<EnableCursorEvent>.Broadcast(new EnableCursorEvent(false));
        Event<LockPlayerControlesEvent>.Broadcast(new LockPlayerControlesEvent(false));
    }

    void Start()
    {
        m_renderer = GetComponent<Renderer>();
        m_miniGame.desactivate += StopMiniGame;
    }
}
