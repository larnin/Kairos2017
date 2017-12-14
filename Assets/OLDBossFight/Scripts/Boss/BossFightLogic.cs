using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using DG.Tweening;
using System.Collections;

class BossFightLogic : MonoBehaviour
{
    [SerializeField] GameObject m_UI;
    [SerializeField] List<Stage> m_stages;
    [SerializeField] int m_playerLife = 5;
    [SerializeField] float m_answerTime = 5;
    int m_timerTime = 5;

    int m_stageIndex = 0;
    int m_roundIndex = 0;
    int m_bossLife = 0;

    List<CardData> m_currentStageCards;

    SubscriberList m_subscriberList = new SubscriberList();

    private void Awake()
    {
        m_subscriberList.Add(new Event<CardAndSentenseSelectedEvent>.Subscriber(onCardAndSequenceSelected));
        m_subscriberList.Add(new Event<TimerTimeoutEvent>.Subscriber(onTimerTimeout));
        m_subscriberList.Subscribe();

        foreach (var s in m_stages)
        {
            foreach (var r in s.rounds)
            {
                m_bossLife++;
                for(int i = 0; i < r.sentenses.Count; i++)
                    r.sentenses[i] = r.sentenses[i].Replace("\\n", "\n");
            }
        }
    }

    private void Start()
    {
        m_UI.SetActive(false);

        StartCoroutine(awakeCoroutine());
    }

    private IEnumerator awakeCoroutine()
    {
        yield return new WaitForSeconds(1);

        G2.sys.trailerManager.ApparitionDemon();

        yield return new WaitForSeconds(7);

        m_UI.SetActive(true);
        Event<UpdateBossUIEvent>.Broadcast(new UpdateBossUIEvent(m_playerLife, m_bossLife));

        if (m_stages.Count != 0)
        {
            yield return new WaitForSeconds(1);
            startCurrentRound();
        }
    }

    private void OnDestroy()
    {
        m_subscriberList.Unsubscribe();
    }

    void onCardAndSequenceSelected(CardAndSentenseSelectedEvent e)
    {
		if (e.cardName == m_stages[m_stageIndex].rounds[m_roundIndex].rightCardName && e.sentenseIndex == m_stages[m_stageIndex].rounds[m_roundIndex].rightSentenseindex)
		{
			Event<AnimateSentenceEvent>.Broadcast(new AnimateSentenceEvent(e.sentenseIndex, PowFeedbackLogic.FeedbackType.RIGHT));
			DOVirtual.DelayedCall(0.5f, () => { endRound(PowFeedbackLogic.FeedbackType.RIGHT); });
		}
		else
		{
			Event<AnimateSentenceEvent>.Broadcast(new AnimateSentenceEvent(e.sentenseIndex, PowFeedbackLogic.FeedbackType.WRONG));
			DOVirtual.DelayedCall(0.5f, () => { endRound(PowFeedbackLogic.FeedbackType.WRONG); });
		}
	}

    void onTimerTimeout(TimerTimeoutEvent e)
    {
        endRound(PowFeedbackLogic.FeedbackType.TIMEOUT);
    }

    void endRound(PowFeedbackLogic.FeedbackType type)
    {
        string text = "";
        if (type == PowFeedbackLogic.FeedbackType.RIGHT)
        {
            text = m_stages[m_stageIndex].rounds[m_roundIndex].rightSentenseAnswer;
            m_currentStageCards.RemoveAll(c => c.name == m_stages[m_stageIndex].rounds[m_roundIndex].rightCardName);
            m_roundIndex++;
            if (m_roundIndex >= m_stages[m_stageIndex].rounds.Count)
            {
                m_roundIndex = 0;
                m_stageIndex++;
            }
            m_bossLife--;
        }
        else
        {
            text = m_stages[m_stageIndex].rounds[m_roundIndex].wrongSentenseAnswer;
            G2.sys.trailerManager.MonstreFrappe();
            m_playerLife--;
        }
        
        Event<UpdateBossUIEvent>.Broadcast(new UpdateBossUIEvent(m_playerLife, m_bossLife, type, true, text));

        Event<HideSentensesAndCardsEvent>.Broadcast(new HideSentensesAndCardsEvent());
        DOVirtual.DelayedCall(m_answerTime, startCurrentRound);
    }

    void startCurrentRound()
    {
        if (m_stages.Count <= m_stageIndex)
        {
            Debug.Log("End !");
            //end
            return;
        }

        if (m_roundIndex == 0)
            m_currentStageCards = m_stages[m_stageIndex].cards.ToList();
       

        Event<UpdateBossUIEvent>.Broadcast(new UpdateBossUIEvent(m_playerLife, m_bossLife, m_timerTime));
        Event<FillCardsEvent>.Broadcast(new FillCardsEvent(m_currentStageCards));
        DOVirtual.DelayedCall(0.2f, ()=> { Event<ShowBossSentensesEvent>.Broadcast(new ShowBossSentensesEvent(m_stages[m_stageIndex].rounds[m_roundIndex].sentenses)); }); 
    }

    [Serializable]
    public class Round
    {
        public List<string> sentenses;
        public int rightSentenseindex;
        public string rightCardName;
        public string rightSentenseAnswer;
        public string wrongSentenseAnswer;

    }

    [Serializable]
    public class Stage
    {
        public List<CardData> cards;
        public List<Round> rounds;
    }
}
