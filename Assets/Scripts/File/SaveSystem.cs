using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;

public class SaveSystem
{
    static int version = 1;

    Save m_save = new Save();

    string filename = "Save.json";

    public SaveSystem()
    {
        Load();
    }

    void Load()
    {
        string filePath = Application.persistentDataPath + "/" + filename;
        try
        {
            if (!File.Exists(filePath))
                save();
            else
            {
                var s = File.ReadAllText(filePath);
                m_save = JsonUtility.FromJson<Save>(s);
                if(m_save == null)
                    Debug.LogWarning("Can't load the file !");
            }
        }
        catch (Exception e)
        {
            Debug.LogWarning("Can't load the file !");
            Debug.Log(e.ToString());
            reset();
        }

        if (m_save.version != version)
            reset();
    }

    void save()
    {
        string filePath = Application.persistentDataPath + "/" + filename;
        try
        {
            var s = JsonUtility.ToJson(m_save);
            File.WriteAllText(filePath, s);
        }
        catch (Exception e)
        {
            Debug.LogWarning("Can't save the file !");
            Debug.Log(e.ToString());
        }
    }

    public void reset()
    {
        m_save = defaultSave();
        save();
    }

    public void set<T>(string key, T value)
    {
        var item = m_save.items.Find(x => { return x.key == key; });
        if (item == null)
            m_save.items.Add(new Save.Item(key, value));
        else item.value = value;
        save();
    }

    public T get<T>(string key, T defaultValue = default(T))
    {
        var item = m_save.items.Find(x => { return x.key == key; });
        if (item == null)
            return defaultValue;
        return (T)item.value;
    }

    public object get(string key)
    {
        var item = m_save.items.Find(x => { return x.key == key; });
        if (item == null)
            return null;
        return item.value;
    }

    public void remove(string key)
    {
        m_save.items.RemoveAll(x => { return x.key == key; });
        save();
    }

    Save defaultSave()
    {
        var s = new Save();
        s.version = version;
        initializeStoryBookItem(s);
        initializeCardDatas(s);
        return s;
    }

    void initializeStoryBookItem(Save s)
    {
        string assetName = "InventoryBook/Story";

        var text = Resources.Load<TextAsset>(assetName);
        if (text != null)
        {
            var items = JsonUtility.FromJson<StorySerializer>(text.text);
            if (items != null)
            {
                foreach (var i in items.categories)
                    foreach (var j in i.items)
                        s.items.Add(new Save.Item("Story." + i.categoryName + "." + j.name, j.visibility));
            }
        }
    }

    void initializeCardDatas(Save s)
    {
        string assetName = "InventoryBook/Cards";

        var text = Resources.Load<TextAsset>(assetName);
        if (text != null)
        {
            var items = JsonUtility.FromJson<CardsSerializer>(text.text);
            if (items != null)
            {
                foreach (var i in items.cards)
                    s.items.Add(new Save.Item("Card." + i.name, i.visibility));
            }
        }
    }
}