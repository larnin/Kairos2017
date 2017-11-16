using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;

public class SaveSystem
{
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
            m_save = new Save();
        }
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
        m_save = new Save();
        save();
    }

    public void setStoryItemVisibility(string category, string story, StoryItem.VisibilityState state)
    {
        var item = m_save.storyItems.Find(x => { return x.category == category && x.story == story; });
        if(item == null)
        {
            m_save.storyItems.Add(new Save.StoryBookItem(category, story, state));
            save();
        }
        else if(item.state != state)
        {
            item.state = state;
            save();
        }
    }

    public StoryItem.VisibilityState getStoryItemVisibility(string category, string story)
    {
        var item = m_save.storyItems.Find(x => { return x.category == category && x.story == story; });
        if (item == null)
            return StoryItem.VisibilityState.HIDDEN;
        return item.state;
    }
}