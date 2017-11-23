using UnityEngine;
using System.Collections;
using UnityEditor;

[CustomEditor(typeof(MatchedPhrase))]
public class MatchPhraseEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        MatchedPhrase myScript = (MatchedPhrase)target;
        if (GUILayout.Button("Apply"))
        {
            const byte offset = 1;
            for (byte i = 0; i < myScript.m_matched.Count; i++)
            {
                SerializedObject A = new SerializedObject(myScript.m_matched[i].A);
                SerializedObject B = new SerializedObject(myScript.m_matched[i].B);
                SerializedProperty AIndex = A.FindProperty("m_matchingIndex");
                SerializedProperty BIndex = B.FindProperty("m_matchingIndex");

                int value = i + offset;
                AIndex.intValue = value;
                BIndex.intValue = value;

                A.ApplyModifiedProperties();
                B.ApplyModifiedProperties();
            }

            for (byte i = 0; i < myScript.m_indices.Count; i++)
            {
                SerializedObject Indice = new SerializedObject(myScript.m_indices[i]);
                SerializedProperty IndiceIndex = Indice.FindProperty("m_matchingIndex");
                IndiceIndex.intValue = 0;
                Indice.ApplyModifiedProperties();
            }
            AssetDatabase.SaveAssets();
        }
    }
}
