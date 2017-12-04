using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class PowFeedbackLogic : MonoBehaviour
{
    public enum FeedbackType
    {
        RIGHT,
        WRONG,
        TIMEOUT,
    }

    Color rightColor = new Color(0, 1, 0);
    Color falseColor = new Color(1, 0, 0);

    Image m_powBackImage;
    Text m_powText;

    private void Awake()
    {
        m_powBackImage = transform.Find("Pow").GetComponent<Image>();
        m_powText = transform.Find("PowText").GetComponent<Text>();
    }

    private void Start()
    {
        //gameObject.SetActive(false);
    }

    public void show(FeedbackType type, float time)
    {
        gameObject.SetActive(true); 

        m_powText.text = textFromFeedbackType(type);
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