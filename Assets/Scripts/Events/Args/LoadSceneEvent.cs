using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine.SceneManagement;

public class LoadSceneEvent : EventArgs
{
    public LoadSceneEvent(int _sceneIndex, Action _callback = null, LoadSceneMode _mode = LoadSceneMode.Single)
    {
        useIndex = true;
        sceneIndex = _sceneIndex;
        loadMode = _mode;
        callback = _callback;
    }

    public LoadSceneEvent(string _sceneName, Action _callback = null, LoadSceneMode _mode = LoadSceneMode.Single)
    {
        useIndex = false;
        sceneName = _sceneName;
        loadMode = _mode;
        callback = _callback;
    }

    public bool useIndex;
    public int sceneIndex;
    public string sceneName;
    public LoadSceneMode loadMode;
    public Action callback;
}