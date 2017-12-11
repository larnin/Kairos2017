using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
 
public class VertexJitterSmooth : MonoBehaviour
{

    public float AngleMultiplier = 1.0f;
    public float SpeedMultiplier = 1.0f;
    public float CurveScale = 1.0f;
    public float valueWait = 0;

    public float timeBetweenAppearingLetter = 0.25f;

    public float m_speedUsedForSmooth = 5;

    private TMP_Text m_TextComponent;
    private bool hasTextChanged;

    Vector3[] base0;
    Vector3[] base1;
    Vector3[] base2;
    Vector3[] base3;

    Vector3[] target0;
    Vector3[] target1;
    Vector3[] target2;
    Vector3[] target3;

    Vector3[] step0;
    Vector3[] step1;
    Vector3[] step2;
    Vector3[] step3;

    // Create an Array which contains pre-computed Angle Ranges and Speeds for a bunch of characters.
    VertexAnim[] vertexAnim = new VertexAnim[1024];
    /*
        for (int i = 0; i< 1024; i++)
        {
            vertexAnim[i].angleRange = Random.Range(10f, 25f);
            vertexAnim[i].speed = Random.Range(1f, 3f);
        }
    */

    Matrix4x4 matrix;
    TMP_TextInfo textInfo;
    TMP_MeshInfo[] cachedMeshInfo;

    /// <summary>
    /// Structure to hold pre-computed animation data.
    /// </summary>
    private struct VertexAnim
    {
        public float angleRange;
        public float angle;
        public float speed;
    }

    private int visibleCharacters = 0;

    void Awake()
    {
        for (int i = 0; i < 1024; i++)
        {
            vertexAnim[i].angleRange = Random.Range(10f, 25f);
            vertexAnim[i].speed = Random.Range(1f, 3f);
        }

        m_TextComponent = GetComponent<TMP_Text>();
    }

    void OnEnable()
    {
        // Subscribe to event fired when text object has been regenerated.
       TMPro_EventManager.TEXT_CHANGED_EVENT.Add(ON_TEXT_CHANGED);
    }

    void OnDisable()
    {
        TMPro_EventManager.TEXT_CHANGED_EVENT.Remove(ON_TEXT_CHANGED);
    }


    void Start()
    {
        m_TextComponent.ForceMeshUpdate();

        //Compute  start Pos
        //#####################################################################################
        textInfo = m_TextComponent.textInfo;
        
        base0 = new Vector3[textInfo.characterCount];
        base1 = new Vector3[textInfo.characterCount];
        base2 = new Vector3[textInfo.characterCount];
        base3 = new Vector3[textInfo.characterCount];

        target0 = new Vector3[textInfo.characterCount];
        target1 = new Vector3[textInfo.characterCount];
        target2 = new Vector3[textInfo.characterCount];
        target3 = new Vector3[textInfo.characterCount];


        for (int ithatGoAll = 0; ithatGoAll < textInfo.characterCount; ithatGoAll++)
        { 
            // computer "basePos"
            TMP_CharacterInfo charInfo = textInfo.characterInfo[ithatGoAll];

            // Get the index of the material used by the current character.
            int materialIndex = textInfo.characterInfo[ithatGoAll].materialReferenceIndex;


            // Get the index of the first vertex used by this text element.
            int vertexIndex = textInfo.characterInfo[ithatGoAll].vertexIndex;

            
            // Cache the vertex data of the text object as the Jitter FX is applied to the original position of the characters.
            cachedMeshInfo = textInfo.CopyMeshInfoVertexData();

            // Get the cached vertices of the mesh used by this text element (character or sprite).
            Vector3[] sourceVertices = cachedMeshInfo[materialIndex].vertices;

            // Determine the center point of each character at the baseline.
            //Vector2 charMidBasline = new Vector2((sourceVertices[vertexIndex + 0].x + sourceVertices[vertexIndex + 2].x) / 2, charInfo.baseLine);
            // Determine the center point of each character.
            Vector2 charMidBasline = (sourceVertices[vertexIndex + 0] + sourceVertices[vertexIndex + 2]) / 2;

            // Need to translate all 4 vertices of each quad to aligned with middle of character / baseline.
            // This is needed so the matrix TRS is applied at the origin for each character.
            Vector3 offset = charMidBasline;

            Vector3[] destinationVertices = textInfo.meshInfo[materialIndex].vertices;
            
            base0[ithatGoAll] = destinationVertices[vertexIndex + 0];
            base1[ithatGoAll] = destinationVertices[vertexIndex + 1];
            base2[ithatGoAll] = destinationVertices[vertexIndex + 2];
            base3[ithatGoAll] = destinationVertices[vertexIndex + 3];


            //Compute  dest Pos
            //################################################################
            ComputeNewTarget(ithatGoAll, out target0[ithatGoAll], out target1[ithatGoAll], out target2[ithatGoAll], out target3[ithatGoAll]);

                /*
                pseudo code algo 



                vertexAnim[i] = vertAnim;
                 */

        }

        StartCoroutine(updateValueOfLetterOne());

        //  StartCoroutine(AnimateVertexColors());
    }

