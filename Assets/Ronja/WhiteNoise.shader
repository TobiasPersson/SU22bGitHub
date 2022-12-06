Shader "Custom/WhiteNoise"
{
    Properties
    {
	   _Smoothness("Smoothness", Range(0,1)) = 0
		_Metallic("Metalness", Range(0,1)) = 0
		[HDR]_Emission("Emission", Color) = (0,0,0,1)
		 _CellSize("Cell Size", Vector) = (1,1,1,0)
    }
    SubShader
    {
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows
#pragma target 3.0
		#include "WhiteNoise.cginc"

		half _Smoothness;
		half _Metallic;
		half3 _Emission;
		float3 _CellSize;

		struct Input {
			float3 worldPos;
		};

		void surf(Input i, inout SurfaceOutputStandard o) {
			float3 value = floor(i.worldPos/ _CellSize);
			o.Albedo = rand3dTo3d(value);
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Emission = _Emission;
		}
		ENDCG
    }
    FallBack "Diffuse"
}
