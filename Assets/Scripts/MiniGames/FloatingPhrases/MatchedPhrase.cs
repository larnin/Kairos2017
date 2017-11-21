using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MatchedPhrase : ScriptableObject
{
    [System.Serializable]
    public class PairPhrases
    {
        public FloatingPhraseLogic A;
        public FloatingPhraseLogic B;
    }
    
    public List<PairPhrases> m_matched;
    public List<FloatingPhraseLogic> m_indices;
}
