using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PieceOfBrainTeaser : Interactable
{
    [SerializeField]
    private PieceOfBrainTeaser m_lock = null;

    [SerializeField]
    private PieceOfBrainTeaser m_unlock = null;

    [SerializeField]
    private PieceOfBrainTeaser m_swipe = null;
    
    [SerializeField]
    private GameObject m_feedbackHover = null;

    [SerializeField]
    private GameObject m_LockedFeedBack = null;
    public GameObject LockedFeedBack
    {
        get
        {
            return m_LockedFeedBack;
        }
    }

    private BrainTeaserManager m_brainTeaserManager;
    public void setBrainTeaserManager(BrainTeaserManager brainTeaserManager)
    {
        m_brainTeaserManager = brainTeaserManager;
    }


    private Animator m_animator;
    const string FitIntoOutoStateName = "FitIntoOuto";
    const string LockedFeedbackName = "LockedFeedback"; 

    private bool m_isLocked = false;
    public bool isLocked
    {
        get
        {
            return m_isLocked;
        }
    }

    private bool m_isIn = false;
    public bool isIn
    {
        get
        {
            return m_isIn;
        }
        set
        {
            m_isIn = value;
        }
    }

    void Start()
    {
        m_animator = GetComponent<Animator>();
        m_animator.Play(FitIntoOutoStateName);
        m_animator.enabled = false;
    }

    public override void hoverEnter()
    {
        if (! m_isLocked)
        {
            m_feedbackHover.SetActive(true);
        }
    }

    public override void hoverExit()
    {
        m_feedbackHover.SetActive(false);
    }

    public override void select()
    {
        if (!m_isLocked)
        {
            if (m_animator.GetCurrentAnimatorStateInfo(0).IsTag(LockedFeedbackName))
            {
                m_animator.Play(FitIntoOutoStateName);
            }
            else
            {
                if (m_animator.enabled)
                {
                    m_animator.SetTrigger("ChangeWay");
                }
                else
                {
                    m_animator.enabled = true;
                }
            }
        }
    }

    public void setLock(bool value)
    {
        if (m_isIn || (m_isLocked == false && value == false) )
        {
            return;
        }

        if (value)
        {
            if (!m_animator.GetCurrentAnimatorStateInfo(0).IsName(LockedFeedbackName))
            {
                m_animator.Play(LockedFeedbackName);
            }
            m_animator.enabled = true;
            m_isLocked = true; 
        }
        else
        {
            if (m_isLocked)
            {
                m_animator.enabled = true;
                m_animator.SetTrigger("ChangeWay");
                m_isLocked = false;
            }
            
        }
    }

    public void PieceIsIn()
    {
        if (m_animator.GetCurrentAnimatorStateInfo(0).IsName(FitIntoOutoStateName))
        {
            m_isIn = true;
            m_brainTeaserManager.UpdateNumberOfPieceIn(m_isIn);
            if (m_lock)
            {
                m_lock.setLock(true);
            }

            if (m_unlock)
            {
                m_unlock.setLock(false);
            }

            if (m_swipe)
            {
                if (m_isLocked)
                {
                    m_swipe.setLock(false);
                }
                else
                {
                    m_swipe.setLock(true);
                }
            }
        }
    }
    
    public void PieceIsOut()
    {
        if (!m_animator.GetCurrentAnimatorStateInfo(0).IsName(FitIntoOutoStateName))
        {
            m_isIn = false;
            m_brainTeaserManager.UpdateNumberOfPieceIn(m_isIn);
            if (m_lock)
            {
                m_lock.setLock(false);
            }

            if (m_unlock)
            {
                m_unlock.setLock(true);
            }

            if (m_swipe)
            {
                if (m_swipe.isLocked)
                {
                    m_swipe.setLock(false);
                }
                else
                {
                    m_swipe.setLock(true);
                }
            }
        }
    }
}
