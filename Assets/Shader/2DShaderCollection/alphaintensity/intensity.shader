Shader "Custom/intensity"
{
    Properties
    {

        [PerRendererData] _MainTex("Sprite Texture",2D)="white" {}
        _AlphaIntensity_Fade_1("_AlphaIntensity_Fade_1",Range(0,6))=1
        _SpriteFade("SpriteFade",Range(0,1))=1.0
        
        [HideInInspector]_StencilRef("_Stencil Ref",float)=8
        [HideInInspector]_StencilComp("_Stencil Comp",float)=0
        [HideInInspector]_StencilPass("_Stencil Pass",float)=0
        [HideInInspector]_StencilReadMask("_Stencil ReadMask",float)=255
        [HideInInspector]_StencilWriteMask("_Stencil WriteMask",float)=255
        [HideInInspector]_ColorMask("Color Mask", Float) = 15
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off

        Stencil
        {
            Ref[_StencilRef]
            Comp[_StencilComp]
            pass[_StencilPass]
            ReadMask[_StencilReadMask]
            WriteMask[_StencilWriteMask]
        }

        pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ABR_precision_hint_fastest
            #include "UnityCG.cginc"
            
            struct a2v
            {
                float4 vertex:POSITION;
                float4 color :COLOR;
                float2 texcood:TEXCOORD0;
            };

            struct v2f 
            {
                float2 texcood:TEXCOORD0;
                float4 vertex:SV_POSITION;
                float4 color :COLOR;
            };

            sampler2D _MainTex;
            float _SpriteFade;
            float _AlphaIntensity_Fade_1;

            v2f vert(a2v IN)
            {
                v2f OUT;
                OUT.vertex=UnityObjectToClipPos(IN.vertex);
                OUT.texcood=IN.texcood;
                OUT.color=IN.color;
                return OUT;
            } 

            float4 AlphaIntensity(float4 txt,float fade)
            {
                if (txt.a<1)
                {
                    txt.a= txt.a*fade; 
                }
                return txt;
            }
            
            float4 frag(v2f i):COLOR
            {
                float4 _MainTex_1=tex2D(_MainTex,i.texcood);
                float4 AlphaIntensity_1=AlphaIntensity(_MainTex_1,_AlphaIntensity_Fade_1);
                float4 FinalResult=AlphaIntensity_1;
                FinalResult.rgb*=i.color.rgb;
                FinalResult.a=FinalResult.a*_SpriteFade*i.color.a;
                return FinalResult;
            }
            

            ENDCG
        }
    }
    Fallback "Sprites/Default"
}