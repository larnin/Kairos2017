using System;
using UnityEngine;

public class CursorClickEvent : EventArgs
{
    public GameObject gameObject;
    public CursorLogic cursorLogic;

    public CursorClickEvent(GameObject _gameObject, CursorLogic _cursorLogic)
    {
        gameObject = _gameObject;
        cursorLogic = _cursorLogic;
    }
}

