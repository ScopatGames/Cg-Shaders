Shader "Custom/RadialColorRings" {
	Properties{
		_Color01("Color01", Color) = (1,1,1,1)
		_Color01Radius("Color01 Radius Location", Range(0.0, 1.0)) = 0.0

		_Color02("Color02", Color) = (1,1,1,1)
		_Color02Radius("Color02 Radius Location", Range(0.0, 1.0)) = 0.5

		_Color03("Color03", Color) = (1,1,1,1)
		_Color03Radius("Color03 Radius Location", Range(0.0, 1.0)) = 1.0

		_Color04("Color04", Color) = (1,1,1,1)
		_Color04Radius("Color04 Radius Location", Range(0.0, 1.0)) = 1.0



	}

		SubShader{
			Pass{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 3.0

				#include "UnityCG.cginc"

				uniform float4	_Color01;
				uniform float	_Color01Radius;

				uniform float4	_Color02;
				uniform float	_Color02Radius;

				uniform float4	_Color03;
				uniform float	_Color03Radius;

				uniform float4	_Color04;
				uniform float	_Color04Radius;


				struct vertexInput {
					float4 vertex : POSITION;
					float4 texcoord0 : TEXCOORD0;
				};

				struct fragmentInput {
					float4 position : SV_POSITION;
					float4 texcoord0 : TEXCOORD0;
				};

				fragmentInput vert(vertexInput i) {
					fragmentInput o;
					o.position = mul(UNITY_MATRIX_MVP, i.vertex);
					o.texcoord0 = i.texcoord0 - 0.5; //Centers the texture coordinates to the middle of the Quad
					return o;
				}
				fixed4 frag(fragmentInput i) : SV_Target{
					float distance = length(i.texcoord0.xy);
					if (distance < _Color01Radius) {
						return _Color01;
					}
					else if (distance < _Color02Radius) {
						float distanceFactor = (distance - _Color01Radius) / (_Color02Radius - _Color01Radius);
						return lerp(_Color01, _Color02, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
					}
					else if (distance < _Color03Radius) {
						float distanceFactor = (distance - _Color02Radius) / (_Color03Radius - _Color02Radius);
						return lerp(_Color02, _Color03, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
					}
					else if (distance < _Color04Radius) {
						float distanceFactor = (distance - _Color03Radius) / (_Color04Radius - _Color03Radius);
						return lerp(_Color03, _Color04, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
					}
					else {
						return _Color04;
					}
				}
				ENDCG
		}
	}
}