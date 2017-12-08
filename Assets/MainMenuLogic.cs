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
        G.sys.loopSystem.startLoop(1);
    }

    public void onContinue()
    {
        G.sys.loopSystem.startLoop(SaveAttributes.getCurrentLoopIndex());
    }

    public void onReset()
    {
        G.sys.saveSystem.reset();
        if (SaveAttributes.getCurrentLoopIndex() <= 0)
            transform.Find("ContinueButton").gameObject.SetActive(false);
    }

    public void onQuit()
    {
        Application.Quit();
    }
}
