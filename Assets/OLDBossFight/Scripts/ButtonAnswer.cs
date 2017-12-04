using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonAnswer : Interactable
{
    private FindThemeManager m_findThemeManager;
    private Color m_baseColor;

    public bool m_isCorrectAnswer;

    public void Start()
    {
        m_baseColor = GetComponent<UnityEngine.UI.Image>().color;
    }

    public override void hoverEnter()
    {
        GetComponent<UnityEngine.UI.Image>().color = m_findThemeManager.hoverColor;
    }

    public override void hoverExit()
    {
        GetComponent<UnityEngine.UI.Image>().color = m_baseColor;
    }

    public override void select()
    {
        if (m_isCorrectAnswer)
        {
            m_findThemeManager.correct();
        }
        else
        {
            m_findThemeManager.notCorrect();
        }
    }

    public void SetFindThemeManager(FindThemeManager _m_findThemeManager)
    {
        m_findThemeManager = _m_findThemeManager;
    }
}
