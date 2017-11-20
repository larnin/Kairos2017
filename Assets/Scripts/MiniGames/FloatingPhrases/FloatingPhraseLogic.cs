using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using System;

public class FloatingPhraseLogic : InteractableBaseLogic
{
    [SerializeField]
    private Text m_textToChange;

    [SerializeField]
    private Transform m_targetToRest;

    [SerializeField]
    private Vector3 m_BeginningScale = new Vector3(0.2f, 0.5f, 1.5f);

    [SerializeField]
    private Color m_BeginningColor = Color.black;

    public delegate void destroyedDelegate(FloatingPhraseLogic floatingPhrase);
    public delegate void selectedDelegate(FloatingPhraseLogic floatingPhrase);
    
    private Camera m_camera;
    private Collider m_collider;
    private Renderer m_renderer;

    private bool canMoveUp = false;

    private float m_decalSin = 0f;

    private bool m_cursorIsHover = false;
    private Color m_currentColorHoverinSetted = Color.white;

    private bool m_selected = false;

    private byte m_index;
    public byte Index
    {
        get
        {
            return m_index;
        }

        set
        {
            m_index = value;
        }
    }

    private destroyedDelegate m_onDestroyDelegate;
    public destroyedDelegate onDestroyCallback
    {
        get
        {
            return m_onDestroyDelegate;
        }

        set
        {
            m_onDestroyDelegate = value;
        }
    }

    
    private selectedDelegate m_onSelectedDelegate;
    public selectedDelegate onSelected
    {
        get
        {
            return m_onSelectedDelegate;
        }

        set
        {
            m_onSelectedDelegate = value;
        }
    }
    
    public void SetTargetToRest(Transform e)
    {
        m_targetToRest = e;
    }

    public void SetDecalSin(float decalSin)
    {
        m_decalSin = decalSin;
    }

    // Use this for initialization
    void Start ()
    {
        m_camera = Camera.main;
        m_collider = GetComponent<Collider>();
        m_renderer = GetComponentInChildren<Renderer>();
        GotToRest();
    }

    // Update is called once per frame
    void Update()
    {
        if(! m_selected)
        { 
            if (canMoveUp)
            {
                moveUp();
                updateHoveringColor();
            }

            if (m_textToChange.enabled)
            {
                if (transform.position.y > 5.4f)
                {
                    beginDisappear();
                }
            }

        }
        transform.LookAt(m_camera.transform);
    }

    private void beginDisappear()
    {
        m_textToChange.enabled = false;
        transform.DOScale(0.1f, 1f).OnComplete(() =>
        {
            Destroy(gameObject);
        });

        m_collider.enabled = false;
        m_cursorIsHover = false;
        m_renderer.material.DOColor(Color.black, 0.5f);
    }

    private void moveUp()
    {
        // this code is "buggy" 
        //Vector3 horizontalForce = transform.forward * Mathf.Sin(m_decalSin + transform.position.y * 1.5f) * 0.75f;
        Vector3 verticalForce = Vector3.up * 0.85f;
        Vector3 newForce = (verticalForce) * (m_cursorIsHover ? 0.5f : 1f);
        newForce *= Time.deltaTime;

        transform.Translate(newForce, Space.World);
    }

    private void updateHoveringColor()
    {
        if(m_textToChange.enabled)
        {
            if (m_cursorIsHover && m_currentColorHoverinSetted != Color.blue)
            {
                m_renderer.material.color = Color.blue; 
                m_currentColorHoverinSetted = Color.blue;
            }
            else if (!m_cursorIsHover && m_currentColorHoverinSetted != Color.white)
            {
                m_renderer.material.color = Color.white;
                m_currentColorHoverinSetted = Color.white;
            }
        }
    }

    void OnDestroy()
    {
        m_onDestroyDelegate(this);
    }

    void SettargetToRest(Transform e)
    {
        m_targetToRest = e;
    }

    void GotToRest()
    {
        m_renderer.material.color = m_BeginningColor;
        m_textToChange.enabled = false;
        transform.localScale = m_BeginningScale;
        transform.DOMove(m_targetToRest.position + UnityEngine.Random.insideUnitSphere*0.5f, 0.75f).OnComplete(() => {
            m_renderer.material.DOColor(Color.white, 0.25f);
            transform.DOScale(1f, 0.25f).OnComplete(() =>{
                m_textToChange.enabled = true;
                canMoveUp = true;
            });
        });
    }

    public override void onEnter(OrigineType type, Vector3 localPosition)
    {
        if(type == OrigineType.CURSOR)
        {
            m_cursorIsHover = true;
        }

    }

    public override void onExit(OrigineType type)
    {
        if (type == OrigineType.CURSOR)
        {
            m_cursorIsHover = false;
        }
    }

    public override void onInteract(OrigineType type, Vector3 localPosition)
    {
        if (type == OrigineType.CURSOR && m_textToChange.enabled)
        {
            Time.timeScale = 0f;
            m_renderer.material.color = Color.cyan;
            transform.DOMove(transform.position + transform.forward, 0.75f).SetUpdate(true).OnComplete(() =>
            {
                onSelected(this);
            });
            m_selected = true;
        }
    }

    public override void onInteractEnd(OrigineType type)
    {
        
    }

    public override void onDrag(DragData data, OrigineType type)
    {
        
    }
}
