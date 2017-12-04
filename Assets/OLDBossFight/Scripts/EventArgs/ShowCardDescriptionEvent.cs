using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class ShowCardDescriptionEvent : EventArgs
{
    public ShowCardDescriptionEvent(string _description)
    {
        description = _description;
    }

    public string description;
}
