using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEditor;
using System.IO;

[Serializable]
public class StoryItem
{
    public enum VisibilityState
    {
        HIDDEN,
        EXIST_NOT_VISIBLE,
        VISIBLE,
    }

    public enum ContentType
    {
        TEXT,
        IMAGE,
    }

    public enum ContentAlignement
    {
        LEFT,
        CENTRED,
        RIGHT,
        TOP_LEFT
    }

    public StoryItem(string _name)
    {
        name = _name;
        visibility = VisibilityState.HIDDEN;
        contentType = ContentType.TEXT;
        contentAlignement = ContentAlignement.LEFT;
        useSpaceIfHiden = false;
        spacing = 0;
        shift = 0;
        text = "";
        textSize = 10;
        textColor = Color.black;
        textFontName = "";

        textureName = "";
        textureResize = false;
        textureSize = new Vector2(100, 100);
        folded = false;
    }

    public bool folded;
    public string name;
    public VisibilityState visibility;
    public ContentType contentType;
    public ContentAlignement contentAlignement;
    public bool useSpaceIfHiden;
    public int spacing;
    public int shift;

    // content specific
    // -- Text
    public string text;
    public int textSize;
    public Color textColor;
    public string textFontName;

    // -- image
    public string textureName;
    public bool textureResize;
    public Vector2 textureSize;
}

[Serializable]
public class StoryCategory
{
    public StoryCategory(string _categoryName)
    {
        categoryName = _categoryName;
        folded = false;
    }

    public bool folded;
    public string categoryName;
    public string fancyCategoryName;
    public List<StoryItem> items = new List<StoryItem>();
}

[Serializable]
public class StorySerializer
{
    public StorySerializer(List<StoryCategory> _categories)
    {
        categories = _categories;
    }

    public List<StoryCategory> categories;
}

public class BookStoryTool : EditorWindow
{
    string assetPath = "Assets/Resources/InventoryBook/";
    string assetName = "Story.json";

    List<StoryCategory> m_categories = new List<StoryCategory>();
    Vector2 m_scrollPosition = Vector2.zero;

    [MenuItem("Tools/InventoryBook/Story")]
    static void Init()
    {
        BookStoryTool window = (BookStoryTool)EditorWindow.GetWindow(typeof(BookStoryTool));
        window.Show();
    }

