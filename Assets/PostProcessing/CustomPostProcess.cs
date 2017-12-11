﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CustomPostProcess : MonoBehaviour {

	public float intensity;
	public Material myMaterial;
	private Material material; 

	// Creates a private material used to the effect
	void Awake()
	{
		material = myMaterial; 
	}
	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		if (intensity == 0)
		{
			Graphics.Blit (source, destination);
			return;
		}
		Graphics.Blit (source, destination, material);
	}
}