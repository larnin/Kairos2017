// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CustomLightingTest_TerrainV2"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(SHDF_LightStep)]
		_MouvSpeed("MouvSpeed", Float) = 0
		_Normal("Normal", 2D) = "bump" {}
		_BrushTexture("BrushTexture", 2D) = "white" {}
		_BrushTextureTiling("BrushTextureTiling", Float) = 1
		_BrushStrokeTexture("BrushStrokeTexture", 2D) = "white" {}
		_BrushStrokeTiling("BrushStrokeTiling", Float) = 0
		_CircleTexture("CircleTexture", 2D) = "white" {}
		_Ramp("Ramp", 2D) = "white" {}
		_NormalIntensity("Normal Intensity", Range( 0 , 0.5)) = 0.5
		_ShadowColor("Shadow Color", Color) = (0.1617647,0.08207179,0.08207179,0)
		_ShadowOpacity("ShadowOpacity", Range( 0 , 1)) = 0
		_AmbiantLightStrength("AmbiantLightStrength", Range( 0 , 1)) = 0
		_ShadowStrokeStep("ShadowStrokeStep", Range( 0 , 1)) = 0
		_ShadowSoftStep("ShadowSoftStep", Range( 0 , 1)) = 0.39
		_ShadowSoftStrokeStep("ShadowSoftStrokeStep", Range( 0 , 1)) = 0.39
		_LightSoftStepStrokes("LightSoftStepStrokes", Range( 0 , 1)) = 0
		_SpecularStrength("Specular Strength", Range( 0 , 1)) = 0
		_Position("Position", Range( 0 , 1)) = 0.476
		_Control("Control", 2D) = "white" {}
		_Contrast("Contrast", Range( 0 , 1)) = 0.03
		_Metalness("Metalness", Range( 0 , 1)) = 0.5
		_Roughness("Roughness", Range( 0 , 1)) = 0.5
		_Splat0("Splat0", 2D) = "white" {}
		_Splat3("Splat3", 2D) = "white" {}
		_Splat2("Splat2", 2D) = "white" {}
		_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _Metalness;
		uniform sampler2D _Splat0;
		uniform float4 _Splat0_ST;
		uniform sampler2D _Splat1;
		uniform float4 _Splat1_ST;
		uniform sampler2D _Control;
		uniform float4 _Control_ST;
		uniform sampler2D _Splat2;
		uniform float4 _Splat2_ST;
		uniform sampler2D _Splat3;
		uniform float4 _Splat3_ST;
		uniform float4 _ShadowColor;
		uniform float _ShadowOpacity;
		uniform float _Roughness;
		uniform sampler2D _Ramp;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _NormalIntensity;
		uniform float _SpecularStrength;
		uniform float _Contrast;
		uniform float _Position;
		uniform sampler2D _BrushTexture;
		uniform float _BrushTextureTiling;
		uniform float _MouvSpeed;
		uniform float _ShadowSoftStep;
		uniform sampler2D _BrushStrokeTexture;
		uniform float _BrushStrokeTiling;
		uniform float _ShadowStrokeStep;
		uniform sampler2D _CircleTexture;
		uniform float _ShadowSoftStrokeStep;
		uniform float _LightSoftStepStrokes;
		uniform float _AmbiantLightStrength;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#if DIRECTIONAL
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			float4 temp_cast_0 = (_Metalness).xxxx;
			float4 lerpResult733 = lerp( _LightColor0 , temp_cast_0 , ( _Metalness * 0.5 ));
			float4 lerpResult291 = lerp( ( 1.0 - lerpResult733 ) , float4( 1,1,1,0 ) , 0.5);
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float4 tex2DNode746 = tex2D( _Splat1, uv_Splat1 );
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode745 = tex2D( _Control, uv_Control );
			float4 lerpResult748 = lerp( tex2D( _Splat0, uv_Splat0 ) , tex2DNode746 , tex2DNode745.r);
			float4 lerpResult751 = lerp( lerpResult748 , tex2DNode746 , tex2DNode745.g);
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float4 lerpResult753 = lerp( lerpResult751 , tex2D( _Splat2, uv_Splat2 ) , tex2DNode745.b);
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 lerpResult754 = lerp( lerpResult753 , tex2D( _Splat3, uv_Splat3 ) , tex2DNode745.a);
			float4 lerpResult363 = lerp( lerpResult754 , _ShadowColor , _ShadowOpacity);
			float lerpResult738 = lerp( _Roughness , 0.0 , ( _Metalness * 0.2 ));
			float4 lerpResult700 = lerp( ( _Metalness * ( lerpResult754 * 0.5 ) ) , lerpResult754 , lerpResult738);
			float lerpResult725 = lerp( 1.0 , 0.5 , _Metalness);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode551 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float4 lerpResult552 = lerp( float4(0.4980392,0.4980392,1,0) , float4( tex2DNode551 , 0.0 ) , _NormalIntensity);
			float3 newWorldNormal52 = WorldNormalVector( i , lerpResult552 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			float dotResult53 = dot( newWorldNormal52 , ase_worldlightDir );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult637 = dot( newWorldNormal52 , ase_worldViewDir );
			float3 temp_cast_2 = (dotResult637).xxx;
			float temp_output_696_0 = ( 1.0 - lerpResult738 );
			float lerpResult632 = lerp( ( ase_lightAtten * dotResult53 ) , Luminance(temp_cast_2) , ( _SpecularStrength * temp_output_696_0 ));
			float temp_output_4_0_g234 = saturate( (lerpResult632*_Contrast + _Position) );
			float4 appendResult5_g234 = (float4(temp_output_4_0_g234 , temp_output_4_0_g234 , 0.0 , 0.0));
			float2 temp_cast_5 = (_BrushTextureTiling).xx;
			float4 transform46_g556 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g556 = (float4(transform46_g556.z , transform46_g556.x , 0.0 , 0.0));
			float2 _TextureOffset4 = float2(0.5,0.5);
			float4 tex2DNode23_g556 = tex2D( _BrushTexture, ( ( ( temp_cast_5 * 0.75 ).x * appendResult7_g556 ) + float4( ( _TextureOffset4 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_10 = (_BrushTextureTiling).xx;
			float4 appendResult6_g556 = (float4(transform46_g556.z , transform46_g556.y , 0.0 , 0.0));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 transform47_g556 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g556 = abs( transform47_g556 );
			float4 temp_output_3_0_g556 = ( temp_output_2_0_g556 * temp_output_2_0_g556 );
			float2 componentMask5_g556 = temp_output_3_0_g556.xw;
			float4 lerpResult26_g556 = lerp( tex2DNode23_g556 , tex2D( _BrushTexture, ( ( ( temp_cast_10 * 0.75 ).x * appendResult6_g556 ) + float4( ( _TextureOffset4 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g556, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g556 = temp_output_3_0_g556.yw;
			float4 lerpResult29_g556 = lerp( lerpResult26_g556 , tex2DNode23_g556 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g556, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_19 = (_BrushTextureTiling).xx;
			float4 appendResult13_g556 = (float4(transform46_g556.x , transform46_g556.y , 0.0 , 0.0));
			float2 componentMask17_g556 = temp_output_3_0_g556.zw;
			float4 lerpResult32_g556 = lerp( lerpResult29_g556 , tex2D( _BrushTexture, ( ( ( temp_cast_19 * 0.75 ).x * appendResult13_g556 ) + float4( ( _TextureOffset4 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g556, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_25 = (_BrushTextureTiling).xx;
			float4 transform46_g555 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g555 = (float4(transform46_g555.z , transform46_g555.x , 0.0 , 0.0));
			float4 tex2DNode23_g555 = tex2D( _BrushTexture, ( ( temp_cast_25.x * appendResult7_g555 ) + float4( ( _TextureOffset4 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_30 = (_BrushTextureTiling).xx;
			float4 appendResult6_g555 = (float4(transform46_g555.z , transform46_g555.y , 0.0 , 0.0));
			float4 transform47_g555 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g555 = abs( transform47_g555 );
			float4 temp_output_3_0_g555 = ( temp_output_2_0_g555 * temp_output_2_0_g555 );
			float2 componentMask5_g555 = temp_output_3_0_g555.xw;
			float4 lerpResult26_g555 = lerp( tex2DNode23_g555 , tex2D( _BrushTexture, ( ( temp_cast_30.x * appendResult6_g555 ) + float4( ( _TextureOffset4 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g555, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g555 = temp_output_3_0_g555.yw;
			float4 lerpResult29_g555 = lerp( lerpResult26_g555 , tex2DNode23_g555 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g555, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_39 = (_BrushTextureTiling).xx;
			float4 appendResult13_g555 = (float4(transform46_g555.x , transform46_g555.y , 0.0 , 0.0));
			float2 componentMask17_g555 = temp_output_3_0_g555.zw;
			float4 lerpResult32_g555 = lerp( lerpResult29_g555 , tex2D( _BrushTexture, ( ( temp_cast_39.x * appendResult13_g555 ) + float4( ( _TextureOffset4 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g555, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult54_g554 = lerp( lerpResult32_g556 , lerpResult32_g555 , 0.5);
			float temp_output_4_0_g560 = saturate( (Luminance(( ( tex2D( _Ramp, appendResult5_g234.xy ) + CalculateContrast(1.25,lerpResult54_g554) ) * tex2D( _Ramp, appendResult5_g234.xy ) ).xyz)*3.0 + _ShadowSoftStep) );
			float4 appendResult5_g560 = (float4(temp_output_4_0_g560 , temp_output_4_0_g560 , 0.0 , 0.0));
			float2 temp_cast_50 = (_BrushStrokeTiling).xx;
			float4 transform46_g558 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g558 = (float4(transform46_g558.z , transform46_g558.x , 0.0 , 0.0));
			float4 tex2DNode23_g558 = tex2D( _BrushStrokeTexture, ( ( temp_cast_50.x * appendResult7_g558 ) + float4( _TextureOffset4, 0.0 , 0.0 ) ).xy );
			float2 temp_cast_55 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g558 = (float4(transform46_g558.z , transform46_g558.y , 0.0 , 0.0));
			float4 transform47_g558 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g558 = abs( transform47_g558 );
			float4 temp_output_3_0_g558 = ( temp_output_2_0_g558 * temp_output_2_0_g558 );
			float2 componentMask5_g558 = temp_output_3_0_g558.xw;
			float4 lerpResult26_g558 = lerp( tex2DNode23_g558 , tex2D( _BrushStrokeTexture, ( ( temp_cast_55.x * appendResult6_g558 ) + float4( _TextureOffset4, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g558, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g558 = temp_output_3_0_g558.yw;
			float4 lerpResult29_g558 = lerp( lerpResult26_g558 , tex2DNode23_g558 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g558, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_64 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g558 = (float4(transform46_g558.x , transform46_g558.y , 0.0 , 0.0));
			float2 componentMask17_g558 = temp_output_3_0_g558.zw;
			float4 lerpResult32_g558 = lerp( lerpResult29_g558 , tex2D( _BrushStrokeTexture, ( ( temp_cast_64.x * appendResult13_g558 ) + float4( _TextureOffset4, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g558, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_70 = (_BrushStrokeTiling).xx;
			float4 transform46_g557 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g557 = (float4(transform46_g557.z , transform46_g557.x , 0.0 , 0.0));
			float4 tex2DNode23_g557 = tex2D( _CircleTexture, ( ( temp_cast_70.x * appendResult7_g557 ) + float4( _TextureOffset4, 0.0 , 0.0 ) ).xy );
			float2 temp_cast_75 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g557 = (float4(transform46_g557.z , transform46_g557.y , 0.0 , 0.0));
			float4 transform47_g557 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g557 = abs( transform47_g557 );
			float4 temp_output_3_0_g557 = ( temp_output_2_0_g557 * temp_output_2_0_g557 );
			float2 componentMask5_g557 = temp_output_3_0_g557.xw;
			float4 lerpResult26_g557 = lerp( tex2DNode23_g557 , tex2D( _CircleTexture, ( ( temp_cast_75.x * appendResult6_g557 ) + float4( _TextureOffset4, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g557, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g557 = temp_output_3_0_g557.yw;
			float4 lerpResult29_g557 = lerp( lerpResult26_g557 , tex2DNode23_g557 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g557, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_84 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g557 = (float4(transform46_g557.x , transform46_g557.y , 0.0 , 0.0));
			float2 componentMask17_g557 = temp_output_3_0_g557.zw;
			float4 lerpResult32_g557 = lerp( lerpResult29_g557 , tex2D( _CircleTexture, ( ( temp_cast_84.x * appendResult13_g557 ) + float4( _TextureOffset4, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g557, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult12_g554 = lerp( float4( 0,0,0,0 ) , lerpResult32_g558 , step( _ShadowStrokeStep , Luminance(( lerpResult32_g557 * tex2D( _Ramp, appendResult5_g234.xy ) ).rgb) ));
			float temp_output_4_0_g559 = saturate( (0.0*0.2 + _ShadowSoftStrokeStep) );
			float4 appendResult5_g559 = (float4(temp_output_4_0_g559 , temp_output_4_0_g559 , 0.0 , 0.0));
			float4 lerpResult116 = lerp( ( lerpResult291 * lerpResult363 ) , ( lerpResult733 * ( lerpResult700 * lerpResult725 ) ) , saturate( ( tex2D( _Ramp, appendResult5_g560.xy ) + ( lerpResult12_g554 * tex2D( _Ramp, appendResult5_g559.xy ) ) ) ).r);
			float temp_output_273_0 = ( ( _LightColor0.a + ( _Metalness * 0.3 ) ) * temp_output_696_0 );
			float temp_output_4_0_g561 = saturate( (lerpResult632*0.03 + 0.476) );
			float4 appendResult5_g561 = (float4(temp_output_4_0_g561 , temp_output_4_0_g561 , 0.0 , 0.0));
			float2 temp_cast_98 = (_BrushTextureTiling).xx;
			float4 transform46_g564 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g564 = (float4(transform46_g564.z , transform46_g564.x , 0.0 , 0.0));
			float4 tex2DNode23_g564 = tex2D( _BrushTexture, ( ( ( temp_cast_98 * 0.75 ).x * appendResult7_g564 ) + float4( ( float2( 0,0 ) + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_103 = (_BrushTextureTiling).xx;
			float4 appendResult6_g564 = (float4(transform46_g564.z , transform46_g564.y , 0.0 , 0.0));
			float4 transform47_g564 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g564 = abs( transform47_g564 );
			float4 temp_output_3_0_g564 = ( temp_output_2_0_g564 * temp_output_2_0_g564 );
			float2 componentMask5_g564 = temp_output_3_0_g564.xw;
			float4 lerpResult26_g564 = lerp( tex2DNode23_g564 , tex2D( _BrushTexture, ( ( ( temp_cast_103 * 0.75 ).x * appendResult6_g564 ) + float4( ( float2( 0,0 ) + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g564, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g564 = temp_output_3_0_g564.yw;
			float4 lerpResult29_g564 = lerp( lerpResult26_g564 , tex2DNode23_g564 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g564, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_112 = (_BrushTextureTiling).xx;
			float4 appendResult13_g564 = (float4(transform46_g564.x , transform46_g564.y , 0.0 , 0.0));
			float2 componentMask17_g564 = temp_output_3_0_g564.zw;
			float4 lerpResult32_g564 = lerp( lerpResult29_g564 , tex2D( _BrushTexture, ( ( ( temp_cast_112 * 0.75 ).x * appendResult13_g564 ) + float4( ( float2( 0,0 ) + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g564, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_118 = (_BrushTextureTiling).xx;
			float4 transform46_g563 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g563 = (float4(transform46_g563.z , transform46_g563.x , 0.0 , 0.0));
			float4 tex2DNode23_g563 = tex2D( _BrushTexture, ( ( temp_cast_118.x * appendResult7_g563 ) + float4( ( float2( 0,0 ) + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_123 = (_BrushTextureTiling).xx;
			float4 appendResult6_g563 = (float4(transform46_g563.z , transform46_g563.y , 0.0 , 0.0));
			float4 transform47_g563 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g563 = abs( transform47_g563 );
			float4 temp_output_3_0_g563 = ( temp_output_2_0_g563 * temp_output_2_0_g563 );
			float2 componentMask5_g563 = temp_output_3_0_g563.xw;
			float4 lerpResult26_g563 = lerp( tex2DNode23_g563 , tex2D( _BrushTexture, ( ( temp_cast_123.x * appendResult6_g563 ) + float4( ( float2( 0,0 ) + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g563, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g563 = temp_output_3_0_g563.yw;
			float4 lerpResult29_g563 = lerp( lerpResult26_g563 , tex2DNode23_g563 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g563, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_132 = (_BrushTextureTiling).xx;
			float4 appendResult13_g563 = (float4(transform46_g563.x , transform46_g563.y , 0.0 , 0.0));
			float2 componentMask17_g563 = temp_output_3_0_g563.zw;
			float4 lerpResult32_g563 = lerp( lerpResult29_g563 , tex2D( _BrushTexture, ( ( temp_cast_132.x * appendResult13_g563 ) + float4( ( float2( 0,0 ) + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g563, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult54_g562 = lerp( lerpResult32_g564 , lerpResult32_g563 , 0.5);
			float temp_output_732_0 = (0.2 + (lerpResult738 - 0.0) * (0.4 - 0.2) / (1.0 - 0.0));
			float temp_output_4_0_g568 = saturate( (Luminance(( ( tex2D( _Ramp, appendResult5_g561.xy ) + CalculateContrast(1.25,lerpResult54_g562) ) * tex2D( _Ramp, appendResult5_g561.xy ) ).xyz)*3.0 + temp_output_732_0) );
			float4 appendResult5_g568 = (float4(temp_output_4_0_g568 , temp_output_4_0_g568 , 0.0 , 0.0));
			float2 temp_cast_143 = (_BrushStrokeTiling).xx;
			float4 transform46_g566 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g566 = (float4(transform46_g566.z , transform46_g566.x , 0.0 , 0.0));
			float4 tex2DNode23_g566 = tex2D( _BrushStrokeTexture, ( ( temp_cast_143.x * appendResult7_g566 ) + float4( float2( 0,0 ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_148 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g566 = (float4(transform46_g566.z , transform46_g566.y , 0.0 , 0.0));
			float4 transform47_g566 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g566 = abs( transform47_g566 );
			float4 temp_output_3_0_g566 = ( temp_output_2_0_g566 * temp_output_2_0_g566 );
			float2 componentMask5_g566 = temp_output_3_0_g566.xw;
			float4 lerpResult26_g566 = lerp( tex2DNode23_g566 , tex2D( _BrushStrokeTexture, ( ( temp_cast_148.x * appendResult6_g566 ) + float4( float2( 0,0 ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g566, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g566 = temp_output_3_0_g566.yw;
			float4 lerpResult29_g566 = lerp( lerpResult26_g566 , tex2DNode23_g566 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g566, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_157 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g566 = (float4(transform46_g566.x , transform46_g566.y , 0.0 , 0.0));
			float2 componentMask17_g566 = temp_output_3_0_g566.zw;
			float4 lerpResult32_g566 = lerp( lerpResult29_g566 , tex2D( _BrushStrokeTexture, ( ( temp_cast_157.x * appendResult13_g566 ) + float4( float2( 0,0 ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g566, 0.0 , 0.0 )) , 5.0 ) ).r);
			float lerpResult730 = lerp( 0.18 , 0.075 , lerpResult738);
			float2 temp_cast_163 = (_BrushStrokeTiling).xx;
			float4 transform46_g565 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g565 = (float4(transform46_g565.z , transform46_g565.x , 0.0 , 0.0));
			float4 tex2DNode23_g565 = tex2D( _CircleTexture, ( ( temp_cast_163.x * appendResult7_g565 ) + float4( float2( 0,0 ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_168 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g565 = (float4(transform46_g565.z , transform46_g565.y , 0.0 , 0.0));
			float4 transform47_g565 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g565 = abs( transform47_g565 );
			float4 temp_output_3_0_g565 = ( temp_output_2_0_g565 * temp_output_2_0_g565 );
			float2 componentMask5_g565 = temp_output_3_0_g565.xw;
			float4 lerpResult26_g565 = lerp( tex2DNode23_g565 , tex2D( _CircleTexture, ( ( temp_cast_168.x * appendResult6_g565 ) + float4( float2( 0,0 ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g565, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g565 = temp_output_3_0_g565.yw;
			float4 lerpResult29_g565 = lerp( lerpResult26_g565 , tex2DNode23_g565 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g565, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_177 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g565 = (float4(transform46_g565.x , transform46_g565.y , 0.0 , 0.0));
			float2 componentMask17_g565 = temp_output_3_0_g565.zw;
			float4 lerpResult32_g565 = lerp( lerpResult29_g565 , tex2D( _CircleTexture, ( ( temp_cast_177.x * appendResult13_g565 ) + float4( float2( 0,0 ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g565, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult12_g562 = lerp( float4( 0,0,0,0 ) , lerpResult32_g566 , step( lerpResult730 , Luminance(( lerpResult32_g565 * tex2D( _Ramp, appendResult5_g561.xy ) ).rgb) ));
			float temp_output_4_0_g567 = saturate( (0.0*0.2 + _LightSoftStepStrokes) );
			float4 appendResult5_g567 = (float4(temp_output_4_0_g567 , temp_output_4_0_g567 , 0.0 , 0.0));
			float4 lerpResult319 = lerp( lerpResult116 , ( ( lerpResult754 + ( temp_output_273_0 * 0.25 ) ) * lerpResult733 ) , saturate( ( tex2D( _Ramp, appendResult5_g568.xy ) + ( lerpResult12_g562 * tex2D( _Ramp, appendResult5_g567.xy ) ) ) ).r);
			float2 temp_cast_191 = (_BrushTextureTiling).xx;
			float4 transform46_g571 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g571 = (float4(transform46_g571.z , transform46_g571.x , 0.0 , 0.0));
			float2 temp_output_595_0 = ( _TextureOffset4 + float2( 0.2,0.2 ) );
			float4 tex2DNode23_g571 = tex2D( _BrushTexture, ( ( ( temp_cast_191 * 0.75 ).x * appendResult7_g571 ) + float4( ( temp_output_595_0 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_196 = (_BrushTextureTiling).xx;
			float4 appendResult6_g571 = (float4(transform46_g571.z , transform46_g571.y , 0.0 , 0.0));
			float4 transform47_g571 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g571 = abs( transform47_g571 );
			float4 temp_output_3_0_g571 = ( temp_output_2_0_g571 * temp_output_2_0_g571 );
			float2 componentMask5_g571 = temp_output_3_0_g571.xw;
			float4 lerpResult26_g571 = lerp( tex2DNode23_g571 , tex2D( _BrushTexture, ( ( ( temp_cast_196 * 0.75 ).x * appendResult6_g571 ) + float4( ( temp_output_595_0 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g571, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g571 = temp_output_3_0_g571.yw;
			float4 lerpResult29_g571 = lerp( lerpResult26_g571 , tex2DNode23_g571 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g571, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_205 = (_BrushTextureTiling).xx;
			float4 appendResult13_g571 = (float4(transform46_g571.x , transform46_g571.y , 0.0 , 0.0));
			float2 componentMask17_g571 = temp_output_3_0_g571.zw;
			float4 lerpResult32_g571 = lerp( lerpResult29_g571 , tex2D( _BrushTexture, ( ( ( temp_cast_205 * 0.75 ).x * appendResult13_g571 ) + float4( ( temp_output_595_0 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g571, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_211 = (_BrushTextureTiling).xx;
			float4 transform46_g570 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g570 = (float4(transform46_g570.z , transform46_g570.x , 0.0 , 0.0));
			float4 tex2DNode23_g570 = tex2D( _BrushTexture, ( ( temp_cast_211.x * appendResult7_g570 ) + float4( ( temp_output_595_0 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_216 = (_BrushTextureTiling).xx;
			float4 appendResult6_g570 = (float4(transform46_g570.z , transform46_g570.y , 0.0 , 0.0));
			float4 transform47_g570 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g570 = abs( transform47_g570 );
			float4 temp_output_3_0_g570 = ( temp_output_2_0_g570 * temp_output_2_0_g570 );
			float2 componentMask5_g570 = temp_output_3_0_g570.xw;
			float4 lerpResult26_g570 = lerp( tex2DNode23_g570 , tex2D( _BrushTexture, ( ( temp_cast_216.x * appendResult6_g570 ) + float4( ( temp_output_595_0 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g570, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g570 = temp_output_3_0_g570.yw;
			float4 lerpResult29_g570 = lerp( lerpResult26_g570 , tex2DNode23_g570 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g570, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_225 = (_BrushTextureTiling).xx;
			float4 appendResult13_g570 = (float4(transform46_g570.x , transform46_g570.y , 0.0 , 0.0));
			float2 componentMask17_g570 = temp_output_3_0_g570.zw;
			float4 lerpResult32_g570 = lerp( lerpResult29_g570 , tex2D( _BrushTexture, ( ( temp_cast_225.x * appendResult13_g570 ) + float4( ( temp_output_595_0 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g570, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult54_g569 = lerp( lerpResult32_g571 , lerpResult32_g570 , 0.5);
			float temp_output_612_0 = ( temp_output_732_0 + -0.1 );
			float temp_output_4_0_g575 = saturate( (Luminance(( ( tex2D( _Ramp, appendResult5_g561.xy ) + CalculateContrast(1.25,lerpResult54_g569) ) * tex2D( _Ramp, appendResult5_g561.xy ) ).xyz)*3.0 + temp_output_612_0) );
			float4 appendResult5_g575 = (float4(temp_output_4_0_g575 , temp_output_4_0_g575 , 0.0 , 0.0));
			float2 temp_cast_236 = (_BrushStrokeTiling).xx;
			float4 transform46_g573 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g573 = (float4(transform46_g573.z , transform46_g573.x , 0.0 , 0.0));
			float4 tex2DNode23_g573 = tex2D( _BrushStrokeTexture, ( ( temp_cast_236.x * appendResult7_g573 ) + float4( temp_output_595_0, 0.0 , 0.0 ) ).xy );
			float2 temp_cast_241 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g573 = (float4(transform46_g573.z , transform46_g573.y , 0.0 , 0.0));
			float4 transform47_g573 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g573 = abs( transform47_g573 );
			float4 temp_output_3_0_g573 = ( temp_output_2_0_g573 * temp_output_2_0_g573 );
			float2 componentMask5_g573 = temp_output_3_0_g573.xw;
			float4 lerpResult26_g573 = lerp( tex2DNode23_g573 , tex2D( _BrushStrokeTexture, ( ( temp_cast_241.x * appendResult6_g573 ) + float4( temp_output_595_0, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g573, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g573 = temp_output_3_0_g573.yw;
			float4 lerpResult29_g573 = lerp( lerpResult26_g573 , tex2DNode23_g573 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g573, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_250 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g573 = (float4(transform46_g573.x , transform46_g573.y , 0.0 , 0.0));
			float2 componentMask17_g573 = temp_output_3_0_g573.zw;
			float4 lerpResult32_g573 = lerp( lerpResult29_g573 , tex2D( _BrushStrokeTexture, ( ( temp_cast_250.x * appendResult13_g573 ) + float4( temp_output_595_0, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g573, 0.0 , 0.0 )) , 5.0 ) ).r);
			float temp_output_605_0 = ( lerpResult730 + 0.025 );
			float2 temp_cast_256 = (_BrushStrokeTiling).xx;
			float4 transform46_g572 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g572 = (float4(transform46_g572.z , transform46_g572.x , 0.0 , 0.0));
			float4 tex2DNode23_g572 = tex2D( _CircleTexture, ( ( temp_cast_256.x * appendResult7_g572 ) + float4( temp_output_595_0, 0.0 , 0.0 ) ).xy );
			float2 temp_cast_261 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g572 = (float4(transform46_g572.z , transform46_g572.y , 0.0 , 0.0));
			float4 transform47_g572 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g572 = abs( transform47_g572 );
			float4 temp_output_3_0_g572 = ( temp_output_2_0_g572 * temp_output_2_0_g572 );
			float2 componentMask5_g572 = temp_output_3_0_g572.xw;
			float4 lerpResult26_g572 = lerp( tex2DNode23_g572 , tex2D( _CircleTexture, ( ( temp_cast_261.x * appendResult6_g572 ) + float4( temp_output_595_0, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g572, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g572 = temp_output_3_0_g572.yw;
			float4 lerpResult29_g572 = lerp( lerpResult26_g572 , tex2DNode23_g572 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g572, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_270 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g572 = (float4(transform46_g572.x , transform46_g572.y , 0.0 , 0.0));
			float2 componentMask17_g572 = temp_output_3_0_g572.zw;
			float4 lerpResult32_g572 = lerp( lerpResult29_g572 , tex2D( _CircleTexture, ( ( temp_cast_270.x * appendResult13_g572 ) + float4( temp_output_595_0, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g572, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult12_g569 = lerp( float4( 0,0,0,0 ) , lerpResult32_g573 , step( temp_output_605_0 , Luminance(( lerpResult32_g572 * tex2D( _Ramp, appendResult5_g561.xy ) ).rgb) ));
			float temp_output_4_0_g574 = saturate( (0.0*0.2 + _LightSoftStepStrokes) );
			float4 appendResult5_g574 = (float4(temp_output_4_0_g574 , temp_output_4_0_g574 , 0.0 , 0.0));
			float4 lerpResult149 = lerp( lerpResult319 , ( ( _Metalness + ( temp_output_273_0 * 0.5 ) ) * lerpResult733 ) , saturate( ( tex2D( _Ramp, appendResult5_g575.xy ) + ( lerpResult12_g569 * tex2D( _Ramp, appendResult5_g574.xy ) ) ) ).r);
			float2 temp_cast_284 = (_BrushTextureTiling).xx;
			float4 transform46_g578 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g578 = (float4(transform46_g578.z , transform46_g578.x , 0.0 , 0.0));
			float2 temp_output_613_0 = ( temp_output_595_0 + float2( 0.2,0.2 ) );
			float4 tex2DNode23_g578 = tex2D( _BrushTexture, ( ( ( temp_cast_284 * 0.75 ).x * appendResult7_g578 ) + float4( ( temp_output_613_0 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_289 = (_BrushTextureTiling).xx;
			float4 appendResult6_g578 = (float4(transform46_g578.z , transform46_g578.y , 0.0 , 0.0));
			float4 transform47_g578 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g578 = abs( transform47_g578 );
			float4 temp_output_3_0_g578 = ( temp_output_2_0_g578 * temp_output_2_0_g578 );
			float2 componentMask5_g578 = temp_output_3_0_g578.xw;
			float4 lerpResult26_g578 = lerp( tex2DNode23_g578 , tex2D( _BrushTexture, ( ( ( temp_cast_289 * 0.75 ).x * appendResult6_g578 ) + float4( ( temp_output_613_0 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g578, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g578 = temp_output_3_0_g578.yw;
			float4 lerpResult29_g578 = lerp( lerpResult26_g578 , tex2DNode23_g578 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g578, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_298 = (_BrushTextureTiling).xx;
			float4 appendResult13_g578 = (float4(transform46_g578.x , transform46_g578.y , 0.0 , 0.0));
			float2 componentMask17_g578 = temp_output_3_0_g578.zw;
			float4 lerpResult32_g578 = lerp( lerpResult29_g578 , tex2D( _BrushTexture, ( ( ( temp_cast_298 * 0.75 ).x * appendResult13_g578 ) + float4( ( temp_output_613_0 + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g578, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_304 = (_BrushTextureTiling).xx;
			float4 transform46_g577 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g577 = (float4(transform46_g577.z , transform46_g577.x , 0.0 , 0.0));
			float4 tex2DNode23_g577 = tex2D( _BrushTexture, ( ( temp_cast_304.x * appendResult7_g577 ) + float4( ( temp_output_613_0 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_309 = (_BrushTextureTiling).xx;
			float4 appendResult6_g577 = (float4(transform46_g577.z , transform46_g577.y , 0.0 , 0.0));
			float4 transform47_g577 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g577 = abs( transform47_g577 );
			float4 temp_output_3_0_g577 = ( temp_output_2_0_g577 * temp_output_2_0_g577 );
			float2 componentMask5_g577 = temp_output_3_0_g577.xw;
			float4 lerpResult26_g577 = lerp( tex2DNode23_g577 , tex2D( _BrushTexture, ( ( temp_cast_309.x * appendResult6_g577 ) + float4( ( temp_output_613_0 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g577, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g577 = temp_output_3_0_g577.yw;
			float4 lerpResult29_g577 = lerp( lerpResult26_g577 , tex2DNode23_g577 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g577, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_318 = (_BrushTextureTiling).xx;
			float4 appendResult13_g577 = (float4(transform46_g577.x , transform46_g577.y , 0.0 , 0.0));
			float2 componentMask17_g577 = temp_output_3_0_g577.zw;
			float4 lerpResult32_g577 = lerp( lerpResult29_g577 , tex2D( _BrushTexture, ( ( temp_cast_318.x * appendResult13_g577 ) + float4( ( temp_output_613_0 + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g577, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult54_g576 = lerp( lerpResult32_g578 , lerpResult32_g577 , 0.5);
			float temp_output_615_0 = ( temp_output_612_0 + -0.1 );
			float temp_output_4_0_g582 = saturate( (Luminance(( ( tex2D( _Ramp, appendResult5_g561.xy ) + CalculateContrast(1.25,lerpResult54_g576) ) * tex2D( _Ramp, appendResult5_g561.xy ) ).xyz)*3.0 + temp_output_615_0) );
			float4 appendResult5_g582 = (float4(temp_output_4_0_g582 , temp_output_4_0_g582 , 0.0 , 0.0));
			float2 temp_cast_329 = (_BrushStrokeTiling).xx;
			float4 transform46_g580 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g580 = (float4(transform46_g580.z , transform46_g580.x , 0.0 , 0.0));
			float4 tex2DNode23_g580 = tex2D( _BrushStrokeTexture, ( ( temp_cast_329.x * appendResult7_g580 ) + float4( temp_output_613_0, 0.0 , 0.0 ) ).xy );
			float2 temp_cast_334 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g580 = (float4(transform46_g580.z , transform46_g580.y , 0.0 , 0.0));
			float4 transform47_g580 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g580 = abs( transform47_g580 );
			float4 temp_output_3_0_g580 = ( temp_output_2_0_g580 * temp_output_2_0_g580 );
			float2 componentMask5_g580 = temp_output_3_0_g580.xw;
			float4 lerpResult26_g580 = lerp( tex2DNode23_g580 , tex2D( _BrushStrokeTexture, ( ( temp_cast_334.x * appendResult6_g580 ) + float4( temp_output_613_0, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g580, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g580 = temp_output_3_0_g580.yw;
			float4 lerpResult29_g580 = lerp( lerpResult26_g580 , tex2DNode23_g580 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g580, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_343 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g580 = (float4(transform46_g580.x , transform46_g580.y , 0.0 , 0.0));
			float2 componentMask17_g580 = temp_output_3_0_g580.zw;
			float4 lerpResult32_g580 = lerp( lerpResult29_g580 , tex2D( _BrushStrokeTexture, ( ( temp_cast_343.x * appendResult13_g580 ) + float4( temp_output_613_0, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g580, 0.0 , 0.0 )) , 5.0 ) ).r);
			float temp_output_614_0 = ( temp_output_605_0 + 0.025 );
			float2 temp_cast_349 = (_BrushStrokeTiling).xx;
			float4 transform46_g579 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g579 = (float4(transform46_g579.z , transform46_g579.x , 0.0 , 0.0));
			float4 tex2DNode23_g579 = tex2D( _CircleTexture, ( ( temp_cast_349.x * appendResult7_g579 ) + float4( temp_output_613_0, 0.0 , 0.0 ) ).xy );
			float2 temp_cast_354 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g579 = (float4(transform46_g579.z , transform46_g579.y , 0.0 , 0.0));
			float4 transform47_g579 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g579 = abs( transform47_g579 );
			float4 temp_output_3_0_g579 = ( temp_output_2_0_g579 * temp_output_2_0_g579 );
			float2 componentMask5_g579 = temp_output_3_0_g579.xw;
			float4 lerpResult26_g579 = lerp( tex2DNode23_g579 , tex2D( _CircleTexture, ( ( temp_cast_354.x * appendResult6_g579 ) + float4( temp_output_613_0, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g579, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g579 = temp_output_3_0_g579.yw;
			float4 lerpResult29_g579 = lerp( lerpResult26_g579 , tex2DNode23_g579 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g579, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_363 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g579 = (float4(transform46_g579.x , transform46_g579.y , 0.0 , 0.0));
			float2 componentMask17_g579 = temp_output_3_0_g579.zw;
			float4 lerpResult32_g579 = lerp( lerpResult29_g579 , tex2D( _CircleTexture, ( ( temp_cast_363.x * appendResult13_g579 ) + float4( temp_output_613_0, 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g579, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult12_g576 = lerp( float4( 0,0,0,0 ) , lerpResult32_g580 , step( temp_output_614_0 , Luminance(( lerpResult32_g579 * tex2D( _Ramp, appendResult5_g561.xy ) ).rgb) ));
			float temp_output_4_0_g581 = saturate( (0.0*0.2 + _LightSoftStepStrokes) );
			float4 appendResult5_g581 = (float4(temp_output_4_0_g581 , temp_output_4_0_g581 , 0.0 , 0.0));
			float4 lerpResult177 = lerp( lerpResult149 , ( ( lerpResult754 + ( temp_output_273_0 * 0.75 ) ) * lerpResult733 ) , saturate( ( tex2D( _Ramp, appendResult5_g582.xy ) + ( lerpResult12_g576 * tex2D( _Ramp, appendResult5_g581.xy ) ) ) ).r);
			float2 temp_cast_377 = (_BrushTextureTiling).xx;
			float4 transform46_g585 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g585 = (float4(transform46_g585.z , transform46_g585.x , 0.0 , 0.0));
			float4 tex2DNode23_g585 = tex2D( _BrushTexture, ( ( ( temp_cast_377 * 0.75 ).x * appendResult7_g585 ) + float4( ( ( temp_output_613_0 + float2( 0.2,0.2 ) ) + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_382 = (_BrushTextureTiling).xx;
			float4 appendResult6_g585 = (float4(transform46_g585.z , transform46_g585.y , 0.0 , 0.0));
			float4 transform47_g585 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g585 = abs( transform47_g585 );
			float4 temp_output_3_0_g585 = ( temp_output_2_0_g585 * temp_output_2_0_g585 );
			float2 componentMask5_g585 = temp_output_3_0_g585.xw;
			float4 lerpResult26_g585 = lerp( tex2DNode23_g585 , tex2D( _BrushTexture, ( ( ( temp_cast_382 * 0.75 ).x * appendResult6_g585 ) + float4( ( ( temp_output_613_0 + float2( 0.2,0.2 ) ) + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g585, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g585 = temp_output_3_0_g585.yw;
			float4 lerpResult29_g585 = lerp( lerpResult26_g585 , tex2DNode23_g585 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g585, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_391 = (_BrushTextureTiling).xx;
			float4 appendResult13_g585 = (float4(transform46_g585.x , transform46_g585.y , 0.0 , 0.0));
			float2 componentMask17_g585 = temp_output_3_0_g585.zw;
			float4 lerpResult32_g585 = lerp( lerpResult29_g585 , tex2D( _BrushTexture, ( ( ( temp_cast_391 * 0.75 ).x * appendResult13_g585 ) + float4( ( ( temp_output_613_0 + float2( 0.2,0.2 ) ) + ( _Time.y * _MouvSpeed * -1.0 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g585, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_397 = (_BrushTextureTiling).xx;
			float4 transform46_g584 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g584 = (float4(transform46_g584.z , transform46_g584.x , 0.0 , 0.0));
			float4 tex2DNode23_g584 = tex2D( _BrushTexture, ( ( temp_cast_397.x * appendResult7_g584 ) + float4( ( ( temp_output_613_0 + float2( 0.2,0.2 ) ) + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_402 = (_BrushTextureTiling).xx;
			float4 appendResult6_g584 = (float4(transform46_g584.z , transform46_g584.y , 0.0 , 0.0));
			float4 transform47_g584 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g584 = abs( transform47_g584 );
			float4 temp_output_3_0_g584 = ( temp_output_2_0_g584 * temp_output_2_0_g584 );
			float2 componentMask5_g584 = temp_output_3_0_g584.xw;
			float4 lerpResult26_g584 = lerp( tex2DNode23_g584 , tex2D( _BrushTexture, ( ( temp_cast_402.x * appendResult6_g584 ) + float4( ( ( temp_output_613_0 + float2( 0.2,0.2 ) ) + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g584, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g584 = temp_output_3_0_g584.yw;
			float4 lerpResult29_g584 = lerp( lerpResult26_g584 , tex2DNode23_g584 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g584, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_411 = (_BrushTextureTiling).xx;
			float4 appendResult13_g584 = (float4(transform46_g584.x , transform46_g584.y , 0.0 , 0.0));
			float2 componentMask17_g584 = temp_output_3_0_g584.zw;
			float4 lerpResult32_g584 = lerp( lerpResult29_g584 , tex2D( _BrushTexture, ( ( temp_cast_411.x * appendResult13_g584 ) + float4( ( ( temp_output_613_0 + float2( 0.2,0.2 ) ) + ( _Time.y * _MouvSpeed ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g584, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult54_g583 = lerp( lerpResult32_g585 , lerpResult32_g584 , 0.5);
			float temp_output_4_0_g589 = saturate( (Luminance(( ( tex2D( _Ramp, appendResult5_g561.xy ) + CalculateContrast(1.25,lerpResult54_g583) ) * tex2D( _Ramp, appendResult5_g561.xy ) ).xyz)*3.0 + ( temp_output_615_0 + -0.1 )) );
			float4 appendResult5_g589 = (float4(temp_output_4_0_g589 , temp_output_4_0_g589 , 0.0 , 0.0));
			float2 temp_cast_422 = (_BrushStrokeTiling).xx;
			float4 transform46_g587 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g587 = (float4(transform46_g587.z , transform46_g587.x , 0.0 , 0.0));
			float4 tex2DNode23_g587 = tex2D( _BrushStrokeTexture, ( ( temp_cast_422.x * appendResult7_g587 ) + float4( ( temp_output_613_0 + float2( 0.2,0.2 ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_427 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g587 = (float4(transform46_g587.z , transform46_g587.y , 0.0 , 0.0));
			float4 transform47_g587 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g587 = abs( transform47_g587 );
			float4 temp_output_3_0_g587 = ( temp_output_2_0_g587 * temp_output_2_0_g587 );
			float2 componentMask5_g587 = temp_output_3_0_g587.xw;
			float4 lerpResult26_g587 = lerp( tex2DNode23_g587 , tex2D( _BrushStrokeTexture, ( ( temp_cast_427.x * appendResult6_g587 ) + float4( ( temp_output_613_0 + float2( 0.2,0.2 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g587, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g587 = temp_output_3_0_g587.yw;
			float4 lerpResult29_g587 = lerp( lerpResult26_g587 , tex2DNode23_g587 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g587, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_436 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g587 = (float4(transform46_g587.x , transform46_g587.y , 0.0 , 0.0));
			float2 componentMask17_g587 = temp_output_3_0_g587.zw;
			float4 lerpResult32_g587 = lerp( lerpResult29_g587 , tex2D( _BrushStrokeTexture, ( ( temp_cast_436.x * appendResult13_g587 ) + float4( ( temp_output_613_0 + float2( 0.2,0.2 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g587, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_442 = (_BrushStrokeTiling).xx;
			float4 transform46_g586 = mul(unity_WorldToObject,float4( ase_worldPos , 0.0 ));
			float4 appendResult7_g586 = (float4(transform46_g586.z , transform46_g586.x , 0.0 , 0.0));
			float4 tex2DNode23_g586 = tex2D( _CircleTexture, ( ( temp_cast_442.x * appendResult7_g586 ) + float4( ( temp_output_613_0 + float2( 0.2,0.2 ) ), 0.0 , 0.0 ) ).xy );
			float2 temp_cast_447 = (_BrushStrokeTiling).xx;
			float4 appendResult6_g586 = (float4(transform46_g586.z , transform46_g586.y , 0.0 , 0.0));
			float4 transform47_g586 = mul(unity_WorldToObject,float4( ase_worldNormal , 0.0 ));
			float4 temp_output_2_0_g586 = abs( transform47_g586 );
			float4 temp_output_3_0_g586 = ( temp_output_2_0_g586 * temp_output_2_0_g586 );
			float2 componentMask5_g586 = temp_output_3_0_g586.xw;
			float4 lerpResult26_g586 = lerp( tex2DNode23_g586 , tex2D( _CircleTexture, ( ( temp_cast_447.x * appendResult6_g586 ) + float4( ( temp_output_613_0 + float2( 0.2,0.2 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask5_g586, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 componentMask11_g586 = temp_output_3_0_g586.yw;
			float4 lerpResult29_g586 = lerp( lerpResult26_g586 , tex2DNode23_g586 , saturate( pow( CalculateContrast(4.0,float4( componentMask11_g586, 0.0 , 0.0 )) , 5.0 ) ).r);
			float2 temp_cast_456 = (_BrushStrokeTiling).xx;
			float4 appendResult13_g586 = (float4(transform46_g586.x , transform46_g586.y , 0.0 , 0.0));
			float2 componentMask17_g586 = temp_output_3_0_g586.zw;
			float4 lerpResult32_g586 = lerp( lerpResult29_g586 , tex2D( _CircleTexture, ( ( temp_cast_456.x * appendResult13_g586 ) + float4( ( temp_output_613_0 + float2( 0.2,0.2 ) ), 0.0 , 0.0 ) ).xy ) , saturate( pow( CalculateContrast(4.0,float4( componentMask17_g586, 0.0 , 0.0 )) , 5.0 ) ).r);
			float4 lerpResult12_g583 = lerp( float4( 0,0,0,0 ) , lerpResult32_g587 , step( ( temp_output_614_0 + 0.025 ) , Luminance(( lerpResult32_g586 * tex2D( _Ramp, appendResult5_g561.xy ) ).rgb) ));
			float temp_output_4_0_g588 = saturate( (0.0*0.2 + _LightSoftStepStrokes) );
			float4 appendResult5_g588 = (float4(temp_output_4_0_g588 , temp_output_4_0_g588 , 0.0 , 0.0));
			float4 lerpResult254 = lerp( lerpResult177 , ( ( lerpResult754 + temp_output_273_0 ) * lerpResult733 ) , saturate( ( tex2D( _Ramp, appendResult5_g589.xy ) + ( lerpResult12_g583 * tex2D( _Ramp, appendResult5_g588.xy ) ) ) ).r);
			float3 indirectNormal297 = WorldNormalVector( i , tex2DNode551 );
			Unity_GlossyEnvironmentData g297;
			g297.roughness = 1.0;
			g297.reflUVW = reflect( -data.worldViewDir, indirectNormal297 );
			float3 indirectSpecular297 = UnityGI_IndirectSpecular( data, 1.0, indirectNormal297, g297 );
			float3 lerpResult295 = lerp( float3( 0.0,0,0 ) , indirectSpecular297 , _AmbiantLightStrength);
			c.rgb = ( lerpResult254 + float4( lerpResult295 , 0.0 ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred nodirlightmap 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				float4 texcoords01 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.texcoords01 = float4( v.texcoord.xy, v.texcoord1.xy );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord.xy = IN.texcoords01.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13201
1939;127;1684;906;682.7576;98.77215;2.104966;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;742;275.3755,369.4816;Float;True;Property;_Splat0;Splat0;24;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.TexturePropertyNode;743;277.1051,587.6857;Float;True;Property;_Splat1;Splat1;27;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.TexturePropertyNode;741;-76.05655,108.7642;Float;True;Property;_Control;Control;20;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SamplerNode;745;177.3347,108.6218;Float;True;Property;_TextureSample6;Texture Sample 6;24;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;744;574.8729,369.9662;Float;True;Property;_TextureSample2;Texture Sample 2;24;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;746;574.8729,587.1396;Float;True;Property;_TextureSample8;Texture Sample 8;24;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;747;271.9106,812.8192;Float;True;Property;_Splat2;Splat2;26;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.CommentaryNode;702;-2369.552,1293.266;Float;False;2411.398;1112.047;;18;551;557;553;49;552;635;637;636;634;571;610;611;632;600;642;641;640;717;Light Vector;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;748;1071.796,406.7753;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.TexturePropertyNode;750;283.045,1041.788;Float;True;Property;_Splat3;Splat3;25;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.RangedFloatNode;718;1853.382,1081.45;Float;False;Property;_Metalness;Metalness;22;0;0.5;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;751;1276.086,554.0115;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;551;-2319.552,1530.266;Float;True;Property;_Normal;Normal;3;0;Assets/Textures/T_Briques_N.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;749;576.7139,811.6749;Float;True;Property;_TextureSample10;Texture Sample 10;24;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;557;-2089.552,1343.266;Float;False;Constant;_Color0;Color 0;15;0;0.4980392,0.4980392,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;553;-2149.552,1736.266;Float;False;Property;_NormalIntensity;Normal Intensity;10;0;0.5;0;0.5;0;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;49;-1512.098,1489.73;Float;False;731.401;320.6003;Comment;5;352;344;53;50;52;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;753;1493.26,741.7377;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;752;573.0328,1038.051;Float;True;Property;_TextureSample12;Texture Sample 12;24;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;552;-1825.602,1504.538;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;739;1365.535,3381.145;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.2;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;695;1247.156,3233.73;Float;False;Property;_Roughness;Roughness;23;0;0.5;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;738;1536.535,3358.145;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;635;-1462.61,2133.885;Float;False;World;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.WorldNormalVector;52;-1400.1,1537.73;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;50;-1448.1,1697.731;Float;False;1;0;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;698;2303.842,1472.489;Float;False;Constant;_Float3;Float 3;28;0;0.5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;754;1697.551,916.5807;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;699;2690.331,1450.582;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.DotProductOpNode;637;-1262.345,2116.841;Float;False;2;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;740;2240.498,1094.645;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.LightColorNode;115;2046.627,727.1579;Float;True;0;3;COLOR;FLOAT3;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;634;-1275.504,1841.055;Float;False;Property;_SpecularStrength;Specular Strength;18;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.DotProductOpNode;53;-1112.099,1601.73;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;696;2462.034,985.0536;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LightAttenuation;352;-1144.521,1530.155;Float;False;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;727;2386.057,862.3914;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.3;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;-926.1151,1559.929;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;733;2589.087,1075.667;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;697;2843.125,1428.098;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.TFHCGrayscale;636;-1123.72,2111.039;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;726;2544.249,799.6393;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;717;-967.748,1909.125;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;632;-726.9901,1592.527;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;725;3044.413,1656.187;Float;False;3;0;FLOAT;1.0;False;1;FLOAT;0.5;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;3034.6,810.2264;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;102;2728.485,396.5167;Float;False;Property;_ShadowColor;Shadow Color;11;0;0.1617647,0.08207179,0.08207179,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;290;2807.827,250.6423;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;272;2732.823,575.4328;Float;False;Property;_ShadowOpacity;ShadowOpacity;12;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;700;3042.97,1517.747;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.CommentaryNode;643;1901.971,1762.139;Float;False;894.8264;719.6025;;6;593;599;108;317;361;567;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;611;-539.0967,1802.38;Float;False;Property;_Position;Position;19;0;0.476;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;571;-269.4276,1354.605;Float;True;Property;_Ramp;Ramp;9;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.RangedFloatNode;610;-547.0967,1701.38;Float;False;Property;_Contrast;Contrast;21;0;0.03;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;639;2806.949,164.1661;Float;False;Constant;_Float1;Float 1;20;0;0.5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;701;1755.678,2666.022;Float;False;1144.633;2014.232;;18;279;592;605;595;612;691;615;692;613;614;617;693;619;622;694;730;731;732;highlights;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;410;1261.871,1868.497;Float;True;Property;_BrushTexture;BrushTexture;4;0;Assets/Textures/T_brush_mask_white.png;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.LerpOp;363;3322.704,546.9489;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;642;-534.5305,1918.789;Float;False;Constant;_Float4;Float 4;22;0;0.03;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;3610.433,1403.343;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.25;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;291;3060.827,244.6423;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;641;-526.5305,2019.789;Float;False;Constant;_Float2;Float 2;21;0;0.476;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;108;2014.564,1910.918;Float;False;Property;_BrushStrokeTiling;BrushStrokeTiling;7;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;361;1951.971,2138.229;Float;False;Property;_ShadowStrokeStep;ShadowStrokeStep;14;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;593;1962.49,2249.476;Float;False;Property;_ShadowSoftStrokeStep;ShadowSoftStrokeStep;16;0;0.39;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.Vector2Node;317;2033.877,2007.453;Float;False;Constant;_TextureOffset4;TextureOffset4;12;0;0.5,0.5;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;567;1954.748,2366.742;Float;False;Property;_ShadowSoftStep;ShadowSoftStep;15;0;0.39;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;599;1991.846,1812.139;Float;False;Property;_BrushTextureTiling;BrushTextureTiling;5;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;337;1268.877,2101.855;Float;True;Property;_BrushStrokeTexture;BrushStrokeTexture;6;0;Assets/Textures/T_brush_mask_white.png;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;723;3224.81,1621.417;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.TexturePropertyNode;78;1273.364,2340.012;Float;True;Property;_CircleTexture;CircleTexture;8;0;Assets/Textures/T_PaintMask04.png;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.FunctionNode;600;-189.6498,1578.903;Float;False;SHDF_RampRemap;-1;;234;4;0;FLOAT;0.0;False;1;SAMPLER2D;;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;730;1916.298,2972.956;Float;False;3;0;FLOAT;0.18;False;1;FLOAT;0.075;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TFHCRemap;732;1857.861,3403.665;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.2;False;4;FLOAT;0.4;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;690;2426.797,1890.312;Float;False;SHDF_LightStep;0;;554;11;0;FLOAT4;0,0,0,0;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;SAMPLER2D;;False;4;SAMPLER2D;;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;3428.827,387.6423;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.Vector2Node;279;1884.289,2843.58;Float;False;Constant;_TextureOffset0;TextureOffset0;16;0;0,0;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;258;3770.539,1337.555;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;3547.77,1605.404;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;3615.326,1224.237;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;592;1798.088,3256.173;Float;False;Property;_LightSoftStepStrokes;LightSoftStepStrokes;17;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;640;-188.1539,1919.513;Float;False;SHDF_RampRemap;-1;;561;4;0;FLOAT;0.0;False;1;SAMPLER2D;;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;260;3768.409,1147.199;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;3927.119,1344.669;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.FunctionNode;691;2511.044,2716.022;Float;False;SHDF_LightStep;0;;562;11;0;FLOAT4;0,0,0,0;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;SAMPLER2D;;False;4;SAMPLER2D;;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;605;2133.699,3509.598;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.025;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;3581.591,1015.102;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.75;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;595;2143.499,3405.232;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.2,0.2;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;612;2136.103,3609.914;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;-0.1;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;116;3932.12,1650.857;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;3922.259,1140.51;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;614;2152.666,4021.912;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.025;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;613;2150.371,3918.701;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.2,0.2;False;1;FLOAT2
Node;AmplifyShaderEditor.LerpOp;319;4171.634,1653.303;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.FunctionNode;692;2509.603,3340.643;Float;False;SHDF_LightStep;0;;569;11;0;FLOAT4;0,0,0,0;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;SAMPLER2D;;False;4;SAMPLER2D;;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;615;2150.375,4129.709;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;-0.1;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;259;3760.612,959.5443;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;622;2142.365,4547.254;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;-0.1;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;149;4421.595,1655.105;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;558;4325.083,1863.31;Float;False;Constant;_Float0;Float 0;16;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;617;2149.569,4327.355;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.2,0.2;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;619;2144.365,4440.254;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.025;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;269;3751.205,786.8109;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.FunctionNode;693;2513.361,3826.772;Float;False;SHDF_LightStep;0;;576;11;0;FLOAT4;0,0,0,0;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;SAMPLER2D;;False;4;SAMPLER2D;;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;3914.964,958.2262;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.FunctionNode;694;2530.311,4306.258;Float;False;SHDF_LightStep;0;;583;11;0;FLOAT4;0,0,0,0;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;SAMPLER2D;;False;4;SAMPLER2D;;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.IndirectSpecularLight;297;4651.734,1820.704;Float;False;Tangent;3;0;FLOAT3;0,0,0;False;1;FLOAT;1.0;False;2;FLOAT;1.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;3917.392,783.2325;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;177;4815.326,1652.812;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;296;4600.08,1956.346;Float;False;Property;_AmbiantLightStrength;AmbiantLightStrength;13;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;254;5091.264,1652.773;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;295;4892.675,1862.866;Float;False;3;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;294;5355.01,1641.649;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;731;2117.042,3076.325;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.3;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5659.555,1595.829;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;CustomLightingTest_TerrainV2;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;0;0;14;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;745;0;741;0
WireConnection;744;0;742;0
WireConnection;746;0;743;0
WireConnection;748;0;744;0
WireConnection;748;1;746;0
WireConnection;748;2;745;1
WireConnection;751;0;748;0
WireConnection;751;1;746;0
WireConnection;751;2;745;2
WireConnection;749;0;747;0
WireConnection;753;0;751;0
WireConnection;753;1;749;0
WireConnection;753;2;745;3
WireConnection;752;0;750;0
WireConnection;552;0;557;0
WireConnection;552;1;551;0
WireConnection;552;2;553;0
WireConnection;739;0;718;0
WireConnection;738;0;695;0
WireConnection;738;2;739;0
WireConnection;52;0;552;0
WireConnection;754;0;753;0
WireConnection;754;1;752;0
WireConnection;754;2;745;4
WireConnection;699;0;754;0
WireConnection;699;1;698;0
WireConnection;637;0;52;0
WireConnection;637;1;635;0
WireConnection;740;0;718;0
WireConnection;53;0;52;0
WireConnection;53;1;50;0
WireConnection;696;0;738;0
WireConnection;727;0;718;0
WireConnection;344;0;352;0
WireConnection;344;1;53;0
WireConnection;733;0;115;0
WireConnection;733;1;718;0
WireConnection;733;2;740;0
WireConnection;697;0;718;0
WireConnection;697;1;699;0
WireConnection;636;0;637;0
WireConnection;726;0;115;2
WireConnection;726;1;727;0
WireConnection;717;0;634;0
WireConnection;717;1;696;0
WireConnection;632;0;344;0
WireConnection;632;1;636;0
WireConnection;632;2;717;0
WireConnection;725;2;718;0
WireConnection;273;0;726;0
WireConnection;273;1;696;0
WireConnection;290;0;733;0
WireConnection;700;0;697;0
WireConnection;700;1;754;0
WireConnection;700;2;738;0
WireConnection;363;0;754;0
WireConnection;363;1;102;0
WireConnection;363;2;272;0
WireConnection;117;0;273;0
WireConnection;291;0;290;0
WireConnection;291;2;639;0
WireConnection;723;0;700;0
WireConnection;723;1;725;0
WireConnection;600;0;632;0
WireConnection;600;1;571;0
WireConnection;600;2;610;0
WireConnection;600;3;611;0
WireConnection;730;2;738;0
WireConnection;732;0;738;0
WireConnection;690;0;600;0
WireConnection;690;1;571;0
WireConnection;690;2;410;0
WireConnection;690;3;337;0
WireConnection;690;4;78;0
WireConnection;690;5;599;0
WireConnection;690;6;108;0
WireConnection;690;7;317;0
WireConnection;690;8;361;0
WireConnection;690;9;593;0
WireConnection;690;10;567;0
WireConnection;292;0;291;0
WireConnection;292;1;363;0
WireConnection;258;0;754;0
WireConnection;258;1;117;0
WireConnection;318;0;733;0
WireConnection;318;1;723;0
WireConnection;144;0;273;0
WireConnection;640;0;632;0
WireConnection;640;1;571;0
WireConnection;640;2;642;0
WireConnection;640;3;641;0
WireConnection;260;0;718;0
WireConnection;260;1;144;0
WireConnection;289;0;258;0
WireConnection;289;1;733;0
WireConnection;691;0;640;0
WireConnection;691;1;571;0
WireConnection;691;2;410;0
WireConnection;691;3;337;0
WireConnection;691;4;78;0
WireConnection;691;5;599;0
WireConnection;691;6;108;0
WireConnection;691;7;279;0
WireConnection;691;8;730;0
WireConnection;691;9;592;0
WireConnection;691;10;732;0
WireConnection;605;0;730;0
WireConnection;178;0;273;0
WireConnection;595;0;317;0
WireConnection;612;0;732;0
WireConnection;116;0;292;0
WireConnection;116;1;318;0
WireConnection;116;2;690;0
WireConnection;288;0;260;0
WireConnection;288;1;733;0
WireConnection;614;0;605;0
WireConnection;613;0;595;0
WireConnection;319;0;116;0
WireConnection;319;1;289;0
WireConnection;319;2;691;0
WireConnection;692;0;640;0
WireConnection;692;1;571;0
WireConnection;692;2;410;0
WireConnection;692;3;337;0
WireConnection;692;4;78;0
WireConnection;692;5;599;0
WireConnection;692;6;108;0
WireConnection;692;7;595;0
WireConnection;692;8;605;0
WireConnection;692;9;592;0
WireConnection;692;10;612;0
WireConnection;615;0;612;0
WireConnection;259;0;754;0
WireConnection;259;1;178;0
WireConnection;622;0;615;0
WireConnection;149;0;319;0
WireConnection;149;1;288;0
WireConnection;149;2;692;0
WireConnection;617;0;613;0
WireConnection;619;0;614;0
WireConnection;269;0;754;0
WireConnection;269;1;273;0
WireConnection;693;0;640;0
WireConnection;693;1;571;0
WireConnection;693;2;410;0
WireConnection;693;3;337;0
WireConnection;693;4;78;0
WireConnection;693;5;599;0
WireConnection;693;6;108;0
WireConnection;693;7;613;0
WireConnection;693;8;614;0
WireConnection;693;9;592;0
WireConnection;693;10;615;0
WireConnection;287;0;259;0
WireConnection;287;1;733;0
WireConnection;694;0;640;0
WireConnection;694;1;571;0
WireConnection;694;2;410;0
WireConnection;694;3;337;0
WireConnection;694;4;78;0
WireConnection;694;5;599;0
WireConnection;694;6;108;0
WireConnection;694;7;617;0
WireConnection;694;8;619;0
WireConnection;694;9;592;0
WireConnection;694;10;622;0
WireConnection;297;0;551;0
WireConnection;297;1;558;0
WireConnection;286;0;269;0
WireConnection;286;1;733;0
WireConnection;177;0;149;0
WireConnection;177;1;287;0
WireConnection;177;2;693;0
WireConnection;254;0;177;0
WireConnection;254;1;286;0
WireConnection;254;2;694;0
WireConnection;295;1;297;0
WireConnection;295;2;296;0
WireConnection;294;0;254;0
WireConnection;294;1;295;0
WireConnection;731;0;695;0
WireConnection;0;2;294;0
ASEEND*/
//CHKSM=95EE6AEC2AF03AA19EC7471E8DBF1D9B833E627E