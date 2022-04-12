Shader "Unlit/Halogram"
{
    Properties //declare properties which will later need to be declared in CG program
    {    //_NameinScript ("Name in Editor", type) set to ...
        _MainTex ("Texture", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1, 1, 1, 1)
        _Transparency("Transparency", Range(0.0,0.5)) = 0.25
        _CutoutThresh("Cutout Threshold", Range(0.0, 1.0)) = 0.2

            //variables for vertex manipulation via a sine in vertex func
        _Distance("Distance", Float) = 1
        _Amplitude("Amplitude", Float) = 1
        _Speed ("Speed", Float) = 1
        _Amount ("Amount", Range(0.0,1.0)) = 1

    }
    SubShader
    {
            //subshader syntax tags rendering order matters 
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" } //render types can be opaque, transparent 
        LOD 100

         //tells it not to render to depth buffer turn off for semi transparent objects
         ZWrite Off  
         Blend srcAlpha OneMinusSrcAlpha 

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            //variables declaring in CG program convention to underscore before name 
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _TintColor; 
            float _Transparency; 
            float _CutoutThresh;

            float _Distance;
            float _Amplitude;
            float _Speed;
            float _Amount;

            v2f vert (appdata v)
            {
                v2f o;
                //manipulating vertices 
                v.vertex.x += sin(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance * _Amount;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) + _TintColor;
                col.a = _Transparency; 
                //clip out or cut out any pixels that have less red than cutout threshold
                clip(col.r - _CutoutThresh); 
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
