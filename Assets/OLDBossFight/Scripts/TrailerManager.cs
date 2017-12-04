using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrailerManager : MonoBehaviour {

    public Animator monsterAnimator;
    public Animator jeanAnimator;
    public Animator terrainAnimator;
    public Animator eyesAnimator;
    public Animator monsterHandsAnimator;
    public Animator mainCharaAnimator;
    public Animator cameraFOVAnimator;
    public Animator cameraControllerAnimator;
    public Animator imageEffectAnimator;
    public Animator[] abstractAnimator;
    public Material monsterHandsMat;
    public Material apparitionSphereMat;
    public Material jeanMat1;
    public Material jeanMat2;
    public Material jeanMat3;
    public Material[] sceneMaterial;
    public Material skyMat;
    public Transform monsterBody;
    public Transform jeanTransform;
    //public Transform cameraController;
    public Transform sphereTransform;
    public SpriteRenderer imageEffect;
    //public Transform transformImageEffect;
    public Animator cameraAnimator;
    //public Camera mainCamera;

    public float handsApparitionSpeed;
    public float handsApparitionTiming;
    public float monsterPopTiming;
    public float monsterGrowthSpeed;
	public float turnAbstractTiming;
    public float animCamTiming;
    public float animCamSpeed;
    public float jeanMoveSpeed;
    public float timeStopTiming;
    public ParticleSystem jeanFallingPS;
    public ParticleSystem monsterPopPS;
    public ParticleSystem monsterLightings;
    public ParticleSystem timeStop;
    public ParticleSystem jeanFlyingPS;

    private bool handsVisible = false;
    private bool monsterPoped = false;
    private bool sphereFull = false;
    private bool alreadyStanding = false;
    private bool growing = false;
    private bool timeStopped = false;
    private bool animationRunning = false;
    private bool animation2Running = false;
    private float monsterStandTiming = 0;
    private float timer = 0;
    private float timer2 = 0;
    private float timerAbstract = 0;
    private int abstractPopNumber = 0;

    private void Awake()
    {
        G2.sys.trailerManager = this;
    }

    // Use this for initialization
    void Start () {
        monsterHandsMat.SetFloat("_Apparition", 0);
        apparitionSphereMat.SetFloat("_Opacity", 0);
        monsterAnimator.SetBool("Standing", false);
        cameraAnimator.SetBool("Screenshake", false);
        jeanAnimator.SetBool("Falling", false);
        eyesAnimator.SetBool("OpenEyes", false);
        monsterHandsAnimator.SetBool("Frappe", false);
        mainCharaAnimator.SetBool("Spell", false);
        monsterBody.localScale = new Vector3(0,0,0);
        jeanTransform.localPosition = new Vector3(-7.76f, -0.05f, 5.87f);
        //imageEffect.color = new Color(1, 1, 1, 0);
        jeanMat1.SetFloat("_EmissiveStrength", 0);
        jeanMat2.SetFloat("_EmissiveStrength", 0);
        jeanMat3.SetFloat("_EmissiveStrength", 0);
        skyMat.SetFloat("_Alpha", 0);
        
        for(int i = 0; i < sceneMaterial.Length; i++)
        {
            sceneMaterial[i].SetFloat("_AbstractEffect", 0);
        }

    }
	
	// Update is called once per frame
	void Update () {

		//Debug.Log (timer);

        if(animationRunning)
        {
            timer += Time.deltaTime;
            //Debug.Log(timer);
        }

        if(animation2Running)
        {
            timer2 += Time.deltaTime;
        }

        /*if(Input.GetKeyUp("e"))
        {
            animationRunning = true;
            jeanAnimator.SetBool("Falling", true);
            jeanFallingPS.Play();
            StartCoroutine(MonsterPop());
        }*/

        if(timer > monsterPopTiming -0.5f && monsterPoped == false)
        {
            monsterPopPS.Play();
            StartCoroutine(ApparitionSphere());
            monsterPoped = true;
        }

        if(timer > animCamTiming && growing == false)
        {
            cameraAnimator.SetBool("Screenshake", true);
            //StartCoroutine(CameraAnimation());
            cameraFOVAnimator.SetBool("FOVChange", true);
            //imageEffectAnimator.SetBool("FOVChange", true);
            cameraControllerAnimator.SetBool("CameraMouv", true);
            growing = true;
            if(monsterLightings.isPlaying == false)
            {
                jeanFallingPS.Stop();
                monsterLightings.Play();
            }

        }

        if(monsterBody.localScale.x >=0.07f)
        {
            if(alreadyStanding == false)
            {
                monsterStandTiming = timer;
                monsterAnimator.SetBool("Standing", true);
                StartCoroutine(Standing());
                jeanAnimator.SetBool("Flying", true);
                jeanFlyingPS.Play();
				cameraAnimator.SetBool("Screenshake", false);
                alreadyStanding = true;
            }
        }

        if(timer >= handsApparitionTiming && handsVisible == false)
        {
            handsVisible = true;
            StartCoroutine(ApparitionHands());
        }

        if (monsterHandsMat.GetFloat("_Apparition") >= 0.5f)
        {
            eyesAnimator.SetBool("OpenEyes", true);
        }

        if(monsterHandsMat.GetFloat("_Apparition") >= 1f)
        {
            Debug.Log("le monstre est apparu");
        }

        /*if(Input.GetKeyUp("r"))
        {
            monsterHandsAnimator.SetBool("Frappe", true);
            animation2Running = true;
        }*/


        if (timer2 >= 0.1f)
        {
			monsterHandsAnimator.SetBool("Frappe", false);
			timer2 = 0;
			animation2Running = false;
        }

        if(timer2 >=timeStopTiming && timeStopped == false)
        {
            /*Debug.Log("je fais la particule a: " + timer2);
            monsterLightings.Stop();
            timeStop.Play();*/
            cameraAnimator.SetBool("Screenshake", false);
            //timeStopped = true;
        }

		if(timer > turnAbstractTiming)
        {
            timerAbstract = 0;
            StartCoroutine(PopAbstract());
            StartCoroutine(WorldChangeAbstract());
        }
	}

	public void ApparitionDemon()
	{
		animationRunning = true;
		jeanAnimator.SetBool("Falling", true);
		jeanFallingPS.Play();
		StartCoroutine(MonsterPop());
	}

	public void MonstreFrappe()
	{
		monsterHandsAnimator.SetBool("Frappe", true);
		animation2Running = true;
	}

    IEnumerator ApparitionHands()
    {
        while((timer - handsApparitionTiming)*handsApparitionSpeed <= 1) 
        {
            monsterHandsMat.SetFloat("_Apparition", Mathf.Lerp(0.3f, 1, (timer - handsApparitionTiming) * handsApparitionSpeed));
            yield return null;
        }
    }

    IEnumerator Standing()
    {
        while((timer - monsterStandTiming) * jeanMoveSpeed < 1)
        {
            jeanMat1.SetFloat("_EmissiveStrength", Mathf.Lerp(0, 1,(timer - monsterStandTiming) * jeanMoveSpeed));
            jeanMat2.SetFloat("_EmissiveStrength", Mathf.Lerp(0, 1,(timer - monsterStandTiming) * jeanMoveSpeed));
            jeanMat3.SetFloat("_EmissiveStrength", Mathf.Lerp(0, 1,(timer - monsterStandTiming) * jeanMoveSpeed));
            jeanTransform.localPosition = new Vector3(Mathf.Lerp(-7.76f, -7.123f, (timer - monsterStandTiming) * jeanMoveSpeed), Mathf.Lerp(-0.05f, 0.118f, (timer - monsterStandTiming) * jeanMoveSpeed), Mathf.Lerp(5.87f, 9.85f, (timer - monsterStandTiming) * jeanMoveSpeed));
            yield return null;
        }
    }

    IEnumerator MonsterPop()
    {
        while((timer - monsterPopTiming) * monsterGrowthSpeed <= 1)
        {
            monsterBody.localScale = new Vector3(Mathf.Lerp(0, 0.09f, (timer-monsterPopTiming)*monsterGrowthSpeed), Mathf.Lerp(0, 0.23f, (timer - monsterPopTiming) * monsterGrowthSpeed), Mathf.Lerp(0, 0.1f, (timer - monsterPopTiming) * monsterGrowthSpeed));
            //imageEffect.color = Color.Lerp(new Color(1,1,1,0),new Color(1,1,1,1), ((timer - monsterPopTiming) * 2));
            
            yield return null;
        }
    }

    IEnumerator ApparitionSphere()
    {
        while ((timer - monsterPopTiming) * monsterGrowthSpeed <= 1)
        {
            apparitionSphereMat.SetFloat("_Opacity", Mathf.Lerp(0.7f, 0.4f, ((timer - monsterPopTiming) * monsterGrowthSpeed * 2)-1));
            if((timer - monsterPopTiming) * monsterGrowthSpeed >= 0.4f)
            {
                sphereTransform.localScale = new Vector3(Mathf.Lerp(40, 200, ((timer - monsterPopTiming) * monsterGrowthSpeed -0.4f)*2f), Mathf.Lerp(40, 200, ((timer - monsterPopTiming) * monsterGrowthSpeed - 0.4f) * 2f), Mathf.Lerp(40, 200, ((timer - monsterPopTiming) * monsterGrowthSpeed - 0.4f)*2f));
            }
            yield return null;
        }
    }

    IEnumerator CameraAnimation()
    {
        while((timer - animCamTiming) * animCamSpeed <= 1)
        {
            //cameraController.localPosition = new Vector3(Mathf.Lerp(0.15f, -0.18f, (timer - animCamTiming) * animCamSpeed), Mathf.Lerp(0.56f, 0.71f, (timer - animCamTiming) * animCamSpeed), Mathf.Lerp(-3.85f, -2.29f, (timer - animCamTiming) * animCamSpeed));
            //cameraController.eulerAngles = new Vector3(Mathf.Lerp(0, 9.42f, (timer - animCamTiming) * animCamSpeed), 0, 0);
            //mainCamera.fieldOfView = Mathf.Lerp(70, 100, (timer - animCamTiming) * animCamSpeed);
            //transformImageEffect.localPosition = new Vector3(0, 0, Mathf.Lerp(0.7f,0.44f, (timer - animCamTiming) * animCamSpeed));
            yield return null;
        }
    }

    IEnumerator PopAbstract()
    {
        while (abstractAnimator.Length > abstractPopNumber)
        {
            abstractAnimator[abstractPopNumber].SetBool("Pop", true);
            abstractPopNumber += 1;
            yield return new WaitForSeconds(0.1f);
        }
    }

    IEnumerator WorldChangeAbstract()
    {
        while(timerAbstract*2 <= 1)
        {
			timerAbstract += Time.deltaTime;
            foreach(var m in sceneMaterial)
                m.SetFloat("_AbstractEffect", Mathf.Lerp(0, 1, (timer - timerAbstract) * 4));
            //sceneMaterial[0].SetFloat("_AbstractEffect", Mathf.Lerp(0,1, (timer - timerAbstract) * 4));
            //sceneMaterial[1].SetFloat("_AbstractEffect", Mathf.Lerp(0, 1, (timer - timerAbstract) * 4));
            //sceneMaterial[2].SetFloat("_AbstractEffect", Mathf.Lerp(0, 1, (timer - timerAbstract) * 4));
            skyMat.SetFloat("_Alpha", Mathf.Lerp(0, 1, (timer - timerAbstract) * 4));
            yield return null;
        }
    }
}
