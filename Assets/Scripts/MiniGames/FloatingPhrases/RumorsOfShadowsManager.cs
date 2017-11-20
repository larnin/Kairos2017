using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class RumorsOfShadowsManager : MiniGameBaseLogic
{
    [SerializeField]
    private Transform m_placeForSelected1;
    [SerializeField]
    private Transform m_placeForSelected2;

    private bool m_activated = true;
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
	}

    public void FloatingPhraseIsSelected(FloatingPhraseLogic floatingPhrase)
    {
        if (!m_firstSelected)
        {
            m_firstSelected = floatingPhrase;
        }
        else
        {
            m_secondSelected = floatingPhrase;

            m_firstSelected.GetComponent<Collider>().enabled = false;
            m_secondSelected.GetComponent<Collider>().enabled = false;

            m_firstSelected.transform.DOMove(m_placeForSelected1.position, 0.75f).SetUpdate(true);
            m_secondSelected.transform.DOMove(m_placeForSelected2.position, 0.75f).SetUpdate(true);

            if (true) // add the check to dertmine if the phrase are compatible. 
            { // for testing we assume there are always compatible. 
                StartCoroutine(animationForCorrectPhrase(m_firstSelected, m_secondSelected));
            }


        }
    }

    public void FloatingPhraseIsDestroy(FloatingPhraseLogic floatingPhrase)
    {

    } 

    IEnumerator animationForCorrectPhrase(FloatingPhraseLogic floatingPhrase1, FloatingPhraseLogic floatingPhrase2)
    {
        floatingPhrase1.enabled = false;
        floatingPhrase2.enabled = false;

        yield return new WaitForSecondsRealtime(1f);
        floatingPhrase1.transform.DOMove(floatingPhrase1.transform.position + floatingPhrase1.transform.right * 5f, 2f)
            .SetUpdate(true);
        floatingPhrase2.transform.DOMove(floatingPhrase2.transform.position + floatingPhrase2.transform.right * -5f, 2f)
            .SetUpdate(true);
    }
}
