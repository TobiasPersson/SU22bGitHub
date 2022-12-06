Shader "Custom/Atmosphere"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RimPower("Rim Power", Range(0.5,5.0)) = 3.0
		_Radius("Radius", Float) = 1
		_CentrePoint("Centre", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "ForceNoShadowCasting" = "True" "Queue" = "Transparent" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard alpha

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
			float3 worldPos;
			float4 screenPos;
        };
        fixed4 _Color;
		float _RimPower;
		float _Radius;
		float4 _CentrePoint;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = _Color;
			float3 CenterScreenPos =   IN.worldPos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
			float distanceToCenter = distance(IN.screenPos, _CentrePoint);

			if (distanceToCenter > _Radius)
			{
				o.Albedo = c.rgb;
				o.Alpha = 1;
			}
			else
			{
				o.Albedo = c.rgb;
				o.Alpha = 0;
			}

			
			
			//float fresnel = dot(IN.worldNormal, IN.viewDir);
			
			//fresnel = saturate(1 - fresnel);
			//fresnel = pow(fresnel, _RimPower);
			//half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			//o.Albedo = c.rgb * fresnel;
			//o.Alpha = c.a * fresnel;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
