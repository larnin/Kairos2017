using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class MouseLockerLogic : MonoBehaviour
{
    bool m_locked = true;

    private void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.L))
        {
            Cursor.lockState = m_locked ? CursorLockMode.None : CursorLockMode.Locked;
            m_locked = !m_locked;
        }
            
    }
}