Shader "Custom/addition"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" { }
        _SpriteFade ("SpriteFade", Range(0, 1)) = 1.0
        
        [HideInInspector] _Stencil ("Stencil Ref", float) = 8
        [HideInInspector] _StencilComp ("Stencil Comp", float) = 0
        [HideInInspector] _StencilOp ("Stencil pass", float) = 0
        [HideInInspector] _StencilReadMask ("Stencil ReadMask", float) = 255
        [HideInInspector] _StencilWriteMask ("Stencil WriteMask", float) = 255
        [HideInInspector]_ColorMask("Color Mask", Float) = 15
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "true"
            "Renderype" = "Transparent" 
            "PreviewType" = "Plane" 
            "CanUseSpriteAtlas" = "True"
        }
        ZWrite Off
        // Blend SrcAlpha One
        Blend SrcAlpha OneMinusSrcAlpha
        Cull off

        Stencil
        {
            Ref[_Stencil]
            Comp[_StencilComp]
            pass[_StencilOp]
            ReadMask[_StencilReadMask]
            WriteMask[_StencilWriteMask]
        }

        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            struct appdata_t{
                float4 vertex:POSITION;
                float4 color :COLOR;
                float2 texcoord :TEXCOORD;
            };
            
            struct v2f{
                float2 texcoord :TEXCOORD;
                float4 vertex:SV_POSITION;
                float4 color :COLOR;
            };

            sampler2D _MainTex;
            float _SpriteFade;
            v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.vertex=UnityObjectToClipPos(IN.vertex);
                OUT.texcoord=IN.texcoord;
                OUT.color=IN.color;
                return OUT;
            }

            float4 frag(v2f i):COLOR
            {
                float4 _MainTex1=tex2D(_MainTex,i.texcoord);
                float4 FinalResult=_MainTex1;
                FinalResult.rgb =  FinalResult.rgb*i.color.rgb;
                FinalResult.a=FinalResult.a*_SpriteFade*i.color.a;
                return FinalResult;
            }
            ENDCG
        }
        
    }
    FallBack "Sprites/Default"
}