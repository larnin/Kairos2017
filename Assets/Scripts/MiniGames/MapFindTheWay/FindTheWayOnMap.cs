using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class FindTheWayOnMap : MiniGameBaseLogic
{
    public readonly Color m_selectableColor;
    public readonly Color m_selectedColor;
    public readonly uint m_maxNumberOfPlaceSelected = 3;
    
    // TODO linerenderer must be fix someday 
    public override void activate()
    {
        print("HELLO WORLD JE PASSE ICI putain");
        Event<EnableCursorEvent>.Broadcast(new EnableCursorEvent(true, true));
        enableMiniGame(true);
    }

    [SerializeField]
    private List<SelectablePlaceLogic> m_correctOrder = new List<SelectablePlaceLogic>();

    [SerializeField]
    private Camera m_PlayerCamera;

    [SerializeField]
    private Transform m_cursor;

    [SerializeField]
    private GameObject m_feedbackWin;
    private bool m_win = false;

    [SerializeField]
    private GameObject m_explication;

    private uint m_currentNumberOfPlaceSelected;

    private List<SelectablePlaceLogic> m_selectedPlace = new List<SelectablePlaceLogic>(); // it's like a list but each element are unique

    private LineRenderer m_lineRenderer;

    void Start()
    {
        m_lineRenderer = GetComponent<LineRenderer>();
        m_feedbackWin.SetActive(false);
        enableMiniGame(false);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Cancel"))
        {
            if (m_selectedPlace.Count > 0 && !m_win)
            {
                int lastIndex = m_selectedPlace.Count - 1;
                m_selectedPlace[lastIndex].reset();
                m_selectedPlace.RemoveAt(lastIndex);

                m_lineRenderer.positionCount--;
                m_currentNumberOfPlaceSelected--;
            }
            else
            {
               // desactivate();
            }
        }

        if (m_selectedPlace.Count > 0 && isMaxNotReached())
        {
            positionLineRendererOnCursor();
        }
    }

    public int addPlace(SelectablePlaceLogic selectablePlace)
    {
        if (isMaxNotReached())
        {
            m_currentNumberOfPlaceSelected++;
            m_lineRenderer.positionCount = (int)m_currentNumberOfPlaceSelected + 1;
            m_lineRenderer.SetPosition((int)m_currentNumberOfPlaceSelected-1, selectablePlace.transform.position);
            
            if (!m_selectedPlace.Contains(selectablePlace))
            {
                m_selectedPlace.Add(selectablePlace);

                if (m_selectedPlace.SequenceEqual(m_correctOrder))
                {
                    m_win = true;
                    StartCoroutine(feedBackWinCoroutine());
                }
                positionLineRendererOnCursor();
                return m_selectedPlace.Count;
            }
            positionLineRendererOnCursor();
            return -1;
        }
        else
        {
            return -1;
        }
    }

    public bool isMaxNotReached()
    {
        return m_currentNumberOfPlaceSelected < m_maxNumberOfPlaceSelected;
    }

    IEnumerator feedBackWinCoroutine()
    {
        m_feedbackWin.SetActive(true);
        yield return new WaitForSeconds(1.25f);
        m_feedbackWin.SetActive(false);
    }

    void positionLineRendererOnCursor()
    {
        Vector3 cursorScreenPosition = m_cursor.transform.position;
        cursorScreenPosition.z = 0.5f;
        Vector3 cursorWorldPosition = m_PlayerCamera.ScreenToWorldPoint(cursorScreenPosition);

        m_lineRenderer.SetPosition((int)m_currentNumberOfPlaceSelected, cursorWorldPosition);
    }

    void enableMiniGame(bool _enable)
    {
        gameObject.SetActive(_enable);
        m_explication.SetActive(_enable);
    }
}
