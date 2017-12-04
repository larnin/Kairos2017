// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.32 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.32;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.4881056,fgcg:0.5210539,fgcb:0.5441177,fgca:1,fgde:0.04,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3803,x:33091,y:32685,varname:node_3803,prsc:2|custl-8291-RGB,alpha-9043-OUT;n:type:ShaderForge.SFN_Tex2d,id:8402,x:32253,y:32906,ptovrint:False,ptlb:Texture,ptin:_Texture,varname:node_8402,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-1941-UVOUT;n:type:ShaderForge.SFN_Panner,id:1941,x:32052,y:32906,varname:node_1941,prsc:2,spu:1,spv:0|UVIN-5710-UVOUT,DIST-8244-OUT;n:type:ShaderForge.SFN_Multiply,id:8244,x:31760,y:32975,varname:node_8244,prsc:2|A-6041-T,B-183-OUT;n:type:ShaderForge.SFN_TexCoord,id:5710,x:31556,y:32775,varname:node_5710,prsc:2,uv:0;n:type:ShaderForge.SFN_Time,id:6041,x:31556,y:32932,varname:node_6041,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:183,x:31556,y:33076,ptovrint:False,ptlb:MouvSpeed,ptin:_MouvSpeed,varname:node_183,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Lerp,id:4245,x:32479,y:32968,varname:node_4245,prsc:2|A-8402-B,B-5356-OUT,T-3993-OUT;n:type:ShaderForge.SFN_Vector1,id:5356,x:32253,y:33066,varname:node_5356,prsc:2,v1:1;n:type:ShaderForge.SFN_Slider,id:3993,x:32096,y:33148,ptovrint:False,ptlb:Opacity,ptin:_Opacity,varname:node_3993,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Lerp,id:7751,x:32686,y:32968,varname:node_7751,prsc:2|A-4245-OUT,B-6725-OUT,T-6739-OUT;n:type:ShaderForge.SFN_Vector1,id:6725,x:32479,y:33094,varname:node_6725,prsc:2,v1:0;n:type:ShaderForge.SFN_OneMinus,id:6739,x:32468,y:33158,varname:node_6739,prsc:2|IN-3993-OUT;n:type:ShaderForge.SFN_Step,id:9043,x:32872,y:32968,varname:node_9043,prsc:2|A-4670-OUT,B-7751-OUT;n:type:ShaderForge.SFN_Vector1,id:4670,x:32686,y:33094,varname:node_4670,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Color,id:8291,x:32446,y:32795,ptovrint:False,ptlb:BaseColor,ptin:_BaseColor,varname:node_8291,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;proporder:8402-183-3993-8291;pass:END;sub:END;*/

Shader "Custom/SHD_ApparitionSphere" {
    Properties {
        _Texture ("Texture", 2D) = "white" {}
        _MouvSpeed ("MouvSpeed", Float ) = 0
        _Opacity ("Opacity", Range(0, 1)) = 0
        _BaseColor ("BaseColor", Color) = (0,0,0,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform float _MouvSpeed;
            uniform float _Opacity;
            uniform float4 _BaseColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
                float3 finalColor = _BaseColor.rgb;
                float4 node_6041 = _Time + _TimeEditor;
                float2 node_1941 = (i.uv0+(node_6041.g*_MouvSpeed)*float2(1,0));
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(node_1941, _Texture));
                return fixed4(finalColor,step(0.5,lerp(lerp(_Texture_var.b,1.0,_Opacity),0.0,(1.0 - _Opacity))));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
