using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;

[Serializable]
public class LoopInfo
{
    public string baseSceneName = "";
    public List<string> essentialCards = new List<string>();
    public List<string> optionalCards = new List<string>();
    public bool folded = true;
    public bool essentialCardsFolded = true;
    public bool optionalCardsFolded = true;
}

[Serializable]
public class LoopSerializer
{
    public LoopSerializer(List<LoopInfo> _loops)
    {
        loops = _loops;
    }

    public List<LoopInfo> loops;
}

#if UNITY_EDITOR
public class LoopsTool : EditorWindow
{
    string assetPath = "Assets/Resources/";
    string assetName = "Loops.json";

    List<LoopInfo> m_loops = new List<LoopInfo>();

    Vector2 m_scrollPosition = Vector2.zero;

    [MenuItem("Tools/Kairos/Loops")]
    static void Init()
    {
        LoopsTool window = (LoopsTool)EditorWindow.GetWindow(typeof(LoopsTool));
        window.Show();
    }

    private void OnEnable()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(assetPath + assetName);
        if (text != null)
        {
            var data = JsonUtility.FromJson<LoopSerializer>(text.text);

            m_loops = data.loops;
        }
    }

    void OnGUI()
    {
        if (GUILayout.Button("Add loop"))
            addLoop();

        var categoryStyle = new GUIStyle();
        categoryStyle.margin = new RectOffset(5, 5, 5, 5);
        var itemStyle = new GUIStyle();
        itemStyle.margin = new RectOffset(20, 0, 0, 0);

        m_scrollPosition = GUILayout.BeginScrollView(m_scrollPosition);

        for(int i = 0; i < m_loops.Count; i++)
        {
            var loop = m_loops[i];

            GUILayout.BeginVertical(categoryStyle);
            loop.folded = EditorGUILayout.Foldout(loop.folded, "Loop " + (i + 1));
            if(loop.folded)
            {
                GUILayout.BeginVertical(itemStyle);

                GUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Base scene name: ", GUILayout.MaxWidth(130));
                loop.baseSceneName = GUILayout.TextField(loop.baseSceneName);
                GUILayout.EndHorizontal();

                loop.essentialCardsFolded = EditorGUILayout.Foldout(loop.essentialCardsFolded, "Essential cards");
                if(loop.essentialCardsFolded)
                {
                    GUILayout.BeginVertical(itemStyle);

                    for(int j = 0; j < loop.essentialCards.Count; j++)
                    {
                        GUILayout.BeginHorizontal();
                        loop.essentialCards[j] = GUILayout.TextField(loop.essentialCards[j]);
                        if (GUILayout.Button("X", GUILayout.MaxWidth(30)))
                            removeEssentialCard(i, j);
                        GUILayout.EndHorizontal();
                    }
                    if (GUILayout.Button("Add card"))
                        addEssentialCard(i);
                    GUILayout.EndVertical();
                }

                loop.optionalCardsFolded = EditorGUILayout.Foldout(loop.optionalCardsFolded, "Optional cards");
                if (loop.optionalCardsFolded)
                {
                    GUILayout.BeginVertical(itemStyle);

                    for (int j = 0; j < loop.optionalCards.Count; j++)
                    {
                        GUILayout.BeginHorizontal();
                        loop.optionalCards[j] = GUILayout.TextField(loop.optionalCards[j]);
                        if (GUILayout.Button("X", GUILayout.MaxWidth(30)))
                            removeOptionalCard(i, j);
                        GUILayout.EndHorizontal();
                    }
                    if (GUILayout.Button("Add card"))
                        addOptionalCaard(i);
                    GUILayout.EndVertical();
                }

                GUILayout.BeginHorizontal();
                if (i > 0 && GUILayout.Button("Up", GUILayout.MaxWidth(150)))
                    moveLoopUp(i);
                if (i < m_loops.Count - 1 && GUILayout.Button("Down", GUILayout.MaxWidth(150)))
                    moveLoopDown(i);
                if (GUILayout.Button("Remove", GUILayout.MaxWidth(150)))
                    removeLoop(i);
                GUILayout.EndHorizontal();

                GUILayout.EndVertical();
            }
            GUILayout.EndVertical();
        }

        GUILayout.EndScrollView();

        if (GUILayout.Button("Save loops"))
            save();
    }

    void addLoop()
    {
        m_loops.Add(new LoopInfo());
    }

    void moveLoopUp(int index)
    {
        if (index <= 0 || index >= m_loops.Count)
            return;

        var item = m_loops[index-1];
        m_loops[index - 1] = m_loops[index];
        m_loops[index] = item;
    }

    void moveLoopDown(int index)
    {
        if (index < 0 || index >= m_loops.Count-1)
            return;

        var item = m_loops[index + 1];
        m_loops[index + 1] = m_loops[index];
        m_loops[index] = item;
    }

    void removeLoop(int index)
    {
        if (index < 0 || index >= m_loops.Count)
            return;
        m_loops.RemoveAt(index);
    }

    void removeEssentialCard(int loop, int index)
    {
        if (loop < 0 || loop >= m_loops.Count)
            return;
        if (index < 0 || index >= m_loops[loop].essentialCards.Count)
            return;
        m_loops[loop].essentialCards.RemoveAt(index);
    }

    void removeOptionalCard(int loop, int index)
    {
        if (loop < 0 || loop >= m_loops.Count)
            return;
        if (index < 0 || index >= m_loops[loop].optionalCards.Count)
            return;
        m_loops[loop].optionalCards.RemoveAt(index);
    }

    void addEssentialCard(int loop)
    {
        if (loop < 0 || loop >= m_loops.Count)
            return;
        m_loops[loop].essentialCards.Add("");
    }

    void addOptionalCaard(int loop)
    {
        if (loop < 0 || loop >= m_loops.Count)
            return;
        m_loops[loop].optionalCards.Add("");
    }

    void save()
    {
        var s = new LoopSerializer(m_loops);
        var json = JsonUtility.ToJson(s);

        Directory.CreateDirectory(assetPath);
        StreamWriter writer = new StreamWriter(assetPath + assetName);
        writer.WriteLine(json);
        writer.Close();
        AssetDatabase.ImportAsset(assetPath + assetName);
    }
}
#endif
