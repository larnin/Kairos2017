using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class InteractableMiniGameByCursorLogic : InteractableBaseLogic
{
    [SerializeField]
    private MiniGameBaseLogic m_miniGame;

    private Renderer m_renderer;

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
        m_renderer.enabled = false;
        Camera.main.GetComponent<FollowCamera>().enabled = false;
        Event<LockPlayerControlesEvent>.Broadcast(new LockPlayerControlesEvent(true));
        Camera.main.transform.DOMove (m_miniGame.CameraTransformUsed.position, 1.0f);
        Camera.main.transform.DORotate(m_miniGame.CameraTransformUsed.rotation.eulerAngles, 1.0f).OnComplete(beginMiniGame);
    }

    public override void onInteractEnd(OrigineType type)
    {
        // no used for this class
    }
    
    void beginMiniGame()
    {
        gameObject.SetActive(false);
        m_miniGame.activate();
    }

    void replaceCamera()
    {
        gameObject.SetActive(true);
    }

    void Start()
    {
        m_renderer = GetComponent<Renderer>();
       // m_miniGame.desactivate += StopMiniGame;
    }
}
