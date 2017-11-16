using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

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

    private Camera m_camera;

    private bool canMoveUp = false;

    private float m_decalSin = 0f;

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
        transform.DOMove(m_targetToRest.position + Random.insideUnitSphere*0.5f, 0.75f).OnComplete(() => {
            e.material.DOColor(Color.white, 0.25f);
            transform.DOScale(1f, 0.25f).OnComplete(() =>{
                m_textToChange.enabled = true;
                canMoveUp = true;
            });
        });
        GetComponent<Collider>().enabled = true;
    }
}
