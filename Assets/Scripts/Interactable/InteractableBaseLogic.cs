using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public abstract class InteractableBaseLogic : MonoBehaviour
{
    public enum OrigineType
    {
        CURSOR,
        FIRST_PERSON_CAMERA,
        THIRD_PERSON_CAMERA
    }

    public abstract void onEnter(OrigineType type, Vector3 localPosition);

    public abstract void onExit(OrigineType type);

    public abstract void onInteract(OrigineType type, Vector3 localPosition);

    public abstract void onInteractEnd(OrigineType type);

    public abstract void onDrag(Vector2 dist, OrigineType type);
}
