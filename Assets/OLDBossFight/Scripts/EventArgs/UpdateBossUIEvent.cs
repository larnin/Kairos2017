using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class UpdateBossUIEvent : EventArgs
{
    public UpdateBossUIEvent(int _playerLife, int _bossLife, bool _stopTimer = false)
    {
        playerLife = _playerLife;
        bossLife = _bossLife;
        startTimer = false;
        showFeedback = false;
        stopTimer = _stopTimer;
    }

    public UpdateBossUIEvent(int _playerLife, int _bossLife, float _timer)
    {
        playerLife = _playerLife;
        bossLife = _bossLife;
        startTimer = true;
        timerTime = _timer;
        showFeedback = false;
        stopTimer = false;
    }

    public UpdateBossUIEvent(int _playerLife, int _bossLife, PowFeedbackLogic.FeedbackType _type, bool _stopTimer = false)
    {
        playerLife = _playerLife;
        bossLife = _bossLife;
        startTimer = false;
        showFeedback = true;
        feedbackType = _type;
        stopTimer = _stopTimer;
    }

    public UpdateBossUIEvent(int _playerLife, int _bossLife, float _timer, PowFeedbackLogic.FeedbackType _type)
    {
        playerLife = _playerLife;
        bossLife = _bossLife;
        startTimer = true;
        timerTime = _timer;
        showFeedback = true;
        feedbackType = _type;
        stopTimer = false;
    }

    public int playerLife;
    public int bossLife;
    public bool startTimer;
    public float timerTime;
    public bool stopTimer;
    public bool showFeedback;
    public PowFeedbackLogic.FeedbackType feedbackType;
}
