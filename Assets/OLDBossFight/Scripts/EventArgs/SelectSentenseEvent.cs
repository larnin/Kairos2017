using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class SelectSentenseEvent : EventArgs
{
    public SelectSentenseEvent(BossTextLogic _sentense)
    {
        sentense = _sentense;
    }

    public BossTextLogic sentense;
}
