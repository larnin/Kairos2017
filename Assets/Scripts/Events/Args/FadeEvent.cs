using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class FadeEvent : EventArgs
{
    public FadeEvent(Color _targetColor, float _time)
    {
        targetColor = _targetColor;
        time = _time;
        instant = false;
    }

    public FadeEvent(Color _targetColor)
    {
        targetColor = _targetColor;
        instant = true;
    }

    public Color targetColor;
    public float time;
    public bool instant;
}