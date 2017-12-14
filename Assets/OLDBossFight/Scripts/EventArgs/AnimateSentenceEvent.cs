using UnityEngine;
using UnityEditor;
using System;

public class AnimateSentenceEvent : EventArgs
{
	public AnimateSentenceEvent(int _sentenseIndex, PowFeedbackLogic.FeedbackType _type)
	{
		sentenseIndex = _sentenseIndex;
		type = _type;
	}
	public int sentenseIndex;
	public PowFeedbackLogic.FeedbackType type;
}