using UnityEngine;
using System.Collections;
using UnityEditor;

[CustomEditor(typeof(MatchedPhrase))]
public class MatchPhraseEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector(); // use oiro

        MatchedPhrase myScript = (MatchedPhrase)target;
        if (GUILayout.Button("Apply"))
        {
            for(byte i = 1; i < myScript.m_matched.Count; i++)
            {
                myScript.m_matched[i].A.MatchingIndex = i;
                myScript.m_matched[i].B.MatchingIndex = i;
            }

            for (byte i = 0; i < myScript.m_indices.Count; i++)
            {
                myScript.m_indices[i].MatchingIndex = 0;
            }

        }
    }
}
