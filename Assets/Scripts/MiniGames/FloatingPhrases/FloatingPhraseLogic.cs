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
    
    public delegate void destroyedDelegate(FloatingPhraseLogic floatingPhrase);
    public delegate bool isWholeAnimationOccuringDelegate();

    private Camera m_camera;
    private TextMeshPro m_textToChange;
    
    private bool m_IsDoingAnimation = false;
    
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
    
    private bool m_beingDestroy = false;
    public bool beingDestroy
    {
        get
        {
            return m_beingDestroy;
        }

        set
        {
            m_beingDestroy = value;
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
    
    [NonSerialized] public Action<FloatingPhraseLogic> m_onDestroy;
    [NonSerialized] public Func<bool> m_isWholeAnimationOccuring;
    

    // Use this for initialization
    void Awake ()
    {
        m_camera = Camera.main;
        m_textToChange = GetComponent<TextMeshPro>();
        m_baseAttributes = ScriptableObject.CreateInstance<TextMeshProAttributes>();
        saveTextMeshProAttributes(m_baseAttributes);
    }

    void Start()
    {  
        Init();
    }

    // Update is called once per frame
    void Update()
    {        
        transform.LookAt(m_camera.transform);
        transform.Rotate(Vector3.up, 180f);
    }

    void OnDestroy()
    {
       m_onDestroy(this);
    }
   
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

    private void Init()
    {
        m_textToChange.enabled = true;
        transform.localScale = new Vector3(1f, 1f, 1f);
    }
}
