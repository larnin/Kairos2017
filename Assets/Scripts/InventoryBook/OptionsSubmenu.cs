using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

class OptionsSubmenu : MenuSubmenu
{
    public class Category
    {
        public Category(Transform parent)
        {
            var labelObj = parent.Find("Label");
            label = labelObj.GetComponent<OptionsSubmenuButtonLogic>();
            propertyName = labelObj.GetComponent<OptionsSubmenuSaveInfoLogic>().propertyName;
            var s = parent.Find("Slider");
            if (s != null)
            {
                slider = parent.Find("Slider").GetComponent<Slider>();
                value = parent.Find("Value").GetComponent<Text>();
            }
            else toggle = parent.Find("Toggle").GetComponent<Toggle>();
        }

        public Category(OptionsSubmenuButtonLogic _label)
        {
            label = _label;
        }

        public OptionsSubmenuButtonLogic label;
        public Slider slider;
        public Toggle toggle;
        public Text value;
        public string propertyName;
    }

    string submitButton = "Submit";
    string returnButton = "Cancel";
    string verticalAxis = "Vertical";
    string horizontalAxis = "Horizontal";
    float axisThreshold = 0.6f;
    float moveSpeed = 1.0f;

    GameObject m_item;
    List<Category> m_categories = new List<Category>();
    OptionsSubmenuButtonLogic m_returnButton;
    float m_oldVerticalAxisValue = 0;

    public OptionsSubmenu(MenuPageLogic menu, GameObject item) : base(menu)
    {
        m_item = item;
        initializeCategories();
        loadProperties();
        m_returnButton = m_item.transform.Find("Exit").GetComponent<OptionsSubmenuButtonLogic>();
        m_returnButton.clickAction = disable;
        m_categories.Add(new Category(m_returnButton));
        foreach (var c in m_categories)
            c.label.hoverAction = disableHovered;
        foreach (var c in m_categories)
            if (c.toggle != null)
                c.label.clickAction = () => { toggle(c.toggle); };
        m_item.SetActive(false);
    }
    
    void initializeCategories()
    {
        var categoriesParent = m_item.transform.Find("Categories");
        for(int i = 0; i < categoriesParent.childCount; i++)
        {
            m_categories.Add(new Category(categoriesParent.GetChild(i).Find("Mouse")));
            m_categories.Add(new Category(categoriesParent.GetChild(i).Find("Controler")));
        }
    }

    void loadProperties()
    {
        foreach (var c in m_categories)
        {
            if (c.slider != null)
                c.slider.value = G.sys.saveSystem.getFloat(c.propertyName, c.slider.value);
            if (c.toggle != null)
                c.toggle.isOn = G.sys.saveSystem.getBool(c.propertyName, c.toggle.isOn);
        }
    }

    void saveProperties()
    {
        foreach (var c in m_categories)
        {
            if (c.slider != null)
                G.sys.saveSystem.set(c.propertyName, c.slider.value);
            if (c.toggle != null)
                G.sys.saveSystem.set(c.propertyName, c.toggle.isOn);
        }
    }

    protected override void onDisable()
    {
        saveProperties();
        m_item.SetActive(false);
    }

    protected override void onEnable()
    {
        m_item.SetActive(true);
    }

    protected override void onUpdate()
    {
        if (Input.GetButtonDown(returnButton))
            disable();

        updateValues();

        var value = Input.GetAxisRaw(verticalAxis);
        var direction = value > axisThreshold && m_oldVerticalAxisValue < axisThreshold ? -1 : value < -axisThreshold && m_oldVerticalAxisValue > -axisThreshold ? 1 : 0;
        m_oldVerticalAxisValue = value;
        if (direction != 0)
        {
            var old = getCurrentSelected();
            var current = Mathf.Clamp(old + direction, 0, m_categories.Count - 1);
            if (old >= 0)
                m_categories[old].label.hovered = false;
            m_categories[current].label.hovered = true;
        }

        controlSlider();

        if(Input.GetButtonDown(submitButton))
        {
            var selected = getCurrentSelected();
            if (selected > 0)
                m_categories[selected].label.click();
        }
    }

    void controlSlider()
    {
        var selected = getCurrentSelected();
        if (selected < 0)
            return;
        var item = m_categories[selected];
        if (item.slider == null)
            return;
        var offset = Input.GetAxisRaw(horizontalAxis);
        if (Mathf.Abs(offset) < 0.6f)
            offset = 0;
        else offset = Mathf.Sign(offset);
        if (offset == 0)
            return;
        offset *= moveSpeed * (item.slider.maxValue - item.slider.minValue) * Time.deltaTime;
        item.slider.value += offset;
    }

    void updateValues()
    {
        foreach (var c in m_categories)
            if(c.value != null && c.slider != null)
                c.value.text = ((int)c.slider.value).ToString();
    }

    int getCurrentSelected()
    {
        for (int i = 0; i < m_categories.Count; i++)
        {
            var c = m_categories[i];
            if (c.label.hovered)
                return i;
        }
        return -1;
    }

    void disableHovered()
    {
        for (int i = 0; i < m_categories.Count; i++)
            m_categories[i].label.hovered = false;
    }

    void toggle(Toggle t)
    {
        t.isOn = !t.isOn;
    }
}
