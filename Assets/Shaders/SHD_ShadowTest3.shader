// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SHD_ShadowTest3"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MouvSpeed("MouvSpeed", Range( -1 , 1)) = 0
		_Tiling("Tiling", Range( 0 , 5)) = 2.037486
		_Texture0("Texture 0", 2D) = "black" {}
		_Clouds("Clouds", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Texture0;
		uniform float _Tiling;
		uniform float _MouvSpeed;
		uniform sampler2D _Clouds;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 appendResult218 = (float4(ase_screenPosNorm.x , ase_screenPosNorm.y , 0.0 , 0.0));
			float4 unityObjectToClipPos212 = UnityObjectToClipPos( float3( 0,0,0 ) );
			float4 computeScreenPos213 = ComputeScreenPos( unityObjectToClipPos212 );
			float componentMask214 = computeScreenPos213.w;
			float4 appendResult219 = (float4(( computeScreenPos213 / componentMask214 ).x , ( computeScreenPos213 / componentMask214 ).y , 0.0 , 0.0));
			float4 temp_output_224_0 = ( ( appendResult218 - appendResult219 ) * _Tiling );
			float temp_output_226_0 = ( _Time.y * _MouvSpeed );
			float4 appendResult230 = (float4(temp_output_224_0.x , ( temp_output_224_0.y + temp_output_226_0 ) , 0.0 , 0.0));
			float4 tex2DNode233 = tex2Dlod( _Clouds, appendResult230 );
			v.vertex.xyz += ( tex2DNode233.r * float4(0.084,0.122,0,0) ).rgb;
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 appendResult218 = (float4(ase_screenPosNorm.x , ase_screenPosNorm.y , 0.0 , 0.0));
			float4 unityObjectToClipPos212 = UnityObjectToClipPos( float3( 0,0,0 ) );
			float4 computeScreenPos213 = ComputeScreenPos( unityObjectToClipPos212 );
			float componentMask214 = computeScreenPos213.w;
			float4 appendResult219 = (float4(( computeScreenPos213 / componentMask214 ).x , ( computeScreenPos213 / componentMask214 ).y , 0.0 , 0.0));
			float4 temp_output_224_0 = ( ( appendResult218 - appendResult219 ) * _Tiling );
			float temp_output_226_0 = ( _Time.y * _MouvSpeed );
			float4 appendResult230 = (float4(temp_output_224_0.x , ( temp_output_224_0.y + temp_output_226_0 ) , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			fixed3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float4 tex2DNode233 = tex2D( _Clouds, appendResult230.xy );
			float lerpResult202 = lerp( 0 , tex2DNode233.r , 1);
			float fresnelNode177 = ( lerpResult202 + 1.5 * pow( 1.0 - dot( ase_worldNormal, ase_worldViewDir ), 5.0 ) );
			float4 temp_cast_3 = (fresnelNode177).xxxx;
			float fresnelNode197 = ( 0.0 + 5.0 * pow( 1.0 - dot( ase_worldNormal, ase_worldViewDir ), 2.0 ) );
			float fresnelNode241 = ( 0.0 + 2.0 * pow( 1.0 - dot( ase_worldNormal, ase_worldViewDir ), 2.0 ) );
			o.Alpha = saturate( ( ( ( CalculateContrast(1.0,( tex2D( _Texture0, ( temp_output_224_0 + ( temp_output_226_0 * 0.1 ) ).xy ) + tex2D( _Texture0, appendResult230.xy ) )) * i.vertexColor ) * ( 1.0 - saturate( ( CalculateContrast(1.0,temp_cast_3) * fresnelNode197 ) ) ) ) * ( 1.0 - fresnelNode241 ) ) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13201
1960;127;1684;906;-1410.604;-418.1405;1.953194;True;True
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;212;-1167.846,-225.6229;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;213;-979.9045,-224.7409;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ComponentMaskNode;214;-758.0856,-275.8735;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;215;-504.8525,-235.9319;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ScreenPosInputsNode;216;-333.7275,-399.3822;Float;False;0;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.BreakToComponentsNode;217;-333.7776,-210.7019;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;219;-64.9856,-208.95;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.DynamicAppendNode;218;-73.92554,-379.0522;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;221;97.71655,-294.6973;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;176;-838.6962,-33.36443;Float;False;Property;_Tiling;Tiling;4;0;2.037486;0;5;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;137;-187.4618,84.75753;Float;False;Property;_MouvSpeed;MouvSpeed;2;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;222;-82.95044,-4.577881;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;250.2043,-296.2427;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.BreakToComponentsNode;227;426.2734,-292.8861;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;115.7314,21.40405;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;229;728.5364,-138.7219;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;230;898.5435,-296.4127;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.TexturePropertyNode;190;1040.221,1454.917;Float;True;Property;_Clouds;Clouds;7;0;Assets/Textures/sf_noise_clouds_01.png;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SamplerNode;233;1355.723,1336.296;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Assets/Textures/T_Paint02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;225;131.3735,155.1901;Float;False;Constant;_Float9;Float 9;5;0;0.1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;202;1841.968,1404.796;Float;False;3;0;FLOAT;0;False;1;FLOAT;0,0,0,0;False;2;FLOAT;1;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;314.6404,65.3551;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;239;959.4725,-782.5766;Float;True;Property;_Texture0;Texture 0;5;0;None;False;black;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.FresnelNode;177;2068.581,1385.493;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.5;False;3;FLOAT;5.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;231;758.4285,-337.1107;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SamplerNode;136;1358.224,-431.6914;Float;True;Property;_TextureSample3;Texture Sample 3;1;0;Assets/Textures/T_Paint02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;135;1351.773,-652.4565;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Assets/Textures/T_Paint02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleContrastOpNode;188;2324.872,1385.111;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.0;False;1;COLOR
Node;AmplifyShaderEditor.FresnelNode;197;2067.949,1569.765;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;5.0;False;3;FLOAT;2.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;144;1784.356,-538.6981;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;2499.031,1382.864;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.VertexColorNode;234;2013.555,-40.366;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SaturateNode;181;2672.347,1358.163;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleContrastOpNode;232;2071.286,-460.1405;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.0;False;1;COLOR
Node;AmplifyShaderEditor.OneMinusNode;182;2634.355,939.0896;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;2363.844,-107.7958;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.FresnelNode;241;2072.738,1785.376;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;2.0;False;3;FLOAT;2.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;2672.923,798.1707;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.OneMinusNode;242;2359.857,1779.516;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;3197.777,1547.087;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.ColorNode;206;3323.497,1138.164;Float;False;Constant;_Color3;Color 3;7;0;0.084,0.122,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SaturateNode;149;3167.876,841.6722;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;211;3678.217,663.4139;Float;False;Constant;_Float0;Float 0;7;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;3642.041,1170.823;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3967.951,805.4673;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SHD_ShadowTest3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexScale;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;14;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;213;0;212;0
WireConnection;214;0;213;0
WireConnection;215;0;213;0
WireConnection;215;1;214;0
WireConnection;217;0;215;0
WireConnection;219;0;217;0
WireConnection;219;1;217;1
WireConnection;218;0;216;1
WireConnection;218;1;216;2
WireConnection;221;0;218;0
WireConnection;221;1;219;0
WireConnection;224;0;221;0
WireConnection;224;1;176;0
WireConnection;227;0;224;0
WireConnection;226;0;222;0
WireConnection;226;1;137;0
WireConnection;229;0;227;1
WireConnection;229;1;226;0
WireConnection;230;0;227;0
WireConnection;230;1;229;0
WireConnection;233;0;190;0
WireConnection;233;1;230;0
WireConnection;202;1;233;1
WireConnection;228;0;226;0
WireConnection;228;1;225;0
WireConnection;177;1;202;0
WireConnection;231;0;224;0
WireConnection;231;1;228;0
WireConnection;136;0;239;0
WireConnection;136;1;230;0
WireConnection;135;0;239;0
WireConnection;135;1;231;0
WireConnection;188;1;177;0
WireConnection;144;0;135;0
WireConnection;144;1;136;0
WireConnection;203;0;188;0
WireConnection;203;1;197;0
WireConnection;181;0;203;0
WireConnection;232;1;144;0
WireConnection;182;0;181;0
WireConnection;235;0;232;0
WireConnection;235;1;234;0
WireConnection;183;0;235;0
WireConnection;183;1;182;0
WireConnection;242;0;241;0
WireConnection;243;0;183;0
WireConnection;243;1;242;0
WireConnection;149;0;243;0
WireConnection;204;0;233;1
WireConnection;204;1;206;0
WireConnection;0;9;149;0
WireConnection;0;11;204;0
ASEEND*/
//CHKSM=4EB2030DFFC1110597BF4C4D8BA2A394B67B2A19