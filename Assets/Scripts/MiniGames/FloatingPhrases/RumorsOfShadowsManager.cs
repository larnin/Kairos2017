using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

/*
 * cette classe sert a gérer le mini et a gérer les input de cancel
 * 
 * * */
public class RumorsOfShadowsManager : MiniGameBaseLogic
{
    [SerializeField]
    private Transform m_placeForSelected1;
    [SerializeField]
    private Transform m_placeForSelected2;
    [SerializeField]
    private float m_animationTime = 0.5f;


    private bool m_activated = true;
    private bool m_animationIsOccuring = false;

    private FloatingPhraseGeneratorLogic[] m_generators;
    private FloatingPhraseLogic m_firstSelected = null;
    private FloatingPhraseLogic m_secondSelected = null;

    public override void activate()
    {
        
    }
    
    // Use this for initialization
    void Awake ()
    {
        m_generators = GetComponentsInChildren<FloatingPhraseGeneratorLogic>();
        foreach(FloatingPhraseGeneratorLogic e in m_generators)
        {
            e.setRumorsOfShadowsManager(this);
        }
	}
	
	// Update is called once per frame
	void Update ()
    {
        // will be used latter to track the cancel input and finish the MiniGame;
        if (Input.GetButtonDown("Cancel"))
        {
            if (m_firstSelected && !m_firstSelected.IsDoingAnimation)
            {
                if (!m_secondSelected)
                {
                    m_firstSelected.unselect();
                    m_firstSelected = null;
                }
            }
        }
	}

    public bool globalAnimationOccuring()
    {
        return m_animationIsOccuring;
    }

    public void floatingPhraseIsSelected(FloatingPhraseLogic floatingPhrase)
    {
        if (!m_firstSelected)
        {
            m_firstSelected = floatingPhrase;
        }
        else if (m_firstSelected == floatingPhrase)
        {
            m_firstSelected.unselect();
            m_firstSelected = null;
        }

        else
        {
            m_secondSelected = floatingPhrase;

            m_firstSelected.GetComponent<Collider>().enabled = false;
            m_secondSelected.GetComponent<Collider>().enabled = false;

            m_firstSelected.transform.DOMove(m_placeForSelected1.position, m_animationTime).SetUpdate(true);
            m_secondSelected.transform.DOMove(m_placeForSelected2.position, m_animationTime).SetUpdate(true);

            if (m_firstSelected.MatchingIndex == m_secondSelected.MatchingIndex) 
            { 
                StartCoroutine(animationForCorrectPhrase(m_firstSelected, m_secondSelected));
            }
            else
            {
                StartCoroutine(animationForWrongPhrase(m_firstSelected, m_secondSelected));
            }
        }
    }

    IEnumerator animationForCorrectPhrase(FloatingPhraseLogic floatingPhrase1, FloatingPhraseLogic floatingPhrase2)
    {
        floatingPhrase1.IsMatched = true;
        floatingPhrase2.IsMatched = true;
        m_animationIsOccuring = true;

        yield return new WaitForSecondsRealtime(1f);
        floatingPhrase1.transform.DOMove(floatingPhrase1.transform.position + floatingPhrase1.transform.right * 5f, m_animationTime*4f)
            .SetUpdate(true);
        Tween animationTween = floatingPhrase2.transform.DOMove(floatingPhrase2.transform.position + floatingPhrase2.transform.right * -5f, m_animationTime * 4f)
            .SetUpdate(true);
        yield return animationTween.WaitForCompletion();
        Destroy(floatingPhrase1.gameObject);
        Destroy(floatingPhrase2.gameObject);
        Time.timeScale = 1f;
        m_firstSelected = null;
        m_secondSelected = null;
        m_animationIsOccuring = false;
    }

    IEnumerator animationForWrongPhrase(FloatingPhraseLogic floatingPhrase1, FloatingPhraseLogic floatingPhrase2)
    {
        m_animationIsOccuring = true;

        yield return new WaitForSecondsRealtime(1f);
        foreach (FloatingPhraseGeneratorLogic e in m_generators)
        {
            e.destroyAllPhrase();
        }
        Camera.main.DOShakePosition(m_animationTime);
        Time.timeScale = 1f;
        m_firstSelected = null;
        m_secondSelected = null;
        m_animationIsOccuring = false;
    }
}
