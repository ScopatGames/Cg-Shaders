Shader "Custom/FresnelVertexShader" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimWidth("Rim Width", Range(0.0, 10.5)) = 0.5

	}

	SubShader{
		Tags{ "RenderType" = "Opaque"}
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"

			uniform float4 _Color;
			uniform float4 _RimColor;
			uniform float _RimWidth;

			struct fragmentInput {
				float4 position : SV_POSITION;
				float3 color : COLOR;
			};

			fragmentInput vert(appdata_base i) {
				fragmentInput o;
				o.position = mul(UNITY_MATRIX_MVP, i.vertex);
				float3 viewDir = normalize(ObjSpaceViewDir(i.vertex));
				float dotProduct =  1 - dot(i.normal, viewDir);
				o.color = smoothstep(1 - _RimWidth, 1.0, dotProduct);
				o.color *= _RimColor;
				return o;
			}

			fixed4 frag(fragmentInput i) : COLOR {
				float4 shaderColor = _Color;
				shaderColor.rgb += i.color;
				return shaderColor;
			}
			ENDCG
		}
	}
}
