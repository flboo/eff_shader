// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'


Shader "ll/pixel"
{
    Properties
    {
        _Diffise ("Diffise", Color) =(1,1,1,1)
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

            float4 _Diffise;
            
            struct a2v
            {
                float4 vertex:POSITION;
                float3 normal: NORMAL;
            };

            struct v2f{
                float4 pos:SV_POSITION;
                fixed3 worldNormal:TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;   
                o.pos=UnityObjectToClipPos(v.vertex);
                
                o.worldNormal=mul(v.normal,(float3x3)unity_WorldToObject);
                return  o;
            }
            

            fixed4 frag(v2f i):SV_TARGET
            {
                float3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
                float3 worldNormal= normalize(i.worldNormal);
                fixed3 worldLightdir=normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse=_LightColor0.rgb*_Diffise.rgb*saturate(mul(worldNormal,worldLightdir));
                fixed3 color= ambient+diffuse;
                return fixed4(color,1.0);
            }

            ENDCG
        }
    }
    Fallback "Diffuse"
}