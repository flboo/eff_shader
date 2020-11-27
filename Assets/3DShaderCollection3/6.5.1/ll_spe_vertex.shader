﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'


Shader "ll/spe_vertex"
{
    Properties
    {
        _Diffise ("Diffise", Color) =(1,1,1,1)
        _Specular ("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20
    }
    SubShader
    {
        pass
        {
            Tags{"LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 
            #include "Lighting.cginc"
            #include "UNITYCG.cginc"

            float4 _Diffise;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal: NORMAL;
            };

            struct v2f{
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
            };

            v2f vert(a2v v)
            {
                v2f o;   
                o.pos=UnityObjectToClipPos(v.vertex);
                //环境光
                float3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
                //法线方向
                float3 worldNormal=mul(v.normal,(float3x3)unity_WorldToObject);
                //世界光方向
                float3 worldLightDir=normalize(_WorldSpaceLightPos0.xyz);
                //漫反射
                fixed3 diffuse=_LightColor0.rgb * _Diffise.rgb * saturate( dot(worldNormal,worldLightDir));
                //反射方向
                fixed3 reflectDir=normalize(reflect(-worldLightDir,worldNormal));
                //世界空间中的视觉方向
                float3 viewDir=normalize(_WorldSpaceCameraPos.xyz-mul(unity_ObjectToWorld,v.vertex).xyz);
                //计算高光
                float3 specular=_LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir,viewDir)),_Gloss);
                o.color=ambient+diffuse*specular;
                return  o;
            }
            
            fixed4 frag(v2f i):SV_TARGET
            {
                return fixed4(i.color,1.0);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}