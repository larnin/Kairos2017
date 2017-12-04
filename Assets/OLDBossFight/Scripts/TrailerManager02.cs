using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrailerManager02 : MonoBehaviour {

    public Animator persoAnimator;
    public Animator persoMouvAnimator;
    public Renderer[] persoRenderer;
    public float apparitionTiming;
    public float walkTiming;
    public ParticleSystem apparitionPS;

    private float timer = 0;
    private bool animationRunning = false;

	// Use this for initialization
	void Start () {

        for (int i = 0; i < persoRenderer.Length; i++)
        {
            persoRenderer[i].enabled = false;
        }
        persoAnimator.SetBool("Idle2", true);
	}
	
	// Update is called once per frame
	void Update () {

        if(animationRunning)
        {
            timer += Time.deltaTime;
        }

        if(Input.GetKeyUp("a"))
        {
            animationRunning = true;
            apparitionPS.Play();
        }

        if(timer >= apparitionTiming)
        {
            for(int i = 0; i < persoRenderer.Length; i++)
            {
                persoRenderer[i].enabled = true;
            }
        }

        if(timer >= walkTiming)
        {
            persoAnimator.SetBool("Walking", true);
            persoMouvAnimator.SetBool("Walking", true);
        }
	}
}
