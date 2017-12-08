using UnityEngine;
using System.Collections;

public class AllCardsFeedback : MonoBehaviour
{
    [SerializeField] Texture m_texture;

    SubscriberList m_subscriberList = new SubscriberList();

    private void Awake()
    {
        m_subscriberList.Add(new Event<FindCardEvent>.Subscriber(onfindCard));
        m_subscriberList.Subscribe();
        StartCoroutine(waitAFrameBeforeCheckCards());
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    void onfindCard(FindCardEvent e)
    {
        StartCoroutine(waitAFrameBeforeCheckCards());
    }

    IEnumerator waitAFrameBeforeCheckCards()
    {
        yield return null;
        if(G.sys.loopSystem.essentialCardsFoundCount() >= G.sys.loopSystem.essentialCardsCount())
            GetComponent<MeshRenderer>().material.mainTexture = m_texture;
    }
}
