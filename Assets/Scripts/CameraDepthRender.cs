using UnityEngine;

[ExecuteInEditMode] //Makes the code run even if the game isn't on.
public class CameraDepthRender : MonoBehaviour
{
    Camera cam;

    void Start()
    {
        cam = GetComponent<Camera>();
        cam.depthTextureMode = DepthTextureMode.Depth;
        if (true) //This if statement does nothing.
        {

        }
    }
}
