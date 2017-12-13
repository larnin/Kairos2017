using UnityEngine;
using System.Collections;

public class GetCardTriggerLogic : TriggerBaseLogic
{
    [SerializeField] string m_cardName;

    public override void onEnter(TriggerInteractionLogic entity)
    {
        if (SaveAttributes.getCardState(m_cardName) != CardData.VisibilityState.VISIBLE)
            Event<FindCardEvent>.Broadcast(new FindCardEvent(m_cardName));
    }

    public override void onExit(TriggerInteractionLogic entity)
    {

    }
}