    private void ComputeNewTarget(int index, out Vector3 _target0, out Vector3 _target1, out Vector3 _target2, out Vector3 _target3)
    {
        // Get the index of the material used by the current character.
        int materialIndex = textInfo.characterInfo[index].materialReferenceIndex;
        
        // Get the cached vertices of the mesh used by this text element (character or sprite).
        Vector3[] sourceVertices = cachedMeshInfo[materialIndex].vertices;

        Vector3[] destinationVertices = textInfo.meshInfo[materialIndex].vertices;

        // Get the index of the first vertex used by this text element.
        int vertexIndex = textInfo.characterInfo[index].vertexIndex;

        Vector2 charMidBasline = (sourceVertices[vertexIndex + 0] + sourceVertices[vertexIndex + 2]) / 2;

        // Need to translate all 4 vertices of each quad to aligned with middle of character / baseline.
        // This is needed so the matrix TRS is applied at the origin for each character.
        Vector3 offset = charMidBasline;
        
        VertexAnim vertAnim = vertexAnim[index];

        Vector3 baseValue1 = destinationVertices[vertexIndex + 0];
        Vector3 baseValue2 = destinationVertices[vertexIndex + 1];
        Vector3 baseValue3 = destinationVertices[vertexIndex + 2];
        Vector3 baseValue4 = destinationVertices[vertexIndex + 3];

        destinationVertices[vertexIndex + 0] = sourceVertices[vertexIndex + 0] - offset;
        destinationVertices[vertexIndex + 1] = sourceVertices[vertexIndex + 1] - offset;
        destinationVertices[vertexIndex + 2] = sourceVertices[vertexIndex + 2] - offset;
        destinationVertices[vertexIndex + 3] = sourceVertices[vertexIndex + 3] - offset;

        vertAnim.angle = Mathf.SmoothStep(-vertAnim.angleRange, vertAnim.angleRange, Mathf.PingPong(0 / 25f * vertAnim.speed, 1f)); // loopCount in place of zero
        Vector3 jitterOffset = new Vector3(Random.Range(-.25f, .25f), Random.Range(-.25f, .25f), 0);

        matrix = Matrix4x4.TRS(jitterOffset * CurveScale, Quaternion.Euler(0, 0, Random.Range(-5f, 5f) * AngleMultiplier), Vector3.one);

        destinationVertices[vertexIndex + 0] = matrix.MultiplyPoint3x4(destinationVertices[vertexIndex + 0]);
        destinationVertices[vertexIndex + 1] = matrix.MultiplyPoint3x4(destinationVertices[vertexIndex + 1]);
        destinationVertices[vertexIndex + 2] = matrix.MultiplyPoint3x4(destinationVertices[vertexIndex + 2]);
        destinationVertices[vertexIndex + 3] = matrix.MultiplyPoint3x4(destinationVertices[vertexIndex + 3]);

        destinationVertices[vertexIndex + 0] += offset;
        destinationVertices[vertexIndex + 1] += offset;
        destinationVertices[vertexIndex + 2] += offset;
        destinationVertices[vertexIndex + 3] += offset;

        _target0 = destinationVertices[vertexIndex + 0];
        _target1 = destinationVertices[vertexIndex + 1];
        _target2 = destinationVertices[vertexIndex + 2];
        _target3 = destinationVertices[vertexIndex + 3];


        destinationVertices[vertexIndex + 0] = baseValue1;
        destinationVertices[vertexIndex + 1] = baseValue2;
        destinationVertices[vertexIndex + 2] = baseValue3;
        destinationVertices[vertexIndex + 3] = baseValue4;
    }

