using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System;

/*
 * cette classe sert a gérer le mini jeu
 * 
 * * */
public class RumorsOfShadowsManager : MiniGameBaseLogic
{

    [SerializeField]
    private IndiceGeneratorLogic indiceGeneratorLogic;

    [SerializeField]
    private float m_animationTime = 0.5f;
    [SerializeField]
    private int m_numberOfMatchNeeded = 2;

    [SerializeField]
    private TextMeshProAttributes m_hoverAttributes;
    public TextMeshProAttributes hoverAttributes
    {
        get
        {
            return m_hoverAttributes;
        }
    }

    [SerializeField]
    private TextMeshProAttributes m_selectedAttributes;
    public TextMeshProAttributes selectedAttributes
    {
        get
        {
            return m_selectedAttributes;
        }
    }

    [SerializeField]
    private TextMeshProAttributes m_MatchedAttributes;
    public TextMeshProAttributes matchedAttributes
    {
        get
        {
            return m_MatchedAttributes;
        }
    }

    [SerializeField]
    private TextMeshProAttributes m_unMtachedAttributes;
    public TextMeshProAttributes UnMtachedAttributes
    {
        get
        {
            return m_unMtachedAttributes;
        }
    }
    
    [SerializeField]
    float  m_timeTransitionBetweenAttributes = 0.4f;
    public float timeTransitionBetweenAttribute
    {
        get
        {
            return m_timeTransitionBetweenAttributes;
        }
    }
    
    [SerializeField]
    private List<ShadowMatched> shadowMatchedList;
    
    [System.Serializable]
    class ShadowMatched
    {
        public Transform A;
        public Transform B;
    }

    private bool m_activated = true;
    private bool m_animationIsOccuring = false;
    private int m_currentNumberOfMatch = 0;

    private FloatingPhraseGeneratorLogic[] m_generators;
    private FloatingPhraseLogic m_firstSelected = null;

    private FloatingPhraseLogic m_secondSelected = null;

    private Transform m_firstShadowSelected = null;
    private Transform m_secondShadowSelected = null;
    
    public override void activate()
    {

    }
    
    // Use this for initialization
    void Awake ()
    {
        m_generators = FindObjectsOfType<FloatingPhraseGeneratorLogic>();
        foreach(FloatingPhraseGeneratorLogic e in m_generators)
        {
            e.setRumorsOfShadowsManager(this);
        }
    }
	

    private bool canMatch(Transform shadow1,Transform shadow2)
    {
        foreach (ShadowMatched e in shadowMatchedList)
        {
            if ( (e.A == shadow1 && e.B == shadow2) || (e.B == shadow1 && e.A == shadow2) )
            {
                return true;
            }
        }
        
        return false;
    }

    public void hoverShadow(Transform transformShadow, bool isHovering)
    {
        foreach(Transform e in transformShadow)
        {
            FloatingPhraseLogic floatingPhrase = e.GetComponent<FloatingPhraseLogic>();
            if (floatingPhrase && !floatingPhrase.beingDestroy)
            {
                if(isHovering)
                {
                    floatingPhrase.applyTextMeshProAttributes(m_hoverAttributes, false);
                }
                else
                {
                    floatingPhrase.applyTextMeshProAttributes(null, false);
                }
                
            }
        }
    }

    public bool globalAnimationOccuring()
    {
        return m_animationIsOccuring;
    }
    
    public bool selectShadow(Transform transformShadow)
    {
        if (!m_firstShadowSelected)
        {
            m_firstShadowSelected = transformShadow;

            foreach (Transform e in transformShadow)
            {
                ApplyFeedBack(e, m_selectedAttributes);
            }
            return true;
        }

        else if (m_firstShadowSelected == transformShadow)
        {
            foreach (Transform e in transformShadow)
            {
                ApplyFeedBack(e, m_hoverAttributes);
            }
            m_firstShadowSelected = null;
            return false;
        }
        else
        {
            m_secondShadowSelected = transformShadow;

            if (canMatch(m_firstShadowSelected, m_secondShadowSelected))
            {
                indiceGeneratorLogic.unlockOneIndice();
                StartCoroutine(animationForCorrectPhrase(m_firstShadowSelected, m_secondShadowSelected));
            }
            else
            {
                StartCoroutine(animationForWrongPhrase(m_firstShadowSelected, m_secondShadowSelected));
            }
            
            return true;
        }
    }

    private void ApplyFeedBack(Transform e, TextMeshProAttributes meshProAttributes)
    {
        FloatingPhraseLogic floatingPhrase = e.GetComponent<FloatingPhraseLogic>();
        if (floatingPhrase && !floatingPhrase.beingDestroy)
        {
            floatingPhrase.applyTextMeshProAttributes(meshProAttributes, false);
        }
    }

    public  IEnumerator animationForCorrectPhrase(Transform shadow1, Transform shadow2)
    {
        m_animationIsOccuring = true;

        foreach (Transform e in shadow1)
        {
            FloatingPhraseLogic floatingPhrase = e.GetComponent<FloatingPhraseLogic>();
            if (floatingPhrase && !floatingPhrase.beingDestroy)
            {
                floatingPhrase.applyTextMeshProAttributes(m_MatchedAttributes, false);
            }
        }

        foreach (Transform e in shadow2)
        {
            FloatingPhraseLogic floatingPhrase = e.GetComponent<FloatingPhraseLogic>();
            if (floatingPhrase && !floatingPhrase.beingDestroy)
            {
                floatingPhrase.applyTextMeshProAttributes(m_MatchedAttributes, false);
            }
        }

        shadow1.GetComponent<ShadowTriggerSelectionLogic>().shadowIsMatched = true;
        shadow2.GetComponent<ShadowTriggerSelectionLogic>().shadowIsMatched = true;

        yield return null;
        m_firstSelected = null;
        m_secondSelected = null;

        m_animationIsOccuring = false;
    }

    IEnumerator animationForWrongPhrase(Transform shadow1, Transform shadow2)
    {
        m_animationIsOccuring = true;

        ShadowTriggerSelectionLogic ShadowTrigger1 = shadow1.GetComponent<ShadowTriggerSelectionLogic>();
        ShadowTriggerSelectionLogic ShadowTrigger2 = shadow2.GetComponent<ShadowTriggerSelectionLogic>();

        ShadowTrigger1.shadowIsSelected = false;
        ShadowTrigger2.shadowIsSelected = false;

        FloatingPhraseGeneratorLogic G2 = shadow2.parent.parent.gameObject.GetComponentInChildren<FloatingPhraseGeneratorLogic>();
        G2.StopAllCoroutines();

        float time = m_timeTransitionBetweenAttributes + 0.001f;
        
        G2.destroyAllPhrase(time, m_unMtachedAttributes);
        

        yield return new WaitForSeconds(time);
        m_firstShadowSelected = null;
        m_firstShadowSelected = null;
        ShadowTrigger1.shadowIsSelected = false;
        ShadowTrigger2.shadowIsSelected = false;

        G2.StartCoroutine(G2.SpawningFloatingPhraseInSequence());

        m_animationIsOccuring = false;
    }
}
