using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlyCamera : MonoBehaviour
{
    [SerializeField]
    float speed = 60;
    [SerializeField]
    float rotSpeed = 60;

    // Start is called before the first frame update
    void Start()
    {
        transform.rotation = Quaternion.Euler(Vector3.zero);
        transform.GetChild(0).rotation = Quaternion.Euler(Vector3.zero); 
    }

    // Update is called once per frame
    void Update()
    {
        float horz = Input.GetAxis("Horizontal");
        float vert = Input.GetAxis("Vertical");
        float upDown = Input.GetAxis("UpDown");

        float mouseHorz = Input.GetAxis("Mouse X");
        float mouseVert = Input.GetAxis("Mouse Y");
        
        transform.Rotate(new Vector3(0, mouseHorz * Time.deltaTime * rotSpeed, 0), Space.World);
        transform.GetChild(0).Rotate(mouseVert * Time.deltaTime * rotSpeed,0,0);
        transform.Translate(new Vector3(horz * Time.deltaTime * speed, upDown * Time.deltaTime * speed, vert * Time.deltaTime* speed));
    }
}
