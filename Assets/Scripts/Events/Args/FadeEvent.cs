using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/// <summary>
/// callback a void function with a bool parameter that is called when the fade finished.
/// The bool value is false if the fade has not finished (broken by a new fade)
/// </summary>
public class FadeEvent : EventArgs
{
    public FadeEvent(float _targetValue, float _time, Action<bool> _callback = null)
    {
        targetValue = _targetValue;
        time = _time;
        callback = _callback;
    }

    public float targetValue;
    public float time;
    public Action<bool> callback;
}
