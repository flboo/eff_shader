Shader "Custom/BreakingMirror"
{
    Properties
    {
        [PerRendererData] _MainTex("Sprite Texture",2D)="white" {}
        [MaterialToggle] PixelSnap("Pixel Snap",float)=0
        Displacement("Displacement_Value",Range(-0.3,0.3))=0.022
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
            "Queue" = "Transparent" 
            "IgnoreProjector" = "true" 
            "RenderType" = "Transparent" 
            "PreviewType"="Plane" 
            "CanUseSpriteAtlas"="True"
        }

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
            #pragma multi_compile __ PIXELSNAP_ON
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
            float Displacement;
            float _SpriteFade;

            v2f vert(a2v IN)
            {
                v2f OUT;
                OUT.vertex=UnityObjectToClipPos(IN.vertex);
                OUT.texcoord=IN.texcoord;
                OUT.color=IN.color;
                return OUT;
            }


            float4 Generate_Xray(float2 uv, float posx, float posy, float number, float speed, float black)
            {
                uv -= float2(posx,posy);
                float dist = 1.;
                float a1 = atan2(uv.y,uv.x) + 3.14;
                a1 = a1 / 6.28;
                a1+=_Time * speed;
                a1 = abs(a1);
                if (fmod(a1 * number, 2.0) < 1) dist = 0.;
                float4 result = float4(1,1,1,dist);
                if (black == 1) result = float4(dist, dist, dist, 1);
                return result;
            }

            float2 SimpleDisplacementUV(float2 uv,float x, float y, float value)
            {
                return lerp(uv,uv+float2(x,y),value);
            }

            float4 frag (v2f i) : COLOR
            {
                float4 _Generate_Xray_1 = Generate_Xray(i.texcoord,0.5,0.5,16,2.429,0);
                float2 _Simple_Displacement_1 = SimpleDisplacementUV(i.texcoord,_Generate_Xray_1.r*_Generate_Xray_1.a,0,Displacement);
                float4 _MainTex_1 = tex2D(_MainTex,_Simple_Displacement_1);
                float4 FinalResult = _MainTex_1;
                FinalResult.rgb *= i.color.rgb;
                FinalResult.a = FinalResult.a * _SpriteFade * i.color.a;
                FinalResult.rgb *= FinalResult.a;
                FinalResult.a = saturate(FinalResult.a);
                return FinalResult;
            }

            ENDCG 
        }
    }
    Fallback "Sprites/Default"
}