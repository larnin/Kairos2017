﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 * cette classe sert a spawn les differente phrase de maniere aléatoire. 
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

    private bool m_coroutineIsRunning = false;

    private List<FloatingPhraseLogic> m_spawnedFloatingPhrase = new List<FloatingPhraseLogic>();
    private List<int> m_indexWhoIsMatched = new List<int>();

    private RumorsOfShadowsManager m_rumorsOfShadowsManager;
    public void setRumorsOfShadowsManager(RumorsOfShadowsManager rumorsOfShadowsManager)
    {
        m_rumorsOfShadowsManager = rumorsOfShadowsManager;
    }

    //private float m_decalSin = 0f; 
    private bool m_pauseGenerator = false;
    

    void Start()
    {
        foreach (SpokenPhrase e in m_spokenPhrases)
        {
            e.m_spawnPoint = e.m_shadow.Find("SpawnPoint");
            e.m_goPoint = e.m_shadow.Find("GoPoint");
        }

      //  StartCoroutine(SpawningFloatingPhraseInSequence());
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
        if(m_indexWhoIsMatched.Contains(index))
        {
            spawned.IsMatched = true;
        }
        spawned.transform.SetParent(this.transform, true);
        
        // on set les delegates
        spawned.onDestroyCallback += OnPhraseIsDestroy;
        spawned.onSelected += m_rumorsOfShadowsManager.floatingPhraseIsSelected;
        spawned.IsWholeAnimationOccuring += m_rumorsOfShadowsManager.globalAnimationOccuring;
        
        m_spawnedFloatingPhrase.Add(spawned);
    }

     

    void OnPhraseIsDestroy(FloatingPhraseLogic floatingPhrase)
    {

    }

    public void destroyAllPhrase()
    {
        foreach (FloatingPhraseLogic e in m_spawnedFloatingPhrase)
        {
            Destroy(e.gameObject);
        }
        m_spawnedFloatingPhrase.Clear();
    }

    public void pause()
    {
        m_pauseGenerator = true;
        foreach (Transform e in transform)
        {
            e.GetComponent<FloatingPhraseLogic>().freeze();
        }
    }

    public void resume()
    {
        m_pauseGenerator = false;
        foreach (Transform e in transform)
        {
            e.GetComponent<FloatingPhraseLogic>().unFreeze();
        }
    }

    public void phraseIsMatched(FloatingPhraseLogic floatingPhrase)
    {
        m_indexWhoIsMatched.Add(floatingPhrase.Index);
    }

    public void appearing()
    {
        if (!m_coroutineIsRunning)
        {
            StartCoroutine(SpawningFloatingPhraseInSequence());
        }
        else
        {
            bool theyAllCanAppear = true;

            foreach(Transform e in this.transform)
            {
                FloatingPhraseLogic floatingPhrase = e.GetComponent<FloatingPhraseLogic>();
                theyAllCanAppear = floatingPhrase.tryAppearing() && theyAllCanAppear;
            }

            if (theyAllCanAppear)
            {
                resume();
            }
        }
    }

    public void disappearing()
    {
        foreach (Transform e in this.transform)
        {
            FloatingPhraseLogic floatingPhrase = e.GetComponent<FloatingPhraseLogic>();
            floatingPhrase.tryDisappearing();
        }

        pause();        
    }

    IEnumerator SpawningFloatingPhraseInSequence()
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

                    if (m_stack)
                    {
                        break;
                    }
                    else
                    {
                        targetTime = m_resetTimeAFterLast;
                    }
                }
                else
                {
                    targetTime = m_spokenPhrases[currentIndex].m_spawnAfterThePreviousOne;
                }
            }
            yield return null;
        }

        yield return new WaitForSeconds(targetTime);

        foreach(Transform e in transform)
        {
            e.GetComponent<FloatingPhraseLogic>().SetSpeedUP(0f);
        }
    }
}