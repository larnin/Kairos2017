using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookAtCameraLogic : MonoBehaviour {

    private Transform m_camera;

	// Use this for initialization
	void Start () {
        m_camera = Camera.main.transform;
    }
	
	// Update is called once per frame
	void Update () {
        transform.LookAt(m_camera.transform);
        transform.Rotate(Vector3.up, 180f);
    }
}
