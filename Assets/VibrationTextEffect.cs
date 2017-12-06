using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using DG.Tweening;

public class VibrationTextEffect : MonoBehaviour {

    public enum VibrationDirection {HORIZONTAL, VERTICAL, BOTH }
    public enum SpaceUsed {CAMERA, OWN}
    
    [SerializeField] private float m_speed = 1f;
    [SerializeField] private float m_amplitude = 1f;
    [SerializeField] private float m_randomnessAmplitude = 0.1f;
    [SerializeField] private VibrationDirection m_directionUsed = VibrationDirection.HORIZONTAL;
    [SerializeField] private SpaceUsed m_spaceUsed = SpaceUsed.OWN;
    
    [NonSerialized] public bool activated = true;

    float m_flipflopHorizontal = -1f;
    float m_flipflopVertical = -1f;

    private Vector3 targetPosition; //in localPosition !
    private Transform m_camera;

    // Use this for initialization
    void Start ()
    {
        m_camera = Camera.main.transform;
        play();
    }
	
    public void play()
    {

        targetPosition = findNewTargetPosition();
        
        activated = true;
    }

    private Vector3 findNewTargetPosition()
    {
        float randomAmplitude = UnityEngine.Random.Range(-m_randomnessAmplitude, m_randomnessAmplitude);
        Vector3 newPos;

        if (m_directionUsed == VibrationDirection.HORIZONTAL)
        {
            m_flipflopHorizontal *= -1f;
            newPos = Vector3.right * (m_amplitude + randomAmplitude) * m_flipflopHorizontal;
        }

        else if (m_directionUsed == VibrationDirection.VERTICAL)
        {
            m_flipflopVertical*= -1f;
            newPos = Vector3.up * (m_amplitude + randomAmplitude) * m_flipflopVertical;
        }

        else if (m_directionUsed == VibrationDirection.BOTH)
        {
            Vector3 P = UnityEngine.Random.insideUnitCircle;

            newPos = ( P )* (m_amplitude + randomAmplitude);
        }
        else
        {
            return Vector3.zero; 
        }
        
        if (m_spaceUsed == SpaceUsed.CAMERA)
        {
            Vector3 directionInWorldCoordinate = m_camera.TransformDirection(newPos);
            newPos = transform.InverseTransformDirection(directionInWorldCoordinate);
        }
        return newPos;
    }

    private void stop()
    {
        targetPosition = Vector3.zero;
    }
    
    void Update()
    {
        if(activated)
        {
            Vector3 currentStep = Vector3.MoveTowards(transform.localPosition, targetPosition, Time.deltaTime * m_speed);
            transform.localPosition = currentStep;

            if(transform.localPosition == targetPosition)
            {
                if (targetPosition != Vector3.zero)
                {
                    targetPosition = findNewTargetPosition();
                }
                else
                {
                    activated = false;
                }
                
            }
        }
    }
}
