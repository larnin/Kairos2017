// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SHD_ShadowTest1"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MouvSpeed("MouvSpeed", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_Tiling("Tiling", Float) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha 
		struct Input
		{
			float4 screenPos;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Texture0;
		uniform float _Tiling;
		uniform float _MouvSpeed;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 temp_cast_0 = (0.0).xxx;
			o.Emission = temp_cast_0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 appendResult237 = (float4(ase_screenPosNorm.x , ase_screenPosNorm.y , 0.0 , 0.0));
			float4 unityObjectToClipPos217 = UnityObjectToClipPos( float3( 0,0,0 ) );
			float4 computeScreenPos218 = ComputeScreenPos( unityObjectToClipPos217 );
			float componentMask233 = computeScreenPos218.w;
			float4 appendResult235 = (float4(( computeScreenPos218 / componentMask233 ).x , ( computeScreenPos218 / componentMask233 ).y , 0.0 , 0.0));
			float4 temp_output_241_0 = ( ( appendResult237 - appendResult235 ) * _Tiling );
			float temp_output_261_0 = ( _Time.y * _MouvSpeed );
			float4 tex2DNode265 = tex2D( _Texture0, ( temp_output_241_0 + ( temp_output_261_0 * 0.1 ) ).xy );
			float4 appendResult264 = (float4(temp_output_241_0.x , ( temp_output_241_0.y + temp_output_261_0 ) , 0.0 , 0.0));
			float4 tex2DNode240 = tex2D( _Texture0, appendResult264.xy );
			o.Alpha = saturate( CalculateContrast(1.0,( ( saturate( CalculateContrast(1.0,( tex2DNode265 * tex2DNode240 )) ) + i.vertexColor.r ) * i.vertexColor.r )) ).r;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13201
2076;111;1684;902;-3623.835;-661.2159;1.394791;True;True
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;217;1631.028,1018.354;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;218;1818.969,1019.236;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ComponentMaskNode;233;2040.788,968.1034;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;231;2294.021,1008.045;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.BreakToComponentsNode;219;2465.096,1033.275;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ScreenPosInputsNode;236;2465.146,844.5947;Float;False;0;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;235;2733.888,1035.027;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.DynamicAppendNode;237;2724.948,864.9247;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;238;2896.59,949.2796;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;242;2905.143,1077.612;Float;False;Property;_Tiling;Tiling;6;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;262;2729.678,1334.155;Float;False;Property;_MouvSpeed;MouvSpeed;4;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;260;2715.923,1239.399;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;3049.078,947.7342;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;2914.605,1265.381;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.BreakToComponentsNode;263;3225.147,951.0908;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;272;2930.247,1399.167;Float;False;Constant;_Float1;Float 1;5;0;0.1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;259;3527.41,1105.255;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;3113.514,1309.332;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;264;3697.417,947.5642;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.TexturePropertyNode;268;3148.306,488.7;Float;True;Property;_Texture0;Texture 0;6;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SimpleAddOpNode;270;3557.302,906.8663;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SamplerNode;265;3941.875,698.4771;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Assets/Textures/T_Paint02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;240;3945.095,916.6674;Float;True;Property;_T_Paint02;T_Paint02;5;0;Assets/Textures/T_Paint02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;279;4310.072,1152.183;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleContrastOpNode;278;4474.655,1156.368;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.0;False;1;COLOR
Node;AmplifyShaderEditor.VertexColorNode;277;4303.317,1698.834;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SaturateNode;274;4621.976,1083.062;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;257;4685.671,1520.218;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;4828.229,1520.217;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleContrastOpNode;275;5017.807,1384.728;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.0;False;1;COLOR
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;246;3691.476,1707.581;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;255;3626.78,1889.275;Float;False;Property;_Ytransparencycontrast;Y transparency contrast;2;0;0;0;5;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;243;4612.438,923.0759;Float;False;Constant;_Float0;Float 0;2;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;258;5178.337,1383.099;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleSubtractOpNode;245;3925.129,1597.627;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;244;3359.942,1518.662;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleContrastOpNode;253;4114.569,1596.656;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;273;4374.809,1036.23;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;251;3692.099,1558.538;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;252;3369.698,1678.048;Float;False;Property;_YTransparencyoffset;Y Transparency offset;2;0;0;-5;5;0;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;254;4293.834,1598.045;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5333.447,1178.868;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SHD_ShadowTest1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexScale;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;14;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;218;0;217;0
WireConnection;233;0;218;0
WireConnection;231;0;218;0
WireConnection;231;1;233;0
WireConnection;219;0;231;0
WireConnection;235;0;219;0
WireConnection;235;1;219;1
WireConnection;237;0;236;1
WireConnection;237;1;236;2
WireConnection;238;0;237;0
WireConnection;238;1;235;0
WireConnection;241;0;238;0
WireConnection;241;1;242;0
WireConnection;261;0;260;0
WireConnection;261;1;262;0
WireConnection;263;0;241;0
WireConnection;259;0;263;1
WireConnection;259;1;261;0
WireConnection;271;0;261;0
WireConnection;271;1;272;0
WireConnection;264;0;263;0
WireConnection;264;1;259;0
WireConnection;270;0;241;0
WireConnection;270;1;271;0
WireConnection;265;0;268;0
WireConnection;265;1;270;0
WireConnection;240;0;268;0
WireConnection;240;1;264;0
WireConnection;279;0;265;0
WireConnection;279;1;240;0
WireConnection;278;1;279;0
WireConnection;274;0;278;0
WireConnection;257;0;274;0
WireConnection;257;1;277;1
WireConnection;256;0;257;0
WireConnection;256;1;277;1
WireConnection;275;1;256;0
WireConnection;258;0;275;0
WireConnection;245;0;251;0
WireConnection;245;1;246;2
WireConnection;253;1;245;0
WireConnection;253;0;255;0
WireConnection;273;0;265;0
WireConnection;273;1;240;0
WireConnection;251;0;244;2
WireConnection;251;1;252;0
WireConnection;254;0;253;0
WireConnection;0;2;243;0
WireConnection;0;9;258;0
ASEEND*/
//CHKSM=53B682C12CE3E309FFC07DAC86F4D3599828E5E3