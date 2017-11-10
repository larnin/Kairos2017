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

    public class DragData
    {
        public DragData(Vector2 _raw, Vector3 _move, Quaternion _rotation, Transform _origine)
        {
            move = _move;
            rawMove = _raw;
            origine = _origine;
            rotation = _rotation;
        }

        public DragData(Vector2 _raw, Vector3 _move, Transform _origine)
        {
            move = _move;
            rawMove = _raw;
            origine = _origine;
            rotation = Quaternion.identity;
        }

        public Vector3 move;
        public Vector2 rawMove;
        public Transform origine;
        public Quaternion rotation;
    }

    public abstract void onEnter(OrigineType type, Vector3 localPosition);

    public abstract void onExit(OrigineType type);

    public abstract void onInteract(OrigineType type, Vector3 localPosition);

    public abstract void onInteractEnd(OrigineType type);

    public abstract void onDrag(DragData data, OrigineType type);
}
