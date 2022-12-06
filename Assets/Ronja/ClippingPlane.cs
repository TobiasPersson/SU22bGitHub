using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class ClippingPlane : MonoBehaviour
{

    public Material mat;

    // Update is called once per frame
    void Update()
    {
        Plane plane = new Plane(transform.up, transform.position);

        Vector4 planeRepresentation = new Vector4(plane.normal.x, plane.normal.y, plane.normal.z, plane.distance);

        mat.SetVector("_Plane", planeRepresentation);
        
       
    }
}
