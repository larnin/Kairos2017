using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class StoryImageItemLogic : MonoBehaviour
{
    Image m_image;

    private void Awake()
    {
        m_image = GetComponent<Image>();
    }

    public void set(Sprite image, Vector2 imageSize)
    {
        var tr = GetComponent<RectTransform>();
        tr.sizeDelta = imageSize;
        m_image.sprite = image;
    }

    public void set(Sprite image)
    {
        m_image.sprite = image;
        m_image.SetNativeSize();
    }
}