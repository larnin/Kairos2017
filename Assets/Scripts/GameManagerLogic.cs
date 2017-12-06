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

        m_subscriberlist.Add(new Event<LoadSceneEvent>.Subscriber(onLoadScene));
        m_subscriberlist.Add(new Event<PauseEvent>.Subscriber(onPauseEnd));
        m_subscriberlist.Add(new Event<FindCardEvent>.Subscriber(onCardFind));
        m_subscriberlist.Subscribe();
        DOVirtual.DelayedCall(10, () => { Event<FindCardEvent>.Broadcast(new FindCardEvent("fdg")); });
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
        G.sys.saveSystem.set(e.name, (int)CardData.VisibilityState.VISIBLE);
        var card = Instantiate(m_cardPrefab);
        var comp = card.GetComponent<BigCardLogic>();

        string assetName = "InventoryBook/Cards";

        var text = Resources.Load<TextAsset>(assetName);
        if (text != null)
        {
            var items = JsonUtility.FromJson<CardsSerializer>(text.text);
            if (items != null)
            {
                foreach(var c in items.cards)
                    if(c.name == e.name)
                    {
                        comp.set((c.fancyName.Length == 0 ? c.name : c.fancyName), c.textureName, c.description);
                        break;
                    }
            }
        }
    }
}