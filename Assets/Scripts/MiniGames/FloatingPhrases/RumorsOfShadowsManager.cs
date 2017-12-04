using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System;

/*
 * cette classe sert a gérer le mini jeu
 * 
 * * */
public class RumorsOfShadowsManager : MonoBehaviour
{
    [Serializable]
    class MatchedShadow
    {
        public Transform shadowA;
        public Transform shadowB;
    }
    
    [SerializeField]
    private IndiceGeneratorLogic indiceGeneratorLogic;
    
    [SerializeField]
    private TextMeshProAttributes m_hoverAttributes;
    public TextMeshProAttributes hoverAttributes { get { return m_hoverAttributes; } }

    [SerializeField]
    private TextMeshProAttributes m_selectedAttributes;
    public TextMeshProAttributes selectedAttributes { get { return m_selectedAttributes; } }

    [SerializeField]
    private TextMeshProAttributes m_MatchedAttributes;
    public TextMeshProAttributes matchedAttributes{ get{ return m_MatchedAttributes; }}

    [SerializeField]
    private TextMeshProAttributes m_unMtachedAttributes;
    public TextMeshProAttributes UnMtachedAttributes{ get{ return m_unMtachedAttributes; }}
    
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
    private List<MatchedShadow> shadowMatchedList;

    private bool m_animationIsOccuring = false;

    private FloatingPhraseGeneratorLogic[] m_generators;

    private Transform m_firstShadowSelected = null;
    private Transform m_secondShadowSelected = null;
    
    // Use this for initialization
    void Awake ()
    {
        m_generators = gameObject.GetComponentsInChildren<FloatingPhraseGeneratorLogic>();
        foreach(FloatingPhraseGeneratorLogic e in m_generators)
        {
            e.setRumorsOfShadowsManager(this);
        }
    }
	
    private bool canMatch(Transform shadowA,Transform shadowB)
    {
        foreach (MatchedShadow e in shadowMatchedList)
        {
            if ( (e.shadowA == shadowA && e.shadowB == shadowB) || (e.shadowB == shadowA && e.shadowA == shadowB) )
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
        m_firstShadowSelected = null;
        m_secondShadowSelected = null;

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
