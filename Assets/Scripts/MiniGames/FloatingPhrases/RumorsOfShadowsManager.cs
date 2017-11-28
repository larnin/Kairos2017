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
    [SerializeField]
    private int m_numberOfMatchNeeded = 2;
    [SerializeField]
    private GameObject m_PlayerWinFeedback;

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
    
    public override void activate()
    {
        Event<EnableCursorEvent>.Broadcast(new EnableCursorEvent(true));
        Event<LockPlayerControlesEvent>.Broadcast(new LockPlayerControlesEvent(true));
    }
    
    // Use this for initialization
    void Awake ()
    {
        m_generators = FindObjectsOfType<FloatingPhraseGeneratorLogic>();
        foreach(FloatingPhraseGeneratorLogic e in m_generators)
        {
            e.setRumorsOfShadowsManager(this);
        }
        m_PlayerWinFeedback.SetActive(false);
    }
	
	// Update is called once per frame
	void Update ()
    {
        // will be used latter to track the cancel input and finish the MiniGame;
        if (Input.GetButtonDown("Cancel"))
        {
            desactivate();
        }
	}

    private bool canMatch(Transform shadow1,Transform Shadow2)
    {
        bool isMatch = false;



        return isMatch;
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
            m_firstSelected.selectPlaceholder();

            

            FloatingPhraseGeneratorLogic generator = floatingPhrase.transform.parent.GetComponent<FloatingPhraseGeneratorLogic>();
            generator.pause();
            /*
            foreach (Transform e in generator.transform)
            {
                print(m_firstSelected.m_shadow);
                if (e.GetComponent<FloatingPhraseLogic>().m_shadow ==
                    m_firstSelected.m_shadow)
                {
                    e.GetComponent<FloatingPhraseLogic>().selectPlaceholder();
                }
            }
            */
        }
        else if (m_firstSelected == floatingPhrase)
        {
            m_firstSelected.unselect();
            m_firstSelected = null;
            FloatingPhraseGeneratorLogic generator = floatingPhrase.transform.parent.GetComponent<FloatingPhraseGeneratorLogic>();

            generator.resume();
        }
        else if (m_firstSelected.transform.parent == floatingPhrase.transform.parent)
        {
            m_firstSelected.unselect();
            m_firstSelected = floatingPhrase;
        }

        else
        {
            m_secondSelected = floatingPhrase;

            if (m_firstSelected.MatchingIndex == m_secondSelected.MatchingIndex && m_firstSelected.MatchingIndex != 0) 
            { 
                StartCoroutine(animationForCorrectPhrase(m_firstSelected, m_secondSelected));
            }
            else
            {
                StartCoroutine(animationForWrongPhrase(m_firstSelected, m_secondSelected));
            }
        }
    }

    public  IEnumerator animationForCorrectPhrase(FloatingPhraseLogic floatingPhrase1, FloatingPhraseLogic floatingPhrase2)
    {
        floatingPhrase1.IsMatched = true;
        floatingPhrase2.IsMatched = true;

        /*
        foreach(Transform e in floatingPhrase1.transform.parent)
        {
            if(e.GetComponent<FloatingPhraseLogic>().m_shadow ==
                floatingPhrase1.m_shadow)
            {
                e.GetComponent<FloatingPhraseLogic>().IsMatched = true;
            }
        }
        */

        m_animationIsOccuring = true;
        FloatingPhraseGeneratorLogic generator1 = floatingPhrase1.transform.parent.GetComponent<FloatingPhraseGeneratorLogic>();
        FloatingPhraseGeneratorLogic generator2 = floatingPhrase2.transform.parent.GetComponent<FloatingPhraseGeneratorLogic>();

        generator1.phraseIsMatched(floatingPhrase1);
        generator2.phraseIsMatched(floatingPhrase2);
        m_currentNumberOfMatch++;
        if (m_currentNumberOfMatch == m_numberOfMatchNeeded)
        {
            m_PlayerWinFeedback.SetActive(true);
        }
        yield return null;
        m_firstSelected = null;
        m_secondSelected = null;

        m_animationIsOccuring = false;
    }

    IEnumerator animationForWrongPhrase(FloatingPhraseLogic floatingPhrase1, FloatingPhraseLogic floatingPhrase2)
    {
        m_animationIsOccuring = true;
        floatingPhrase1.unselect();
        floatingPhrase2.unselect();

        FloatingPhraseGeneratorLogic generator1 = floatingPhrase1.transform.parent.GetComponent<FloatingPhraseGeneratorLogic>();
        generator1.resume();

        FloatingPhraseGeneratorLogic generator2 = floatingPhrase2.transform.parent.GetComponent<FloatingPhraseGeneratorLogic>();
        generator2.resume();

        Camera.main.DOShakePosition(m_animationTime);
        yield return new WaitForSecondsRealtime(1f);
        m_firstSelected = null;
        m_secondSelected = null;
        m_animationIsOccuring = false;
    }
}
