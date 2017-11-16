using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class StoryPageLogic : MonoBehaviour
{
    string verticalAxis = "Vertical";
    float axisThreshold = 0.6f;

    [SerializeField] GameObject m_categoryTextPrefab;
    [SerializeField] GameObject m_storyItemTextPrefab;
    [SerializeField] GameObject m_storyItemImagePrefab;
    [SerializeField] Font m_defaultFont;
    [SerializeField] Vector2 m_categoryOrigine;
    [SerializeField] float m_categoryHeight = 400;
    [SerializeField] float m_categoryHeightMax = 100;
    [SerializeField] Rect m_storyArea;

    string m_selectedCategory;

    float m_oldVerticalAxisValue = 0;

    List<StoryCategory> m_categories = new List<StoryCategory>();

    List<StoryCategoryTextLogic> m_categoryTexts = new List<StoryCategoryTextLogic>();

    List<GameObject> m_objects = new List<GameObject>();

    private void Awake()
    {
        loadStoryData();
        createCategories();
        if(m_categoryTexts.Count > 0)
        {
            m_selectedCategory = m_categoryTexts[0].categoryName;
            selectCategory(m_selectedCategory);
        }
    }

    private void Update()
    {
        var value = Input.GetAxisRaw(verticalAxis);
        var direction = value > axisThreshold && m_oldVerticalAxisValue < axisThreshold ? -1 : value < -axisThreshold && m_oldVerticalAxisValue > -axisThreshold ? 1 : 0;
        m_oldVerticalAxisValue = value;
        if(direction != 0)
        {
            exitHover();
            var i = currentSelectedIndex();
            if (!((i == 0 && direction < 0) || (i == m_categoryTexts.Count - 1 && direction > 0)))
                selectCategory(m_categoryTexts[i + direction].categoryName);
        }
    }

    int currentSelectedIndex()
    {
        for (int i = 0; i < m_categoryTexts.Count; i++)
            if (m_categoryTexts[i].selected)
                return i;
        return 0;
    }

    void loadStoryData()
    {
        string assetPath = "InventoryBook/";
        string assetName = "Story";

        var text = Resources.Load<TextAsset>(assetPath + assetName);
        if (text != null)
        {
            var items = JsonUtility.FromJson<StorySerializer>(text.text);
            if (items != null)
                m_categories = items.categories;
            else Debug.LogError("Can't parse story asset !");
        }
        else Debug.LogError("Can't load story asset !");

        foreach (var c in m_categories)
            foreach (var i in c.items)
                i.visibility = G.sys.saveSystem.getStoryItemVisibility(c.categoryName, i.name);
    }

    void createCategories()
    {
        if (m_categories.Count == 0)
            return;

        float offset = Mathf.Min(m_categoryHeightMax, m_categories.Count > 1 ? m_categoryHeight / (m_categories.Count - 1) : m_categoryHeight);
        for(int i = 0; i < m_categories.Count; i++)
        {
            var category = m_categories[i];

            var obj = Instantiate(m_categoryTextPrefab, transform);
            var tr = obj.GetComponent<RectTransform>();
            tr.localPosition = m_categoryOrigine - new Vector2(0, offset * i);
            var cat = obj.GetComponent<StoryCategoryTextLogic>();
            cat.setText(category.categoryName, category.fancyCategoryName.Count() == 0 ? category.categoryName : category.fancyCategoryName);
            cat.clickAction = onCategoryClick;
            cat.hoverAction = onCategoryHover;
            cat.hoverExitAction = onCategoryHoverExit;
            m_categoryTexts.Add(cat);
        }
    }

    void onCategoryHover(string categoryName)
    {
        foreach(var c in m_categoryTexts)
        {
            if (c.categoryName == categoryName)
                c.hovered = true;
            else c.hovered = false;
        }
    }

    void onCategoryHoverExit(string categoryName)
    {
        foreach (var c in m_categoryTexts)
        {
            if (c.categoryName == categoryName)
                c.hovered = false;
        }
    }

    void exitHover()
    {
        foreach (var c in m_categoryTexts)
            c.hovered = false;
    }

    void onCategoryClick(string categoryName)
    {
        selectCategory(categoryName);
    }

    void selectCategory(string categoryName)
    {
        m_selectedCategory = categoryName;
        foreach (var c in m_categoryTexts)
        {
            if (c.categoryName == categoryName)
                c.selected = true;
            else c.selected = false;
        }

        foreach (var o in m_objects)
            Destroy(o);
        m_objects.Clear();
        createCurrentCategoryPage();
    }

    void createCurrentCategoryPage()
    {

    }
}
