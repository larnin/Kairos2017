// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.32 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.32;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:3,spmd:1,trmd:0,grmd:1,uamb:True,mssp:True,bkdf:True,hqlp:True,rprd:True,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:False,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:2980,x:35257,y:32752,varname:node_2980,prsc:2|diff-8922-OUT,spec-3313-OUT,gloss-2627-OUT,normal-4630-OUT,emission-5615-OUT,olwid-7052-OUT;n:type:ShaderForge.SFN_Tex2d,id:3413,x:32101,y:32453,ptovrint:False,ptlb:Albedo,ptin:_Albedo,varname:node_3413,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:6b945e39de12bf34ab4880818ca028f6,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Dot,id:8903,x:30746,y:32731,varname:node_8903,prsc:2,dt:4|A-451-OUT,B-9732-OUT;n:type:ShaderForge.SFN_LightVector,id:451,x:30478,y:32678,varname:node_451,prsc:2;n:type:ShaderForge.SFN_NormalVector,id:9732,x:30478,y:32814,prsc:2,pt:True;n:type:ShaderForge.SFN_Multiply,id:2904,x:30962,y:32741,varname:node_2904,prsc:2|A-8903-OUT,B-6850-OUT;n:type:ShaderForge.SFN_Multiply,id:8561,x:33672,y:32758,varname:node_8561,prsc:2|A-4016-OUT,B-5355-OUT;n:type:ShaderForge.SFN_Rotator,id:3725,x:31011,y:31888,varname:node_3725,prsc:2|UVIN-6752-OUT,ANG-6548-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:5771,x:30527,y:31899,ptovrint:False,ptlb:Crayon,ptin:_Crayon,varname:node_5771,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a501453cc08e2d443893d1f88e5d5e58,ntxv:0,isnm:False;n:type:ShaderForge.SFN_ValueProperty,id:6548,x:30527,y:32085,ptovrint:False,ptlb:Crayon2 Pivot,ptin:_Crayon2Pivot,varname:node_6548,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_Slider,id:1072,x:32778,y:33361,ptovrint:False,ptlb:OutlineWidth,ptin:_OutlineWidth,varname:node_1072,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.008798556,max:0.1;n:type:ShaderForge.SFN_Tex2d,id:8026,x:32282,y:33256,ptovrint:False,ptlb:Clouds,ptin:_Clouds,varname:node_8026,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ba37349d2e148c743a23954dcb764e72,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Lerp,id:3681,x:32388,y:32736,varname:node_3681,prsc:2|A-5759-OUT,B-9833-OUT,T-2556-OUT;n:type:ShaderForge.SFN_Tex2d,id:8033,x:33721,y:32923,ptovrint:False,ptlb:Normal Map,ptin:_NormalMap,varname:node_8033,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_NormalVector,id:3053,x:30678,y:31099,prsc:2,pt:True;n:type:ShaderForge.SFN_Abs,id:5232,x:30863,y:31099,varname:node_5232,prsc:2|IN-3053-OUT;n:type:ShaderForge.SFN_Multiply,id:1948,x:31048,y:31099,varname:node_1948,prsc:2|A-5232-OUT,B-5232-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:2444,x:30233,y:31570,varname:node_2444,prsc:2;n:type:ShaderForge.SFN_Append,id:6752,x:30872,y:31428,cmnt:iz projection,varname:node_6752,prsc:2|A-9666-B,B-9666-G;n:type:ShaderForge.SFN_Append,id:4720,x:30872,y:31573,cmnt:zx projection,varname:node_4720,prsc:2|A-9666-R,B-9666-B;n:type:ShaderForge.SFN_Append,id:7542,x:30872,y:31720,cmnt:ix projection,varname:node_7542,prsc:2|A-9666-R,B-9666-G;n:type:ShaderForge.SFN_ComponentMask,id:9666,x:30497,y:31568,varname:node_9666,prsc:2,cc1:0,cc2:1,cc3:2,cc4:-1|IN-2444-XYZ;n:type:ShaderForge.SFN_Tex2d,id:9083,x:31170,y:31429,varname:node_9083,prsc:2,tex:a501453cc08e2d443893d1f88e5d5e58,ntxv:0,isnm:False|UVIN-6752-OUT,TEX-5771-TEX;n:type:ShaderForge.SFN_Tex2d,id:6666,x:31170,y:31723,varname:node_6666,prsc:2,tex:a501453cc08e2d443893d1f88e5d5e58,ntxv:0,isnm:False|UVIN-7542-OUT,TEX-5771-TEX;n:type:ShaderForge.SFN_Tex2d,id:2133,x:31170,y:31574,varname:node_2133,prsc:2,tex:a501453cc08e2d443893d1f88e5d5e58,ntxv:0,isnm:False|UVIN-4720-OUT,TEX-5771-TEX;n:type:ShaderForge.SFN_ChannelBlend,id:5759,x:31543,y:31574,varname:node_5759,prsc:2,chbt:0|M-1948-OUT,R-9083-RGB,G-2133-RGB,B-6666-RGB,A-2098-OUT;n:type:ShaderForge.SFN_Rotator,id:3579,x:30995,y:32041,varname:node_3579,prsc:2|UVIN-4720-OUT,ANG-6548-OUT;n:type:ShaderForge.SFN_Rotator,id:847,x:30995,y:32190,varname:node_847,prsc:2|UVIN-7542-OUT,ANG-6548-OUT;n:type:ShaderForge.SFN_ChannelBlend,id:3692,x:31550,y:32057,varname:node_3692,prsc:2,chbt:0|M-1948-OUT,R-3469-RGB,G-9300-RGB,B-6648-RGB,A-2098-OUT;n:type:ShaderForge.SFN_Tex2d,id:3469,x:31166,y:31901,varname:node_3469,prsc:2,tex:a501453cc08e2d443893d1f88e5d5e58,ntxv:0,isnm:False|UVIN-3725-UVOUT,TEX-5771-TEX;n:type:ShaderForge.SFN_Tex2d,id:6648,x:31166,y:32190,varname:node_6648,prsc:2,tex:a501453cc08e2d443893d1f88e5d5e58,ntxv:0,isnm:False|UVIN-847-UVOUT,TEX-5771-TEX;n:type:ShaderForge.SFN_Tex2d,id:9300,x:31166,y:32041,varname:node_9300,prsc:2,tex:a501453cc08e2d443893d1f88e5d5e58,ntxv:0,isnm:False|UVIN-3579-UVOUT,TEX-5771-TEX;n:type:ShaderForge.SFN_Multiply,id:4016,x:33194,y:32470,varname:node_4016,prsc:2|A-4103-RGB,B-3413-RGB;n:type:ShaderForge.SFN_Color,id:4103,x:32101,y:32291,ptovrint:False,ptlb:BaseColor,ptin:_BaseColor,varname:node_4103,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Slider,id:2451,x:33469,y:32358,ptovrint:False,ptlb:Metalness,ptin:_Metalness,varname:node_2451,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:4879,x:33469,y:32671,ptovrint:False,ptlb:Roughness,ptin:_Roughness,varname:node_4879,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Multiply,id:7052,x:33215,y:33213,varname:node_7052,prsc:2|A-1072-OUT,B-8026-R;n:type:ShaderForge.SFN_Clamp01,id:7270,x:32904,y:32831,varname:node_7270,prsc:2|IN-5076-OUT;n:type:ShaderForge.SFN_Vector1,id:9833,x:31976,y:32660,varname:node_9833,prsc:2,v1:1;n:type:ShaderForge.SFN_Lerp,id:5355,x:33246,y:32829,varname:node_5355,prsc:2|A-7270-OUT,B-2315-OUT,T-8108-OUT;n:type:ShaderForge.SFN_Vector1,id:2315,x:32904,y:32961,varname:node_2315,prsc:2,v1:1;n:type:ShaderForge.SFN_Slider,id:8108,x:32753,y:33254,ptovrint:False,ptlb:Opacity,ptin:_Opacity,varname:node_8108,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Clamp01,id:2556,x:32042,y:32742,varname:node_2556,prsc:2|IN-8957-OUT;n:type:ShaderForge.SFN_Add,id:8957,x:31793,y:32729,varname:node_8957,prsc:2|A-9781-OUT,B-9781-OUT;n:type:ShaderForge.SFN_Lerp,id:1505,x:32388,y:32873,varname:node_1505,prsc:2|A-3692-OUT,B-9833-OUT,T-4242-OUT;n:type:ShaderForge.SFN_Multiply,id:5076,x:32619,y:32840,varname:node_5076,prsc:2|A-3681-OUT,B-1505-OUT;n:type:ShaderForge.SFN_Clamp01,id:4242,x:32042,y:32864,varname:node_4242,prsc:2|IN-5391-OUT;n:type:ShaderForge.SFN_Add,id:5391,x:31793,y:32864,varname:node_5391,prsc:2|A-8957-OUT,B-8957-OUT;n:type:ShaderForge.SFN_Vector1,id:2098,x:31331,y:31854,varname:node_2098,prsc:2,v1:1;n:type:ShaderForge.SFN_Power,id:9781,x:31354,y:32741,varname:node_9781,prsc:2|VAL-1534-OUT,EXP-9410-OUT;n:type:ShaderForge.SFN_Slider,id:9410,x:30962,y:32911,ptovrint:False,ptlb:node_9410,ptin:_node_9410,varname:node_9410,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:1,max:5;n:type:ShaderForge.SFN_LightAttenuation,id:6329,x:30307,y:32990,varname:node_6329,prsc:2;n:type:ShaderForge.SFN_Tex2d,id:4615,x:30261,y:31840,varname:node_4615,prsc:2,tex:a501453cc08e2d443893d1f88e5d5e58,ntxv:0,isnm:False|TEX-5771-TEX;n:type:ShaderForge.SFN_Normalize,id:6850,x:30478,y:32990,varname:node_6850,prsc:2|IN-6329-OUT;n:type:ShaderForge.SFN_Clamp01,id:1534,x:31165,y:32741,varname:node_1534,prsc:2|IN-2904-OUT;n:type:ShaderForge.SFN_Multiply,id:2242,x:33878,y:32420,varname:node_2242,prsc:2|A-9348-R,B-2451-OUT;n:type:ShaderForge.SFN_Tex2d,id:9348,x:33605,y:32188,ptovrint:False,ptlb:MetalnessTex,ptin:_MetalnessTex,varname:node_9348,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2349,x:33626,y:32434,ptovrint:False,ptlb:RoughnessTex,ptin:_RoughnessTex,varname:node_2349,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Lerp,id:9525,x:33887,y:32557,varname:node_9525,prsc:2|A-2349-R,B-9382-OUT,T-4879-OUT;n:type:ShaderForge.SFN_Vector1,id:9382,x:33626,y:32589,varname:node_9382,prsc:2,v1:1;n:type:ShaderForge.SFN_Color,id:9021,x:34093,y:32862,ptovrint:False,ptlb:EmissiveColor,ptin:_EmissiveColor,varname:node_9021,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:3460,x:34353,y:32889,varname:node_3460,prsc:2|A-9021-RGB,B-5847-OUT;n:type:ShaderForge.SFN_Slider,id:5847,x:33888,y:33085,ptovrint:False,ptlb:EmissiveStrength,ptin:_EmissiveStrength,varname:node_5847,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Vector1,id:1151,x:31774,y:33274,varname:node_1151,prsc:2,v1:0;n:type:ShaderForge.SFN_Step,id:6478,x:34353,y:33069,varname:node_6478,prsc:2|A-8248-OUT,B-2904-OUT;n:type:ShaderForge.SFN_Slider,id:8248,x:33888,y:33194,ptovrint:False,ptlb:ShadowZone,ptin:_ShadowZone,varname:node_8248,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.3089881,max:1;n:type:ShaderForge.SFN_Vector1,id:733,x:34561,y:32746,varname:node_733,prsc:2,v1:0;n:type:ShaderForge.SFN_Lerp,id:8922,x:34787,y:32733,varname:node_8922,prsc:2|A-8561-OUT,B-733-OUT,T-5026-OUT;n:type:ShaderForge.SFN_Slider,id:5026,x:34300,y:32505,ptovrint:False,ptlb:AbstractEffect,ptin:_AbstractEffect,varname:node_5026,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:4086,x:34561,y:32818,varname:node_4086,prsc:2,v1:0;n:type:ShaderForge.SFN_Lerp,id:3313,x:34787,y:32858,varname:node_3313,prsc:2|A-2242-OUT,B-4086-OUT,T-5026-OUT;n:type:ShaderForge.SFN_Lerp,id:2627,x:34787,y:32973,varname:node_2627,prsc:2|A-9525-OUT,B-4377-OUT,T-5026-OUT;n:type:ShaderForge.SFN_Vector1,id:4377,x:34560,y:32907,varname:node_4377,prsc:2,v1:1;n:type:ShaderForge.SFN_Vector3,id:9324,x:34561,y:33213,varname:node_9324,prsc:2,v1:0.4980392,v2:0.4980392,v3:1;n:type:ShaderForge.SFN_Lerp,id:4630,x:34799,y:33089,varname:node_4630,prsc:2|A-8033-RGB,B-9324-OUT,T-5026-OUT;n:type:ShaderForge.SFN_Lerp,id:5615,x:34781,y:33283,varname:node_5615,prsc:2|A-6314-OUT,B-6478-OUT,T-5026-OUT;n:type:ShaderForge.SFN_Vector1,id:6314,x:34398,y:33429,varname:node_6314,prsc:2,v1:0;proporder:3413-5771-6548-1072-8026-8033-4103-2451-4879-8108-9410-2349-9348-9021-5847-5026-8248;pass:END;sub:END;*/

