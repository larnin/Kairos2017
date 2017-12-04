using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class StoryTextItemLogic : MonoBehaviour
{
    Text m_text;

    private void Awake()
    {
        m_text = GetComponent<Text>();
    }

    public void set(string text, StoryItem.ContentAlignement alignement, Font font, int fontSize, FontStyle style, Color color, float width)
    {
        var tr = GetComponent<RectTransform>();
        tr.sizeDelta = new Vector2(width, tr.sizeDelta.y);
        switch(alignement)
        {
            case StoryItem.ContentAlignement.RIGHT:
            case StoryItem.ContentAlignement.TOP_LEFT: //can't place text in that position
                m_text.alignment = TextAnchor.UpperRight;
                break;
            case StoryItem.ContentAlignement.CENTRED:
                m_text.alignment = TextAnchor.UpperCenter;
                break;
            case StoryItem.ContentAlignement.LEFT:
                m_text.alignment = TextAnchor.UpperLeft;
                break;
            default:
                Debug.LogError("Can't use that alignement !");
                break;
        }

        m_text.text = text;
        if(font != null)
            m_text.font = font;
        m_text.fontSize = fontSize;
        m_text.color = color;
        m_text.fontStyle = style;
    }
}
