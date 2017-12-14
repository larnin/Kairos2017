using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System;

/// <summary>
/// cette classe sert a gérer le mini jeu
/// </summary>
public class RumorsOfShadowsManager : MonoBehaviour
{
    [Serializable]
    class MatchedShadow
    {
        public Transform shadowA = null;
        public Transform shadowB = null;
    }

    [SerializeField]
    private IndiceGeneratorLogic m_indiceGeneratorLogic;
    
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
    public float timeTransitionBetweenAttribute { get { return m_timeTransitionBetweenAttributes; }}


    [SerializeField]
    private List<MatchedShadow> m_shadowMatchedList;

    private bool m_animationIsOccuring = false;

    private FloatingPhraseGeneratorLogic[] m_generators;

    private Transform m_firstShadowSelected = null;
    private Transform m_secondShadowSelected = null;
    
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
        foreach (MatchedShadow e in m_shadowMatchedList)
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
            if (floatingPhrase && !floatingPhrase.m_beingDestroy)
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
                m_indiceGeneratorLogic.unlockOneIndice();
                StartCoroutine(animationForCorrectPhrase(m_firstShadowSelected, m_secondShadowSelected));
                return false;
            }
            else
            {
                StartCoroutine(animationForWrongPhrase(m_firstShadowSelected, m_secondShadowSelected));
                return false;
            }
            
            
        }
    }

    private void ApplyFeedBack(Transform e, TextMeshProAttributes meshProAttributes)
    {
        if(e.childCount > 0)
        {
            FloatingPhraseLogic floatingPhrase = e.GetChild(0).GetComponent<FloatingPhraseLogic>();
            if (floatingPhrase && !floatingPhrase.m_beingDestroy)
            {
                floatingPhrase.applyTextMeshProAttributes(meshProAttributes, false);
            }
        }

    }

    public  IEnumerator animationForCorrectPhrase(Transform shadow1, Transform shadow2)
    {
        m_animationIsOccuring = true;
        
        foreach (Transform e in shadow1)
        {
            FloatingPhraseLogic floatingPhrase = e.GetComponent<FloatingPhraseLogic>();
            if (floatingPhrase && !floatingPhrase.m_beingDestroy)
            {
                floatingPhrase.applyTextMeshProAttributes(m_MatchedAttributes, false);
            }
        }

        foreach (Transform e in shadow2)
        {
            FloatingPhraseLogic floatingPhrase = e.GetComponent<FloatingPhraseLogic>();
            if (floatingPhrase && !floatingPhrase.m_beingDestroy)
            {
                floatingPhrase.applyTextMeshProAttributes(m_MatchedAttributes, false);
            }
        }

        ShadowTriggerSelectionLogic ShadowTrigger1 = shadow1.GetComponent<ShadowTriggerSelectionLogic>();
        ShadowTriggerSelectionLogic ShadowTrigger2 = shadow2.GetComponent<ShadowTriggerSelectionLogic>();

        ShadowTrigger1.m_matched = true;
        ShadowTrigger1.updateFeedback();
        ShadowTrigger2.m_matched = true;
        ShadowTrigger2.updateFeedback();


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


        ShadowTrigger1.m_selected = false;
        ShadowTrigger2.m_selected = false;

        FloatingPhraseGeneratorLogic G2 = shadow2.parent.parent.gameObject.GetComponentInChildren<FloatingPhraseGeneratorLogic>();

        G2.StopAllCoroutines();
        
        G2.destroyAllPhrase(m_unMtachedAttributes.m_timeToApply, m_unMtachedAttributes);

        
        ShadowTrigger1.StartCoroutine(ShadowTrigger1.shadowNotMatchedFeedback());
        ShadowTrigger2.StartCoroutine(ShadowTrigger2.shadowNotMatchedFeedback());


        yield return new WaitForSeconds(m_unMtachedAttributes.m_timeToApply);
        m_firstShadowSelected = null;
        m_firstShadowSelected = null;
        ShadowTrigger1.m_selected = false;
        ShadowTrigger2.m_selected = false;

        G2.StartCoroutine(G2.SpawningFloatingPhraseInSequence());

        m_animationIsOccuring = false;
    }
}
