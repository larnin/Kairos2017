using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public abstract class Interactable : MonoBehaviour
{
    public abstract void hoverEnter();
    public abstract void hoverExit();
    public abstract void select();
}