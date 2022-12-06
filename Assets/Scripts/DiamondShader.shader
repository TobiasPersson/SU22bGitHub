Shader "Custom/DiamondShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Sides("Sides", float) = 2
		_Cube("Cubemap", CUBE) = "" {}
		_ReflectionDetail("Reflection Detal", float) = 2
		_ReflectionFactor("Reflection Factor %", range(0,1)) = 1
		_ReflectionExposure("Reflection Exposure", float) = 2
    }
    SubShader
    {
		Pass //Colour
		{
		Tags { "RenderType" = "Transparent" }
		LOD 100
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members worldPos)
#pragma exclude_renderers d3d11
			#pragma vertex vert
			#pragma fragment frag
		// make fog work
		#pragma multi_compile_fog

		#include "UnityCG.cginc"

		float4 unity_triangle(float2 uv, float size, float sides) {

		float distance = 0;
		float4 render = 0;
		float2 st = 0;
		int vertex = sides;

		st = uv;
		st = st * 2 - 1;
		float angle = atan2(st.x, st.y) + 3.14159265359;
		float radius = 6.283118530718 / float(vertex);
		distance = cos(floor(0.5 + angle / radius) * radius - angle) * length(st);

		render = (1.0 - smoothstep(size, size + 0.01, distance));
		return render;
	}

	float unity_noise_randomValue(float2 uv) {
		return frac(sin(dot(uv , float2(12.9898, 78.233))) * 43758.5453);
	}

	float4 Texture_float(float3 worldPos, float2 uv_render, float sides)
	{
		uv_render *= 32;
		uv_render += _WorldSpaceCameraPos.xy;

		float2 uvFrac = float2(frac(uv_render.x), frac(uv_render.y));
		float2 id = floor(uv_render);
		float4 col = 0;
		float x = 0;
		float y = 0;

		for (y = -1; y <= 1; y++)
		{
			for (x = -1; x <= 1; x++)
			{
				float2 offset = float2(x, y);
				float noise = unity_noise_randomValue(id + offset);
				float size = frac(noise * 123.32);
				float render = unity_triangle(uvFrac - offset - float2(noise, frac(noise * 23.12)), size * 1.5, sides);

				render *= (sin(noise * ((_WorldSpaceCameraPos.x - (worldPos.x * 5) + noise) * 20)));
				render *= (sin(noise * ((_WorldSpaceCameraPos.y - (worldPos.y * 5) + noise) * 20)));
				render *= (sin(noise * ((_WorldSpaceCameraPos.z - (worldPos.z * 5) + noise) * 20)));
			
				col += render;
			}
		}
		return col;
}

		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			UNITY_FOG_COORDS(1)
			float4 vertex : SV_POSITION;
			float3 worldPos;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;
		float _Sides;
		samplerCUBE _Cube;
		float _ReflectionDetail;
		float _ReflectionFactor;
		float _ReflectionExposure;

		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			o.worldPos = mul(unity_ObjectToWorld, v.vertex);
			UNITY_TRANSFER_FOG(o,o.vertex);
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			// sample the texture
			fixed4 col = clamp( Texture_float(i.worldPos, i.uv,_Sides), fixed4(0,0,0,0), fixed4(1,1,1,1);
		col += ((SAMPLE_TEXTURECUBE_LOD(_Cube, Sampler, i.worldPos, _ReflectionDetail) * _ReflectionFactor) * _ReflectionExposure);
		col *= 0.5;
		// apply fog
		//UNITY_APPLY_FOG(i.fogCoord, col);
		return col;
	}
	ENDCG
}

        /*Pass //Reflection
        {
		Tags { "RenderType" = "Opaque" }
		LOD 100
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }*/
    }

	Fallback "Diffuse"
}
