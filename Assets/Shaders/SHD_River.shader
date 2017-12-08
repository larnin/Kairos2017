// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/SHD_River"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Alpha("Alpha", Float) = 0
		_MouvSpeed("MouvSpeed", Vector) = (0,0,0,0)
		_Texture0("Texture 0", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_Color2("Color 2", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		_Color3("Color 3", Color) = (0,0,0,0)
		_Color0("Color 0", Color) = (0,0,0,0)
		_Depth("Depth", Float) = 0
		_T_GradientLinear("T_GradientLinear", 2D) = "white" {}
		_Foam("Foam", Range( 0 , 1)) = 0
		_FoamOffset("FoamOffset", Float) = 0
		_FoamContrast("FoamContrast", Float) = 0
		_T_PaintMask02("T_PaintMask02", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 texcoord_0;
			float2 texcoord_1;
			float4 screenPos;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _Texture0;
		uniform float2 _MouvSpeed;
		uniform float2 _Tiling;
		uniform float4 _Color2;
		uniform float4 _Color3;
		uniform sampler2D _T_PaintMask02;
		uniform sampler2D _T_GradientLinear;
		uniform float _Foam;
		uniform float _FoamContrast;
		uniform float _FoamOffset;
		uniform float _Alpha;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Depth;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * _Tiling + float2( 0,0 );
			o.texcoord_1.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner12 = ( i.texcoord_0 + 1.0 * _Time.y * _MouvSpeed);
			float4 tex2DNode10 = tex2D( _Texture0, panner12 );
			float4 lerpResult57 = lerp( _Color0 , _Color1 , tex2DNode10.r);
			float2 temp_output_61_0 = ( _MouvSpeed * float2( 1,1 ) );
			float2 temp_output_18_0 = ( i.texcoord_0 * float2( 0.5,0.5 ) );
			float2 panner60 = ( temp_output_18_0 + 1.0 * _Time.y * temp_output_61_0);
			float4 lerpResult58 = lerp( lerpResult57 , _Color2 , tex2D( _Texture0, panner60 ).r);
			float2 panner66 = ( ( temp_output_18_0 * float2( 0.5,0.5 ) ) + 1.0 * _Time.y * ( temp_output_61_0 * float2( 1,1 ) ));
			float4 lerpResult72 = lerp( lerpResult58 , _Color3 , tex2D( _Texture0, panner66 ).r);
			float4 appendResult86 = (float4(i.texcoord_1.y , i.texcoord_1.x , 0.0 , 0.0));
			float lerpResult88 = lerp( ( 1.0 - tex2D( _T_GradientLinear, appendResult86.xy ).r ) , tex2DNode10.r , _Foam);
			float2 temp_cast_1 = ((lerpResult88*_FoamContrast + _FoamOffset)).xx;
			float4 tex2DNode93 = tex2D( _T_PaintMask02, temp_cast_1 );
			float4 lerpResult96 = lerp( lerpResult72 , float4( 1,1,1,0 ) , tex2DNode93.r);
			o.Albedo = lerpResult96.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth77 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float distanceDepth77 = abs( ( screenDepth77 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) );
			float lerpResult79 = lerp( _Alpha , 0.9 , saturate( distanceDepth77 ));
			float lerpResult97 = lerp( lerpResult79 , 1.0 , tex2DNode93.r);
			o.Alpha = lerpResult97;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float3 worldPos : TEXCOORD6;
				float4 screenPos : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
1927;29;1906;1004;1071.026;496.1323;2.10001;True;True
Node;AmplifyShaderEditor.Vector2Node;53;-2249.999,362.2371;Float;False;Property;_Tiling;Tiling;3;0;0,0;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;84;-1443.908,1180.722;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Vector2Node;15;-2003.725,209.3741;Float;False;Property;_MouvSpeed;MouvSpeed;1;0;0,0;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-2030.813,363.5244;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;86;-1185.018,1204.257;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1717.535,707.6067;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT2;1,1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1707.881,593.8651;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;82;-1029.98,1159.659;Float;True;Property;_T_GradientLinear;T_GradientLinear;9;0;Assets/Blockout/Ile03/Textures/T_GradientLinear.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;16;-2020.014,-20.72479;Float;True;Property;_Texture0;Texture 0;2;0;Assets/Blockout/Ile03/Textures/Ua5Mn_edited.jpg;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.PannerNode;12;-1372,360;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.ColorNode;55;-874.7253,-785.5118;Float;False;Property;_Color0;Color 0;7;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1703.291,974.9249;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;81;-506.0738,555.019;Float;False;Property;_Depth;Depth;8;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.PannerNode;60;-1416.436,594.8951;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1693.637,861.1833;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;89;-858.4261,1368.882;Float;False;Property;_Foam;Foam;10;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;10;-1137,354;Float;True;Property;_Ua5Mn_edited;Ua5Mn_edited;4;0;Assets/Blockout/Ile03/Textures/Ua5Mn_edited.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;56;-870.5937,-601.4515;Float;False;Property;_Color1;Color 1;5;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;87;-718.0047,1175.981;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;57;-344.0715,-189.2511;Float;False;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.ColorNode;59;-868.463,-414.7834;Float;False;Property;_Color2;Color 2;4;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;88;-478.296,1137.684;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;92;-388.6658,1303.006;Float;False;Property;_FoamContrast;FoamContrast;12;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;95;-379.9238,1394.092;Float;False;Property;_FoamOffset;FoamOffset;11;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;17;-1117.2,566.0002;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Assets/Blockout/Ile03/Textures/Ua5Mn_edited.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.PannerNode;66;-1402.192,862.2133;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DepthFade;77;-330.1729,473.6161;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;58;-155.683,-165.0988;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;2;-546,190;Float;False;Property;_Alpha;Alpha;0;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;80;-77.35316,446.6741;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ScaleAndOffsetNode;94;-54.96806,1307.132;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;74;-857.2178,-226.4889;Float;False;Property;_Color3;Color 3;6;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;67;-1102.956,833.3184;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Assets/Blockout/Ile03/Textures/Ua5Mn_edited.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;79;105.762,267.9388;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.9;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;72;29.97961,-102.5069;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;93;198.2839,1291.876;Float;True;Property;_T_PaintMask02;T_PaintMask02;13;0;Assets/Blockout/Ile03/Textures/T_PaintMask02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;96;297.54,-38.37151;Float;False;3;0;COLOR;0.0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;97;306.5809,167.471;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;91;48.18979,1095.354;Float;False;1;0;COLOR;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleContrastOpNode;90;-142.5922,1137.669;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;604,-36;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/SHD_River;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Transparent;0.5;True;True;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;53;0
WireConnection;86;0;84;2
WireConnection;86;1;84;1
WireConnection;61;0;15;0
WireConnection;18;0;13;0
WireConnection;82;1;86;0
WireConnection;12;0;13;0
WireConnection;12;2;15;0
WireConnection;64;0;61;0
WireConnection;60;0;18;0
WireConnection;60;2;61;0
WireConnection;65;0;18;0
WireConnection;10;0;16;0
WireConnection;10;1;12;0
WireConnection;87;0;82;1
WireConnection;57;0;55;0
WireConnection;57;1;56;0
WireConnection;57;2;10;1
WireConnection;88;0;87;0
WireConnection;88;1;10;1
WireConnection;88;2;89;0
WireConnection;17;0;16;0
WireConnection;17;1;60;0
WireConnection;66;0;65;0
WireConnection;66;2;64;0
WireConnection;77;0;81;0
WireConnection;58;0;57;0
WireConnection;58;1;59;0
WireConnection;58;2;17;1
WireConnection;80;0;77;0
WireConnection;94;0;88;0
WireConnection;94;1;92;0
WireConnection;94;2;95;0
WireConnection;67;0;16;0
WireConnection;67;1;66;0
WireConnection;79;0;2;0
WireConnection;79;2;80;0
WireConnection;72;0;58;0
WireConnection;72;1;74;0
WireConnection;72;2;67;1
WireConnection;93;1;94;0
WireConnection;96;0;72;0
WireConnection;96;2;93;1
WireConnection;97;0;79;0
WireConnection;97;2;93;1
WireConnection;91;0;90;0
WireConnection;90;1;88;0
WireConnection;90;0;92;0
WireConnection;0;0;96;0
WireConnection;0;9;97;0
ASEEND*/
//CHKSM=41B897304A336B29540DDFEBDDE4A314B95F2EFA