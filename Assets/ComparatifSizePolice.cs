using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ComparatifSizePolice : MonoBehaviour {

    public UnityEngine.UI.Text TUI;
    public TextMeshPro TMPText;

    float baseValueUI;
    float baseValueTextMesh;

	// Use this for initialization
	void Start () {
        baseValueUI = TUI.fontSize;
        baseValueTextMesh = TMPText.fontSize;

    }

    float time = 0;
    float newTime = 5f;
	// Update is called once per frame
	void Update () {
		if(Input.GetKey(KeyCode.A))
        {
            time += Time.deltaTime;
            TUI.fontSize = (int)Mathf.Lerp(baseValueUI, 0f, time / newTime);
            TMPText.fontSize = Mathf.Lerp(baseValueTextMesh, 0f, time / newTime);
        }
    }
}
