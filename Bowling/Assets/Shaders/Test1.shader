﻿Shader "Custom/test1"
{
	Properties
	{
		_Color("Diffuse Material Color", Color) = (1,1,1,1)
		_SpecColor("Specular Material Color", Color) = (1,1,1,1)
		_Shininess("Shininess", Float) = 10
	}
		SubShader
	{
		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"


		uniform float4 _Color;
	uniform float4 _SpecColor;
	uniform float _Shininess;

	uniform float4 _LightColor0;

	struct appdata {
		float4 pos : POSITION;
		float3 norm : NORMAL;
	};
	struct v2f {
		float4 pos : SV_POSITION;
		float3 norm : NORMAL;
		float4 p : TEXCOORD0;
		//float4 pos1;
	};

	v2f vert(appdata v)
	{
		v2f output;

		output.norm = v.norm;

		output.pos = UnityObjectToClipPos(v.pos);

		output.p = v.pos;

		return output;
	}

	float4 frag(v2f v) : COLOR
	{
		float4x4 modelMatrix = unity_ObjectToWorld;
		float3x3 modelMatrixInverse = unity_WorldToObject;

		float3 normalDirection = normalize(mul(v.norm, modelMatrixInverse));
		float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(modelMatrix, v.p).xyz);
		float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
		//ambientLighting
		float3 ambientLighting = unity_AmbientSky.rgb * _Color.rgb;

		//diffuseReflection
		float3 diffuseReflection = _LightColor0.rgb * _Color.rgb * (max(0.0, dot(lightDirection, normalDirection)));

		//specularReflection
		float3 h = normalize(lightDirection + viewDirection);
		float3 nh = max(0.0, dot(normalDirection, h));

		float3 specularReflection = _LightColor0.rgb * _SpecColor.rgb * pow(nh, _Shininess);

		return float4(ambientLighting + diffuseReflection + specularReflection, 1.0);
	}
		ENDCG
	}
	}
}
