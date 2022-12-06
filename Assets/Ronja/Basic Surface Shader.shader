Shader "Custom/Basic Surface"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
       _Smoothness("Smoothness", Range(0,1)) = 0
		_Metallic ("Metalness", Range(0,1)) = 0
		   _EmissionMap ("Emission Map", 2D) = "white"{}
[HDR]_Emission ("Emission", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        
		#pragma surface surf Standard fullforwardshadows
#pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;

		half _Smoothness;
		half _Metallic;
		sampler2D _EmissionMap;
		half3 _Emission; 

		struct Input {
			float2 uv_MainTex;
		};

		void surf(Input i, inout SurfaceOutputStandard o){
			fixed4 col = tex2D(_MainTex, i.uv_MainTex);
			col *= _Color;
			o.Albedo = col.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			fixed3 emi = tex2D(_EmissionMap, i.uv_MainTex);
			emi *= _Emission;
			o.Emission = emi;
		}
        ENDCG
    }
    FallBack "Diffuse"
}
