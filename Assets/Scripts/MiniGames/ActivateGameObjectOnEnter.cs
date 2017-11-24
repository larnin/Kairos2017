using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateGameObjectOnEnter : TriggerBaseLogic {

    [SerializeField]
    private FloatingPhraseGeneratorLogic ToActivate = null;

    public override void onEnter(TriggerInteractionLogic entity)
    {
        ToActivate.appearing();
    }

    public override void onExit(TriggerInteractionLogic entity)
    {
        ToActivate.disappearing();
    }
}
