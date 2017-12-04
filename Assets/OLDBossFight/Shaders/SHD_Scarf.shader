// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.32 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.32;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.4881056,fgcg:0.5210539,fgcb:0.5441177,fgca:1,fgde:0.04,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:8415,x:34695,y:32805,varname:node_8415,prsc:2|diff-9281-RGB,alpha-7070-OUT,voffset-8126-OUT,tess-8348-OUT;n:type:ShaderForge.SFN_TexCoord,id:9166,x:31180,y:32848,varname:node_9166,prsc:2,uv:0;n:type:ShaderForge.SFN_OneMinus,id:9739,x:32198,y:32851,varname:node_9739,prsc:2|IN-9166-U;n:type:ShaderForge.SFN_Multiply,id:3985,x:32410,y:32824,varname:node_3985,prsc:2|A-9166-U,B-9739-OUT;n:type:ShaderForge.SFN_RemapRange,id:2635,x:32593,y:32824,varname:node_2635,prsc:2,frmn:0,frmx:0.3,tomn:0,tomx:1|IN-3985-OUT;n:type:ShaderForge.SFN_Tex2d,id:5267,x:32128,y:33069,ptovrint:False,ptlb:Perlin Noise,ptin:_PerlinNoise,varname:node_5267,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:2486eadde0565ea4f967b1eb2b2ddab6,ntxv:0,isnm:False|UVIN-3786-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:2408,x:32784,y:33012,ptovrint:False,ptlb:Panner,ptin:_Panner,varname:node_2408,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5d19b2e8aa5628d449bbecfca5dec2a3,ntxv:0,isnm:False|UVIN-5296-OUT;n:type:ShaderForge.SFN_Panner,id:3786,x:31942,y:33069,varname:node_3786,prsc:2,spu:0.5,spv:1|UVIN-938-OUT,DIST-860-OUT;n:type:ShaderForge.SFN_Multiply,id:3388,x:33089,y:32910,varname:node_3388,prsc:2|A-2635-OUT,B-7368-OUT;n:type:ShaderForge.SFN_Color,id:9281,x:34025,y:32782,ptovrint:False,ptlb:BaseColor,ptin:_BaseColor,varname:node_9281,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.8529412,c2:0,c3:0.2294119,c4:1;n:type:ShaderForge.SFN_Time,id:8496,x:31542,y:33012,varname:node_8496,prsc:2;n:type:ShaderForge.SFN_Multiply,id:860,x:31749,y:33069,varname:node_860,prsc:2|A-8496-T,B-5385-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5385,x:31542,y:33158,ptovrint:False,ptlb:Speed,ptin:_Speed,varname:node_5385,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ComponentMask,id:8086,x:32296,y:33069,varname:node_8086,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-5267-RGB;n:type:ShaderForge.SFN_Lerp,id:5296,x:32593,y:33001,varname:node_5296,prsc:2|A-9166-UVOUT,B-8086-OUT,T-5049-OUT;n:type:ShaderForge.SFN_Slider,id:501,x:32139,y:33253,ptovrint:False,ptlb:EffectStrength,ptin:_EffectStrength,varname:node_501,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5415415,max:1;n:type:ShaderForge.SFN_Multiply,id:5049,x:32500,y:33170,varname:node_5049,prsc:2|A-501-OUT,B-9728-OUT;n:type:ShaderForge.SFN_OneMinus,id:9728,x:32296,y:33321,varname:node_9728,prsc:2|IN-9166-V;n:type:ShaderForge.SFN_Multiply,id:3407,x:33283,y:32903,varname:node_3407,prsc:2|A-3388-OUT,B-793-OUT;n:type:ShaderForge.SFN_Add,id:6882,x:33508,y:33004,varname:node_6882,prsc:2|A-3407-OUT,B-3407-OUT;n:type:ShaderForge.SFN_Add,id:4507,x:32887,y:33249,varname:node_4507,prsc:2|A-9166-V,B-9166-V;n:type:ShaderForge.SFN_Clamp01,id:793,x:33211,y:33247,varname:node_793,prsc:2|IN-5464-OUT;n:type:ShaderForge.SFN_Lerp,id:4889,x:34094,y:32951,varname:node_4889,prsc:2|A-6882-OUT,B-3407-OUT,T-4428-OUT;n:type:ShaderForge.SFN_Vector1,id:4428,x:33508,y:32937,varname:node_4428,prsc:2,v1:0.7;n:type:ShaderForge.SFN_Multiply,id:9972,x:34013,y:33170,varname:node_9972,prsc:2|A-8814-G,B-6167-OUT,C-3853-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:7783,x:32296,y:33497,ptovrint:False,ptlb:Scarf,ptin:_Scarf,varname:node_7783,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a2de3a598dd94c64d95b68174ebfc8b1,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:8814,x:32573,y:33503,varname:node_8814,prsc:2,tex:a2de3a598dd94c64d95b68174ebfc8b1,ntxv:0,isnm:False|UVIN-1262-UVOUT,TEX-7783-TEX;n:type:ShaderForge.SFN_Rotator,id:1262,x:32296,y:33664,varname:node_1262,prsc:2|UVIN-3786-UVOUT,ANG-104-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3853,x:33720,y:33395,ptovrint:False,ptlb:VertexOffsetStrength,ptin:_VertexOffsetStrength,varname:node_3853,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Lerp,id:8126,x:34188,y:33170,varname:node_8126,prsc:2|A-9972-OUT,B-762-OUT,T-9166-V;n:type:ShaderForge.SFN_Vector1,id:762,x:34013,y:33312,varname:node_762,prsc:2,v1:0;n:type:ShaderForge.SFN_Add,id:7041,x:32983,y:33012,varname:node_7041,prsc:2|A-2408-R,B-2408-R;n:type:ShaderForge.SFN_Clamp01,id:7368,x:33159,y:33048,varname:node_7368,prsc:2|IN-7041-OUT;n:type:ShaderForge.SFN_Vector3,id:6167,x:33720,y:33282,varname:node_6167,prsc:2,v1:0,v2:1,v3:0;n:type:ShaderForge.SFN_Slider,id:8348,x:34220,y:33373,ptovrint:False,ptlb:Tesselation,ptin:_Tesselation,varname:node_8348,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:1,max:10;n:type:ShaderForge.SFN_ValueProperty,id:6608,x:32098,y:33782,ptovrint:False,ptlb:Rotator,ptin:_Rotator,varname:node_6608,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Tex2d,id:2930,x:32573,y:33707,varname:node_2930,prsc:2,tex:a2de3a598dd94c64d95b68174ebfc8b1,ntxv:0,isnm:False|UVIN-7951-UVOUT,TEX-7783-TEX;n:type:ShaderForge.SFN_Add,id:8129,x:32930,y:33666,varname:node_8129,prsc:2|A-2930-R,B-2930-R;n:type:ShaderForge.SFN_Rotator,id:7951,x:32296,y:33802,varname:node_7951,prsc:2|UVIN-3784-UVOUT,ANG-6608-OUT;n:type:ShaderForge.SFN_Panner,id:3784,x:31755,y:33506,varname:node_3784,prsc:2,spu:0.5,spv:1|UVIN-9166-UVOUT,DIST-566-OUT;n:type:ShaderForge.SFN_Multiply,id:566,x:31562,y:33506,varname:node_566,prsc:2|A-2881-T,B-5105-OUT;n:type:ShaderForge.SFN_Time,id:2881,x:31355,y:33449,varname:node_2881,prsc:2;n:type:ShaderForge.SFN_Multiply,id:5105,x:31355,y:33572,varname:node_5105,prsc:2|A-5385-OUT,B-5387-OUT;n:type:ShaderForge.SFN_Vector1,id:5387,x:31164,y:33632,varname:node_5387,prsc:2,v1:0;n:type:ShaderForge.SFN_Add,id:1941,x:34296,y:32969,varname:node_1941,prsc:2|A-4889-OUT,B-4889-OUT;n:type:ShaderForge.SFN_Clamp01,id:5627,x:34498,y:32969,varname:node_5627,prsc:2|IN-1941-OUT;n:type:ShaderForge.SFN_Power,id:738,x:33370,y:33481,varname:node_738,prsc:2|VAL-8129-OUT,EXP-7009-OUT;n:type:ShaderForge.SFN_Vector1,id:7009,x:33189,y:33605,varname:node_7009,prsc:2,v1:5;n:type:ShaderForge.SFN_Multiply,id:7070,x:34433,y:33210,varname:node_7070,prsc:2|A-3282-OUT,B-793-OUT;n:type:ShaderForge.SFN_Clamp01,id:3282,x:33531,y:33482,varname:node_3282,prsc:2|IN-738-OUT;n:type:ShaderForge.SFN_Multiply,id:5464,x:33071,y:33247,varname:node_5464,prsc:2|A-4507-OUT,B-4507-OUT;n:type:ShaderForge.SFN_ValueProperty,id:104,x:32098,y:33698,ptovrint:False,ptlb:Rotator_copy,ptin:_Rotator_copy,varname:_Rotator_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:938,x:31756,y:33800,varname:node_938,prsc:2|A-9166-UVOUT,B-96-OUT;n:type:ShaderForge.SFN_Vector1,id:96,x:31507,y:33858,varname:node_96,prsc:2,v1:2;proporder:9281-5267-5385-501-7783-3853-2408-8348-6608-104;pass:END;sub:END;*/

