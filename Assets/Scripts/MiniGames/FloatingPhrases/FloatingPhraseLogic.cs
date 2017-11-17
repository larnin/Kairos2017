using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using System;

public class FloatingPhraseLogic : MonoBehaviour
{
    [SerializeField]
    private Text m_textToChange;

    [SerializeField]
    private Transform m_targetToRest;

    [SerializeField]
    private Vector3 m_BeginningScale = new Vector3(0.2f, 0.5f, 1.5f);

    [SerializeField]
    private Color m_BeginningColor = Color.black;

    public delegate void destroyedDelegate(FloatingPhraseLogic floatingPhrase);
    
    private Camera m_camera;

    private bool canMoveUp = false;

    private float m_decalSin = 0f;

    private byte m_index;
    public byte Index
    {
        get
        {
            return m_index;
        }

        set
        {
            m_index = value;
        }
    }

    private destroyedDelegate m_onDestroyCallback;
    public destroyedDelegate OnDestroyCallback
    {
        get
        {
            return m_onDestroyCallback;
        }

        set
        {
            m_onDestroyCallback = value;
        }
    }

    public void SetTargetToRest(Transform e)
    {
        m_targetToRest = e;
    }

    public void SetDecalSin(float decalSin)
    {
        m_decalSin = decalSin;
    }

    // Use this for initialization
    void Start ()
    {
        m_camera = Camera.main;
        GotToRest();
    }
	
	// Update is called once per frame
	void Update ()
    {
        transform.LookAt(m_camera.transform);
        
        if (m_textToChange.enabled)
        {
            if(transform.position.y > 5.4f)
            {
                m_textToChange.enabled = false;
                transform.DOScale(0.1f,1f).OnComplete(() => {
                    Destroy(gameObject);
                });

                GetComponentInChildren<Renderer>().material.DOColor(Color.black, 0.5f);
            }
        }

        if(canMoveUp)
        {
            Vector3 newForce = Vector3.up * 0.85f + transform.forward * Mathf.Sin(m_decalSin + transform.position.y * 1.5f) * 0.75f;
            newForce *= Time.deltaTime;
            transform.Translate(newForce);
        }
    }

    void OnDestroy()
    {
        m_onDestroyCallback(this);
    }

    void SettargetToRest(Transform e)
    {
        m_targetToRest = e;
    }

    void GotToRest()
    {
        Renderer e = GetComponentInChildren<Renderer>();
        e.material.color = m_BeginningColor;
        m_textToChange.enabled = false;
        transform.localScale = m_BeginningScale;
        transform.DOMove(m_targetToRest.position + UnityEngine.Random.insideUnitSphere*0.5f, 0.75f).OnComplete(() => {
            e.material.DOColor(Color.white, 0.25f);
            transform.DOScale(1f, 0.25f).OnComplete(() =>{
                m_textToChange.enabled = true;
                canMoveUp = true;
            });
        });
        GetComponent<Collider>().enabled = true;
    }
}
