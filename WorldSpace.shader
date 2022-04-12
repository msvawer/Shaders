Shader "Unlit/WorldSpace"
{
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                
            };

            struct v2f
            {
               
                
                float4 vertex : SV_POSITION;
                float3 worldPosition : TEXCOORD0;
            };

            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                float4 ws = mul(unity_ObjectToWorld, v.vertex);
                o.worldPosition = ws.xyz;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                
                return float4(i.worldPosition, 1.0 );
            }
            ENDCG
        }
    }
}
