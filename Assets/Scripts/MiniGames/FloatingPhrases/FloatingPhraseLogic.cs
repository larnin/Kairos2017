﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using TMPro;
using System;
using System.Reflection;

/*
 * cette classe sert a gerer une phrase flottante. 
 * */
public class FloatingPhraseLogic : InteractableBaseLogic
{
    [SerializeField]
    private TextMeshProAttributes m_hoverAttributes;
    [SerializeField]
    private TextMeshProAttributes m_selectedAttributes;
    [SerializeField]
    private TextMeshProAttributes m_MatchedAttributes;


    private TextMeshProAttributes m_baseAttributes;

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
    private TextMeshPro m_textToChange;

    // [SerializeField]
    private Transform m_targetToRest;

    private bool canMoveUp = false;

    //private float m_decalSin = 0f;

    private bool m_cursorIsHover = false;
    private Color m_currentColor = Color.white;

    private bool m_selected = false;
    private bool m_isTheLastOneAndTheIndice = false;
    private bool m_IsDoingAnimation = false;
    private bool m_isMatched = false;
    private bool m_frozen = false;

    //PLACEHOLDERS !!!!!
    public Transform m_shadow = null;

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
                applyTextMeshProAttributes(m_MatchedAttributes);
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
    // PLACEHOLDERS
    public void selectPlaceholder()
    {
        m_selected = true;
        applyTextMeshProAttributes(m_selectedAttributes);
    }


    public void unselect()
    {
        m_selected = false;
        applyTextMeshProAttributes(m_baseAttributes);
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
        m_renderer = transform.GetChild(0).GetChild(0).GetComponent<Renderer>();
        m_textToChange = GetComponent<TextMeshPro>();
        m_baseAttributes = new TextMeshProAttributes();
        saveTextMeshProAttributes(m_baseAttributes);
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
        transform.Rotate(Vector3.up, 180f);
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
        /*
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
               // m_textToChange.material = m_hoverMaterial;
            }

            else
            {
                m_renderer.material.color = Color.white;
            }
        }
        */
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
            //m_textToChange.enabled = true;
        }
       // m_renderer.enabled = true;
        
        return !m_selected;
    }

    public bool tryDisappearing()
    {
        bool canDoIt = (!m_isMatched) && (!m_selected);
        if (canDoIt)
        {
            if (canMoveUp)
            {
               // m_textToChange.enabled = false;
            }
           // m_renderer.enabled = false;
        }
        return !m_selected;
    }

    public bool trySetAlpha(float value)
    {
       // if(canMoveUp)
        {
            Color e = m_textToChange.color;
            e.a = value;
            m_textToChange.color = e;
        }
        return canMoveUp;
    }

    public void applyTextMeshProAttributes(TextMeshProAttributes value)
    {
        m_textToChange.fontStyle = value.m_fontStyle;
        m_textToChange.color = value.m_faceSettingColor;
        m_textToChange.outlineColor = value.m_outlineColor;
    }

    public void saveTextMeshProAttributes(TextMeshProAttributes value)
    {
        value.m_fontStyle = m_textToChange.fontStyle;
        value.m_faceSettingColor = m_textToChange.color;
        value.m_outlineColor = m_textToChange.outlineColor;
    }

    private void GotToRest()
    {
        m_renderer.material.color = m_BeginningColor;
        m_textToChange.enabled = false;
        transform.localScale = m_BeginningScale;
        transform.DOMove(m_targetToRest.position, 0.75f).OnComplete(() => {
            //m_renderer.material.DOColor(Color.white, 0.25f);
            transform.DOScale((m_isTheLastOneAndTheIndice ? 1.5f : 1f), 0.25f).OnComplete(() =>{

                ///if (m_renderer.enabled)
                {
                    m_textToChange.enabled = true;
                }
                canMoveUp = true;
            });
        });
    }

    public override void onEnter(OrigineType type, Vector3 localPosition)
    {
        if(type == OrigineType.CURSOR && !m_isMatched && !m_selected)
        {
            m_cursorIsHover = true;
            //Destroy(m_textToChange);
            //UnityEditorInternal.ComponentUtility.CopyComponent(m_hoverPrefab);
            //UnityEditorInternal.ComponentUtility.PasteComponentValues(m_textToChange);
            //  m_textToChange = gameObject.GetComponent<TextMeshPro>();
            //Destroy(m_textToChange);
            //m_textToChange = gameObject.AddComponent2<TextMeshPro>(m_hoverPrefab);

            applyTextMeshProAttributes(m_hoverAttributes);
        }

    }

    public override void onExit(OrigineType type)
    {
        if (type == OrigineType.CURSOR && !m_isMatched && !m_selected)
        {
            //    m_cursorIsHover = false;
            applyTextMeshProAttributes(m_baseAttributes);
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
                applyTextMeshProAttributes(m_selectedAttributes);
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
