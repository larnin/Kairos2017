using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;
using DG.Tweening;

public class IndiceGeneratorLogic : MonoBehaviour {

    [Serializable]
    public class SpawnIndiceAtNumber
    {
        //public GameObject m_phraseIndice = null;
        public int m_atWhatNumberToHappen = 0;
    }

    [SerializeField] private float timeBetweenEachPhrase = 1f;
    [SerializeField] private string cardName = "TEST";
    [SerializeField] private SpawnIndiceAtNumber[] m_phraseIndices;

    RumorsOfShadowsManager m_manager = null;

    int m_indiceNumber = 0; // collected
    int m_phraseAppearNumber = 0; // appeared

    Transform m_goToPoints;
    Transform m_spawnPoint;

    private FloatingPhraseGeneratorLogic m_floatingPhraseGenerator = null;
    private List<FloatingPhraseGeneratorLogic.SpokenPhrase> m_fullList = new List<FloatingPhraseGeneratorLogic.SpokenPhrase>();

    public void unlockOneIndice()
    {
       // m_floatingPhraseGenerator.getList().Clear();
       // m_phraseAppearNumber = 0;
        m_indiceNumber++;
        
        foreach (SpawnIndiceAtNumber e in m_phraseIndices)
        {
            if (e.m_atWhatNumberToHappen == m_indiceNumber)
            {
                m_floatingPhraseGenerator.getList().Add(m_fullList[m_phraseAppearNumber]);
                m_phraseAppearNumber++;
            }
        }

        if (m_phraseAppearNumber == m_phraseIndices.Length)
        {
            Event<FindCardEvent>.Broadcast(new FindCardEvent(cardName));
        }
    }

    void Start()
    {
        m_manager = GetComponentInParent<RumorsOfShadowsManager>();
        m_floatingPhraseGenerator = GetComponent<FloatingPhraseGeneratorLogic>();
        m_spawnPoint = transform.Find("SpawnPoint");
        m_goToPoints = transform.Find("GoPoints");

        foreach (FloatingPhraseGeneratorLogic.SpokenPhrase e in m_floatingPhraseGenerator.getList())
        {
            m_fullList.Add(e);
        }
        m_floatingPhraseGenerator.getList().Clear();
        m_floatingPhraseGenerator.getList().Add(m_fullList[0]);
        // unlockOneIndice();
        m_phraseAppearNumber = 1;
    }
}


/*
       m_phraseAppearNumber = 0;

       for(int i = 0; i < m_indiceNumber; i++)
       {
           foreach (SpawnIndiceAtNumber e in m_phraseIndices)
           {
               if (e.m_atWhatNumberToHappen == i)
               {

                   Transform pivot = (new GameObject()).transform;
                   pivot.SetParent(pivot, true);
                   pivot.position = m_spawnPoint.position;
                   pivot.rotation = m_spawnPoint.rotation;

                   pivot.SetParent(transform, true);

                   Transform newIndice = (Instantiate(e.m_phraseIndice, m_spawnPoint.position, m_spawnPoint.rotation) as GameObject).transform;
                   newIndice.SetParent(pivot, true);
                   pivot.DOMove(m_goToPoints.GetChild(m_phraseAppearNumber).position, 1.0f);
                   m_phraseAppearNumber++;

               }
           }

       }

       // faire appaitre la carte maintenant 
       /*
       if (m_phraseAppearNumber == m_phraseIndices.Length)
       {
           Event<FindCardEvent>.Broadcast(new FindCardEvent(cardName));
       }
       */
