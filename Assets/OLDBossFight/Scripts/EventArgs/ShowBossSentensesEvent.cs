using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class ShowBossSentensesEvent : EventArgs
{
    public ShowBossSentensesEvent(List<string> _sentenses)
    {
        sentenses = _sentenses;
    }

    public List<string> sentenses;
}