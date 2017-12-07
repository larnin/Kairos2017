using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.UI;

public class MainMenuLogic : MonoBehaviour
{
    private void Awake()
    {
        if (SaveAttributes.getCurrentLoopIndex() <= 0)
            transform.Find("ContinueButton").gameObject.SetActive(false);
    }

    public void onStart()
    {
        //todo start game
    }

    public void onContinue()
    {
        //todo continue game
    }

    public void onQuit()
    {
        Application.Quit();
    }
}
