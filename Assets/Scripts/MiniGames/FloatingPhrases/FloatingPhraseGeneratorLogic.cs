using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using DG.Tweening;

/*
 * cette classe sert a spawn les differente phrase. 
 * */
public class FloatingPhraseGeneratorLogic : MonoBehaviour
{
    [Serializable]
    public class SpokenPhrase
    {
        public FloatingPhraseLogic m_floatingPhrasePrebabs = null;
        public Transform m_shadow = null;

        [NonSerialized]
        public Transform m_spawnPoint = null;
        [NonSerialized]
        public Transform m_goPoints = null;

        public int m_indiceOfTheGoPoint = 0;
        public float m_SpawnAfterThePreviousOne = 0f;
        public float m_GoToRestSpot = 0f;
        public float m_RestBeforeDissapear = 0f; 
    }

    [SerializeField]
    private List<SpokenPhrase> m_spokenPhrases;

    [SerializeField]
    private float m_resetAfterLast = 1f;
    
    private List<FloatingPhraseLogic> m_spawnedFloatingPhrase = new List<FloatingPhraseLogic>();

    private RumorsOfShadowsManager m_rumorsOfShadowsManager;
    public void setRumorsOfShadowsManager(RumorsOfShadowsManager rumorsOfShadowsManager)
    {
        m_rumorsOfShadowsManager = rumorsOfShadowsManager;
    }
    
    private bool m_pauseGenerator = false;
    
    void Start()
    {
        foreach (SpokenPhrase e in m_spokenPhrases)
        {
            e.m_spawnPoint = e.m_shadow.Find("SpawnPoint");
            e.m_goPoints = e.m_shadow.Find("GoPoints");
        }
    }

    void SpawnFloatingPhrase(int index = 0)
    {
        foreach (SpokenPhrase e in m_spokenPhrases)
        {
            e.m_spawnPoint = e.m_shadow.Find("SpawnPoint");
            e.m_goPoints = e.m_shadow.Find("GoPoints");
        }

        SpokenPhrase spokenPhrase = m_spokenPhrases[index];

        Vector3 positionForSpawn = spokenPhrase.m_goPoints.GetChild(spokenPhrase.m_indiceOfTheGoPoint).position;

        Transform pivot = (new GameObject()).transform;
        pivot.SetParent(spokenPhrase.m_shadow, true);
        pivot.position = positionForSpawn;
        pivot.rotation = spokenPhrase.m_spawnPoint.rotation;

        FloatingPhraseLogic spawned = Instantiate(spokenPhrase.m_floatingPhrasePrebabs, 
            positionForSpawn,
            spokenPhrase.m_spawnPoint.rotation);
        
        spawned.m_index = index;

        // place the script in another transform; 

        spawned.transform.SetParent(pivot, true);
        spawned.transform.localPosition = Vector3.zero;
        // pivot.gameObject.AddComponent<LookAtCameraLogic>();
        // spawned.transform.SetParent(spokenPhrase.m_shadow, true);
        spawned.transform.Rotate(Vector3.up, 180f);

        ShadowTriggerSelectionLogic shadowTriggerSelection = spokenPhrase.m_shadow.GetComponent<ShadowTriggerSelectionLogic>();

        spawned.timeTransitionBetweenAttributes = m_rumorsOfShadowsManager.timeTransitionBetweenAttribute;

        if (shadowTriggerSelection.m_matched)
        {
            spawned.applyTextMeshProAttributes(m_rumorsOfShadowsManager.matchedAttributes);
        }
        else if (shadowTriggerSelection.m_selected)
        {
            spawned.applyTextMeshProAttributes(m_rumorsOfShadowsManager.selectedAttributes);
        }
        else if (shadowTriggerSelection.playerIsInside)
        {
            spawned.applyTextMeshProAttributes(m_rumorsOfShadowsManager.hoverAttributes);
        }
        
        TextMeshPro textMesh = spawned.GetComponent<TextMeshPro>();
        StartCoroutine(deathAnimationForFloatingPhrase(spokenPhrase.m_RestBeforeDissapear, spawned));   

        
        // on set les delegates
        spawned.m_onDestroy += OnPhraseIsDestroy;
        spawned.m_isWholeAnimationOccuring += m_rumorsOfShadowsManager.globalAnimationOccuring;
        
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
            if(e && !e.m_beingDestroy)
            {
                e.m_beingDestroy = true;

                if(!e.GetComponentInParent<ShadowTriggerSelectionLogic>().m_matched)
                {
                    e.applyTextMeshProAttributes(effect, false);
                    e.animFade();
                }
                Destroy(e.transform.parent.gameObject, timeToDoIt);
            }
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

    IEnumerator deathAnimationForFloatingPhrase(float timeToWait, FloatingPhraseLogic floatingPhrase)
    {
        yield return new WaitForSeconds(timeToWait);
        if(floatingPhrase)
        {
            floatingPhrase.m_beingDestroy = true;

            if(! floatingPhrase.GetComponentInParent< ShadowTriggerSelectionLogic>().m_matched )
            {
                floatingPhrase.applyTextMeshProAttributes(m_rumorsOfShadowsManager.UnMtachedAttributes, false);
                floatingPhrase.animFade();
            }
            
            Destroy(floatingPhrase.transform.parent.gameObject, m_rumorsOfShadowsManager.timeTransitionBetweenAttribute);
        }
    }

    public IEnumerator SpawningFloatingPhraseInSequence()
    {
        int currentIndex = 0;
        float elapsedTime = 0;
        float targetTime = m_spokenPhrases[currentIndex].m_SpawnAfterThePreviousOne;
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
                    targetTime = m_resetAfterLast;
                }
                else
                {
                    targetTime = m_spokenPhrases[currentIndex].m_SpawnAfterThePreviousOne;
                }
            }
            yield return null;
        }
    }


    public List<SpokenPhrase> getList()
    {
        return m_spokenPhrases;
    }
}
