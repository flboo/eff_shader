// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'


Shader "ll/spe6.5.2"
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
                float3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
            };

            v2f vert(a2v v)
            {
                v2f o;   
                //模型空间到剪切面
                o.pos=UnityObjectToClipPos(v.vertex);
                //法线  由本地空间坐标 到世界空间坐标
                o.worldNormal =mul(v.normal,(float3x3)unity_WorldToObject);
                //位置  由本地空间坐标 到世界空间坐标
                o.worldPos =mul(unity_ObjectToWorld,v.vertex).xyz;
                return  o;
            }
            

            fixed4 frag(v2f i):SV_TARGET
            {
                //环境光
                float3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldNormal=normalize(i.worldNormal);
                fixed3 worldLightDir=normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffise=_LightColor0.rgb*_Diffise.rgb*saturate(mul(worldNormal,worldLightDir));

                //出射光normal方向
                fixed3 reflectir=normalize(reflect(-worldLightDir,worldNormal));
                //视角方向view
                fixed3 viewDir=normalize(_WorldSpaceCameraPos.xyz- i.worldPos.xyz);

                fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectir,viewDir)),_Gloss);
                return fixed4(ambient+diffise+diffise,1.0);
            }

            ENDCG
        }
    }
    Fallback "Diffuse"
}