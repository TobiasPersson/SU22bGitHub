Shader "Custom/WarpingShader"
{
	//show values to edit in inspector
	Properties{
	  _Color("Tint", Color) = (0, 0, 0, 1)
	  _WarpColor("WarpColor", Color) = (0, 0, 0, 1)
	  _MainTex("Texture", 2D) = "white" {}
	_VertexOffset("Vertex Offset", Range(0, 1000)) = 0
		_WarpLerp("Warp", Range(0, 1)) = 0
		_RampTex("Ramp", 2D) = "white"{}
	}

		SubShader{
		//the material is completely non-transparent and is rendered at the same time as the other opaque geometry
		Tags{ "RenderType" = "Transparent" "Queue" = "Geometry" }

		Pass{
		  CGPROGRAM

		  //include useful shader functions
		  #include "UnityCG.cginc"

		  //define vertex and fragment shader functions
		  #pragma vertex vert
		  #pragma fragment frag

		  //texture and transforms of the texture
		  sampler2D _MainTex;
		  float4 _MainTex_ST;
		  float _VertexOffset;
		  float _WarpLerp;
		  sampler2D _RampTex;
		  float4 _RampTex_ST;

		  //tint of the texture
		  fixed4 _Color;
		  fixed4 _WarpColor;

		  //the mesh data thats read by the vertex shader
		  struct appdata {
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		  };

		  //the data thats passed from the vertex to the fragment shader and interpolated by the rasterizer
		  struct v2f {
			float4 position : SV_POSITION;
			float2 uv : TEXCOORD0;
		  };

		  //the vertex shader function
		  v2f vert(appdata v) {
			v2f o;
			if (v.vertex.x <= (_WarpLerp - 0.6) || v.vertex.x >(0.6 - _WarpLerp))
			{
				v.vertex.y -= _VertexOffset;
			}
			
			//convert the vertex positions from object space to clip space so they can be rendered correctly
			o.position = UnityObjectToClipPos(v.vertex);
			
			

			//apply the texture transforms to the UV coordinates and pass them to the v2f struct
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			return o;
		  }

		  //the fragment shader function
		  fixed4 frag(v2f i) : SV_TARGET{
			  //read the texture color at the uv coordinate
			fixed4 col = tex2D(_MainTex, i.uv);
		  //multiply the texture color and tint color
		  col *= _Color;

		  col = lerp( col , _WarpColor , _WarpLerp);
		  col += lerp(0, _WarpColor, _WarpLerp); //Emission
		  //return the final color to be drawn on screen
		  return col;
		}

		ENDCG
	  }
	}
		  Fallback "Diffuse"
}
