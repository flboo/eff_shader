Shader "Custom/spritelerp"
{
    Properties
    {

        [PerRendererData] _MainTex("Sprite Texture",2D)="white" {}
        _NewTex_1("NewTex_1(RGB)",2D)="white"{}
        _AutomaticLerp_Spee_1("AutomaticLerp_Spee_1",Range(0,1))=1
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
        Tags {"Queue" = "Transparent" "IgnoreProjector" = "true" "RenderType" = "Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off

        // required for UI.Mask
        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include  "UnityCG.cginc"
            
            struct a2v{
                float4 vertex :POSITION;
                float4 color: COLOR;
                float2 texcoord:TEXCOORD0;
            };

            struct v2f
            {
                float2 texcoord:TEXCOORD0;
                float4 vertex:SV_POSITION;
                float4 color:COLOR;
            };
            
            sampler2D _MainTex;
            sampler2D _NewTex_1;
            float _AutomaticLerp_Spee_1;
            float _SpriteFade;

            v2f vert(a2v IN)
            {
                v2f OUT;
                OUT.vertex=UnityObjectToClipPos(IN.vertex);
                OUT.texcoord=IN.texcoord;
                OUT.color=IN.color;
                return OUT;
            }

            float4 frag(v2f i):COLOR
            {
                float4 _MainTex_1=tex2D(_MainTex,i.texcoord);
                float4 NewTex_1=tex2D(_NewTex_1,i.texcoord);

                // _MainTex_1.rgb=lerp(_MainTex_1.rgb,NewTex_1.rgb,1-_MainTex_1.a);
                // NewTex_1.rgb=lerp(_MainTex_1.rgb,NewTex_1.rgb,NewTex_1.a);
                
                float4 FinalRasult=lerp(_MainTex_1,NewTex_1,_AutomaticLerp_Spee_1);
                return FinalRasult;
            }
            ENDCG 
        }
    }
    Fallback "Sprites/Default"
}