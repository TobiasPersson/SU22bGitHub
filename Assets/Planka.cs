using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Planka : MonoBehaviour
{
    List<GameObject> gameObjects = new List<GameObject>();
    GeneriskKod<string, bool, GameObject> generisk = new GeneriskKod<string, bool, GameObject>();
    Rigidbody rb;
    // Start is called before the first frame update
    void Start()
    {
        generisk.Metod<Planka>(this);
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            rb.AddForce(Vector3.up * 400);
        }
        
    }
}
