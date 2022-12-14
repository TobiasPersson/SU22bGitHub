using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TerrainFace
{
    ShapeGenerator shapeGenerator;
    Mesh mesh;
    int resolution;
    Vector3 localUp;

    Vector3 axisA;
    Vector3 axisB;

    public TerrainFace(ShapeGenerator shapeGenerator,  Mesh mesh, int resolution, Vector3 localUp)
    {
        this.mesh = mesh;
        this.resolution = resolution;
        this.localUp = localUp;
        this.shapeGenerator = shapeGenerator;

        axisA = new Vector3(localUp.y, localUp.z, localUp.x);
        axisB = Vector3.Cross(localUp, axisA);
    }

    public void ConstructMesh()
    {
        Vector3[] verts = new Vector3[resolution * resolution];
        int[] tri = new int[(resolution - 1) * (resolution - 1) * 6];
        int triIndex = 0; 

        for (int y = 0; y < resolution; y++)
        {
            for (int x = 0; x < resolution; x++)
            {
                int i = x + y * resolution;
                Vector2 percent = new Vector2(x,y) / (resolution - 1);
                Vector3 pointOnUnitCube = localUp + (percent.x - 0.5f) * 2 * axisA + (percent.y - 0.5f) * 2 * axisB;
                Vector3 pointOnUnitSphere = pointOnUnitCube.normalized;
                verts[i] = shapeGenerator.CalculatePointonPlanet(pointOnUnitSphere);

                if (x != resolution-1 && y != resolution -1)
                {
                    tri[triIndex] = i;
                    tri[triIndex + 1] = i + resolution + 1;
                    tri[triIndex + 2] = i + resolution;

                    tri[triIndex +3] = i;
                    tri[triIndex + 4] = i + 1;
                    tri[triIndex + 5] = i + resolution + 1;
                    triIndex += 6;
                }
            }
        }
        mesh.Clear();
        mesh.vertices = verts;
        mesh.triangles = tri;
        mesh.RecalculateNormals();
    }
}
