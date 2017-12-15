using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetAnimationStateForAnimator : MonoBehaviour {

    [SerializeField] private int m_number = 0;


    // Use this for initialization
    void Start ()
    {
        GetComponent<Animator>().SetInteger("AnimNumber", m_number);
    }


}
