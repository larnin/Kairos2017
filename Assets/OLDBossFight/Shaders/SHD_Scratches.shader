// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.32 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.32;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.3843138,fgcg:0.3882353,fgcb:0.3843138,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:2681,x:34353,y:32901,varname:node_2681,prsc:2|gloss-1228-OUT,custl-7532-OUT,clip-2781-OUT,voffset-4911-OUT;n:type:ShaderForge.SFN_Tex2d,id:1699,x:32129,y:32325,varname:node_1699,prsc:2,tex:af977b91af2b5c044a46bed19e38c214,ntxv:0,isnm:False|UVIN-9811-OUT,TEX-3036-TEX;n:type:ShaderForge.SFN_ScreenPos,id:2028,x:30930,y:32238,varname:node_2028,prsc:2,sctp:0;n:type:ShaderForge.SFN_Lerp,id:5550,x:32691,y:32439,varname:node_5550,prsc:2|A-1699-R,B-1699-G,T-9838-OUT;n:type:ShaderForge.SFN_Sin,id:7090,x:31866,y:32976,varname:node_7090,prsc:2|IN-6893-OUT;n:type:ShaderForge.SFN_Time,id:1504,x:31287,y:32857,varname:node_1504,prsc:2;n:type:ShaderForge.SFN_Multiply,id:6893,x:31699,y:32976,varname:node_6893,prsc:2|A-1504-T,B-9550-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9550,x:31280,y:33009,ptovrint:False,ptlb:Speed,ptin:_Speed,varname:node_9550,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Lerp,id:9830,x:32894,y:32558,varname:node_9830,prsc:2|A-5550-OUT,B-1699-B,T-4018-OUT;n:type:ShaderForge.SFN_Vector1,id:5275,x:32122,y:32148,varname:node_5275,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector3,id:3471,x:32135,y:31776,varname:node_3471,prsc:2,v1:1,v2:0,v3:0;n:type:ShaderForge.SFN_Vector3,id:7021,x:32135,y:31869,varname:node_7021,prsc:2,v1:0,v2:1,v3:0;n:type:ShaderForge.SFN_Vector3,id:8680,x:32135,y:31960,varname:node_8680,prsc:2,v1:0,v2:0,v3:1;n:type:ShaderForge.SFN_Vector3,id:7602,x:32135,y:32051,varname:node_7602,prsc:2,v1:1,v2:1,v3:1;n:type:ShaderForge.SFN_Vector1,id:5125,x:32095,y:33101,varname:node_5125,prsc:2,v1:2;n:type:ShaderForge.SFN_Lerp,id:3725,x:33218,y:32692,varname:node_3725,prsc:2|A-9830-OUT,B-1699-A,T-9872-OUT;n:type:ShaderForge.SFN_RemapRange,id:3395,x:32273,y:32980,varname:node_3395,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-7090-OUT;n:type:ShaderForge.SFN_Step,id:9838,x:32728,y:32976,varname:node_9838,prsc:2|A-3395-OUT,B-7265-OUT;n:type:ShaderForge.SFN_Vector1,id:5301,x:32526,y:33282,varname:node_5301,prsc:2,v1:0.1;n:type:ShaderForge.SFN_Step,id:4018,x:32728,y:33114,varname:node_4018,prsc:2|A-3395-OUT,B-6894-OUT;n:type:ShaderForge.SFN_Step,id:9872,x:32728,y:33248,varname:node_9872,prsc:2|A-3395-OUT,B-5301-OUT;n:type:ShaderForge.SFN_Vector1,id:6894,x:32526,y:33215,varname:node_6894,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Vector1,id:7265,x:32526,y:33010,varname:node_7265,prsc:2,v1:0.9;n:type:ShaderForge.SFN_Add,id:9811,x:31406,y:32359,varname:node_9811,prsc:2|A-2028-UVOUT,B-6414-OUT;n:type:ShaderForge.SFN_RemapRange,id:7829,x:30930,y:32406,varname:node_7829,prsc:2,frmn:-1,frmx:1,tomn:-0.2,tomx:0.2|IN-3988-OUT;n:type:ShaderForge.SFN_Multiply,id:6414,x:31143,y:32406,varname:node_6414,prsc:2|A-7829-OUT,B-2328-OUT;n:type:ShaderForge.SFN_Slider,id:2328,x:30773,y:32590,ptovrint:False,ptlb:TurbulenceStrength,ptin:_TurbulenceStrength,varname:node_2328,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:5484,x:31683,y:33216,varname:node_5484,prsc:2|A-4375-T,B-1781-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1781,x:31264,y:33249,ptovrint:False,ptlb:Speed_Turbulences,ptin:_Speed_Turbulences,varname:_Speed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:5;n:type:ShaderForge.SFN_Time,id:4375,x:31271,y:33097,varname:node_4375,prsc:2;n:type:ShaderForge.SFN_Sin,id:3988,x:31850,y:33216,varname:node_3988,prsc:2|IN-5484-OUT;n:type:ShaderForge.SFN_Multiply,id:2947,x:33488,y:32784,varname:node_2947,prsc:2|A-3725-OUT,B-6301-OUT;n:type:ShaderForge.SFN_Slider,id:4289,x:32835,y:32835,ptovrint:False,ptlb:Opacity,ptin:_Opacity,varname:node_4289,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.524581,max:1;n:type:ShaderForge.SFN_OneMinus,id:6301,x:33218,y:32825,varname:node_6301,prsc:2|IN-4289-OUT;n:type:ShaderForge.SFN_Slider,id:1342,x:33342,y:33252,ptovrint:False,ptlb:VertexOffsetStrength,ptin:_VertexOffsetStrength,varname:node_1342,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Multiply,id:4911,x:33711,y:33256,varname:node_4911,prsc:2|A-1342-OUT,B-1855-R,C-736-OUT;n:type:ShaderForge.SFN_Tex2d,id:1855,x:33499,y:33346,varname:node_1855,prsc:2,ntxv:0,isnm:False|UVIN-1832-UVOUT,TEX-8417-TEX;n:type:ShaderForge.SFN_Panner,id:1832,x:33322,y:33346,varname:node_1832,prsc:2,spu:1,spv:1|UVIN-7827-UVOUT,DIST-5987-OUT;n:type:ShaderForge.SFN_TexCoord,id:7827,x:32957,y:33471,varname:node_7827,prsc:2,uv:0;n:type:ShaderForge.SFN_Multiply,id:5987,x:32957,y:33350,varname:node_5987,prsc:2|A-4375-T,B-7934-OUT;n:type:ShaderForge.SFN_NormalVector,id:736,x:33499,y:33512,prsc:2,pt:False;n:type:ShaderForge.SFN_ValueProperty,id:7934,x:32728,y:33471,ptovrint:False,ptlb:VertexOffestSpeed,ptin:_VertexOffestSpeed,varname:node_7934,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Tex2dAsset,id:3036,x:31836,y:32472,ptovrint:False,ptlb:Scratches,ptin:_Scratches,varname:node_3036,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:af977b91af2b5c044a46bed19e38c214,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Vector1,id:5710,x:33843,y:32985,varname:node_5710,prsc:2,v1:0;n:type:ShaderForge.SFN_Slider,id:1228,x:33686,y:33060,ptovrint:False,ptlb:Glossiness,ptin:_Glossiness,varname:node_1228,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Add,id:7532,x:34052,y:32790,varname:node_7532,prsc:2|A-2947-OUT,B-7210-OUT;n:type:ShaderForge.SFN_Color,id:4376,x:33488,y:32639,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_4376,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_TexCoord,id:8052,x:33488,y:32460,varname:node_8052,prsc:2,uv:0;n:type:ShaderForge.SFN_Lerp,id:7210,x:33811,y:32730,varname:node_7210,prsc:2|A-8052-V,B-4376-RGB,T-480-OUT;n:type:ShaderForge.SFN_Slider,id:480,x:33375,y:32933,ptovrint:False,ptlb:GradientOpacity,ptin:_GradientOpacity,varname:node_480,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_OneMinus,id:9235,x:33707,y:33522,varname:node_9235,prsc:2|IN-8052-V;n:type:ShaderForge.SFN_Lerp,id:4023,x:33881,y:33522,varname:node_4023,prsc:2|A-9235-OUT,B-3932-R,T-5110-OUT;n:type:ShaderForge.SFN_Vector1,id:5110,x:33499,y:33821,varname:node_5110,prsc:2,v1:0.2;n:type:ShaderForge.SFN_Lerp,id:2781,x:34277,y:33522,varname:node_2781,prsc:2|A-4458-OUT,B-5998-OUT,T-4093-OUT;n:type:ShaderForge.SFN_Vector1,id:5998,x:34058,y:33659,varname:node_5998,prsc:2,v1:1;n:type:ShaderForge.SFN_Slider,id:4093,x:33901,y:33806,ptovrint:False,ptlb:Apparition,ptin:_Apparition,varname:node_4093,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2dAsset,id:8417,x:33270,y:33602,ptovrint:False,ptlb:Clouds,ptin:_Clouds,varname:node_8417,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:3932,x:33499,y:33693,varname:node_3932,prsc:2,ntxv:0,isnm:False|TEX-8417-TEX;n:type:ShaderForge.SFN_Lerp,id:4458,x:34058,y:33522,varname:node_4458,prsc:2|A-5870-OUT,B-4023-OUT,T-4093-OUT;n:type:ShaderForge.SFN_Vector1,id:5870,x:33881,y:33680,varname:node_5870,prsc:2,v1:0;proporder:9550-1781-2328-4289-1342-7934-3036-1228-4376-480-4093-8417;pass:END;sub:END;*/

