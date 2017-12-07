using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class BigCardLogic : MonoBehaviour
{
    [SerializeField] float lifeTime = 5;

    Text m_title;
    Image m_image;
    Text m_description;

    private void Awake()
    {
        m_title = transform.Find("Title").GetComponent<Text>();
        m_image = transform.Find("Image").GetComponent<Image>();
        m_description = transform.Find("Description").GetComponent<Text>();
    }

    private void Start()
    {
        Destroy(gameObject, lifeTime);
    }

    public void set(string cardName, string textureName, string description)
    {
        m_title.text = cardName;
        m_description.text = description;

        string imagePath = "InventoryBook/Cards/";
        Sprite s = Resources.Load<Sprite>(imagePath + textureName);
        m_image.sprite = s;
    }
}
