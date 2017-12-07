using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class StoryPageLogic : MonoBehaviour
{
    string verticalAxis = "Vertical";
    float axisThreshold = 0.6f;

    [SerializeField] GameObject m_categoryTextPrefab;
    [SerializeField] GameObject m_storyItemTextPrefab;
    [SerializeField] GameObject m_storyItemImagePrefab;
    [SerializeField] Vector2 m_categoryOrigine;
    [SerializeField] float m_categoryHeight = 400;
    [SerializeField] float m_categoryHeightMax = 100;
    [SerializeField] Rect m_storyArea;

    string m_selectedCategory;

    float m_oldVerticalAxisValue = 0;

    //List<StoryCategory> m_categories = new List<StoryCategory>();

    List<StoryCategoryTextLogic> m_categoryTexts = new List<StoryCategoryTextLogic>();

    List<GameObject> m_objects = new List<GameObject>();

    private void Awake()
    {
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

    void createCategories()
    {
        var categories = G.sys.ressourcesData.defaultStory;

        if (categories.Count == 0)
            return;

        float offset = Mathf.Min(m_categoryHeightMax, categories.Count > 1 ? m_categoryHeight / (categories.Count - 1) : m_categoryHeight);
        for(int i = 0; i < categories.Count; i++)
        {
            var category = categories[i];

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
        createCategoryPage(categoryName);
    }

    void createCategoryPage(string categoryName)
    {
        StoryCategory c = null;
        foreach(var cat in G.sys.ressourcesData.defaultStory)
            if(cat.categoryName == categoryName)
            {
                c = cat;
                break;
            }
        if (c == null)
            return;

        int currentOffset = 0;

        foreach(var item in c.items)
        {
            var pos = new Vector2(m_storyArea.x + m_storyArea.width / 2 + item.shift, m_storyArea.y - currentOffset);
            if (item.contentAlignement == StoryItem.ContentAlignement.TOP_LEFT)
                pos = new Vector2(m_storyArea.x + m_storyArea.width + item.shift, m_storyArea.y);

            var visibility = SaveAttributes.getStoryItemState(c.categoryName, item.name, item.visibility);

            if(visibility != StoryItem.VisibilityState.HIDDEN)
            {
                switch(item.contentType)
                {
                    case StoryItem.ContentType.TEXT:
                        createTextItem(item, pos);
                        break;
                    case StoryItem.ContentType.IMAGE:
                        createImageItem(item, pos);
                        break;
                    default:
                        Debug.LogError("Content type not supported !");
                        break;
                }
                currentOffset += item.spacing;
            }
            else if(item.useSpaceIfHiden)
                currentOffset += item.spacing;
        }
    }

    void createTextItem(StoryItem item, Vector2 offset)
    {
        string fontpath = "InventoryBook/Fonts/";

        Font font = null;
        if(item.textFontName.Count() != 0)
            font = Resources.Load<Font>(fontpath + item.textFontName);

        var obj = Instantiate(m_storyItemTextPrefab, transform);
        obj.transform.localPosition = offset;
        var textItem = obj.GetComponent<StoryTextItemLogic>();
        if (item.visibility == StoryItem.VisibilityState.VISIBLE)
            textItem.set(item.text, item.contentAlignement, font, item.textSize, item.textStyle, item.textColor, m_storyArea.width);
        else textItem.set("???", item.contentAlignement, font, item.textSize, item.textStyle, item.textColor, m_storyArea.width);
        m_objects.Add(obj);
    }

    void createImageItem(StoryItem item, Vector2 offset)
    {
        string imagePath = "InventoryBook/Images/";

        Sprite s = Resources.Load<Sprite>(imagePath + item.textureName);
        var obj = Instantiate(m_storyItemImagePrefab, transform);
        obj.transform.localPosition = offset;
        var imageItem = obj.GetComponent<StoryImageItemLogic>();
        if (item.visibility == StoryItem.VisibilityState.VISIBLE)
        {
            if (item.textureResize)
                imageItem.set(s, item.textureSize);
            else imageItem.set(s);
        }
        else
        {
            if (item.textureResize)
                imageItem.set(item.textureSize);
            else imageItem.set(new Vector2(s.texture.width, s.texture.height));
        }
        m_objects.Add(obj);
    }
}
