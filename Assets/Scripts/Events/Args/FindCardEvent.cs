using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class FindCardEvent : EventArgs
{
    public FindCardEvent(string _name)
    {
        name = _name;
    }

    public string name;
}