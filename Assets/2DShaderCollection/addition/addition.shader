Shader "Custom/addition"
{
    Properties
    {
        [PerRenderData] _MainTex ("Sprite Texture", 2D) = "white" { }
        _SpriteFade ("SpriteFade", Range(0, 1)) = 1.0
        
        [HideInInspector] _StencilComp ("Stencil Comparison", float) = 8
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

        SubShader {
            
        }
    }
    FallBack "Sprites/Default"
}