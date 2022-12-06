Shader "Custom/ClippingPlaneShader"
{
    Properties
    {
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	   _Smoothness("Smoothness", Range(0,1)) = 0
		_Metallic("Metalness", Range(0,1)) = 0
		   _EmissionMap("Emission Map", 2D) = "white"{}
[HDR]_Emission("Emission", Color) = (0,0,0,1)
[HDR]_CutoffColor("Cutoff Color", Color) = (0,0,0,1)
		_CutoffTex("Cuttoff Texture", 2D) = "white" {}
    }
    SubShader
    {
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

		Cull Off

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _Color;

		half _Smoothness;
		half _Metallic;
		sampler2D _EmissionMap;
		half3 _Emission;
		float4 _CutoffColor;
		sampler2D _CutoffTex;
		float4 _Plane;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float facing : VFACE;
		};

		void surf(Input i, inout SurfaceOutputStandard o) {
			
			float distance = dot(i.worldPos, _Plane.xyz);
			distance = distance + _Plane.w;
			clip(-distance);

			float facing = i.facing * 0.5 + 0.5;
				

			fixed4 col = tex2D(_MainTex, i.uv_MainTex);
			col *= _Color;
			o.Albedo = col.rgb * facing;
			o.Metallic = _Metallic * facing;
			o.Smoothness = _Smoothness * facing;
			//fixed3 emi = tex2D(_EmissionMap, i.uv_MainTex);
			//emi *= _Emission;
			fixed4 cutOff = tex2D(_CutoffTex, i.uv_MainTex);
			cutOff *= _CutoffColor;
			o.Emission = lerp(cutOff, _Emission, facing);
			//o.Emission = emi;
		}
		ENDCG
    }
    FallBack "Diffuse"
}