    IEnumerator updateValueOfLetterOne()
    {
        int currentLetterIndex = 0;

        
        TMP_TextInfo textInfo = m_TextComponent.textInfo;

        step0 = new Vector3[textInfo.characterCount];
        step1 = new Vector3[textInfo.characterCount];
        step2 = new Vector3[textInfo.characterCount];
        step3 = new Vector3[textInfo.characterCount];
        
        for (currentLetterIndex = 0; currentLetterIndex < textInfo.characterCount; currentLetterIndex++)
        {
            TMP_CharacterInfo charInfo = textInfo.characterInfo[currentLetterIndex];

            // Skip characters that are not visible and thus have no geometry to manipulate.
            // if (!charInfo.isVisible)
            //     continue;

            // Retrieve the pre-computed animation data for the given character.
            VertexAnim vertAnim = vertexAnim[currentLetterIndex];

            // Get the index of the material used by the current character.
            int materialIndex = textInfo.characterInfo[currentLetterIndex].materialReferenceIndex;

            // Get the index of the first vertex used by this text element.
            int vertexIndex = textInfo.characterInfo[currentLetterIndex].vertexIndex;

            Vector3[] destinationVertices = textInfo.meshInfo[materialIndex].vertices;

            step0[currentLetterIndex] = base0[currentLetterIndex];
            step1[currentLetterIndex] = base1[currentLetterIndex];
            step2[currentLetterIndex] = base2[currentLetterIndex];
            step3[currentLetterIndex] = base3[currentLetterIndex];
        }

        while (true)
        {
            

            for(currentLetterIndex = 0; currentLetterIndex < textInfo.characterCount; currentLetterIndex++)
            {

                if (!textInfo.characterInfo[currentLetterIndex].isVisible)
                    continue;

                // Retrieve the pre-computed animation data for the given character.
                VertexAnim vertAnim = vertexAnim[currentLetterIndex];

                // Get the index of the material used by the current character.
                int materialIndex = textInfo.characterInfo[currentLetterIndex].materialReferenceIndex;

                // Get the index of the first vertex used by this text element.
                int vertexIndex = textInfo.characterInfo[currentLetterIndex].vertexIndex;

                Vector3[] destinationVertices = textInfo.meshInfo[materialIndex].vertices;
                
                if(visibleCharacters > currentLetterIndex)
                {
                    step0[currentLetterIndex] = Vector3.MoveTowards(step0[currentLetterIndex], target0[currentLetterIndex], m_speedUsedForSmooth * Time.deltaTime);
                    step1[currentLetterIndex] = Vector3.MoveTowards(step1[currentLetterIndex], target1[currentLetterIndex], m_speedUsedForSmooth * Time.deltaTime);
                    step2[currentLetterIndex] = Vector3.MoveTowards(step2[currentLetterIndex], target2[currentLetterIndex], m_speedUsedForSmooth * Time.deltaTime);
                    step3[currentLetterIndex] = Vector3.MoveTowards(step3[currentLetterIndex], target3[currentLetterIndex], m_speedUsedForSmooth * Time.deltaTime);
                }
                else
                {
                    step0[currentLetterIndex] = Vector3.zero;
                    step1[currentLetterIndex] = Vector3.zero;
                    step2[currentLetterIndex] = Vector3.zero;
                    step3[currentLetterIndex] = Vector3.zero;
                }

                destinationVertices[vertexIndex + 0] = step0[currentLetterIndex];
                destinationVertices[vertexIndex + 1] = step1[currentLetterIndex];
                destinationVertices[vertexIndex + 2] = step2[currentLetterIndex];
                destinationVertices[vertexIndex + 3] = step3[currentLetterIndex];

                vertexAnim[currentLetterIndex] = vertAnim;

                if (step0[currentLetterIndex] == target0[currentLetterIndex] &&
                    step1[currentLetterIndex] == target1[currentLetterIndex] &&
                    step2[currentLetterIndex] == target2[currentLetterIndex] &&
                    step3[currentLetterIndex] == target3[currentLetterIndex])
                {
                    ComputeNewTarget(currentLetterIndex, out target0[currentLetterIndex], out target1[currentLetterIndex], out target2[currentLetterIndex], out target3[currentLetterIndex]);
                }


            }

            // Push changes into meshes
            for (int j = 0; j < textInfo.meshInfo.Length; j++)
            {
                textInfo.meshInfo[j].mesh.vertices = textInfo.meshInfo[j].vertices;
                m_TextComponent.UpdateGeometry(textInfo.meshInfo[j].mesh, j);
            }
            yield return null;
        }

    }

    private float timerLetter = 0;
    void Update()
    {
        if(timerLetter > timeBetweenAppearingLetter)
        {
            timerLetter = 0f;

            if(visibleCharacters != textInfo.characterCount)
            {
                visibleCharacters++;
                int index = visibleCharacters - 1;
                step0[index] = base0[index];
                step1[index] = base1[index];
                step2[index] = base2[index];
                step3[index] = base3[index];

            }
        }
        timerLetter += Time.deltaTime;
    }

    void activateThatScript()
    {
        enabled = true;
    }

    void ON_TEXT_CHANGED(Object obj)
    {
        if (obj == m_TextComponent)
            hasTextChanged = true;
    }    

    
}
