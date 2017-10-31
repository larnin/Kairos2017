using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class ChangeControlerViewEvent : EventArgs
{
    public enum ControlerViewType
    {
        FPS_VIEW,
        THIRD_VIEW,
    }

    public ChangeControlerViewEvent(ControlerViewType _viewType)
    {
        viewType = _viewType;
    }

    public ControlerViewType viewType;
}