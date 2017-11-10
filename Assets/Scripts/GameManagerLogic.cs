using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManagerLogic : MonoBehaviour
{
    static GameManagerLogic instance = null;

    SubscriberList m_subscriberlist = new SubscriberList();

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
        m_subscriberlist.Subscribe();
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
}