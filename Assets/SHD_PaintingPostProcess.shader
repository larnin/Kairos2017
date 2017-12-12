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
		_Deformation("Deformation", Range( 0 , 1)) = 0
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
				float2 panner133 = ( uv135 + 1.0 * _Time.y * temp_cast_0);
				float2 temp_cast_2 = (_MouvSpeed).xx;
				float2 temp_cast_3 = (( _DeformationTiling * 0.5 )).xx;
				float2 uv161 = i.uv.xy*temp_cast_3 + float2( 0,0 );
				float2 panner156 = ( uv161 + -1.0 * _Time.y * temp_cast_2);
				float4 lerpResult164 = lerp( tex2D( _Texture0, panner133 ) , tex2D( _Texture0, panner156 ) , 0.5);
				float2 componentMask166 = lerpResult164.rg;
				float2 uv17 = i.uv.xy*float2( 1,1 ) + float2( 0,0 );
				float temp_output_44_0 = ( _Float2 * -1.0 );
				float2 appendResult69 = (float2(_Float2 , temp_output_44_0));
				float4 tex2DNode65 = tex2D( _MainTex, ( uv17 + appendResult69 ) );
				float2 appendResult70 = (float2(0.0 , _Float2));
				float4 tex2DNode64 = tex2D( _MainTex, ( uv17 + appendResult70 ) );
				float2 appendResult71 = (float2(temp_output_44_0 , temp_output_44_0));
				float4 tex2DNode43 = tex2D( _MainTex, ( uv17 + appendResult71 ) );
				float2 appendResult68 = (float2(_Float2 , 0.0));
				float4 tex2DNode66 = tex2D( _MainTex, ( uv17 + appendResult68 ) );
				float4 tex2DNode11 = tex2D( _MainTex, uv17 );
				float2 appendResult72 = (float2(temp_output_44_0 , 0.0));
				float4 tex2DNode63 = tex2D( _MainTex, ( uv17 + appendResult72 ) );
				float2 appendResult67 = (float2(_Float2 , _Float2));
				float4 tex2DNode38 = tex2D( _MainTex, ( uv17 + appendResult67 ) );
				float2 appendResult74 = (float2(0.0 , _Float2));
				float4 tex2DNode61 = tex2D( _MainTex, ( uv17 + appendResult74 ) );
				float2 appendResult73 = (float2(temp_output_44_0 , _Float2));
				float4 tex2DNode62 = tex2D( _MainTex, ( uv17 + appendResult73 ) );
				float4 temp_cast_40 = (pow( sqrt( ( ( ( ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 0 ] * tex2DNode65.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 1 ] * tex2DNode64.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 2 ] * tex2DNode43.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 0 ] * tex2DNode66.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 1 ] * tex2DNode11.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 2 ] * tex2DNode63.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 0 ] * tex2DNode38.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 1 ] * tex2DNode61.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 2 ] * tex2DNode62.r ) ) * ( ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 0 ] * tex2DNode65.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 1 ] * tex2DNode64.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 0 ][ 2 ] * tex2DNode43.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 0 ] * tex2DNode66.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 1 ] * tex2DNode11.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 1 ][ 2 ] * tex2DNode63.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 0 ] * tex2DNode38.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 1 ] * tex2DNode61.r ) + ( float3x3(-1,0,1,-2,0,2,-1,0,1)[ 2 ][ 2 ] * tex2DNode62.r ) ) ) + ( ( ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 0 ] * tex2DNode65.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 1 ] * tex2DNode64.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 2 ] * tex2DNode43.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 0 ] * tex2DNode66.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 1 ] * tex2DNode11.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 2 ] * tex2DNode63.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 0 ] * tex2DNode38.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 1 ] * tex2DNode61.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 2 ] * tex2DNode62.r ) ) * ( ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 0 ] * tex2DNode65.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 1 ] * tex2DNode64.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 0 ][ 2 ] * tex2DNode43.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 0 ] * tex2DNode66.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 1 ] * tex2DNode11.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 1 ][ 2 ] * tex2DNode63.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 0 ] * tex2DNode38.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 1 ] * tex2DNode61.r ) + ( float3x3(-1,-2,-1,0,0,0,1,2,1)[ 2 ][ 2 ] * tex2DNode62.r ) ) ) ) ) , _Power )).xxxx;
				float2 lerpResult126 = lerp( uv129 , componentMask166 , ( _Deformation * saturate( CalculateContrast(_Contrats,temp_cast_40) ) ).r);

				finalColor = tex2D( _MainTex, lerpResult126 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13201
1939;127;1684;906;-719.5312;-1235.628;1.554844;True;True
Node;AmplifyShaderEditor.RangedFloatNode;40;-2696.594,61.0722;Float;False;Property;_Float2;Float 2;3;0;0;0;0.1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2575.787,150.4709;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;-1.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;74;-2024.945,51.79226;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;69;-1730.715,274.8281;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2640.07,-84.70515;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;70;-2028.981,281.8501;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;72;-2292.09,168.8499;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;71;-2292.089,281.8607;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;68;-1730.714,155.763;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;67;-1728.695,44.77018;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.DynamicAppendNode;73;-2292.09,53.82088;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-1878.32,281.7723;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-2157.791,164.7192;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-2160.098,280.1061;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-1588.12,148.6759;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;10;-1983.389,-352.2708;Float;False;_MainTex;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-1586.102,275.8132;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1583.629,37.64994;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-1874.226,47.03218;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-2157.79,51.64008;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.1;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;63;-1074.391,205.1301;Float;True;Property;_TextureSample5;Texture Sample 5;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;65;-422.4966,451.227;Float;True;Property;_TextureSample7;Texture Sample 7;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;64;-747.1346,459.0811;Float;True;Property;_TextureSample6;Texture Sample 6;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;11;-737.5562,207.0219;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;62;-1077.309,-21.75944;Float;True;Property;_TextureSample4;Texture Sample 4;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;38;-444.7371,-24.43037;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;66;-427.7325,212.9842;Float;True;Property;_TextureSample8;Texture Sample 8;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;43;-1080.059,454.5469;Float;True;Property;_TextureSample2;Texture Sample 2;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;61;-758.0843,-23.65979;Float;True;Property;_TextureSample3;Texture Sample 3;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Matrix3X3Node;107;110.539,1567.29;Float;False;Constant;_Matrix2;Matrix 2;5;0;-1,-2,-1,0,0,0,1,2,1;0;1;FLOAT3x3
Node;AmplifyShaderEditor.Matrix3X3Node;102;106.6862,1451.057;Float;False;Constant;_Matrix1;Matrix 1;5;0;-1,0,1,-2,0,2,-1,0,1;0;1;FLOAT3x3
Node;AmplifyShaderEditor.FunctionNode;110;647.6041,1179.162;Float;False;SHDF_MatrixConvolution;-1;;3;10;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;8;FLOAT;0.0;False;9;FLOAT3x3;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;111;656.7544,1481.361;Float;False;SHDF_MatrixConvolution;-1;;4;10;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT;0.0;False;7;FLOAT;0.0;False;8;FLOAT;0.0;False;9;FLOAT3x3;0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;134;-310.8324,2384.031;Float;False;Property;_DeformationTiling;DeformationTiling;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;961.2211,1171.713;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;976.8215,1465.514;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-233.9804,2763.684;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;115;1165.321,1356.313;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;-54.23525,2370.017;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;161;-46.68864,2727.374;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;138;-187.4931,2606.599;Float;False;Property;_MouvSpeed;MouvSpeed;6;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;119;1070.42,1719.014;Float;False;Property;_Power;Power;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SqrtOpNode;114;1283.621,1357.615;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.PannerNode;156;296.2542,2787.632;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;-1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.TexturePropertyNode;139;-182.3261,2025.539;Float;True;Property;_Texture0;Texture 0;7;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.PannerNode;133;288.7088,2430.275;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;117;1141.922,1813.914;Float;False;Property;_Contrats;Contrats;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.PowerNode;118;1278.421,1566.913;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleContrastOpNode;116;1448.722,1566.913;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;125;552.2474,2396.094;Float;True;Property;_T_Crayon03;T_Crayon03;3;0;Assets/Textures/T_Crayon03.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;165;914.2653,2753.869;Float;False;Constant;_Float6;Float 6;7;0;0.5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;157;559.7935,2753.452;Float;True;Property;_TextureSample13;Texture Sample 13;3;0;Assets/Textures/T_Crayon03.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;130;1278.154,2681.865;Float;False;Property;_Deformation;Deformation;4;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;164;1033.865,2587.469;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SaturateNode;132;1402.255,2780.154;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;1596.276,2687.772;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.ComponentMaskNode;166;1192.464,2579.669;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;1448.738,2242.724;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;126;1766.406,2381.105;Float;False;3;0;FLOAT2;0.0,0,0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0,0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleTimeNode;136;-208.4931,2529.599;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;35.50688,2546.599;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;159;-200.9467,2886.956;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;43.05327,2903.956;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;127;2088.186,2378.37;Float;True;Property;_TextureSample9;Texture Sample 9;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TemplateMasterNode;9;2395.555,1737.851;Float;False;True;2;Float;ASEMaterialInspector;0;1;SHD_PaintingPostProcess;c71b220b631b6344493ea3cf87110c93;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;44;0;40;0
WireConnection;74;1;40;0
WireConnection;69;0;40;0
WireConnection;69;1;44;0
WireConnection;70;1;40;0
WireConnection;72;0;44;0
WireConnection;71;0;44;0
WireConnection;71;1;44;0
WireConnection;68;0;40;0
WireConnection;67;0;40;0
WireConnection;67;1;40;0
WireConnection;73;0;44;0
WireConnection;73;1;40;0
WireConnection;78;0;17;0
WireConnection;78;1;70;0
WireConnection;80;0;17;0
WireConnection;80;1;72;0
WireConnection;81;0;17;0
WireConnection;81;1;71;0
WireConnection;75;0;17;0
WireConnection;75;1;68;0
WireConnection;76;0;17;0
WireConnection;76;1;69;0
WireConnection;39;0;17;0
WireConnection;39;1;67;0
WireConnection;77;0;17;0
WireConnection;77;1;74;0
WireConnection;79;0;17;0
WireConnection;79;1;73;0
WireConnection;63;0;10;0
WireConnection;63;1;80;0
WireConnection;65;0;10;0
WireConnection;65;1;76;0
WireConnection;64;0;10;0
WireConnection;64;1;78;0
WireConnection;11;0;10;0
WireConnection;11;1;17;0
WireConnection;62;0;10;0
WireConnection;62;1;79;0
WireConnection;38;0;10;0
WireConnection;38;1;39;0
WireConnection;66;0;10;0
WireConnection;66;1;75;0
WireConnection;43;0;10;0
WireConnection;43;1;81;0
WireConnection;61;0;10;0
WireConnection;61;1;77;0
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
WireConnection;163;0;134;0
WireConnection;115;0;112;0
WireConnection;115;1;113;0
WireConnection;135;0;134;0
WireConnection;161;0;163;0
WireConnection;114;0;115;0
WireConnection;156;0;161;0
WireConnection;156;2;138;0
WireConnection;133;0;135;0
WireConnection;133;2;138;0
WireConnection;118;0;114;0
WireConnection;118;1;119;0
WireConnection;116;1;118;0
WireConnection;116;0;117;0
WireConnection;125;0;139;0
WireConnection;125;1;133;0
WireConnection;157;0;139;0
WireConnection;157;1;156;0
WireConnection;164;0;125;0
WireConnection;164;1;157;0
WireConnection;164;2;165;0
WireConnection;132;0;116;0
WireConnection;131;0;130;0
WireConnection;131;1;132;0
WireConnection;166;0;164;0
WireConnection;126;0;129;0
WireConnection;126;1;166;0
WireConnection;126;2;131;0
WireConnection;137;0;136;0
WireConnection;137;1;138;0
WireConnection;162;0;159;0
WireConnection;162;1;138;0
WireConnection;127;0;10;0
WireConnection;127;1;126;0
WireConnection;9;0;127;0
ASEEND*/
//CHKSM=62CC255306A9686EEC2C9120B0C90870A5AB034A