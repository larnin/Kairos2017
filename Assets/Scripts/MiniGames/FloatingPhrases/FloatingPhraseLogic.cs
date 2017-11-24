using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using System;

/*
 * cette classe sert a gerer une phrase flottante. 
 * */

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

    [SerializeField]
    private float m_heightWhenPhraseDisappear = 5.4f;

    [SerializeField]
    private float m_speedUP = 0.50f;
    
    public delegate void destroyedDelegate(FloatingPhraseLogic floatingPhrase);
    public delegate void selectedDelegate(FloatingPhraseLogic floatingPhrase);
    public delegate bool isWholeAnimationOccuringDelegate();

    private Camera m_camera;
    private Collider m_collider;
    private Renderer m_renderer;

    private bool canMoveUp = false;

    //private float m_decalSin = 0f;

    private bool m_cursorIsHover = false;
    private Color m_currentColor = Color.white;

    private bool m_selected = false;
    private bool m_isTheLastOneAndTheIndice = false;
    private bool m_IsDoingAnimation = false;
    private bool m_isMatched = false;
    private bool m_frozen = false;

    public bool IsMatched
    {
        get
        {
            return m_isMatched;
        }

        set
        {
            m_isMatched = value;    
            if(m_isMatched)
            {
                m_selected = false;
            }
        }
    }
    
    public bool IsDoingAnimation
    {
        get
        {
            return m_IsDoingAnimation;
        }
    }

    public void unselect()
    {
        m_selected = false;
    }

    [SerializeField]
    private byte m_matchingIndex;
    public byte MatchingIndex
    {
        get
        {
            return m_matchingIndex;
        }

        set
        {
            m_matchingIndex = value;
        }
    }

    private int m_index;
    public int Index
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

    private isWholeAnimationOccuringDelegate m_isWholeAnimationOccuring;
    public isWholeAnimationOccuringDelegate IsWholeAnimationOccuring
    {
        get
        {
            return m_isWholeAnimationOccuring;
        }

        set
        {
            m_isWholeAnimationOccuring = value;
        }
    }

    public void SetTargetToRest(Transform e)
    {
        m_targetToRest = e;
    }

    /*
    public void SetDecalSin(float decalSin)
    {
        m_decalSin = decalSin;
    }
    */

    
    public void SetSpeedUP(float value)
    {
        m_speedUP = value;
    }
    
    public void setHeightWhenPhraseDisappear(float value)
    {
        m_heightWhenPhraseDisappear = value;
    }

    public void freeze()
    {
        m_frozen = true;
    }

    public void unFreeze()
    {
        m_frozen = false;
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
        if(! m_selected || (m_selected && m_isMatched))
        { 
            if (canMoveUp)
            {
                if (!m_frozen)
                {
                    moveUp();
                }
            }

            if (m_textToChange.enabled)
            {
                if (transform.position.y > m_heightWhenPhraseDisappear)
                {
                    beginDisappear();
                }
            }

        }

        if (canMoveUp)
        {
            updateColorFeedback();
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
        // this code is will be remplaced 
        //Vector3 horizontalForce = transform.forward * Mathf.Sin(m_decalSin + transform.position.y * 1.5f) * 0.75f;

        Vector3 verticalForce = Vector3.up * m_speedUP;
        Vector3 newForce = (verticalForce); //* (m_cursorIsHover ? 0.5f : 1f);
        newForce *= Time.deltaTime;

        transform.Translate(newForce, Space.World);
    }

    private void updateColorFeedback()
    {
        if(m_textToChange.enabled)
        {
            if (m_isMatched)
            {
                m_renderer.material.color = Color.yellow;
                m_collider.enabled = false;
            }
            
            else if(m_selected)
            {
                m_renderer.material.color = Color.cyan;
            }

            else if (m_cursorIsHover)
            {
                m_renderer.material.color = Color.blue;
            }

            else
            {
                m_renderer.material.color = Color.white;
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

    public bool tryAppearing()
    {
        if(canMoveUp)
        {
            m_textToChange.enabled = true;
        }
        m_renderer.enabled = true;
        
        return !m_selected;
    }

    public bool tryDisappearing()
    {
        bool canDoIt = (!m_isMatched) && (!m_selected);
        if (canDoIt)
        {
            if (canMoveUp)
            {
                m_textToChange.enabled = false;
            }
            m_renderer.enabled = false;
        }
        return !m_selected;
    }

    private void GotToRest()
    {
        m_renderer.material.color = m_BeginningColor;
        m_textToChange.enabled = false;
        transform.localScale = m_BeginningScale;
        transform.DOMove(m_targetToRest.position + UnityEngine.Random.insideUnitSphere * 0.5f, 0.75f).OnComplete(() => {
            m_renderer.material.DOColor(Color.white, 0.25f);
            transform.DOScale((m_isTheLastOneAndTheIndice ? 1.5f : 1f), 0.25f).OnComplete(() =>{

                if (m_renderer.enabled)
                {
                    m_textToChange.enabled = true;
                }
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
        if (type == OrigineType.CURSOR && m_textToChange.enabled && !m_IsDoingAnimation &&
            !IsWholeAnimationOccuring())
        {
            if (m_selected)
            {
                onSelected(this);
            }
            else
            {
                m_selected = true;
                onSelected(this);
            }
        }
    }

    public override void onInteractEnd(OrigineType type)
    {
        
    }

    public override void onDrag(DragData data, OrigineType type)
    {
        
    }
}
