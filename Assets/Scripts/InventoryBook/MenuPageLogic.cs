using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MenuPageLogic : MonoBehaviour
{
    List<MenuButtonLogic> m_buttons = new List<MenuButtonLogic>();
    int currentIndex = 0;

    private void Awake()
    {
        var buttons = transform.Find("Buttons");
        for (int i = 0; i < buttons.childCount; i++)
        {
            var comp = buttons.GetChild(i).GetComponent<MenuButtonLogic>();
            if (comp != null)
                m_buttons.Add(comp);
        }
    }

    private void Update()
    {
        
    }

    public void onResume()
    {

    }

    public void onOptions()
    {

    }

    public void onControles()
    {

    }

    public void onQuit()
    {
        
    }
}
