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
            slider = parent.Find("Slider").GetComponent<Slider>();
            value = parent.Find("Value").GetComponent<Text>();
        }

        public OptionsSubmenuButtonLogic label;
        public Slider slider;
        public Text value;
        public string propertyName;
    }

    string returnButton = "Cancel";

    GameObject m_item;
    List<Category> m_categories = new List<Category>();
    OptionsSubmenuButtonLogic m_returnButton;


    public OptionsSubmenu(MenuPageLogic menu, GameObject item) : base(menu)
    {
        m_item = item;
        initializeCategories();
        loadProperties();
        m_returnButton = m_item.transform.Find("Exit").GetComponent<OptionsSubmenuButtonLogic>();
        m_returnButton.clickAction = disable;
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
            c.slider.value = G.sys.saveSystem.getFloat(c.propertyName, c.slider.value);
    }

    void saveProperties()
    {
        foreach (var c in m_categories)
            G.sys.saveSystem.set(c.propertyName, c.slider.value);
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
    }

    void updateValues()
    {
        foreach (var c in m_categories)
            c.value.text = ((int)c.slider.value).ToString();
    }
}
