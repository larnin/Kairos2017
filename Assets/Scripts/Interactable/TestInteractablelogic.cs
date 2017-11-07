using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class TestInteractablelogic : InteractableBaseLogic
{
    public override void onDrag(Vector2 dist, OrigineType type)
    {
        Debug.Log("Dragged " + dist);
    }

    public override void onEnter(OrigineType type, Vector3 localPosition)
    {
        Debug.Log("Enter " + localPosition);
    }

    public override void onExit(OrigineType type)
    {
        Debug.Log("Exit");
    }

    public override void onInteract(OrigineType type, Vector3 localPosition)
    {
        Debug.Log("Interact " + localPosition);
    }

    public override void onInteractEnd(OrigineType type)
    {
        Debug.Log("Interact End");
    }
}
