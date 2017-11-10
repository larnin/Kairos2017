using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class ShowUIButtonsEvent : EventArgs
{
    public class ButtonInfos
    {
        public ButtonInfos(string _buttonName, bool _enabled, string _buttonText = "")
        {
            buttonName = _buttonName;
            buttonText = _buttonText;
            enabled = _enabled;
        }

        public ButtonInfos(string _buttonName, string _buttonText = "")
        {
            buttonName = _buttonName;
            buttonText = _buttonText;
            enabled = true;
        }

        public string buttonName;
        public string buttonText;
        public bool enabled;
    }

    public ShowUIButtonsEvent(List<ButtonInfos> _buttonsInfos, bool _hideOtherButtons = true)
    {
        buttonsInfos = _buttonsInfos;
        hideOthersButtons = _hideOtherButtons;
    }

    public ShowUIButtonsEvent(bool _hideOtherButtons = true)
    {
        buttonsInfos = new List<ButtonInfos>();
        hideOthersButtons = _hideOtherButtons;
    }

    public List<ButtonInfos> buttonsInfos;
    public bool hideOthersButtons;
}