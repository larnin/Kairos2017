using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.SceneManagement;
using DG.Tweening;

public class GameManagerLogic : MonoBehaviour
{
    static GameManagerLogic instance = null;

    string inventoryButton = "Inventory";

    [SerializeField] GameObject m_inventory;
    [SerializeField] GameObject m_cardPrefab;

    SubscriberList m_subscriberlist = new SubscriberList();
    bool m_paused = false;

    private void Awake()
    {
        if(instance != null)
        {
            Destroy(gameObject);
            return;
        }
        instance = this;
        DontDestroyOnLoad(gameObject);
        G.sys.gameManager = this;

        m_subscriberlist.Add(new Event<LoadSceneEvent>.Subscriber(onLoadScene));
        m_subscriberlist.Add(new Event<PauseEvent>.Subscriber(onPauseEnd));
        m_subscriberlist.Add(new Event<FindCardEvent>.Subscriber(onCardFind));
        m_subscriberlist.Add(new Event<EndLoopEvent>.Subscriber(onEndLoop));
        m_subscriberlist.Subscribe();
    }

    private void Update()
    {
        if (Input.GetButtonDown(inventoryButton) && !m_paused)
            openInventory();
    }

    private void OnDestroy()
    {
        m_subscriberlist.Unsubscribe();
    }

    void onLoadScene(LoadSceneEvent e)
    {
        AsyncOperation operation;
        if (e.useIndex)
            operation = SceneManager.LoadSceneAsync(e.sceneIndex, e.loadMode);
        else operation = SceneManager.LoadSceneAsync(e.sceneName, e.loadMode);

        if(operation != null)
            StartCoroutine(waitSceneLoadingCoroutine(operation, e.callback));
    }

    IEnumerator waitSceneLoadingCoroutine(AsyncOperation operation, Action callback)
    {
        while (!operation.isDone)
            yield return new WaitForEndOfFrame();

#if UNITY_EDITOR //rebuild the lights in the editor
        if (UnityEditor.Lightmapping.giWorkflowMode == UnityEditor.Lightmapping.GIWorkflowMode.Iterative)
        {
            DynamicGI.UpdateEnvironment();
        }
#endif

        if (callback != null)
            callback();
    }

    void openInventory()
    {
        Event<PauseEvent>.Broadcast(new PauseEvent(true));
        m_paused = true;

        Event<FadeEvent>.Broadcast(new FadeEvent(new Color(0, 0, 0, 0.5f), 1));

        Instantiate(m_inventory);
    }

    void onPauseEnd(PauseEvent e)
    {
        if (e.paused)
            return;
        m_paused = false;

        Event<FadeEvent>.Broadcast(new FadeEvent(new Color(0, 0, 0, 0), 1));
    }

    void onCardFind(FindCardEvent e)
    {
        SaveAttributes.setCardState(e.name, CardData.VisibilityState.VISIBLE);
        var card = Instantiate(m_cardPrefab);
        var comp = card.GetComponent<BigCardLogic>();

        var cardItem = G.sys.ressourcesData.getCard(e.name);
        if (cardItem != null)
            comp.set(cardItem.fancyName.Length > 0 ? cardItem.fancyName : cardItem.name, cardItem.textureName, cardItem.description);
    }

    void onEndLoop(EndLoopEvent e)
    {
        G.sys.loopSystem.startNextLoop(); 
    }
}