Shader "Custom/RadialColorRingWithMultiplyAngleGradient" {
	Properties{
		_Color01("Color01", Color) = (1,1,1,1)
		_Color01Radius("Color01 Radius Location", Range(0.0, 1.0)) = 0.0
		
		_Color02("Color02", Color) = (1,1,1,1)
		_Color02Radius("Color02 Radius Location", Range(0.0, 1.0)) = 0.5
		
		_Color03("Color03", Color) = (1,1,1,1)
		_Color03Radius("Color03 Radius Location", Range(0.0, 1.0)) = 1.0

		_Color04("Color04", Color) = (1,1,1,1)
		_Color04Radius("Color04 Radius Location", Range(0.0, 1.0)) = 1.0

		_UseMultiply("Use multiply, 0-No, 1-Yes", Float) = 0

		_RadialMultiply01("Radial Multiply Color 01", Color) = (1,1,1,1)
		_RadialLocation01("Location 01, Degrees", Range(-180.0, 180.0)) = 0.0
		
		_RadialMultiply02("Radial Multiply Color 02", Color) = (1,1,1,1)
		_RadialLocation02("Location 02, Degrees", Range(-180.0, 180.0)) = 0.0

		_RadialMultiply03("Radial Multiply Color 03", Color) = (1,1,1,1)
		_RadialLocation03("Location 03, Degrees", Range(-180.0, 180.0)) = 0.0

		_RadialMultiply04("Radial Multiply Color 04", Color) = (1,1,1,1)
		_RadialLocation04("Location 04, Degrees", Range(-180.0, 180.0)) = 0.0

		_RadialMultiply05("Radial Multiply Color 05", Color) = (1,1,1,1)
		_RadialLocation05("Location 05, Degrees", Range(-180.0, 180.0)) = 0.0
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

			uniform float	_UseMultiply;

			uniform float4	_RadialMultiply01;
			uniform float	_RadialLocation01;

			uniform float4	_RadialMultiply02;
			uniform float	_RadialLocation02;

			uniform float4	_RadialMultiply03;
			uniform float	_RadialLocation03;

			uniform float4	_RadialMultiply04;
			uniform float	_RadialLocation04;

			uniform float4	_RadialMultiply05;
			uniform float	_RadialLocation05;

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
				o.texcoord0 = i.texcoord0-0.5; //Centers the texture coordinates to the middle of the Quad
				return o;
			}
			fixed4 frag(fragmentInput i) : SV_Target{
				float distance = length(i.texcoord0.xy);
				float4 baseColor;
				//Determine Base Color
				if (distance < _Color01Radius) {
					baseColor = _Color01;
				}
				else if (distance < _Color02Radius) {
					float distanceFactor = (distance - _Color01Radius) / (_Color02Radius - _Color01Radius);
					baseColor = lerp(_Color01, _Color02, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
				}
				else if (distance < _Color03Radius) {
					float distanceFactor = (distance - _Color02Radius) / (_Color03Radius - _Color02Radius);
					baseColor = lerp(_Color02, _Color03, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
				}
				else if (distance < _Color04Radius) {
					float distanceFactor = (distance - _Color03Radius) / (_Color04Radius - _Color03Radius);
					baseColor = lerp(_Color03, _Color04, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
				}
				else {
					baseColor = _Color04;
				}

				//Use multiply?
				if (_UseMultiply > 0.5 && distance != 0) {
										
					//Convert input values to radians
					float radLoc01 = radians(_RadialLocation01);
					float radLoc02 = radians(_RadialLocation02);
					float radLoc03 = radians(_RadialLocation03);
					float radLoc04 = radians(_RadialLocation04);
					float radLoc05 = radians(_RadialLocation05);
					
					float distanceFactor = (distance - _Color01Radius) / (_Color02Radius - _Color01Radius);

					//Determine multiply factor
					float angle = atan2(i.texcoord0.y,i.texcoord0.x);
					if (angle < radLoc01 && distance > _Color01Radius) {
						baseColor = baseColor*_RadialMultiply01;
					}
					else if (angle < radLoc02 && distance > _Color01Radius) {
						float radialFactor = (angle - radLoc01) / (radLoc02 - radLoc01);
						float4 multiplyColor = lerp(_RadialMultiply01, _RadialMultiply02, float4(radialFactor, radialFactor, radialFactor, 1.0));
						baseColor = baseColor*lerp(float4(1.0,1.0,1.0,1.0),multiplyColor,float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
					}
					else if (angle < radLoc03 && distance > _Color01Radius) {
						float radialFactor = (angle - radLoc02) / (radLoc03 - radLoc02);
						float4 multiplyColor = lerp(_RadialMultiply02, _RadialMultiply03, float4(radialFactor, radialFactor, radialFactor, 1.0));
						baseColor = baseColor*lerp(float4(1.0, 1.0, 1.0, 1.0), multiplyColor, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
					}
					else if (angle < radLoc04 && distance > _Color01Radius) {
						float radialFactor = (angle - radLoc03) / (radLoc04 - radLoc03);
						float4 multiplyColor = lerp(_RadialMultiply03, _RadialMultiply04, float4(radialFactor, radialFactor, radialFactor, 1.0));
						baseColor = baseColor*lerp(float4(1.0, 1.0, 1.0, 1.0), multiplyColor, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
					}
					else if (angle < radLoc05 && distance > _Color01Radius) {
						float radialFactor = (angle - radLoc04) / (radLoc05 - radLoc04);
						float4 multiplyColor = lerp(_RadialMultiply04, _RadialMultiply05, float4(radialFactor, radialFactor, radialFactor, 1.0));
						baseColor = baseColor*lerp(float4(1.0, 1.0, 1.0, 1.0), multiplyColor, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
					}
					else if (distance > _Color01Radius){
						float radialFactor = (angle - radLoc05) / (radLoc01 - radLoc05);
						float4 multiplyColor = lerp(_RadialMultiply05, _RadialMultiply01, float4(radialFactor, radialFactor, radialFactor, 1.0));
						baseColor = baseColor*lerp(float4(1.0, 1.0, 1.0, 1.0), multiplyColor, float4(distanceFactor, distanceFactor, distanceFactor, 1.0));
					}
					return baseColor;
				}
				else {
					//No multiply - return base color
					return baseColor;
				}
			}
			ENDCG
		}
	}
}