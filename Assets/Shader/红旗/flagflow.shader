Shader "Hidden/flagflow"
{
    Properties
    {
        [PerRendererData]
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Main Color",color)=(1,1,1,1)
        _WaveX("Wave X",Range(0,1))=0.1
        _WaveZ("Wave Z",Range(0,1))=0.1
        _WindSpeed("Speed",Range(50,200))=200
    }
    
    SubShader
    {
        // Cull Off ZWrite Off ZTest Always
        Pass
        {
            Cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            struct a2v
            {
                float4 vertex:POSITION;
                float4 texcoord:TEXCOORD0;
            };

            struct v2f
            {
                float4 pos:POSITION;
                float2 uv:TEXCOORD0;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            float _WaveX;
            float _WaveZ;
            float _WindSpeed;

            v2f vert(a2v v)
            {
                v2f o;
                float angle=_Time*_WindSpeed;
                if(v.vertex.x<5)
                {
                    v.vertex.z=v.vertex.z+sin(v.vertex.x+angle)*_WaveX;
                    v.vertex.x=v.vertex.x+sin(v.vertex.z+angle)*_WaveZ;
                }

                v.vertex.z-=(v.vertex.x) * 0.4;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv =v.texcoord;
                return o;
            }

            fixed4 frag(v2f i):COLOR
            {
                fixed4 color =saturate(tex2D(_MainTex,i.uv))*0.8;
                return color;
            }

            ENDCG

        }
    }
}
