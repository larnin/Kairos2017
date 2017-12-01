using System.Collections;
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
public class FloatingPhraseLogic : MonoBehaviour
{
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
    public delegate bool isWholeAnimationOccuringDelegate();

    private Camera m_camera;
    private Collider m_collider;
    private TextMeshPro m_textToChange;
    
    private Transform m_targetToRest;

    private bool canMoveUp = false;
    

    private bool m_cursorIsHover = false;
    private Color m_currentColor = Color.white;
    
    private bool m_IsDoingAnimation = false;
    private bool m_frozen = false;

    private float m_timeTransitionBetweenAttributes = 0.4f;
    public float timeTransitionBetweenAttributes
    {
        set
        {
            m_timeTransitionBetweenAttributes = value;
        }
    }
    
    
    public bool IsDoingAnimation
    {
        get
        {
            return m_IsDoingAnimation;
        }
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
    void Awake ()
    {
        m_camera = Camera.main;
        m_collider = GetComponent<Collider>();
        m_textToChange = GetComponent<TextMeshPro>();
        m_baseAttributes = new TextMeshProAttributes();
        saveTextMeshProAttributes(m_baseAttributes);
    }

    void Start()
    {  
        GotToRest();
    }

    // Update is called once per frame
    void Update()
    {
 
        if (canMoveUp)
        {
            if (!m_frozen)
            {
                moveUp();
            }
        }
        
        transform.LookAt(m_camera.transform);
        transform.Rotate(Vector3.up, 180f);
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
    

    void OnDestroy()
    {
       // m_onDestroyDelegate(this);
    }

    void SettargetToRest(Transform e)
    {
        m_targetToRest = e;
    }

    Tweener TweenColor = null;
    Tweener TweenOutLineColor = null;
    public void applyTextMeshProAttributes(TextMeshProAttributes value = null,bool instant = true)
    {
        if (value == null)
        {
            value = m_baseAttributes;
        }

        m_textToChange.fontStyle = value.m_fontStyle;
        if (instant)
        {
            m_textToChange.color = value.m_faceSettingColor;
            m_textToChange.faceColor = value.m_faceSettingColor;
            m_textToChange.outlineColor = value.m_outlineColor;
        }
        else
        {
           DOTween.To(() => m_textToChange.color,
                x => { m_textToChange.color = x; m_textToChange.faceColor = x;},
                value.m_faceSettingColor,
                m_timeTransitionBetweenAttributes);

           DOTween.To( () => m_textToChange.outlineColor, 
                x => m_textToChange.outlineColor = x, 
                value.m_outlineColor, 
                m_timeTransitionBetweenAttributes);
        }
    }

    public void saveTextMeshProAttributes(TextMeshProAttributes value)
    {
        value.m_fontStyle = m_textToChange.fontStyle;
        value.m_faceSettingColor = m_textToChange.color;
        value.m_outlineColor = m_textToChange.outlineColor;
    }

    private void GotToRest()
    {
        canMoveUp = true;
        m_textToChange.enabled = true;
        transform.position = m_targetToRest.position;
        transform.localScale = new Vector3(1f, 1f, 1f);
    }
}
