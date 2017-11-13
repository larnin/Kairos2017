using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public abstract class CharacterBase : MonoBehaviour
{
    public abstract void move(Vector3 move);
}