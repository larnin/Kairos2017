// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.32 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.32;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:1,uamb:True,mssp:True,bkdf:True,hqlp:True,rprd:True,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:2980,x:34705,y:32736,varname:node_2980,prsc:2|diff-8561-OUT,custl-8561-OUT,olwid-7052-OUT;n:type:ShaderForge.SFN_Dot,id:8903,x:30746,y:32731,varname:node_8903,prsc:2,dt:4|A-451-OUT,B-9732-OUT;n:type:ShaderForge.SFN_LightVector,id:451,x:30478,y:32678,varname:node_451,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:9732,x:30478,y:32814,prsc:2,pt:True;n:type:ShaderForge.SFN_Multiply,id:2904,x:30962,y:32741,varname:node_2904,prsc:2|A-8903-OUT,B-6850-OUT;n:type:ShaderForge.SFN_Multiply,id:8561,x:33672,y:32758,varname:node_8561,prsc:2|A-4103-RGB,B-5800-OUT;n:type:ShaderForge.SFN_Slider,id:1072,x:33456,y:33203,ptovrint:False,ptlb:OutlineWidth,ptin:_OutlineWidth,varname:node_1072,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.008798556,max:0.1;n:type:ShaderForge.SFN_Tex2d,id:8026,x:33613,y:33300,ptovrint:False,ptlb:Clouds,ptin:_Clouds,varname:node_8026,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ba37349d2e148c743a23954dcb764e72,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Color,id:4103,x:32954,y:32470,ptovrint:False,ptlb:BaseColor,ptin:_BaseColor,varname:node_4103,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:7052,x:34045,y:33152,varname:node_7052,prsc:2|A-1072-OUT,B-8026-R;n:type:ShaderForge.SFN_LightAttenuation,id:6329,x:30307,y:32990,varname:node_6329,prsc:2;n:type:ShaderForge.SFN_Normalize,id:6850,x:30478,y:32990,varname:node_6850,prsc:2|IN-6329-OUT;n:type:ShaderForge.SFN_Clamp01,id:1534,x:31165,y:32741,varname:node_1534,prsc:2|IN-2904-OUT;n:type:ShaderForge.SFN_Step,id:5800,x:32954,y:32720,varname:node_5800,prsc:2|A-6264-OUT,B-1534-OUT;n:type:ShaderForge.SFN_Slider,id:6264,x:31008,y:32894,ptovrint:False,ptlb:ShadowSize,ptin:_ShadowSize,varname:node_6264,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;proporder:1072-8026-4103-6264;pass:END;sub:END;*/

Shader "Custom/SHD_Abstract" {
    Properties {
        _OutlineWidth ("OutlineWidth", Range(0, 0.1)) = 0.008798556
        _Clouds ("Clouds", 2D) = "white" {}
        _BaseColor ("BaseColor", Color) = (1,1,1,1)
        _ShadowSize ("ShadowSize", Range(0, 1)) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200
        Pass {
            Name "Outline"
            Tags {
            }
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform float _OutlineWidth;
            uniform sampler2D _Clouds; uniform float4 _Clouds_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 _Clouds_var = tex2Dlod(_Clouds,float4(TRANSFORM_TEX(o.uv0, _Clouds),0.0,0));
                o.pos = UnityObjectToClipPos(float4(v.vertex.xyz + v.normal*(_OutlineWidth*_Clouds_var.r),1) );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                return fixed4(float3(0,0,0),0);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _BaseColor;
            uniform float _ShadowSize;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 node_8561 = (_BaseColor.rgb*step(_ShadowSize,saturate((0.5*dot(lightDirection,normalDirection)+0.5*normalize(attenuation)))));
                float3 finalColor = node_8561;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _BaseColor;
            uniform float _ShadowSize;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 node_8561 = (_BaseColor.rgb*step(_ShadowSize,saturate((0.5*dot(lightDirection,normalDirection)+0.5*normalize(attenuation)))));
                float3 finalColor = node_8561;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
