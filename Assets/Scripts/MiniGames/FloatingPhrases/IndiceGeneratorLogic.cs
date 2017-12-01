using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class IndiceGeneratorLogic : MonoBehaviour {

    [System.Serializable]
    public class SpawnIndiceAtNumber
    {
        public GameObject m_phraseIndice = null;
        public int m_atWhatNumberToHappen = 0;
    }

    [SerializeField]
    private SpawnIndiceAtNumber[] m_phraseIndices;
    
    int m_indiceNumber = 0; // collected
    int m_phraseAppearNumber = 0;// appeared

    Transform m_goToPoints;
    Transform m_spawnPoint;

    public void unlockOneIndice()
    {
        foreach (SpawnIndiceAtNumber e in m_phraseIndices)
        {
            if(e.m_atWhatNumberToHappen == m_indiceNumber)
            {
                Transform P = (Instantiate(e.m_phraseIndice, m_spawnPoint.position, Quaternion.identity) as GameObject).transform;
                P.DOMove(m_goToPoints.GetChild(m_phraseAppearNumber).position, 1.0f);
                m_phraseAppearNumber++;
            }
        }
        m_indiceNumber++;
    }

    void Start()
    {
        m_spawnPoint = transform.Find("SpawnPoint");
        m_goToPoints = transform.Find("GoPoints");
    }
}
