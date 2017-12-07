using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraDepth : MonoBehaviour {

	Camera AttachedCamera;
	public RenderTexture depthMap;

	void Start () 
	{
		AttachedCamera = GetComponent<Camera>();
		AttachedCamera.depthTextureMode = DepthTextureMode.DepthNormals;
		depthMap.format = RenderTextureFormat.Depth;
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		
	}
}
