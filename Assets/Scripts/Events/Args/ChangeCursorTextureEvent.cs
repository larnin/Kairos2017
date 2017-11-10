using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ChangeCursorTextureEvent : EventArgs
{
    //revert texture to default state
    public ChangeCursorTextureEvent()
    {
        useDefaultTexture = true;
        color = Color.white;
    }

    public ChangeCursorTextureEvent(Color _color)
    {
        useDefaultTexture = true;
        color = _color;
    }

    public ChangeCursorTextureEvent(string _name)
    {
        useDefaultTexture = false;
        textureName = _name;
        color = Color.white;
    }

    public ChangeCursorTextureEvent(string _name, Color _color)
    {
        useDefaultTexture = false;
        textureName = _name;
        color = _color;
    }

    public bool useDefaultTexture;
    public string textureName;
    public Color color;
}
