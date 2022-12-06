using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GeneriskKod<Ylva,U,V> : MonoBehaviour
{
    public Ylva Something;
    public U SomethingAgain;
    public V NågotAnnat;

    public void Metod<X>(X value1) where X : MonoBehaviour
    {
        print(value1);
    }


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
