// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ll/verdex"
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
                fixed3 color:COLOR;
            };

            v2f vert(a2v v)
            {
                v2f o;   
                o.pos=UnityObjectToClipPos(v.vertex);
                
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz ;
                fixed3 worldNormal= normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                
                fixed3 worldLight=normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse=_LightColor0.rgb*_Diffise.rgb*saturate(dot(worldNormal,worldLight));

                o.color=diffuse+ambient;
                return  o;
            }
            
            fixed4 frag(v2f i):SV_TARGET
            {
                return fixed4(i.color,1.0);
            }

            ENDCG
        }
    }
    Fallback "Diffuse"
}