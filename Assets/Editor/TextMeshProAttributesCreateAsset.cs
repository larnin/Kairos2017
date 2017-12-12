using UnityEngine;
using UnityEditor;
 
public class TextMeshProAttributesCreateAsset
{
    [MenuItem("Assets/Create/TextMeshProAttributesCreateAsset")]
    public static void CreateAsset()
    {
        ScriptableObjectUtility.CreateAsset<TextMeshProAttributes>();
    }
}
