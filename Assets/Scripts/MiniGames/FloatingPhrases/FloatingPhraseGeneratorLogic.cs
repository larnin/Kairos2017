using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 * cette classe sert a spawn les differente phrase. 
 * */
public class FloatingPhraseGeneratorLogic : MonoBehaviour
{
    [System.Serializable]
    public class SpokenPhrase
    {
        public FloatingPhraseLogic m_floatingPhrasePrebabs = null;
        public Transform m_shadow = null;

        [NonSerialized]
        public Transform m_spawnPoint = null;
        [NonSerialized]
        public Transform m_goPoint = null;

        public float m_spawnAfterThePreviousOne = 0f;
    }

    [SerializeField]
    private List<SpokenPhrase> m_spokenPhrases;

    [SerializeField]
    private float m_resetTimeAFterLast = 4f;

    [SerializeField]
    private bool m_stack = false;

    [SerializeField]
    private float m_DistanceForBeginAppearing = 10f;
    [SerializeField]
    private float m_DistanceForEndAppearing = 15f;
    
    private bool m_coroutineIsRunning = false;
    private List<FloatingPhraseLogic> m_spawnedFloatingPhrase = new List<FloatingPhraseLogic>();

    private RumorsOfShadowsManager m_rumorsOfShadowsManager;
    public void setRumorsOfShadowsManager(RumorsOfShadowsManager rumorsOfShadowsManager)
    {
        m_rumorsOfShadowsManager = rumorsOfShadowsManager;
    }
    private Transform playerTransform;
    
    private bool m_pauseGenerator = false;
    
    void Start()
    {
        playerTransform = GameObject.FindWithTag("Player").transform;

        foreach (SpokenPhrase e in m_spokenPhrases)
        {
            e.m_spawnPoint = e.m_shadow.Find("SpawnPoint");
            e.m_goPoint = e.m_shadow.Find("GoPoint");
        }
    }

    void SpawnFloatingPhrase(int index = 0)
    {
        SpokenPhrase spokenPhrase = m_spokenPhrases[index];

        Vector3 positionForSpawn = spokenPhrase.m_spawnPoint.position;
        FloatingPhraseLogic spawned = Instantiate(spokenPhrase.m_floatingPhrasePrebabs, 
            positionForSpawn, 
            Quaternion.identity);
        
        // on set les variable 
        spawned.SetTargetToRest(spokenPhrase.m_goPoint);
        if(m_stack)
        { // when they stack, they don't disappear !
            spawned.setHeightWhenPhraseDisappear(99999);
        }

        spawned.Index = index;

        spawned.transform.SetParent(spokenPhrase.m_shadow, true);

        ShadowTriggerSelectionLogic shadowTriggerSelection = spokenPhrase.m_shadow.GetComponent<ShadowTriggerSelectionLogic>();

        spawned.timeTransitionBetweenAttributes = m_rumorsOfShadowsManager.timeTransitionBetweenAttribute;

        if (shadowTriggerSelection.shadowIsMatched)
        {
            spawned.applyTextMeshProAttributes(m_rumorsOfShadowsManager.matchedAttributes);
        }
        else if (shadowTriggerSelection.shadowIsSelected)
        {
            spawned.applyTextMeshProAttributes(m_rumorsOfShadowsManager.selectedAttributes);
        }
        else if (shadowTriggerSelection.playerIsInside)
        {
            spawned.applyTextMeshProAttributes(m_rumorsOfShadowsManager.hoverAttributes);
        }

        // on set les delegates
        spawned.onDestroyCallback += OnPhraseIsDestroy;
        spawned.IsWholeAnimationOccuring += m_rumorsOfShadowsManager.globalAnimationOccuring;
        
        m_spawnedFloatingPhrase.Add(spawned);
    }

    void OnPhraseIsDestroy(FloatingPhraseLogic floatingPhrase)
    {
        m_spawnedFloatingPhrase.Remove(floatingPhrase);
    }

    public void destroyAllPhrase(float timeToDoIt, TextMeshProAttributes effect)
    {
        foreach (FloatingPhraseLogic e in m_spawnedFloatingPhrase)
        {
            e.transform.parent = null;
            e.applyTextMeshProAttributes(effect, false);
            Destroy(e.gameObject, timeToDoIt);
        }
        m_spawnedFloatingPhrase.Clear();

        StopAllCoroutines();
    }

    public void appearing()
    {
        StartCoroutine(SpawningFloatingPhraseInSequence());   
    }

    public void disappearing(TextMeshProAttributes unMtachedAttributes, float timeTransitionBetweenAttribute)
    {
        destroyAllPhrase(timeTransitionBetweenAttribute, unMtachedAttributes);      
    }

    public IEnumerator SpawningFloatingPhraseInSequence()
    {
        m_coroutineIsRunning = true;

        int currentIndex = 0;
        float elapsedTime = 0;
        float targetTime = m_spokenPhrases[currentIndex].m_spawnAfterThePreviousOne;
        float globalTime = 0;

        while (true)
        {
            float currentDeltaTime = m_pauseGenerator ? 0f : Time.deltaTime;
            elapsedTime += currentDeltaTime;
            globalTime += currentDeltaTime;

            if (elapsedTime >= targetTime)
            {
                elapsedTime = 0f;

                SpawnFloatingPhrase(currentIndex);
                currentIndex++;

                if (currentIndex == m_spokenPhrases.Count)
                {
                    currentIndex = 0;
                     break;
                }
                else
                {
                    targetTime = m_spokenPhrases[currentIndex].m_spawnAfterThePreviousOne;
                }
            }
            yield return null;
        }
        targetTime = m_resetTimeAFterLast;
        yield return new WaitForSeconds(targetTime);
        
        foreach (FloatingPhraseLogic e in m_spawnedFloatingPhrase)
        {
            e.SetSpeedUP(0f);
        }
    }
}
