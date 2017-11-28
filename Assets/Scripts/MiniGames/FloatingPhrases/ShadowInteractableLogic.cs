using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShadowInteractableLogic : InteractableBaseLogic
{
    public override void onDrag(DragData data, OrigineType type)
    { 
        
    }

    public override void onEnter(OrigineType type, Vector3 localPosition)
    {
        
    }

    public override void onExit(OrigineType type)
    {
        
    }

    public override void onInteract(OrigineType type, Vector3 localPosition)
    {
        if(type == OrigineType.CURSOR)
        {

        }
    }

    public override void onInteractEnd(OrigineType type)
    {
        
    }
}
