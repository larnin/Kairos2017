using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class ShadowTriggerSelectionLogic : TriggerBaseLogic
{
    [Serializable]
    public class ShadowParameters
    {
        public ShadowParameters(Color _baseColor = new Color(), float _alpha = 1)
        { baseColor = _baseColor; alpha = _alpha; }
        public Color baseColor;
        public float alpha;
    }

    ShadowParameters m_baseParam = new ShadowParameters();

    [SerializeField]
    ShadowParameters m_hoverParam = new ShadowParameters(Color.grey);
    [SerializeField]
    ShadowParameters m_selectedParam = new ShadowParameters(Color.white, 0.75f);
    [SerializeField]
    ShadowParameters m_matchedParam = new ShadowParameters(Color.white, 0.9f);
    [SerializeField]
    ShadowParameters m_unMatchedParam = new ShadowParameters(Color.red, 0.9f);


    [SerializeField] private float m_normalTransitionTime = 0.4f;
    [SerializeField] private int m_numberOfBlink = 3;
    [SerializeField] private float m_timeToTransitionBetweenColorWrongFeedback = 0.5f;
    [SerializeField] private float m_timeToStayInColor = 0.1f;
    
    private RumorsOfShadowsManager m_rumorsOfShadowsManager;
    private bool m_playerIsInside = false;
    public bool playerIsInside { get { return m_playerIsInside; } }
    
    [NonSerialized] public bool m_selected = false;
    [NonSerialized] public bool m_matched = false;

   // private Material m_baseMaterial;
   // private Material m_fxMaterial;

    private bool unMatchedFeedbackOn = false;

    public override void onEnter(TriggerInteractionLogic entity)
    {
       if(entity.tag == "Player")
       {
            m_playerIsInside = true;

            if (!m_matched && !m_selected)
            {
                StopAllCoroutines();
                unMatchedFeedbackOn = false;
                m_rumorsOfShadowsManager.hoverShadow(transform, true);
                applyEffect(m_hoverParam, m_normalTransitionTime);
            }
        }
    }

    public override void onExit(TriggerInteractionLogic entity)
    {
        if (entity.tag == "Player")
        {
            m_playerIsInside = false;
            if (!m_matched && !m_selected)
            {
                StopAllCoroutines();
                unMatchedFeedbackOn = false;
                m_rumorsOfShadowsManager.hoverShadow(transform, false);
                applyEffect(m_baseParam, m_normalTransitionTime);
            }
        }
    }

    void Start()
    {
        m_rumorsOfShadowsManager = transform.GetComponentInParent<RumorsOfShadowsManager>();
      //  m_baseMaterial = transform.Find("Base").GetComponent<Renderer>().material;
      //  m_fxMaterial = transform.Find("Fx").GetComponent<Renderer>().material;

        m_baseParam.baseColor = Color.black;
        m_baseParam.alpha = 1f;
    }

    bool m_onetime = false;
    void Update()
    {
        if (m_playerIsInside && Input.GetButtonDown("Interact") && !m_matched)
        {
            if(unMatchedFeedbackOn)
            {
                StopAllCoroutines();
                unMatchedFeedbackOn = false;
                m_selected = m_rumorsOfShadowsManager.selectShadow(transform);
                updateFeedback();
            }
            else
            {
                m_selected = m_rumorsOfShadowsManager.selectShadow(transform);
                if(!unMatchedFeedbackOn)
                {
                    updateFeedback();
                }
            }

            IndiceGeneratorLogic indiceGeneratorLogic = transform.parent.parent.GetComponentInChildren<IndiceGeneratorLogic>();

            if (indiceGeneratorLogic)
            {
                indiceGeneratorLogic.tryToGetCard();
            }

        }
    }

    public void updateFeedback()
    {
        if (m_matched)
        {
            applyEffect(m_matchedParam, m_normalTransitionTime);
        }

        else if (m_selected)
        {
            applyEffect(m_selectedParam, m_normalTransitionTime);
        }

        else if(m_playerIsInside)
        {
            applyEffect(m_hoverParam, m_normalTransitionTime);
        }
        else
        {
            applyEffect(m_baseParam, m_normalTransitionTime);
        }
    }

    void applyEffect(ShadowParameters shadowParameters, float applyTime)
    {

        foreach(Renderer e in GetComponentsInChildren<Renderer>())
        {
            e.material.DOColor(shadowParameters.baseColor, applyTime);
        }
       // m_baseMaterial.DOColor(shadowParameters.baseColor, applyTime);
       // m_fxMaterial.DOColor(shadowParameters.baseColor, applyTime);

        applyFade(shadowParameters.alpha, applyTime);
    }

    void applyFade(float value, float applyTime)
    {
        foreach (Renderer e in GetComponentsInChildren<Renderer>())
        {
            e.material.DOFloat(value, "_Alpha", applyTime);
        }

        //m_baseMaterial.DOFloat(value, "_Alpha", applyTime);
        //m_fxMaterial.DOFloat(value, "_Alpha", applyTime);
    }

    public IEnumerator shadowNotMatchedFeedback()
    {
        unMatchedFeedbackOn = true;
        for(int i = 0; i < m_numberOfBlink; i++)
        {
            applyEffect(m_unMatchedParam, m_timeToTransitionBetweenColorWrongFeedback);
            yield return new WaitForSeconds(m_timeToTransitionBetweenColorWrongFeedback + m_timeToStayInColor);
            applyEffect(m_baseParam, m_timeToTransitionBetweenColorWrongFeedback);
            yield return new WaitForSeconds(m_timeToTransitionBetweenColorWrongFeedback + m_timeToStayInColor);
        }
        updateFeedback();
        unMatchedFeedbackOn = false;
    }
}

