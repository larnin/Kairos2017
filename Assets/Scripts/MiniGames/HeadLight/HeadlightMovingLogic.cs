using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeadlightMovingLogic : MonoBehaviour
{
    [SerializeField]
    private Material[] m_materials;

    [SerializeField]
    private float m_Speed = 5.0f;

    [SerializeField]
    private float m_limitX = 8.0f;

	void Update ()
    {
        transform.Translate(Vector3.left * m_Speed * Time.deltaTime);

        Vector4 newPos = new Vector4(transform.position.x, transform.position.y, transform.position.z);

        foreach (Material e in m_materials)
        {
            e.SetVector("_Position1", newPos);
        }
        
        if (transform.position.x < -m_limitX)
        {
            Vector3 temp = transform.position;
            temp.x = m_limitX;
            transform.position = temp;
        }
    }
}
