using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class EnableCursorEvent : EventArgs
{
    public EnableCursorEvent(bool _enable, bool _recenter = true)
    {
        enable = _enable;
        recenter = _recenter;
    }

    public bool enable;
    public bool recenter;
}
