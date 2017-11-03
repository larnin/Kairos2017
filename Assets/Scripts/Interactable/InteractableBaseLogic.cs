using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public abstract class InteractableBaseLogic : MonoBehaviour
{
    public abstract void onEnter();

    public abstract void onExit();

    public abstract void onInteract();

    public abstract void onDrag(Vector2 dist);
}
