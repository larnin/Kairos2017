using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

class TestInteractablelogic : InteractableBaseLogic
{
    public override void onDrag(DragData data, OrigineType type)
    {
        Debug.Log("Dragged " + data.rawMove);
        transform.position += data.move;
        transform.rotation *= data.rotation;
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