Shader "Custom/SHD_Scratches" {
    Properties {
        _Speed ("Speed", Float ) = 1
        _Speed_Turbulences ("Speed_Turbulences", Float ) = 5
        _TurbulenceStrength ("TurbulenceStrength", Range(0, 1)) = 0
        _Opacity ("Opacity", Range(0, 1)) = 0.524581
        _VertexOffsetStrength ("VertexOffsetStrength", Range(0, 1)) = 0
        _VertexOffestSpeed ("VertexOffestSpeed", Float ) = 0
        _Scratches ("Scratches", 2D) = "white" {}
        _Glossiness ("Glossiness", Range(0, 1)) = 0
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _GradientOpacity ("GradientOpacity", Range(0, 1)) = 0
        _Apparition ("Apparition", Range(0, 1)) = 0
        _Clouds ("Clouds", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _Speed;
            uniform float _TurbulenceStrength;
            uniform float _Speed_Turbulences;
            uniform float _Opacity;
            uniform float _VertexOffsetStrength;
            uniform float _VertexOffestSpeed;
            uniform sampler2D _Scratches; uniform float4 _Scratches_ST;
            uniform float _Glossiness;
            uniform float4 _Color;
            uniform float _GradientOpacity;
            uniform float _Apparition;
            uniform sampler2D _Clouds; uniform float4 _Clouds_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                float4 screenPos : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_4375 = _Time + _TimeEditor;
                float2 node_1832 = (o.uv0+(node_4375.g*_VertexOffestSpeed)*float2(1,1));
                float4 node_1855 = tex2Dlod(_Clouds,float4(TRANSFORM_TEX(node_1832, _Clouds),0.0,0));
                v.vertex.xyz += (_VertexOffsetStrength*node_1855.r*v.normal);
                o.pos = UnityObjectToClipPos(v.vertex );
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3 normalDirection = i.normalDir;
                float4 node_3932 = tex2D(_Clouds,TRANSFORM_TEX(i.uv0, _Clouds));
                clip(lerp(lerp(0.0,lerp((1.0 - i.uv0.g),node_3932.r,0.2),_Apparition),1.0,_Apparition) - 0.5);
////// Lighting:
                float4 node_4375 = _Time + _TimeEditor;
                float2 node_9811 = (i.screenPos.rg+((sin((node_4375.g*_Speed_Turbulences))*0.2+0.0)*_TurbulenceStrength));
                float4 node_1699 = tex2D(_Scratches,TRANSFORM_TEX(node_9811, _Scratches));
                float4 node_1504 = _Time + _TimeEditor;
                float node_3395 = (sin((node_1504.g*_Speed))*0.5+0.5);
                float3 finalColor = ((lerp(lerp(lerp(node_1699.r,node_1699.g,step(node_3395,0.9)),node_1699.b,step(node_3395,0.5)),node_1699.a,step(node_3395,0.1))*(1.0 - _Opacity))+lerp(float3(i.uv0.g,i.uv0.g,i.uv0.g),_Color.rgb,_GradientOpacity));
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform float _VertexOffsetStrength;
            uniform float _VertexOffestSpeed;
            uniform float _Apparition;
            uniform sampler2D _Clouds; uniform float4 _Clouds_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float4 node_4375 = _Time + _TimeEditor;
                float2 node_1832 = (o.uv0+(node_4375.g*_VertexOffestSpeed)*float2(1,1));
                float4 node_1855 = tex2Dlod(_Clouds,float4(TRANSFORM_TEX(node_1832, _Clouds),0.0,0));
                v.vertex.xyz += (_VertexOffsetStrength*node_1855.r*v.normal);
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float4 node_3932 = tex2D(_Clouds,TRANSFORM_TEX(i.uv0, _Clouds));
                clip(lerp(lerp(0.0,lerp((1.0 - i.uv0.g),node_3932.r,0.2),_Apparition),1.0,_Apparition) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
