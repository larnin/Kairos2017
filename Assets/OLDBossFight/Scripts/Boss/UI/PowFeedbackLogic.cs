using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class PowFeedbackLogic : MonoBehaviour
{
    public enum FeedbackType
    {
        RIGHT,
        WRONG,
        TIMEOUT,
    }

    public Color rightColor = new Color(0, 1, 0);
    public Color falseColor = new Color(1, 0, 0);

    Image m_powBackImage;
    Text m_powText;
    TextMeshProUGUI m_powTextTMP;

    private void Awake()
    {
        if(transform.Find("Pow") != null)
            m_powBackImage = transform.Find("Pow").GetComponent<Image>();
        m_powText = transform.Find("PowText").GetComponent<Text>();
        m_powTextTMP = transform.Find("PowText").GetComponent<TextMeshProUGUI>();
    }

    private void Start()
    {
        //gameObject.SetActive(false);
    }

    public void show(FeedbackType type, float time, string text)
    {
        gameObject.SetActive(true);

        if (m_powText != null)
        {
            m_powText.text = text;
            m_powText.color = type == FeedbackType.RIGHT ? rightColor : falseColor;
        }
        else
        {
            m_powTextTMP.text = text;
            m_powTextTMP.color = type == FeedbackType.RIGHT ? rightColor : falseColor;
        }
        if(m_powBackImage != null)
            m_powBackImage.color = type == FeedbackType.RIGHT ? rightColor : falseColor;

        StartCoroutine(hidePowCoroutine(time));
    }

    IEnumerator hidePowCoroutine(float time)
    {
        yield return new WaitForSeconds(time);
        gameObject.SetActive(false);
    }

    string textFromFeedbackType(FeedbackType type)
    {
        switch(type)
        {
            case FeedbackType.RIGHT:
                return "VRAIS !";
            case FeedbackType.WRONG:
                return "FAUX !";
            case FeedbackType.TIMEOUT:
                return "Timeout !";
            default:
                return "That's not a valid feedback ... sucker !";
        }
    }
}