using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class MeshPainter : MonoBehaviour {

	public GameObject objectPrefab;
	//public Camera cam;

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {

		Debug.Log ("I am running");
		Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		Debug.Log (Input.mousePosition);
		Debug.DrawRay (ray.origin, ray.direction * 10, Color.yellow);
	}
}
