Shader "Custom/WaterShader"
{
	Properties
	{
		// color of the water
		_Color("Color", Color) = (1,1,1,1)
		// color of the edge effect
		_DepthRampTex("Depth Ramp", 2D) = "DefaultTexture"
		// width of the edge effect
		_DepthFactor("Depth Factor", float) = 1.0
		//Frequency of waves
		_WaveSpeed("Wave Speed", float) = 1.0
		//Amplitude of waves
		_WaveAmp("Wave Amplitude", float) = 1.0
		//Noise Texture for randomness
		_NoiseTex("Noise Texture", 2D) = "DefaultTexture"

		//_MainTex("Main Texture", 2D) = "white" {}
		_DistortStrength("Distort Strength", float) = 1.0
		_ExtraHeight("Extra Height", float) = 0.0
	}
	SubShader
	{
		Tags {
		"Queue" = "Transparent"
}

//Grab the screen behind the object into _BackgroundTexture
GrabPass{
		"_BackgroundTexture"
}
//Background distortion
Pass{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

		// Properties
		sampler2D _BackgroundTexture;
		sampler2D _NoiseTex;
		float     _DistortStrength;
		float  _WaveSpeed;
		float  _WaveAmp;

		struct vertexInput
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float3 texCoord : TEXCOORD0;
		};

		struct vertexOutput
		{
			float4 pos : SV_POSITION;
			float4 grabPos : TEXCOORD0;
		};

		vertexOutput vert(vertexInput input)
		{
			vertexOutput output;

			// convert input to world space
			output.pos = UnityObjectToClipPos(input.vertex);
			float4 normal4 = float4(input.normal, 0.0);
			float3 normal = normalize(mul(normal4, unity_WorldToObject).xyz);

			// use ComputeGrabScreenPos function from UnityCG.cginc
			// to get the correct texture coordinate
			output.grabPos = ComputeGrabScreenPos(output.pos);

			// distort based on bump map
			float noiseSample = tex2Dlod(_NoiseTex, float4(input.texCoord.xy, 0, 0));
			output.grabPos.y += sin(_Time*_WaveSpeed*noiseSample)*_WaveAmp * _DistortStrength;
			output.grabPos.x += cos(_Time*_WaveSpeed*noiseSample)*_WaveAmp * _DistortStrength;

			return output;
		}

		float4 frag(vertexOutput input) : COLOR
		{
			return tex2Dproj(_BackgroundTexture, input.grabPos);
		}
		ENDCG
}
	Pass
	{

			Blend SrcAlpha OneMinusSrcAlpha

	CGPROGRAM
	// required to use ComputeScreenPos()
	#include "UnityCG.cginc"

	#pragma vertex vert
	#pragma fragment frag

	 // Unity built-in - NOT required in Properties
	 sampler2D _CameraDepthTexture;
	float _DepthFactor;
	float4 _Color;
	sampler2D _DepthRampTex;
	float _WaveSpeed;
	float _WaveAmp;
	float _ExtraHeight;
	sampler2D _NoiseTex;

	struct vertexInput
	 {
	   float4 vertex : POSITION;
	   float4 texCoord : TEXCOORD1;
	 };

	struct vertexOutput
	 {
	   float4 pos : SV_POSITION;
	   float4 texCoord : TEXCOORD0;
	   float4 screenPos : TEXCOORD1;
	 };

	vertexOutput vert(vertexInput input)
	  {
		vertexOutput output;

		// convert obj-space position to camera clip space
		output.pos = UnityObjectToClipPos(input.vertex);

		float noiseSample = tex2Dlod(_NoiseTex, float4(input.texCoord.xy, 0, 0));

		output.pos.y += sin(_Time*_WaveSpeed*noiseSample)*_WaveAmp + _ExtraHeight;
		output.pos.x + sin(_Time*_WaveSpeed*noiseSample)*_WaveAmp;

		//Compute depth
		output.screenPos = ComputeScreenPos(output.pos);


		return output;
	  }

	  float4 frag(vertexOutput input) : COLOR
	  {
		  // sample camera depth texture
		  float4 depthSample = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, input.screenPos);
		  float depth = LinearEyeDepth(depthSample).r;

		  
		  float foamLine = 1 - saturate(_DepthFactor * (depth - input.screenPos.w));

		  float4 foamRamp = float4(tex2D(_DepthRampTex, float2(foamLine, 0.5)).rgb, 1.0);


		  float4 col = _Color * foamRamp;

		  return col;
		}

		ENDCG
	  } }}