Shader "Custom/SHD_Crayon01_Triplanar" {
    Properties {
        _Albedo ("Albedo", 2D) = "white" {}
        _Crayon ("Crayon", 2D) = "white" {}
        _Crayon2Pivot ("Crayon2 Pivot", Float ) = 0.1
        _OutlineWidth ("OutlineWidth", Range(0, 0.1)) = 0.008798556
        _Clouds ("Clouds", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _BaseColor ("BaseColor", Color) = (1,1,1,1)
        _Metalness ("Metalness", Range(0, 1)) = 0
        _Roughness ("Roughness", Range(0, 1)) = 1
        _Opacity ("Opacity", Range(0, 1)) = 0
        _node_9410 ("node_9410", Range(1, 5)) = 1
        _RoughnessTex ("RoughnessTex", 2D) = "black" {}
        _MetalnessTex ("MetalnessTex", 2D) = "white" {}
        _EmissiveColor ("EmissiveColor", Color) = (0.5,0.5,0.5,1)
        _EmissiveStrength ("EmissiveStrength", Range(0, 10)) = 0
        _AbstractEffect ("AbstractEffect", Range(0, 1)) = 0
        _ShadowZone ("ShadowZone", Range(0, 1)) = 0.3089881
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
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform float _OutlineWidth;
            uniform sampler2D _Clouds; uniform float4 _Clouds_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float4 _Clouds_var = tex2Dlod(_Clouds,float4(TRANSFORM_TEX(o.uv0, _Clouds),0.0,0));
                o.pos = UnityObjectToClipPos(float4(v.vertex.xyz + v.normal*(_OutlineWidth*_Clouds_var.r),1) );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
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
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _Albedo; uniform float4 _Albedo_ST;
            uniform sampler2D _Crayon; uniform float4 _Crayon_ST;
            uniform float _Crayon2Pivot;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            uniform float4 _BaseColor;
            uniform float _Metalness;
            uniform float _Roughness;
            uniform float _Opacity;
            uniform float _node_9410;
            uniform sampler2D _MetalnessTex; uniform float4 _MetalnessTex_ST;
            uniform sampler2D _RoughnessTex; uniform float4 _RoughnessTex_ST;
            uniform float _ShadowZone;
            uniform float _AbstractEffect;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
                #if defined(LIGHTMAP_ON) || defined(UNITY_SHOULD_SAMPLE_SH)
                    float4 ambientOrLightmapUV : TEXCOORD10;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                #ifdef LIGHTMAP_ON
                    o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                    o.ambientOrLightmapUV.zw = 0;
                #endif
                #ifdef DYNAMICLIGHTMAP_ON
                    o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                #endif
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 normalLocal = lerp(_NormalMap_var.rgb,float3(0.4980392,0.4980392,1),_AbstractEffect);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _RoughnessTex_var = tex2D(_RoughnessTex,TRANSFORM_TEX(i.uv0, _RoughnessTex));
                float gloss = 1.0 - lerp(lerp(_RoughnessTex_var.r,1.0,_Roughness),1.0,_AbstractEffect); // Convert roughness to gloss
                float specPow = exp2( gloss * 10.0+1.0);
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
                    d.ambient = 0;
                    d.lightmapUV = i.ambientOrLightmapUV;
                #else
                    d.ambient = i.ambientOrLightmapUV;
                #endif
                #if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                float LdotH = max(0.0,dot(lightDirection, halfDirection));
                float4 _MetalnessTex_var = tex2D(_MetalnessTex,TRANSFORM_TEX(i.uv0, _MetalnessTex));
                float3 specularColor = lerp((_MetalnessTex_var.r*_Metalness),0.0,_AbstractEffect);
                float specularMonochrome;
                float4 _Albedo_var = tex2D(_Albedo,TRANSFORM_TEX(i.uv0, _Albedo));
                float3 node_5232 = abs(normalDirection);
                float3 node_1948 = (node_5232*node_5232);
                float3 node_9666 = i.posWorld.rgb.rgb;
                float2 node_6752 = float2(node_9666.b,node_9666.g); // iz projection
                float4 node_9083 = tex2D(_Crayon,TRANSFORM_TEX(node_6752, _Crayon));
                float2 node_4720 = float2(node_9666.r,node_9666.b); // zx projection
                float4 node_2133 = tex2D(_Crayon,TRANSFORM_TEX(node_4720, _Crayon));
                float2 node_7542 = float2(node_9666.r,node_9666.g); // ix projection
                float4 node_6666 = tex2D(_Crayon,TRANSFORM_TEX(node_7542, _Crayon));
                float node_9833 = 1.0;
                float node_2904 = (0.5*dot(lightDirection,normalDirection)+0.5*normalize(attenuation));
                float node_9781 = pow(saturate(node_2904),_node_9410);
                float node_8957 = (node_9781+node_9781);
                float node_3725_ang = _Crayon2Pivot;
                float node_3725_spd = 1.0;
                float node_3725_cos = cos(node_3725_spd*node_3725_ang);
                float node_3725_sin = sin(node_3725_spd*node_3725_ang);
                float2 node_3725_piv = float2(0.5,0.5);
                float2 node_3725 = (mul(node_6752-node_3725_piv,float2x2( node_3725_cos, -node_3725_sin, node_3725_sin, node_3725_cos))+node_3725_piv);
                float4 node_3469 = tex2D(_Crayon,TRANSFORM_TEX(node_3725, _Crayon));
                float node_3579_ang = _Crayon2Pivot;
                float node_3579_spd = 1.0;
                float node_3579_cos = cos(node_3579_spd*node_3579_ang);
                float node_3579_sin = sin(node_3579_spd*node_3579_ang);
                float2 node_3579_piv = float2(0.5,0.5);
                float2 node_3579 = (mul(node_4720-node_3579_piv,float2x2( node_3579_cos, -node_3579_sin, node_3579_sin, node_3579_cos))+node_3579_piv);
                float4 node_9300 = tex2D(_Crayon,TRANSFORM_TEX(node_3579, _Crayon));
                float node_847_ang = _Crayon2Pivot;
                float node_847_spd = 1.0;
                float node_847_cos = cos(node_847_spd*node_847_ang);
                float node_847_sin = sin(node_847_spd*node_847_ang);
                float2 node_847_piv = float2(0.5,0.5);
                float2 node_847 = (mul(node_7542-node_847_piv,float2x2( node_847_cos, -node_847_sin, node_847_sin, node_847_cos))+node_847_piv);
                float4 node_6648 = tex2D(_Crayon,TRANSFORM_TEX(node_847, _Crayon));
                float node_2315 = 1.0;
                float node_733 = 0.0;
                float3 diffuseColor = lerp(((_BaseColor.rgb*_Albedo_var.rgb)*lerp(saturate((lerp((node_1948.r*node_9083.rgb + node_1948.g*node_2133.rgb + node_1948.b*node_6666.rgb),float3(node_9833,node_9833,node_9833),saturate(node_8957))*lerp((node_1948.r*node_3469.rgb + node_1948.g*node_9300.rgb + node_1948.b*node_6648.rgb),float3(node_9833,node_9833,node_9833),saturate((node_8957+node_8957))))),float3(node_2315,node_2315,node_2315),_Opacity)),float3(node_733,node_733,node_733),_AbstractEffect); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = max(0.0,dot( normalDirection, viewDirection ));
                float NdotH = max(0.0,dot( normalDirection, halfDirection ));
                float VdotH = max(0.0,dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, 1.0-gloss );
                float normTerm = max(0.0, GGXTerm(NdotH, 1.0-gloss));
                float specularPBL = (NdotL*visTerm*normTerm) * (UNITY_PI / 4);
                if (IsGammaSpace())
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                specularPBL = max(0, specularPBL * NdotL);
                float3 directSpecular = (floor(attenuation) * _LightColor0.xyz)*specularPBL*FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular);
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += gi.indirect.diffuse;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float node_5615 = lerp(0.0,step(_ShadowZone,node_2904),_AbstractEffect);
                float3 emissive = float3(node_5615,node_5615,node_5615);
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
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
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _Albedo; uniform float4 _Albedo_ST;
            uniform sampler2D _Crayon; uniform float4 _Crayon_ST;
            uniform float _Crayon2Pivot;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            uniform float4 _BaseColor;
            uniform float _Metalness;
            uniform float _Roughness;
            uniform float _Opacity;
            uniform float _node_9410;
            uniform sampler2D _MetalnessTex; uniform float4 _MetalnessTex_ST;
            uniform sampler2D _RoughnessTex; uniform float4 _RoughnessTex_ST;
            uniform float _ShadowZone;
            uniform float _AbstractEffect;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
                float3 tangentDir : TEXCOORD5;
                float3 bitangentDir : TEXCOORD6;
                LIGHTING_COORDS(7,8)
                UNITY_FOG_COORDS(9)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 normalLocal = lerp(_NormalMap_var.rgb,float3(0.4980392,0.4980392,1),_AbstractEffect);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _RoughnessTex_var = tex2D(_RoughnessTex,TRANSFORM_TEX(i.uv0, _RoughnessTex));
                float gloss = 1.0 - lerp(lerp(_RoughnessTex_var.r,1.0,_Roughness),1.0,_AbstractEffect); // Convert roughness to gloss
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                float LdotH = max(0.0,dot(lightDirection, halfDirection));
                float4 _MetalnessTex_var = tex2D(_MetalnessTex,TRANSFORM_TEX(i.uv0, _MetalnessTex));
                float3 specularColor = lerp((_MetalnessTex_var.r*_Metalness),0.0,_AbstractEffect);
                float specularMonochrome;
                float4 _Albedo_var = tex2D(_Albedo,TRANSFORM_TEX(i.uv0, _Albedo));
                float3 node_5232 = abs(normalDirection);
                float3 node_1948 = (node_5232*node_5232);
                float3 node_9666 = i.posWorld.rgb.rgb;
                float2 node_6752 = float2(node_9666.b,node_9666.g); // iz projection
                float4 node_9083 = tex2D(_Crayon,TRANSFORM_TEX(node_6752, _Crayon));
                float2 node_4720 = float2(node_9666.r,node_9666.b); // zx projection
                float4 node_2133 = tex2D(_Crayon,TRANSFORM_TEX(node_4720, _Crayon));
                float2 node_7542 = float2(node_9666.r,node_9666.g); // ix projection
                float4 node_6666 = tex2D(_Crayon,TRANSFORM_TEX(node_7542, _Crayon));
                float node_9833 = 1.0;
                float node_2904 = (0.5*dot(lightDirection,normalDirection)+0.5*normalize(attenuation));
                float node_9781 = pow(saturate(node_2904),_node_9410);
                float node_8957 = (node_9781+node_9781);
                float node_3725_ang = _Crayon2Pivot;
                float node_3725_spd = 1.0;
                float node_3725_cos = cos(node_3725_spd*node_3725_ang);
                float node_3725_sin = sin(node_3725_spd*node_3725_ang);
                float2 node_3725_piv = float2(0.5,0.5);
                float2 node_3725 = (mul(node_6752-node_3725_piv,float2x2( node_3725_cos, -node_3725_sin, node_3725_sin, node_3725_cos))+node_3725_piv);
                float4 node_3469 = tex2D(_Crayon,TRANSFORM_TEX(node_3725, _Crayon));
                float node_3579_ang = _Crayon2Pivot;
                float node_3579_spd = 1.0;
                float node_3579_cos = cos(node_3579_spd*node_3579_ang);
                float node_3579_sin = sin(node_3579_spd*node_3579_ang);
                float2 node_3579_piv = float2(0.5,0.5);
                float2 node_3579 = (mul(node_4720-node_3579_piv,float2x2( node_3579_cos, -node_3579_sin, node_3579_sin, node_3579_cos))+node_3579_piv);
                float4 node_9300 = tex2D(_Crayon,TRANSFORM_TEX(node_3579, _Crayon));
                float node_847_ang = _Crayon2Pivot;
                float node_847_spd = 1.0;
                float node_847_cos = cos(node_847_spd*node_847_ang);
                float node_847_sin = sin(node_847_spd*node_847_ang);
                float2 node_847_piv = float2(0.5,0.5);
                float2 node_847 = (mul(node_7542-node_847_piv,float2x2( node_847_cos, -node_847_sin, node_847_sin, node_847_cos))+node_847_piv);
                float4 node_6648 = tex2D(_Crayon,TRANSFORM_TEX(node_847, _Crayon));
                float node_2315 = 1.0;
                float node_733 = 0.0;
                float3 diffuseColor = lerp(((_BaseColor.rgb*_Albedo_var.rgb)*lerp(saturate((lerp((node_1948.r*node_9083.rgb + node_1948.g*node_2133.rgb + node_1948.b*node_6666.rgb),float3(node_9833,node_9833,node_9833),saturate(node_8957))*lerp((node_1948.r*node_3469.rgb + node_1948.g*node_9300.rgb + node_1948.b*node_6648.rgb),float3(node_9833,node_9833,node_9833),saturate((node_8957+node_8957))))),float3(node_2315,node_2315,node_2315),_Opacity)),float3(node_733,node_733,node_733),_AbstractEffect); // Need this for specular when using metallic
                diffuseColor = DiffuseAndSpecularFromMetallic( diffuseColor, specularColor, specularColor, specularMonochrome );
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = max(0.0,dot( normalDirection, viewDirection ));
                float NdotH = max(0.0,dot( normalDirection, halfDirection ));
                float VdotH = max(0.0,dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, 1.0-gloss );
                float normTerm = max(0.0, GGXTerm(NdotH, 1.0-gloss));
                float specularPBL = (NdotL*visTerm*normTerm) * (UNITY_PI / 4);
                if (IsGammaSpace())
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                specularPBL = max(0, specularPBL * NdotL);
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "Meta"
            Tags {
                "LightMode"="Meta"
            }
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_META 1
            #define SHOULD_SAMPLE_SH ( defined (LIGHTMAP_OFF) && defined(DYNAMICLIGHTMAP_OFF) )
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #include "UnityMetaPass.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _Albedo; uniform float4 _Albedo_ST;
            uniform sampler2D _Crayon; uniform float4 _Crayon_ST;
            uniform float _Crayon2Pivot;
            uniform float4 _BaseColor;
            uniform float _Metalness;
            uniform float _Roughness;
            uniform float _Opacity;
            uniform float _node_9410;
            uniform sampler2D _MetalnessTex; uniform float4 _MetalnessTex_ST;
            uniform sampler2D _RoughnessTex; uniform float4 _RoughnessTex_ST;
            uniform float _ShadowZone;
            uniform float _AbstractEffect;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float4 posWorld : TEXCOORD3;
                float3 normalDir : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.uv2 = v.texcoord2;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST );
                return o;
            }
            float4 frag(VertexOutput i) : SV_Target {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT( UnityMetaInput, o );
                
                float node_2904 = (0.5*dot(lightDirection,normalDirection)+0.5*normalize(attenuation));
                float node_5615 = lerp(0.0,step(_ShadowZone,node_2904),_AbstractEffect);
                o.Emission = float3(node_5615,node_5615,node_5615);
                
                float4 _Albedo_var = tex2D(_Albedo,TRANSFORM_TEX(i.uv0, _Albedo));
                float3 node_5232 = abs(normalDirection);
                float3 node_1948 = (node_5232*node_5232);
                float3 node_9666 = i.posWorld.rgb.rgb;
                float2 node_6752 = float2(node_9666.b,node_9666.g); // iz projection
                float4 node_9083 = tex2D(_Crayon,TRANSFORM_TEX(node_6752, _Crayon));
                float2 node_4720 = float2(node_9666.r,node_9666.b); // zx projection
                float4 node_2133 = tex2D(_Crayon,TRANSFORM_TEX(node_4720, _Crayon));
                float2 node_7542 = float2(node_9666.r,node_9666.g); // ix projection
                float4 node_6666 = tex2D(_Crayon,TRANSFORM_TEX(node_7542, _Crayon));
                float node_9833 = 1.0;
                float node_9781 = pow(saturate(node_2904),_node_9410);
                float node_8957 = (node_9781+node_9781);
                float node_3725_ang = _Crayon2Pivot;
                float node_3725_spd = 1.0;
                float node_3725_cos = cos(node_3725_spd*node_3725_ang);
                float node_3725_sin = sin(node_3725_spd*node_3725_ang);
                float2 node_3725_piv = float2(0.5,0.5);
                float2 node_3725 = (mul(node_6752-node_3725_piv,float2x2( node_3725_cos, -node_3725_sin, node_3725_sin, node_3725_cos))+node_3725_piv);
                float4 node_3469 = tex2D(_Crayon,TRANSFORM_TEX(node_3725, _Crayon));
                float node_3579_ang = _Crayon2Pivot;
                float node_3579_spd = 1.0;
                float node_3579_cos = cos(node_3579_spd*node_3579_ang);
                float node_3579_sin = sin(node_3579_spd*node_3579_ang);
                float2 node_3579_piv = float2(0.5,0.5);
                float2 node_3579 = (mul(node_4720-node_3579_piv,float2x2( node_3579_cos, -node_3579_sin, node_3579_sin, node_3579_cos))+node_3579_piv);
                float4 node_9300 = tex2D(_Crayon,TRANSFORM_TEX(node_3579, _Crayon));
                float node_847_ang = _Crayon2Pivot;
                float node_847_spd = 1.0;
                float node_847_cos = cos(node_847_spd*node_847_ang);
                float node_847_sin = sin(node_847_spd*node_847_ang);
                float2 node_847_piv = float2(0.5,0.5);
                float2 node_847 = (mul(node_7542-node_847_piv,float2x2( node_847_cos, -node_847_sin, node_847_sin, node_847_cos))+node_847_piv);
                float4 node_6648 = tex2D(_Crayon,TRANSFORM_TEX(node_847, _Crayon));
                float node_2315 = 1.0;
                float node_733 = 0.0;
                float3 diffColor = lerp(((_BaseColor.rgb*_Albedo_var.rgb)*lerp(saturate((lerp((node_1948.r*node_9083.rgb + node_1948.g*node_2133.rgb + node_1948.b*node_6666.rgb),float3(node_9833,node_9833,node_9833),saturate(node_8957))*lerp((node_1948.r*node_3469.rgb + node_1948.g*node_9300.rgb + node_1948.b*node_6648.rgb),float3(node_9833,node_9833,node_9833),saturate((node_8957+node_8957))))),float3(node_2315,node_2315,node_2315),_Opacity)),float3(node_733,node_733,node_733),_AbstractEffect);
                float specularMonochrome;
                float3 specColor;
                float4 _MetalnessTex_var = tex2D(_MetalnessTex,TRANSFORM_TEX(i.uv0, _MetalnessTex));
                diffColor = DiffuseAndSpecularFromMetallic( diffColor, lerp((_MetalnessTex_var.r*_Metalness),0.0,_AbstractEffect), specColor, specularMonochrome );
                float4 _RoughnessTex_var = tex2D(_RoughnessTex,TRANSFORM_TEX(i.uv0, _RoughnessTex));
                float roughness = lerp(lerp(_RoughnessTex_var.r,1.0,_Roughness),1.0,_AbstractEffect);
                o.Albedo = diffColor + specColor * roughness * roughness * 0.5;
                
                return UnityMetaFragment( o );
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
