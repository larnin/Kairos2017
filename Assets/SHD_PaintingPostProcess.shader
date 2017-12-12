// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "SHD_PaintingPostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_MouvSpeed("MouvSpeed", Float) = 0
		_DeformationTiling("DeformationTiling", Float) = 0
		_Deformation("Deformation", Range( 0 , 0.1)) = 0
		_Contrats("Contrats", Float) = 0
		_Float2("Float 2", Range( 0 , 0.1)) = 0
		_Power("Power", Float) = 0
	}

	SubShader
	{
		Tags{  }
		
		ZTest Always Cull Off ZWrite Off
		


		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _Texture0;
			uniform float _MouvSpeed;
			uniform float _DeformationTiling;
			uniform float _Deformation;
			uniform float _Contrats;
			uniform sampler2D _CameraDepthTexture;
			uniform float _Float2;
			uniform float _Power;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#ifdef UNITY_HALF_TEXEL_OFFSET
						o.uv.y += _MainTex_TexelSize.y;
				#endif

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv129 = i.uv.xy*float2( 1,1 ) + float2( 0,0 );
				float2 temp_cast_0 = (_MouvSpeed).xx;
				float2 temp_cast_1 = (_DeformationTiling).xx;
				float2 uv135 = i.uv.xy*temp_cast_1 + float2( 0,0 );
				float4 appendResult211 = (float4(uv135.y , ( uv135.x * -1.0 ) , 0.0 , 0.0));
				float2 panner133 = ( appendResult211.xy + 1.0 * _Time.y * temp_cast_0);
				float2 temp_cast_3 = (_MouvSpeed).xx;
				float2 temp_cast_4 = (( _DeformationTiling * 0.5 )).xx;
				float2 uv161 = i.uv.xy*temp_cast_4 + float2( 0,0 );
				float2 panner156 = ( uv161 + -1.0 * _Time.y * temp_cast_3);
				float4 lerpResult164 = lerp( tex2D( _Texture0, panner133 ) , tex2D( _Texture0, panner156 ) , 0.5);
				float2 componentMask166 = lerpResult164.rg;
				float2 uv17 = i.uv.xy*float2( 1,1 ) + float2( 0,0 );
				float temp_output_44_0 = ( _Float2 * -1.0 );
				float2 appendResult69 = (float2(_Float2 , temp_output_44_0));
				float4 tex2DNode65 = tex2D( _CameraDepthTexture, ( uv17 + appendResult69 ) );
				float2 appendResult70 = (float2(0.0 , _Float2));
				float4 tex2DNode64 = tex2D( _CameraDepthTexture, ( uv17 + appendResult70 ) );
				float2 appendResult71 = (float2(temp_output_44_0 , temp_output_44_0));
				float4 tex2DNode43 = tex2D( _CameraDepthTexture, ( uv17 + appendResult71 ) );
				float2 appendResult68 = (float2(_Float2 , 0.0));
				float4 tex2DNode66 = tex2D( _CameraDepthTexture, ( uv17 + appendResult68 ) );
				float4 tex2DNode11 = tex2D( _CameraDepthTexture, uv17 );
				float2 appendResult72 = (float2(temp_output_44_0 , 0.0));
				float4 tex2DNode63 = tex2D( _CameraDepthTexture, ( uv17 + appendResult72 ) );
				float2 appendResult67 = (float2(_Float2 , _Float2));
				float4 tex2DNode38 = tex2D( _CameraDepthTexture, ( uv17 + appendResult67 ) );
				float2 appendResult74 = (float2(0.0 , _Float2));
				float4 tex2DNode61 = tex2D( _CameraDepthTexture, ( uv17 + appendResult74 ) );
				float2 appendResult73 = (float2(temp_output_44_0 , _Float2));
				float4 tex2DNode62 = tex2D( _CameraDepthTexture, ( uv17 + appendResult73 ) );
				float4 temp_cast_41 = (pow( sqrt( ( ( ( ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 0 ] * tex2DNode65.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 1 ] * tex2DNode64.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 2 ] * tex2DNode43.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 0 ] * tex2DNode66.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 1 ] * tex2DNode11.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 2 ] * tex2DNode63.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 0 ] * tex2DNode38.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 1 ] * tex2DNode61.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 2 ] * tex2DNode62.r ) ) * ( ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 0 ] * tex2DNode65.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 1 ] * tex2DNode64.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 2 ] * tex2DNode43.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 0 ] * tex2DNode66.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 1 ] * tex2DNode11.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 2 ] * tex2DNode63.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 0 ] * tex2DNode38.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 1 ] * tex2DNode61.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 2 ] * tex2DNode62.r ) ) ) + ( ( ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 0 ] * tex2DNode65.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 1 ] * tex2DNode64.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 2 ] * tex2DNode43.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 0 ] * tex2DNode66.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 1 ] * tex2DNode11.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 2 ] * tex2DNode63.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 0 ] * tex2DNode38.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 1 ] * tex2DNode61.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 2 ] * tex2DNode62.r ) ) * ( ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 0 ] * tex2DNode65.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 1 ] * tex2DNode64.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 2 ] * tex2DNode43.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 0 ] * tex2DNode66.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 1 ] * tex2DNode11.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 2 ] * tex2DNode63.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 0 ] * tex2DNode38.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 1 ] * tex2DNode61.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 2 ] * tex2DNode62.r ) ) ) ) ) , _Power )).xxxx;
				float2 lerpResult126 = lerp( uv129 , componentMask166 , ( _Deformation * saturate( CalculateContrast(_Contrats,temp_cast_41) ) ).r);
				float2 lerpResult213 = lerp( lerpResult126 , uv129 , componentMask166);

				finalColor = tex2D( _MainTex, lerpResult213 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13201
1945;73;1906;1004;-973.3982;-1286.144;2.005829;True;True
Node;AmplifyShaderEditor.RangedFloatNode;40;-2696.594,61.0722;Float;False;Property;_Float2;Float 2;3;0;0;0;0.1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2575.787,150.4709;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;-1.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;69;-1730.715,274.8281;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;70;-2028.981,281.8501;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;74;-2024.945,51.79226;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;67;-1728.695,44.77018;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;68;-1730.714,155.763;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;72;-2292.09,168.8499;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2640.07,-84.70515;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;71;-2292.089,281.8607;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;73;-2292.09,53.82088;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-2157.79,51.64008;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-1586.102,275.8132;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1583.629,37.64994;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-2157.791,164.7192;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-1874.226,47.03218;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-2160.098,280.1061;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.TexturePropertyNode;175;-2620.566,-818.3356;Float;True;Global;_CameraDepthTexture;_CameraDepthTexture;9;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-1588.12,148.6759;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-1878.32,281.7723;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;61;-758.0843,-23.65979;Float;True;Property;_TextureSample3;Texture Sample 3;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;65;-422.4966,451.227;Float;True;Property;_TextureSample7;Texture Sample 7;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;66;-427.7325,212.9842;Float;True;Property;_TextureSample8;Texture Sample 8;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Matrix3X3Node;107;110.539,1655.29;Float;False;Constant;_Matrix2;Matrix 2;5;0;-1,-2,-1,0,0,0,1,2,1;0;1;FLOAT3x3
Node;AmplifyShaderEditor.SamplerNode;11;-737.5562,207.0219;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;43;-1080.059,454.5469;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;64;-747.1346,459.0811;Float;True;Property;_TextureSample6;Texture Sample 6;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;38;-444.7371,-24.43037;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;63;-1074.391,205.1301;Float;True;Property;_TextureSample5;Texture Sample 5;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;62;-1077.309,-21.75944;Float;True;Property;_TextureSample4;Texture Sample 4;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Matrix3X3Node;102;106.6862,1451.057;Float;False;Constant;_Matrix1;Matrix 1;5;0;-1,0,1,-2,0,2,-1,0,1;0;1;FLOAT3x3
Node;AmplifyShaderEditor.FunctionNode;110;658.0922,1163.479;Float;False;SHDF_MatrixConvolution;-1;;3;10;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;8;FLOAT;0.0;False;9;FLOAT3x3;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;111;656.7544,1481.361;Float;False;SHDF_MatrixConvolution;-1;;4;10;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;8;FLOAT;0.0;False;9;FLOAT3x3;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;134;-668.1304,2367.813;Float;False;Property;_DeformationTiling;DeformationTiling;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;961.2211,1171.713;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;976.8215,1465.514;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;-411.5332,2353.799;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;115;1165.321,1356.313;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-233.9804,2763.684;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-68.3465,2461.101;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;-1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SqrtOpNode;114;1283.621,1357.615;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;119;1070.42,1719.014;Float;False;Property;_Power;Power;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-46.68864,2727.374;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;138;-336.5627,2603.261;Float;False;Property;_MouvSpeed;MouvSpeed;6;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;211;117.8462,2402.563;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;117;1141.922,1813.914;Float;False;Property;_Contrats;Contrats;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.PowerNode;118;1278.421,1566.913;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;139;-182.3261,2025.539;Float;True;Property;_Texture0;Texture 0;7;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.PannerNode;133;342.1068,2432.5;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.PannerNode;156;296.2542,2787.632;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;-1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;157;559.7935,2753.452;Float;True;Property;_TextureSample13;Texture Sample 13;3;0;Assets/Textures/T_Crayon03.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;165;914.2653,2753.869;Float;False;Constant;_Float6;Float 6;7;0;0.5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;125;552.2474,2396.094;Float;True;Property;_T_Crayon03;T_Crayon03;3;0;Assets/Textures/T_Crayon03.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleContrastOpNode;116;1448.722,1566.913;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;164;1033.865,2587.469;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;130;1087.187,2877.564;Float;False;Property;_Deformation;Deformation;4;0;0;0;0.1;0;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;132;1402.255,2780.154;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.ComponentMaskNode;166;1192.464,2579.669;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;1596.276,2687.772;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;1448.738,2242.724;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;126;1766.406,2381.105;Float;False;3;0;FLOAT2;0.0,0,0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;10;1734.583,2262.177;Float;False;_MainTex;0;1;SAMPLER2D
Node;AmplifyShaderEditor.LerpOp;213;2001.715,2626.601;Float;False;3;0;FLOAT2;0.0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;196;-1456.145,3486.741;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;180;-2164.606,3502.912;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;200;-619.6509,3908.173;Float;True;Property;_TextureSample14;Texture Sample 14;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;204;-952.5752,3903.638;Float;True;Property;_TextureSample18;Texture Sample 18;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;205;-946.9072,3654.221;Float;True;Property;_TextureSample19;Texture Sample 19;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;182;-2164.605,3730.952;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.TextureCoordinatesNode;185;-2512.586,3364.388;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-2448.303,3599.562;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;-1.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;186;-2164.606,3617.942;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;184;-1897.461,3500.884;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;189;-2030.307,3613.811;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-1458.619,3724.905;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;201;-949.8252,3427.333;Float;True;Property;_TextureSample15;Texture Sample 15;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;202;-300.2486,3662.076;Float;True;Property;_TextureSample16;Texture Sample 16;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;197;-317.2533,3424.662;Float;True;Property;_TextureSample10;Texture Sample 10;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;199;-295.0128,3900.319;Float;True;Property;_TextureSample12;Texture Sample 12;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;170;585.2633,3893.333;Float;False;Constant;_Float0;Float 0;8;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;203;-630.6006,3425.433;Float;True;Property;_TextureSample17;Texture Sample 17;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;209;217.9314,3945.609;Float;False;Constant;_Float7;Float 7;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.Matrix3X3Node;207;-257.7589,4141.243;Float;False;Constant;_Matrix1;Matrix 1;5;0;1,2,1,2,4,2,1,2,1;0;1;FLOAT3x3
Node;AmplifyShaderEditor.DynamicAppendNode;183;-1603.23,3604.855;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;173;592.2633,3708.333;Float;False;Property;_RemapMin;RemapMin;9;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TFHCRemap;169;920.2613,3691.333;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;2;FLOAT;1,0,0,0;False;3;FLOAT;0,0,0,0;False;4;FLOAT;1,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;172;587.2633,3802.333;Float;False;Property;_remapMax;remapMax;8;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;447.6839,3605.145;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;198;-610.0726,3656.114;Float;True;Property;_TextureSample11;Texture Sample 11;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;187;-1901.497,3730.942;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;171;591.2633,3993.334;Float;False;Constant;_Float1;Float 1;8;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;177;1440.629,2940.299;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;188;-1603.231,3723.92;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;190;-1746.742,3496.124;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-2032.615,3729.198;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;178;-2569.11,3510.164;Float;False;Property;_Float5;Float 5;3;0;0;0;0.1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;192;-1750.836,3730.864;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;194;-2030.307,3500.732;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;191;-1460.637,3597.767;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleDivideOpNode;210;403.5733,3961.174;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;16.0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;206;147.49,3577.588;Float;False;SHDF_MatrixConvolution;-1;;5;10;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;8;FLOAT;0.0;False;9;FLOAT3x3;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;181;-1601.211,3493.862;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;127;2066.739,2337.123;Float;True;Property;_TextureSample9;Texture Sample 9;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TemplateMasterNode;9;2805.663,2483.997;Float;False;True;2;Float;ASEMaterialInspector;0;1;SHD_PaintingPostProcess;c71b220b631b6344493ea3cf87110c93;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;44;0;40;0
WireConnection;69;0;40;0
WireConnection;69;1;44;0
WireConnection;70;1;40;0
WireConnection;74;1;40;0
WireConnection;67;0;40;0
WireConnection;67;1;40;0
WireConnection;68;0;40;0
WireConnection;72;0;44;0
WireConnection;71;0;44;0
WireConnection;71;1;44;0
WireConnection;73;0;44;0
WireConnection;73;1;40;0
WireConnection;79;0;17;0
WireConnection;79;1;73;0
WireConnection;76;0;17;0
WireConnection;76;1;69;0
WireConnection;39;0;17;0
WireConnection;39;1;67;0
WireConnection;80;0;17;0
WireConnection;80;1;72;0
WireConnection;77;0;17;0
WireConnection;77;1;74;0
WireConnection;81;0;17;0
WireConnection;81;1;71;0
WireConnection;75;0;17;0
WireConnection;75;1;68;0
WireConnection;78;0;17;0
WireConnection;78;1;70;0
WireConnection;61;0;175;0
WireConnection;61;1;77;0
WireConnection;65;0;175;0
WireConnection;65;1;76;0
WireConnection;66;0;175;0
WireConnection;66;1;75;0
WireConnection;11;0;175;0
WireConnection;11;1;17;0
WireConnection;43;0;175;0
WireConnection;43;1;81;0
WireConnection;64;0;175;0
WireConnection;64;1;78;0
WireConnection;38;0;175;0
WireConnection;38;1;39;0
WireConnection;63;0;175;0
WireConnection;63;1;80;0
WireConnection;62;0;175;0
WireConnection;62;1;79;0
WireConnection;110;0;62;0
WireConnection;110;1;61;0
WireConnection;110;2;38;0
WireConnection;110;3;63;0
WireConnection;110;4;11;0
WireConnection;110;5;66;0
WireConnection;110;6;43;0
WireConnection;110;7;64;0
WireConnection;110;8;65;0
WireConnection;110;9;102;0
WireConnection;111;0;62;0
WireConnection;111;1;61;0
WireConnection;111;2;38;0
WireConnection;111;3;63;0
WireConnection;111;4;11;0
WireConnection;111;5;66;0
WireConnection;111;6;43;0
WireConnection;111;7;64;0
WireConnection;111;8;65;0
WireConnection;111;9;107;0
WireConnection;112;0;110;0
WireConnection;112;1;110;0
WireConnection;113;0;111;0
WireConnection;113;1;111;0
WireConnection;135;0;134;0
WireConnection;115;0;112;0
WireConnection;115;1;113;0
WireConnection;163;0;134;0
WireConnection;212;0;135;1
WireConnection;114;0;115;0
WireConnection;161;0;163;0
WireConnection;211;0;135;2
WireConnection;211;1;212;0
WireConnection;118;0;114;0
WireConnection;118;1;119;0
WireConnection;133;0;211;0
WireConnection;133;2;138;0
WireConnection;156;0;161;0
WireConnection;156;2;138;0
WireConnection;157;0;139;0
WireConnection;157;1;156;0
WireConnection;125;0;139;0
WireConnection;125;1;133;0
WireConnection;116;1;118;0
WireConnection;116;0;117;0
WireConnection;164;0;125;0
WireConnection;164;1;157;0
WireConnection;164;2;165;0
WireConnection;132;0;116;0
WireConnection;166;0;164;0
WireConnection;131;0;130;0
WireConnection;131;1;132;0
WireConnection;126;0;129;0
WireConnection;126;1;166;0
WireConnection;126;2;131;0
WireConnection;213;0;126;0
WireConnection;213;1;129;0
WireConnection;213;2;166;0
WireConnection;196;0;185;0
WireConnection;196;1;181;0
WireConnection;180;0;179;0
WireConnection;180;1;178;0
WireConnection;200;0;175;0
WireConnection;200;1;192;0
WireConnection;204;0;175;0
WireConnection;204;1;193;0
WireConnection;205;0;175;0
WireConnection;205;1;189;0
WireConnection;182;0;179;0
WireConnection;182;1;179;0
WireConnection;179;0;178;0
WireConnection;186;0;179;0
WireConnection;184;1;178;0
WireConnection;189;0;185;0
WireConnection;189;1;186;0
WireConnection;195;0;185;0
WireConnection;195;1;188;0
WireConnection;201;0;175;0
WireConnection;201;1;194;0
WireConnection;202;0;175;0
WireConnection;202;1;191;0
WireConnection;197;0;175;0
WireConnection;197;1;196;0
WireConnection;199;0;175;0
WireConnection;199;1;195;0
WireConnection;203;0;175;0
WireConnection;203;1;190;0
WireConnection;183;0;178;0
WireConnection;169;0;208;0
WireConnection;169;1;173;0
WireConnection;169;2;172;0
WireConnection;169;3;170;0
WireConnection;169;4;171;0
WireConnection;208;0;206;0
WireConnection;208;1;210;0
WireConnection;198;0;175;0
WireConnection;198;1;185;0
WireConnection;187;1;178;0
WireConnection;177;1;130;0
WireConnection;177;2;169;0
WireConnection;188;0;178;0
WireConnection;188;1;179;0
WireConnection;190;0;185;0
WireConnection;190;1;184;0
WireConnection;193;0;185;0
WireConnection;193;1;182;0
WireConnection;192;0;185;0
WireConnection;192;1;187;0
WireConnection;194;0;185;0
WireConnection;194;1;180;0
WireConnection;191;0;185;0
WireConnection;191;1;183;0
WireConnection;210;0;209;0
WireConnection;206;0;201;0
WireConnection;206;1;203;0
WireConnection;206;2;197;0
WireConnection;206;3;205;0
WireConnection;206;4;198;0
WireConnection;206;5;202;0
WireConnection;206;6;204;0
WireConnection;206;7;200;0
WireConnection;206;8;199;0
WireConnection;206;9;207;0
WireConnection;181;0;178;0
WireConnection;181;1;178;0
WireConnection;127;0;10;0
WireConnection;127;1;213;0
WireConnection;9;0;127;0
ASEEND*/
//CHKSM=ADAB71041133F1599B1E03C83F55E151A934F451