    private void OnEnable()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(assetPath + assetName);
        if (text != null)
        {
            var data = JsonUtility.FromJson<StorySerializer>(text.text);
            m_categories = data.categories;
        }
    }

    void OnGUI()
    {
        if (GUILayout.Button("Add story item"))
            askAddStoryItem();

        var categoryStyle = new GUIStyle();
        categoryStyle.margin = new RectOffset(5, 5, 5, 5);
        var itemStyle = new GUIStyle();
        itemStyle.margin = new RectOffset(20, 0, 0, 0);

        m_scrollPosition = GUILayout.BeginScrollView(m_scrollPosition);

        for (int i = 0; i < m_categories.Count; i++)
        {
            var categoryItem = m_categories[i];

            GUILayout.BeginVertical(categoryStyle);
            categoryItem.folded = EditorGUILayout.Foldout(categoryItem.folded, categoryItem.categoryName);
            
            if(!categoryItem.folded)
            {
                categoryItem.fancyCategoryName = EditorGUILayout.TextField("Fancy category name :", categoryItem.fancyCategoryName);

                for (int j = 0; j < categoryItem.items.Count; j++)
                {
                    var storyItem = categoryItem.items[j];
                    GUILayout.BeginVertical(itemStyle);
                    storyItem.folded = EditorGUILayout.Foldout(storyItem.folded, storyItem.name);
                    if (!storyItem.folded)
                    {

                        GUILayout.BeginVertical(itemStyle);

                        storyItem.visibility = (StoryItem.VisibilityState)EditorGUILayout.EnumPopup("Visibility: ", storyItem.visibility);
                        storyItem.useSpaceIfHiden = EditorGUILayout.Toggle("Use space if hidden: ", storyItem.useSpaceIfHiden);
                        storyItem.shift = EditorGUILayout.IntField("Horisontal offset:", storyItem.shift);
                        storyItem.spacing = EditorGUILayout.IntField("Space before next item", storyItem.spacing);
                        storyItem.contentAlignement = (StoryItem.ContentAlignement)EditorGUILayout.EnumPopup("Content alignement:", storyItem.contentAlignement);
                        storyItem.contentType = (StoryItem.ContentType)EditorGUILayout.EnumPopup("Content type:", storyItem.contentType);

                        if (storyItem.contentType == StoryItem.ContentType.TEXT)
                        {
                            GUILayout.Label("Text");
                            storyItem.text = GUILayout.TextArea(storyItem.text);

                            GUILayout.BeginHorizontal();
                            EditorGUILayout.LabelField("Font name: ", GUILayout.MaxWidth(80));
                            storyItem.textFontName = EditorGUILayout.TextField(storyItem.textFontName);
                            EditorGUILayout.LabelField("Size: ", GUILayout.MaxWidth(50));
                            storyItem.textSize = EditorGUILayout.IntField(storyItem.textSize);
                            EditorGUILayout.LabelField("Color: ", GUILayout.MaxWidth(50));
                            storyItem.textColor = EditorGUILayout.ColorField(storyItem.textColor);
                            GUILayout.EndHorizontal();
                        }
                        else //image
                        {
                            GUILayout.BeginHorizontal();
                            EditorGUILayout.LabelField("Image name: ", GUILayout.MaxWidth(80));
                            storyItem.textureName = GUILayout.TextField(storyItem.textureName);
                            GUILayout.EndHorizontal();

                            storyItem.textureResize = EditorGUILayout.Toggle("Resize image", storyItem.textureResize);
                            if (storyItem.textureResize)
                                storyItem.textureSize = EditorGUILayout.Vector2Field("Size: ", storyItem.textureSize);
                        }

                        GUILayout.BeginHorizontal();
                        if (j > 0 && GUILayout.Button("Up", GUILayout.MaxWidth(150)))
                            moveStoryItem(i, j, -1);
                        if (j < categoryItem.items.Count - 1 && GUILayout.Button("Down", GUILayout.MaxWidth(150)))
                            moveStoryItem(i, j, 1);
                        if (GUILayout.Button("Remove", GUILayout.MaxWidth(150)))
                            deleteStoryItem(i, j);
                        GUILayout.EndHorizontal();

                        GUILayout.EndVertical();
                    }
                    EditorGUILayout.Space();
                    GUILayout.EndVertical();
                }

                GUILayout.BeginHorizontal();
                if (i > 0 && GUILayout.Button("Up", GUILayout.MaxWidth(150)))
                    moveCategory(i, -1);
                if (i < m_categories.Count - 1 && GUILayout.Button("Down", GUILayout.MaxWidth(150)))
                    moveCategory(i, 1);
                if (GUILayout.Button("Remove", GUILayout.MaxWidth(150)))
                    deleteCategory(i);
                GUILayout.EndHorizontal();
            }
            GUILayout.EndVertical();
        }
        GUILayout.EndScrollView();

        if (GUILayout.Button("Save story"))
            save();
    }

    public void askAddStoryItem()
    {
        AddStoryEntryWindow.Open();
    }

    public void addStoryItem(string category, string name)
    {
        if (category.Count() == 0 || name.Count() == 0)
            return;

        var categoryitem = m_categories.Find(x => { return x.categoryName == category; });
        if (categoryitem == null)
        {
            m_categories.Add(new StoryCategory(category));
            categoryitem = m_categories[m_categories.Count - 1];
        }

        if (!categoryitem.items.Exists(x => { return x.name == name; }))
            categoryitem.items.Add(new StoryItem(name));
    }

    void moveCategory(int index, int offset)
    {
        offset = Math.Sign(offset);

        if (index + offset < 0 || index < 0)
            return;
        if (index + offset >= m_categories.Count || index >= m_categories.Count)
            return;

        var item = m_categories[index];
        m_categories[index] = m_categories[index + offset];
        m_categories[index + offset] = item;
    }

    void deleteCategory(int index)
    {
        if (index < 0 || index >= m_categories.Count())
            return;

        m_categories.RemoveAt(index);
    }

    void moveStoryItem(int category, int index, int offset)
    {
        if (category < 0 || category >= m_categories.Count)
            return;
        var items = m_categories[category].items;

        if (index + offset < 0 || index < 0)
            return;
        if (index + offset >= items.Count || index >= items.Count)
            return;

        var item = items[index];
        items[index] = items[index + offset];
        items[index + offset] = item;
    }

    void deleteStoryItem(int category, int index)
    {
        if (category < 0 || category >= m_categories.Count)
            return;
        var items = m_categories[category].items;
        if (index < 0 || index >= items.Count)
            return;
        items.RemoveAt(index);
        if (items.Count == 0)
            m_categories.RemoveAt(category);
    }

    void save()
    {
        var s = new StorySerializer(m_categories);
        var json = JsonUtility.ToJson(s);

        Directory.CreateDirectory(assetPath);
        StreamWriter writer = new StreamWriter(assetPath+assetName);
        writer.WriteLine(json);
        writer.Close();
        AssetDatabase.ImportAsset(assetPath+assetName);
    }
}

public class AddStoryEntryWindow : ScriptableWizard
{
    public string category = "";
    public string storyItemName = "";

    public static void Open()
    {
        ScriptableWizard.DisplayWizard<AddStoryEntryWindow>("Add story item", "Add", "Cancel");
    }

    void OnWizardCreate()
    {
        var window = (BookStoryTool)EditorWindow.GetWindow(typeof(BookStoryTool));
        window.addStoryItem(category, storyItemName);
    }

    void OnWizardOtherButton()
    {
        Close();
    }
}
