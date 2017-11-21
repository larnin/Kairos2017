using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 * cette classe sert a spawn les differente phrase de maniere aléatoire. 
 * */
public class FloatingPhraseGeneratorLogic : MonoBehaviour
{
    [SerializeField]
    private float m_minDelayToSpawn = 0.5f;
    
    [SerializeField]
    private Transform m_emplacementForSpawn;

    [SerializeField]
    private Transform m_targetToRest;

    [SerializeField]
    private Transform m_PlaceToRestWhenIndiceLast;

    [SerializeField]
    private FloatingPhraseLogic[] m_floatingPhrasePrebabs;
    /*
     * Lorsque l'on veut faire spawn une nouvelle phrase, on pioche au hassard dans la reserve. 
     * Lorsque que la reserve est vide, on la rempli avec la reserve temporaire. 
     * note : lorsque une phrase est détruit elle est ajoute dans la reserve temporaire (m_tempReserveFloatingPhrase) 
     * Si la reserve est vide meme aprés l'avoir rempli avec la reserve temporaire, on ne fait rien) 
     */
    private List<byte> m_reserveFloatingPhrase = new List<byte>();
    private List<byte> m_tempReserveFloatingPhrase = new List<byte>();
    private List<FloatingPhraseLogic> m_spawnedFloatingPhrase = new List<FloatingPhraseLogic>();

    private RumorsOfShadowsManager m_rumorsOfShadowsManager;
    public void setRumorsOfShadowsManager(RumorsOfShadowsManager rumorsOfShadowsManager)
    {
        m_rumorsOfShadowsManager = rumorsOfShadowsManager;
    }

    private float m_decalSin = 0f; 
   	
    void Start()
    {
        m_reserveFloatingPhrase.Clear();
        m_tempReserveFloatingPhrase.Clear();

        for (byte i = 0; i < m_floatingPhrasePrebabs.Length; i++)
        {
            m_reserveFloatingPhrase.Add(i);
        }
        SpawnFloatingPhrase();
        InvokeRepeating("TrySpawnFloatingPhrase", m_minDelayToSpawn, m_minDelayToSpawn);
    }

    void TrySpawnFloatingPhrase()
    {
        if(m_reserveFloatingPhrase.Count > 0)
        {
            SpawnFloatingPhrase();
        }
        else
        {
            m_reserveFloatingPhrase.AddRange(m_tempReserveFloatingPhrase);
            m_tempReserveFloatingPhrase.Clear();
            if (m_reserveFloatingPhrase.Count > 0)
            {
                SpawnFloatingPhrase();
            }
        }
    }
    
    void SpawnFloatingPhrase()
    {
        byte index = (byte)m_reserveFloatingPhrase[UnityEngine.Random.Range(0, m_reserveFloatingPhrase.Count)];
        FloatingPhraseLogic spawned = Instantiate(m_floatingPhrasePrebabs[index], m_emplacementForSpawn.position, Quaternion.identity);
        spawned.SetTargetToRest(m_targetToRest);
        //spawned.SetDecalSin(m_decalSin);
        spawned.Index = index;
        spawned.onDestroyCallback += OnPhraseIsDestroy;
        spawned.onSelected += m_rumorsOfShadowsManager.FloatingPhraseIsSelected;
        m_reserveFloatingPhrase.Remove(index);
        m_decalSin += 1f ;

        int totalNumber = m_spawnedFloatingPhrase.Count 
            + m_reserveFloatingPhrase.Count 
            + m_tempReserveFloatingPhrase.Count;

        if (( totalNumber + spawned.MatchingIndex) == 0)
        {
            spawned.SetTargetToRest(m_PlaceToRestWhenIndiceLast);
            spawned.ItsTheLastOneAndTheIndice();
        }

        m_spawnedFloatingPhrase.Add(spawned);
    }

    void OnPhraseIsDestroy(FloatingPhraseLogic floatingPhrase)
    {
        if(!floatingPhrase.IsMatched)
        {
            m_tempReserveFloatingPhrase.Add(floatingPhrase.Index);
        }
        // si une carte a était matché elle ne doit pas réapaitre
        //(on ne l'ajoute pas a la reserve !)
        m_spawnedFloatingPhrase.Remove(floatingPhrase);
    }

    public void destroyAllPhrase()
    {
        foreach (FloatingPhraseLogic e in m_spawnedFloatingPhrase)
        {
            Destroy(e.gameObject);
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A)) // placeholder code
        {
            Event<EnableCursorEvent>.Broadcast(new EnableCursorEvent(true));
            Event<LockPlayerControlesEvent>.Broadcast(new LockPlayerControlesEvent(true));
        }
    }
}
