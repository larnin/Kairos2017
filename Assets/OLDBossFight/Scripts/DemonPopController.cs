using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DemonPopController : MonoBehaviour {

	public TrailerManager trailerManager;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {

		if (Input.GetKeyUp ("e")) 
		{
			trailerManager.ApparitionDemon();
		}

		if (Input.GetKeyUp ("a")) 
		{
			trailerManager.MonstreFrappe();
		}
	}
}