Shader "Custom/SHD_Scarf" {
    Properties {
        _BaseColor ("BaseColor", Color) = (0.8529412,0,0.2294119,1)
        _PerlinNoise ("Perlin Noise", 2D) = "white" {}
        _Speed ("Speed", Float ) = 0
        _EffectStrength ("EffectStrength", Range(0, 1)) = 0.5415415
        _Scarf ("Scarf", 2D) = "white" {}
        _VertexOffsetStrength ("VertexOffsetStrength", Float ) = 0
        _Panner ("Panner", 2D) = "white" {}
        _Tesselation ("Tesselation", Range(1, 10)) = 1
        _Rotator ("Rotator", Float ) = 0
        _Rotator_copy ("Rotator_copy", Float ) = 0
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
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma hull hull
            #pragma domain domain
            #pragma vertex tessvert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "Tessellation.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 5.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform float4 _BaseColor;
            uniform float _Speed;
            uniform sampler2D _Scarf; uniform float4 _Scarf_ST;
            uniform float _VertexOffsetStrength;
            uniform float _Tesselation;
            uniform float _Rotator;
            uniform float _Rotator_copy;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                UNITY_FOG_COORDS(3)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float node_1262_ang = _Rotator_copy;
                float node_1262_spd = 1.0;
                float node_1262_cos = cos(node_1262_spd*node_1262_ang);
                float node_1262_sin = sin(node_1262_spd*node_1262_ang);
                float2 node_1262_piv = float2(0.5,0.5);
                float4 node_8496 = _Time + _TimeEditor;
                float2 node_3786 = ((o.uv0*2.0)+(node_8496.g*_Speed)*float2(0.5,1));
                float2 node_1262 = (mul(node_3786-node_1262_piv,float2x2( node_1262_cos, -node_1262_sin, node_1262_sin, node_1262_cos))+node_1262_piv);
                float4 node_8814 = tex2Dlod(_Scarf,float4(TRANSFORM_TEX(node_1262, _Scarf),0.0,0));
                float node_762 = 0.0;
                v.vertex.xyz += lerp((node_8814.g*float3(0,1,0)*_VertexOffsetStrength),float3(node_762,node_762,node_762),o.uv0.g);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            #ifdef UNITY_CAN_COMPILE_TESSELLATION
                struct TessVertex {
                    float4 vertex : INTERNALTESSPOS;
                    float3 normal : NORMAL;
                    float4 tangent : TANGENT;
                    float2 texcoord0 : TEXCOORD0;
                };
                struct OutputPatchConstant {
                    float edge[3]         : SV_TessFactor;
                    float inside          : SV_InsideTessFactor;
                    float3 vTangent[4]    : TANGENT;
                    float2 vUV[4]         : TEXCOORD;
                    float3 vTanUCorner[4] : TANUCORNER;
                    float3 vTanVCorner[4] : TANVCORNER;
                    float4 vCWts          : TANWEIGHTS;
                };
                TessVertex tessvert (VertexInput v) {
                    TessVertex o;
                    o.vertex = v.vertex;
                    o.normal = v.normal;
                    o.tangent = v.tangent;
                    o.texcoord0 = v.texcoord0;
                    return o;
                }
                float Tessellation(TessVertex v){
                    return _Tesselation;
                }
                float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){
                    float tv = Tessellation(v);
                    float tv1 = Tessellation(v1);
                    float tv2 = Tessellation(v2);
                    return float4( tv1+tv2, tv2+tv, tv+tv1, tv+tv1+tv2 ) / float4(2,2,2,3);
                }
                OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
                    OutputPatchConstant o = (OutputPatchConstant)0;
                    float4 ts = Tessellation( v[0], v[1], v[2] );
                    o.edge[0] = ts.x;
                    o.edge[1] = ts.y;
                    o.edge[2] = ts.z;
                    o.inside = ts.w;
                    return o;
                }
                [domain("tri")]
                [partitioning("fractional_odd")]
                [outputtopology("triangle_cw")]
                [patchconstantfunc("hullconst")]
                [outputcontrolpoints(3)]
                TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
                    return v[id];
                }
                [domain("tri")]
                VertexOutput domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
                    VertexInput v = (VertexInput)0;
                    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
                    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
                    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
                    v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
                    VertexOutput o = vert(v);
                    return o;
                }
            #endif
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float3 diffuseColor = _BaseColor.rgb;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                float node_7951_ang = _Rotator;
                float node_7951_spd = 1.0;
                float node_7951_cos = cos(node_7951_spd*node_7951_ang);
                float node_7951_sin = sin(node_7951_spd*node_7951_ang);
                float2 node_7951_piv = float2(0.5,0.5);
                float4 node_2881 = _Time + _TimeEditor;
                float2 node_7951 = (mul((i.uv0+(node_2881.g*(_Speed*0.0))*float2(0.5,1))-node_7951_piv,float2x2( node_7951_cos, -node_7951_sin, node_7951_sin, node_7951_cos))+node_7951_piv);
                float4 node_2930 = tex2D(_Scarf,TRANSFORM_TEX(node_7951, _Scarf));
                float node_4507 = (i.uv0.g+i.uv0.g);
                float node_793 = saturate((node_4507*node_4507));
                fixed4 finalRGBA = fixed4(finalColor,(saturate(pow((node_2930.r+node_2930.r),5.0))*node_793));
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
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma hull hull
            #pragma domain domain
            #pragma vertex tessvert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Tessellation.cginc"
            #pragma multi_compile_fwdadd
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 5.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform float4 _BaseColor;
            uniform float _Speed;
            uniform sampler2D _Scarf; uniform float4 _Scarf_ST;
            uniform float _VertexOffsetStrength;
            uniform float _Tesselation;
            uniform float _Rotator;
            uniform float _Rotator_copy;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                float node_1262_ang = _Rotator_copy;
                float node_1262_spd = 1.0;
                float node_1262_cos = cos(node_1262_spd*node_1262_ang);
                float node_1262_sin = sin(node_1262_spd*node_1262_ang);
                float2 node_1262_piv = float2(0.5,0.5);
                float4 node_8496 = _Time + _TimeEditor;
                float2 node_3786 = ((o.uv0*2.0)+(node_8496.g*_Speed)*float2(0.5,1));
                float2 node_1262 = (mul(node_3786-node_1262_piv,float2x2( node_1262_cos, -node_1262_sin, node_1262_sin, node_1262_cos))+node_1262_piv);
                float4 node_8814 = tex2Dlod(_Scarf,float4(TRANSFORM_TEX(node_1262, _Scarf),0.0,0));
                float node_762 = 0.0;
                v.vertex.xyz += lerp((node_8814.g*float3(0,1,0)*_VertexOffsetStrength),float3(node_762,node_762,node_762),o.uv0.g);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            #ifdef UNITY_CAN_COMPILE_TESSELLATION
                struct TessVertex {
                    float4 vertex : INTERNALTESSPOS;
                    float3 normal : NORMAL;
                    float4 tangent : TANGENT;
                    float2 texcoord0 : TEXCOORD0;
                };
                struct OutputPatchConstant {
                    float edge[3]         : SV_TessFactor;
                    float inside          : SV_InsideTessFactor;
                    float3 vTangent[4]    : TANGENT;
                    float2 vUV[4]         : TEXCOORD;
                    float3 vTanUCorner[4] : TANUCORNER;
                    float3 vTanVCorner[4] : TANVCORNER;
                    float4 vCWts          : TANWEIGHTS;
                };
                TessVertex tessvert (VertexInput v) {
                    TessVertex o;
                    o.vertex = v.vertex;
                    o.normal = v.normal;
                    o.tangent = v.tangent;
                    o.texcoord0 = v.texcoord0;
                    return o;
                }
                float Tessellation(TessVertex v){
                    return _Tesselation;
                }
                float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){
                    float tv = Tessellation(v);
                    float tv1 = Tessellation(v1);
                    float tv2 = Tessellation(v2);
                    return float4( tv1+tv2, tv2+tv, tv+tv1, tv+tv1+tv2 ) / float4(2,2,2,3);
                }
                OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
                    OutputPatchConstant o = (OutputPatchConstant)0;
                    float4 ts = Tessellation( v[0], v[1], v[2] );
                    o.edge[0] = ts.x;
                    o.edge[1] = ts.y;
                    o.edge[2] = ts.z;
                    o.inside = ts.w;
                    return o;
                }
                [domain("tri")]
                [partitioning("fractional_odd")]
                [outputtopology("triangle_cw")]
                [patchconstantfunc("hullconst")]
                [outputcontrolpoints(3)]
                TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
                    return v[id];
                }
                [domain("tri")]
                VertexOutput domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
                    VertexInput v = (VertexInput)0;
                    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
                    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
                    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
                    v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
                    VertexOutput o = vert(v);
                    return o;
                }
            #endif
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 diffuseColor = _BaseColor.rgb;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                float node_7951_ang = _Rotator;
                float node_7951_spd = 1.0;
                float node_7951_cos = cos(node_7951_spd*node_7951_ang);
                float node_7951_sin = sin(node_7951_spd*node_7951_ang);
                float2 node_7951_piv = float2(0.5,0.5);
                float4 node_2881 = _Time + _TimeEditor;
                float2 node_7951 = (mul((i.uv0+(node_2881.g*(_Speed*0.0))*float2(0.5,1))-node_7951_piv,float2x2( node_7951_cos, -node_7951_sin, node_7951_sin, node_7951_cos))+node_7951_piv);
                float4 node_2930 = tex2D(_Scarf,TRANSFORM_TEX(node_7951, _Scarf));
                float node_4507 = (i.uv0.g+i.uv0.g);
                float node_793 = saturate((node_4507*node_4507));
                fixed4 finalRGBA = fixed4(finalColor * (saturate(pow((node_2930.r+node_2930.r),5.0))*node_793),0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
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
            #pragma hull hull
            #pragma domain domain
            #pragma vertex tessvert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "Tessellation.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 5.0
            uniform float4 _TimeEditor;
            uniform float _Speed;
            uniform sampler2D _Scarf; uniform float4 _Scarf_ST;
            uniform float _VertexOffsetStrength;
            uniform float _Tesselation;
            uniform float _Rotator_copy;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float node_1262_ang = _Rotator_copy;
                float node_1262_spd = 1.0;
                float node_1262_cos = cos(node_1262_spd*node_1262_ang);
                float node_1262_sin = sin(node_1262_spd*node_1262_ang);
                float2 node_1262_piv = float2(0.5,0.5);
                float4 node_8496 = _Time + _TimeEditor;
                float2 node_3786 = ((o.uv0*2.0)+(node_8496.g*_Speed)*float2(0.5,1));
                float2 node_1262 = (mul(node_3786-node_1262_piv,float2x2( node_1262_cos, -node_1262_sin, node_1262_sin, node_1262_cos))+node_1262_piv);
                float4 node_8814 = tex2Dlod(_Scarf,float4(TRANSFORM_TEX(node_1262, _Scarf),0.0,0));
                float node_762 = 0.0;
                v.vertex.xyz += lerp((node_8814.g*float3(0,1,0)*_VertexOffsetStrength),float3(node_762,node_762,node_762),o.uv0.g);
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            #ifdef UNITY_CAN_COMPILE_TESSELLATION
                struct TessVertex {
                    float4 vertex : INTERNALTESSPOS;
                    float3 normal : NORMAL;
                    float4 tangent : TANGENT;
                    float2 texcoord0 : TEXCOORD0;
                };
                struct OutputPatchConstant {
                    float edge[3]         : SV_TessFactor;
                    float inside          : SV_InsideTessFactor;
                    float3 vTangent[4]    : TANGENT;
                    float2 vUV[4]         : TEXCOORD;
                    float3 vTanUCorner[4] : TANUCORNER;
                    float3 vTanVCorner[4] : TANVCORNER;
                    float4 vCWts          : TANWEIGHTS;
                };
                TessVertex tessvert (VertexInput v) {
                    TessVertex o;
                    o.vertex = v.vertex;
                    o.normal = v.normal;
                    o.tangent = v.tangent;
                    o.texcoord0 = v.texcoord0;
                    return o;
                }
                float Tessellation(TessVertex v){
                    return _Tesselation;
                }
                float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){
                    float tv = Tessellation(v);
                    float tv1 = Tessellation(v1);
                    float tv2 = Tessellation(v2);
                    return float4( tv1+tv2, tv2+tv, tv+tv1, tv+tv1+tv2 ) / float4(2,2,2,3);
                }
                OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
                    OutputPatchConstant o = (OutputPatchConstant)0;
                    float4 ts = Tessellation( v[0], v[1], v[2] );
                    o.edge[0] = ts.x;
                    o.edge[1] = ts.y;
                    o.edge[2] = ts.z;
                    o.inside = ts.w;
                    return o;
                }
                [domain("tri")]
                [partitioning("fractional_odd")]
                [outputtopology("triangle_cw")]
                [patchconstantfunc("hullconst")]
                [outputcontrolpoints(3)]
                TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
                    return v[id];
                }
                [domain("tri")]
                VertexOutput domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
                    VertexInput v = (VertexInput)0;
                    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
                    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
                    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
                    v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
                    VertexOutput o = vert(v);
                    return o;
                }
            #endif
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
