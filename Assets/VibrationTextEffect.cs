using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class VibrationTextEffect : MonoBehaviour {

    public enum VibrationDirection {HORIZONTAL, VERTICAL, BOTH }
    
    [SerializeField] private float m_speed = 1f;
    [SerializeField] private float m_amplitude = 1f;
    [SerializeField] private float m_randomnessAmplitude = 0.1f;
    [SerializeField] private VibrationDirection directionUsed = VibrationDirection.HORIZONTAL;

    [NonSerialized] public bool activated = true;

    // Use this for initialization
    void Start () {
        if (directionUsed == VibrationDirection.HORIZONTAL)
        {

        }

        else if (directionUsed == VibrationDirection.VERTICAL)
        {

        }

        else if (directionUsed == VibrationDirection.BOTH)
        {

        }
    }
	
	// Update is called once per frame
	void Update () {
		if(activated)
        {

        }
	}

    bool flipflop = true;
    void applyEffect()
    {
        if(directionUsed == VibrationDirection.HORIZONTAL)
        {

        }
    }
}
