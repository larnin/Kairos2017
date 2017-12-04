using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class BrainTeaserManager : MonoBehaviour
{
    
    [SerializeField]
    private float m_rotationSpeed = 125.0f;

    [SerializeField]
    private Transform InteractiblesPieces;

    private const string m_horizontalInputName = "CameraHorizontal";
    private const string m_VerticalInputName = "CameraVertical";

    private int m_numberOfPieceIn = 0;

    // Use this for initialization
    void Start () {
        foreach (Transform e in InteractiblesPieces)
        {
            e.GetComponent<PieceOfBrainTeaser>().setBrainTeaserManager(this);
        }
	}
	
	// Update is called once per frame
	void Update ()
    {
        // rotate Object
        float horizontalInputValue = Input.GetAxis(m_horizontalInputName);
       // float verticalInputValue = Input.GetAxis(m_VerticalInputName);
       // transform.GetChild(0).Rotate(transform.right, verticalInputValue * m_rotationSpeed * Time.deltaTime, Space.World);
        transform.GetChild(0).Rotate(-transform.up, horizontalInputValue * m_rotationSpeed * Time.deltaTime, Space.World);
    }

    public void UpdateNumberOfPieceIn(bool isIn)
    {
        m_numberOfPieceIn += isIn ? +1 : -1;
        if (m_numberOfPieceIn == 4)
        {
            foreach (Transform e in InteractiblesPieces)
            {
                Destroy(e.GetComponent<PieceOfBrainTeaser>().LockedFeedBack);
                e.GetComponent<PieceOfBrainTeaser>().enabled = false;
                e.GetComponent<PieceOfBrainTeaser>().hoverExit();
            }

            InteractiblesPieces.DOMove(InteractiblesPieces.position + Vector3.up * .075f, 0.5f);
        }
    }
}
