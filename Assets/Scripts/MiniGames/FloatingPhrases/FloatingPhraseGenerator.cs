using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// todo A modifier vraiment
public class FloatingPhraseGenerator : MonoBehaviour
{
    [SerializeField]
    private float m_minDelayToSpawn = 0.5f;

    [SerializeField]
    private float m_maxDelayToSpawn = 1f;
    
    [SerializeField]
    private Transform m_emplacementForSpawn;

    [SerializeField]
    private Transform m_targetToRest;

    [SerializeField]
    private  FloatingPhraseLogic[] FloatingPhrasePrebabs;

    private float decalSin = 0f; 
   	
	// Update is called once per frame
    void Start()
    {
        SpawnFloatingPhrase(FloatingPhrasePrebabs[0]);
        InvokeRepeating("TrySpawnFloatingPhrase", m_minDelayToSpawn, m_minDelayToSpawn);
    }

    void TrySpawnFloatingPhrase()
    {
        SpawnFloatingPhrase(FloatingPhrasePrebabs[0]);
    }
    
    void SpawnFloatingPhrase(FloatingPhraseLogic floatingPhrase)
    {
        int numero = Random.Range(0, 2);
        FloatingPhraseLogic spawned = Instantiate(floatingPhrase, m_emplacementForSpawn.GetChild(numero).position, Quaternion.identity);
        spawned.SetTargetToRest(m_targetToRest);
        spawned.SetDecalSin(decalSin);
        decalSin += 1f;
    }
}
