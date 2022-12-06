Shader "Custom/1DRandom"
{
	Properties
	{
		 _CellSize("Cell Size", Range(0,1)) = 1
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows
#pragma target 3.0
		#include "WhiteNoise.cginc"

		float _CellSize;

		struct Input {
			float3 worldPos;
		};

		inline float easeIn(float inter) {
			return inter * inter;
		}

		float easeOut(float inter) {
			return 1 - easeIn(1 - inter);
		}

		float easeInOut(float inter) {
			float easeInValue = easeIn(inter);
			float easeOutValue = easeOut(inter);
			return lerp(easeInValue, easeOutValue, inter);
		}

		float ValueNoise2d(float2 value) {
			float upperLeftCell = rand2dTo1d(float2(floor(value.x), ceil(value.y)));
			float upperRightCell = rand2dTo1d(float2(ceil(value.x), ceil(value.y)));
			float lowerLeftCell = rand2dTo1d(float2(floor(value.x), floor(value.y)));
			float lowerRightCell = rand2dTo1d(float2(ceil(value.x), floor(value.y)));

			float interpolatorX = easeInOut(frac(value.x));
			float interpolatorY = easeInOut(frac(value.y));

			float upperCells = lerp(upperLeftCell, upperRightCell, interpolatorX);
			float lowerCells = lerp(lowerLeftCell, lowerRightCell, interpolatorX);

			float noise = lerp(lowerCells, upperCells, interpolatorY);
			return noise;
		}

		float3 ValueNoise3d(float3 value) {
			float interpolatorX = easeInOut(frac(value.x));
			float interpolatorY = easeInOut(frac(value.y));
			float interpolatorZ = easeInOut(frac(value.z));

			float3 cellNoiseZ[2];
			[unroll]
			for (int z = 0; z <= 1; z++) {
				float3 cellNoiseY[2];
				[unroll]
				for (int y = 0; y <= 1; y++) {
					float3 cellNoiseX[2];
					[unroll]
					for (int x = 0; x <= 1; x++) {
						float3 cell = floor(value) + float3(x, y, z);
						cellNoiseX[x] = rand3dTo3d(cell);
					}
					cellNoiseY[y] = lerp(cellNoiseX[0], cellNoiseX[1], interpolatorX);
				}
				cellNoiseZ[z] = lerp(cellNoiseY[0], cellNoiseY[1], interpolatorY);
			}
			float3 noise = lerp(cellNoiseZ[0], cellNoiseZ[1], interpolatorZ);
			return noise;
		}

		void surf(Input i, inout SurfaceOutputStandard o) {
			float3 value = i.worldPos.xyz / _CellSize;
			
			float3 noise = ValueNoise3d(value);
			
			o.Albedo = noise;
		}
		ENDCG
	}
		FallBack "Diffuse"
}
