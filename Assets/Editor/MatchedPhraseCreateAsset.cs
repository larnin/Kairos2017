using UnityEngine;
using UnityEditor;
 
public class MatchedPhraseCreateAsset
{
    [MenuItem("Assets/Create/MatchedPhrase")]
    public static void CreateAsset()
    {
        ScriptableObjectUtility.CreateAsset<MatchedPhrase>();
    }
}
