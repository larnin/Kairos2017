using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FindThemeManager : MonoBehaviour {

    public Color hoverColor;

    [SerializeField]
    private Transform Answers;
    [SerializeField]
    private GameObject notCorrectFeedback;



    public void Awake()
    {
        foreach (Transform e in Answers)
        {
            if(e.GetComponent<ButtonAnswer>())
            e.GetComponent<ButtonAnswer>().SetFindThemeManager(this);
        }
    }

    public void correct()
    {
        Answers.gameObject.SetActive(false);
    }

    public void notCorrect()
    {
        StartCoroutine(notCorrectFindbackCoroutine());
    }

    IEnumerator notCorrectFindbackCoroutine()
    {
        notCorrectFeedback.SetActive(true);
        yield return new WaitForSeconds(0.5f);
        notCorrectFeedback.SetActive(false);
    }
}
