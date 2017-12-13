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
            // ib recupere la timeLine utilisé
            TimelineAsset PA = director.playableAsset as TimelineAsset;
            
                       //  le sourceObjet est une sorte d'identifiant (key) 
            var track = (PA.outputs.ElementAt(0).sourceObject);  // ceci correspond en fait a la premiere track

            print (director.GetGenericBinding(track) ); // ici on recupere l'objet associété a cette track

            Current = (Current + 1) % 3;
            ((GameObject)director.GetGenericBinding(track)).transform.Translate(Vector3.up * 1000f);

            director.SetGenericBinding(track, m_Gobject[Current]); // on rebind la track a un nouvelle objet. 
        }
	}
}
