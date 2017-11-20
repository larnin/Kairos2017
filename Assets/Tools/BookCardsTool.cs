using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

[Serializable]
public class CardData
{
    public enum VisibilityState
    {
        HIDDEN,
        VISIBLE,
    }

    public CardData(string _name)
    {
        name = _name;
        visibility = VisibilityState.HIDDEN;
        textureName = "";
        description = "";
        descriptionSize = 10;
        descriptionColor = Color.black;
        descriptionFontName = "";
        descriptionStyle = FontStyle.Normal;
        folded = true;
    }

    public bool folded;
    public VisibilityState visibility;
    public string name;
    public string textureName;

    public string description;
    public int descriptionSize;
    public Color descriptionColor;
    public string descriptionFontName;
    public FontStyle descriptionStyle;
}

[Serializable]
public class CardsSerializer
{
    public CardsSerializer(List<CardData> _cards)
    {
        cards = _cards;
    }

    public List<CardData> cards;
}

public class BookCardsTool : EditorWindow
{
    string assetPath = "Assets/Resources/InventoryBook/";
    string assetName = "cards.json";

    List<CardData> m_cards = new List<CardData>();

    Vector2 m_scrollPosition = Vector2.zero;

    [MenuItem("Tools/InventoryBook/Cards")]
    static void Init()
    {
        BookCardsTool window = (BookCardsTool)EditorWindow.GetWindow(typeof(BookCardsTool));
        window.Show();
    }

    private void OnEnable()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(assetPath + assetName);
        if (text != null)
        {
            var data = JsonUtility.FromJson<CardsSerializer>(text.text);
            m_cards = data.cards;
        }
    }

    void OnGUI()
    {
        if (GUILayout.Button("Add card"))
            askAddCard();

        var categoryStyle = new GUIStyle();
        categoryStyle.margin = new RectOffset(5, 5, 5, 5);
        var itemStyle = new GUIStyle();
        itemStyle.margin = new RectOffset(20, 0, 0, 0);

        m_scrollPosition = GUILayout.BeginScrollView(m_scrollPosition);

        for(int i = 0; i < m_cards.Count; i++)
        {
            var card = m_cards[i];

            GUILayout.BeginVertical(categoryStyle);
            card.folded = EditorGUILayout.Foldout(card.folded, card.name);
            if (card.folded)
            {
                GUILayout.BeginVertical(itemStyle);

                card.visibility = (CardData.VisibilityState)EditorGUILayout.EnumPopup("Visibility: ", card.visibility);
                GUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Image name: ", GUILayout.MaxWidth(80));
                card.textureName = GUILayout.TextField(card.textureName);
                GUILayout.EndHorizontal();

                EditorGUILayout.LabelField("Description: ");
                card.description = GUILayout.TextArea(card.description);

                GUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Font name: ", GUILayout.MaxWidth(75));
                card.descriptionFontName = EditorGUILayout.TextField(card.descriptionFontName);
                EditorGUILayout.LabelField("Size: ", GUILayout.MaxWidth(40));
                card.descriptionSize = EditorGUILayout.IntField(card.descriptionSize, GUILayout.MaxWidth(40));
                EditorGUILayout.LabelField("Color: ", GUILayout.MaxWidth(45));
                card.descriptionColor = EditorGUILayout.ColorField(card.descriptionColor, GUILayout.MaxWidth(50));
                EditorGUILayout.LabelField("Style: ", GUILayout.MaxWidth(45));
                card.descriptionStyle = (FontStyle)EditorGUILayout.EnumPopup(card.descriptionStyle);
                GUILayout.EndHorizontal();

                GUILayout.BeginHorizontal();
                if (i > 0 && GUILayout.Button("Up", GUILayout.MaxWidth(150)))
                    move(i, -1);
                if (i < m_cards.Count - 1 && GUILayout.Button("Down", GUILayout.MaxWidth(150)))
                    move(i, 1);
                if (GUILayout.Button("Remove", GUILayout.MaxWidth(150)))
                    delete(i);
                GUILayout.EndHorizontal();

                GUILayout.EndVertical();
            }
            GUILayout.EndVertical();
        }
        GUILayout.EndScrollView();

        if (GUILayout.Button("Save cards"))
            save();
    }

    void move(int index, int offset)
    {
        offset = Math.Sign(offset);

        if (index + offset < 0 || index < 0)
            return;
        if (index + offset >= m_cards.Count || index >= m_cards.Count)
            return;

        var item = m_cards[index];
        m_cards[index] = m_cards[index + offset];
        m_cards[index + offset] = item;
    }

    void delete(int index)
    {
        if (index < 0 || index >= m_cards.Count())
            return;

        m_cards.RemoveAt(index);
    }

    void askAddCard()
    {
        AddCardWindow.Open();
    }

    public void addCard(string cardName)
    {
        if (m_cards.Exists(x => { return x.name == cardName; }))
            return;
        m_cards.Add(new CardData(cardName));
    }

    void save()
    {
        var s = new CardsSerializer(m_cards);
        var json = JsonUtility.ToJson(s);

        Directory.CreateDirectory(assetPath);
        StreamWriter writer = new StreamWriter(assetPath + assetName);
        writer.WriteLine(json);
        writer.Close();
        AssetDatabase.ImportAsset(assetPath + assetName);
    }
}

public class AddCardWindow : ScriptableWizard
{
    public string cardName = "";

    public static void Open()
    {
        ScriptableWizard.DisplayWizard<AddCardWindow>("Add card", "Add", "Cancel");
    }

    void OnWizardCreate()
    {
        var window = (BookCardsTool)EditorWindow.GetWindow(typeof(BookCardsTool));
        window.addCard(cardName);
    }

    void OnWizardOtherButton()
    {
        Close();
    }
}