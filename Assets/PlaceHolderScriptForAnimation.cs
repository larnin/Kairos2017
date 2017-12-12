using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;


public class PlaceHolderScriptForAnimation : MonoBehaviour
{
    public GameObject[] m_Gobject;

    int Current = 0;
    PlayableDirector director;

    // Use this for initialization
    void Start ()
    {
        director = GetComponent<PlayableDirector>();
    }
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            TimelineAsset PA = director.playableAsset as TimelineAsset;
            // AnimationTrack AT = PA.GetOutputTrack(0) as AnimationTrack;
            var sourceObject = (PA.outputs.ElementAt(0).sourceObject);
            print (director.GetGenericBinding(sourceObject) );

            Current = (Current + 1) % 3;
            ((GameObject)director.GetGenericBinding(sourceObject)).transform.Translate(Vector3.up * 1000f);
            director.SetGenericBinding(sourceObject, m_Gobject[Current]);
        }
	}
}
