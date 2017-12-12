using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class MiniGameBaseLogic : MonoBehaviour
{
    public Transform CameraTransformUsed;

    public abstract void activate();
    public Action desactivate;
}
