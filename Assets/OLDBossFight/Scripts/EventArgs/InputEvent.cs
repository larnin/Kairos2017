using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class InputEvent : EventArgs
{
    public enum InputType
    {
        PRESSED,
        RELEASED,
    }

    public InputEvent(string _inputName, int _inputSign, InputType _inputType)
    {
        inputName = _inputName;
        inputSign = _inputSign < 0 ? -1 : 1;
        inputType = _inputType;
    }

    public string inputName;
    public int inputSign;
    public InputType inputType;
}