// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SHD_ShadowTest1"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Color("Color", Color) = (0,0,0,0)
		_Alpha("Alpha", Range( 0 , 1)) = 0
		_MouvSpeed("MouvSpeed", Float) = 0
		_Tiling("Tiling", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_Diffuse("Diffuse", 2D) = "white" {}
		_GlobalOpacity("GlobalOpacity", Float) = 0
		_Contrast("Contrast", Float) = 0
		_Float2("Float 2", Float) = 0
		_MotifOpacity("MotifOpacity", Range( 0 , 1)) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color;
		uniform sampler2D _Diffuse;
		uniform float _Tiling;
		uniform float _Float2;
		uniform float _MouvSpeed;
		uniform float _MotifOpacity;
		uniform float _Contrast;
		uniform sampler2D _Texture0;
		uniform float _GlobalOpacity;
		uniform float _Alpha;


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
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 appendResult237 = (float4(ase_screenPosNorm.x , ase_screenPosNorm.y , 0.0 , 0.0));
			float4 unityObjectToClipPos217 = UnityObjectToClipPos( float3( 0,0,0 ) );
			float4 computeScreenPos218 = ComputeScreenPos( unityObjectToClipPos217 );
			float componentMask233 = computeScreenPos218.w;
			float4 appendResult235 = (float4(( computeScreenPos218 / componentMask233 ).x , ( computeScreenPos218 / componentMask233 ).y , 0.0 , 0.0));
			float4 temp_output_241_0 = ( ( appendResult237 - appendResult235 ) * _Tiling );
			float4 lerpResult293 = lerp( temp_output_241_0 , ( _Float2 * temp_output_241_0 ) , ( 1.0 - saturate( ase_screenPosNorm.z ) ));
			float temp_output_261_0 = ( _Time.y * _MouvSpeed );
			float4 appendResult264 = (float4(lerpResult293.x , ( lerpResult293.y + temp_output_261_0 ) , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 transform312 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 lerpResult306 = lerp( _Color , tex2D( _Diffuse, appendResult264.xy ) , ( _MotifOpacity * saturate( ( ase_worldPos.y - transform312.y ) ) ));
			o.Emission = lerpResult306.rgb;
			float4 appendResult303 = (float4(( lerpResult293.x + 0.3 ) , ( lerpResult293.y + ( temp_output_261_0 * 0.5 ) ) , 0.0 , 0.0));
			float4 lerpResult290 = lerp( tex2D( _Texture0, ( appendResult303 * float4( 0.5,0.5,0,0 ) ).xy ) , tex2D( _Texture0, appendResult264.xy ) , 0.5);
			float lerpResult286 = lerp( 0.0 , i.vertexColor.r , _GlobalOpacity);
			float4 lerpResult284 = lerp( float4( 0,0,0,0 ) , saturate( CalculateContrast(1.0,( ( saturate( CalculateContrast(_Contrast,lerpResult290) ) + lerpResult286 ) * i.vertexColor.r )) ) , _Alpha);
			o.Alpha = lerpResult284.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13201
1927;29;1906;1004;-2271.916;-230.7647;1.841302;True;True
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;217;1631.028,1018.354;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;218;1818.969,1019.236;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ComponentMaskNode;233;2040.788,968.1034;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;231;2294.021,1008.045;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ScreenPosInputsNode;236;2465.146,844.5947;Float;False;0;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.BreakToComponentsNode;219;2465.096,1033.275;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;237;2724.948,864.9247;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.DynamicAppendNode;235;2733.888,1035.027;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;242;2905.143,1077.612;Float;False;Property;_Tiling;Tiling;3;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;238;2896.59,949.2796;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SaturateNode;292;2671.186,626.373;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;295;2949.5,749.4182;Float;False;Property;_Float2;Float 2;8;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;3054.175,945.1857;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.OneMinusNode;299;2819.833,626.938;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;262;2729.678,1334.155;Float;False;Property;_MouvSpeed;MouvSpeed;2;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;260;2715.923,1239.399;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;3133.078,748.0771;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT4;0;False;1;FLOAT4
Node;AmplifyShaderEditor.LerpOp;293;3302.937,820.012;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;272;2930.247,1399.167;Float;False;Constant;_Float1;Float 1;5;0;0.5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;2914.605,1265.381;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.BreakToComponentsNode;263;3204.435,998.011;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;3141.514,1273.332;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;270;3513.302,816.8663;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;305;3511.457,717.5769;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.3;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;303;3683.457,787.5769;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleAddOpNode;259;3527.41,1105.255;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;268;3148.306,488.7;Float;True;Property;_Texture0;Texture 0;4;0;None;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;3771.457,677.5769;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.5,0.5,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.DynamicAppendNode;264;3697.417,947.5642;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;291;4092.608,1118.07;Float;False;Constant;_Float0;Float 0;7;0;0.5;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;240;3945.095,916.6674;Float;True;Property;_T_Paint02;T_Paint02;5;0;Assets/Textures/T_Paint02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;265;3941.875,698.4771;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Assets/Textures/T_Paint02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;290;4340.608,996.0701;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;289;4302.131,1346.415;Float;False;Property;_Contrast;Contrast;7;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleContrastOpNode;278;4474.655,1156.368;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.0;False;1;COLOR
Node;AmplifyShaderEditor.VertexColorNode;277;4308.258,1659.292;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;287;4347.161,1850.264;Float;False;Property;_GlobalOpacity;GlobalOpacity;6;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;286;4614.102,1755.17;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;274;4646.546,1156.772;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;312;4913.005,2136.407;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;311;4917.709,1969.9;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;257;4685.671,1520.218;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;4828.229,1520.217;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleSubtractOpNode;313;5142.983,2095.123;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;307;4777.117,1239.939;Float;False;Property;_MotifOpacity;MotifOpacity;9;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SaturateNode;316;5291.353,1956.393;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleContrastOpNode;275;5017.807,1384.728;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;5103.545,1253.858;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;282;5166.8,1479.232;Float;False;Property;_Alpha;Alpha;1;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;308;4867.562,737.6103;Float;True;Property;_Diffuse;Diffuse;5;0;Assets/Textures/T_Paint02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SaturateNode;258;5178.337,1383.099;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.ColorNode;281;4963.8,996.2323;Float;False;Property;_Color;Color;0;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;306;5304.095,1126.681;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;284;5367.8,1339.232;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5574.447,1193.868;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SHD_ShadowTest1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;False;0;Zero;Zero;0;Zero;Zero;Add;Add;2;False;0;0,0,0,0;VertexScale;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;14;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;218;0;217;0
WireConnection;233;0;218;0
WireConnection;231;0;218;0
WireConnection;231;1;233;0
WireConnection;219;0;231;0
WireConnection;237;0;236;1
WireConnection;237;1;236;2
WireConnection;235;0;219;0
WireConnection;235;1;219;1
WireConnection;238;0;237;0
WireConnection;238;1;235;0
WireConnection;292;0;236;3
WireConnection;241;0;238;0
WireConnection;241;1;242;0
WireConnection;299;0;292;0
WireConnection;294;0;295;0
WireConnection;294;1;241;0
WireConnection;293;0;241;0
WireConnection;293;1;294;0
WireConnection;293;2;299;0
WireConnection;261;0;260;0
WireConnection;261;1;262;0
WireConnection;263;0;293;0
WireConnection;271;0;261;0
WireConnection;271;1;272;0
WireConnection;270;0;263;1
WireConnection;270;1;271;0
WireConnection;305;0;263;0
WireConnection;303;0;305;0
WireConnection;303;1;270;0
WireConnection;259;0;263;1
WireConnection;259;1;261;0
WireConnection;304;0;303;0
WireConnection;264;0;263;0
WireConnection;264;1;259;0
WireConnection;240;0;268;0
WireConnection;240;1;264;0
WireConnection;265;0;268;0
WireConnection;265;1;304;0
WireConnection;290;0;265;0
WireConnection;290;1;240;0
WireConnection;290;2;291;0
WireConnection;278;1;290;0
WireConnection;278;0;289;0
WireConnection;286;1;277;1
WireConnection;286;2;287;0
WireConnection;274;0;278;0
WireConnection;257;0;274;0
WireConnection;257;1;286;0
WireConnection;256;0;257;0
WireConnection;256;1;277;1
WireConnection;313;0;311;2
WireConnection;313;1;312;2
WireConnection;316;0;313;0
WireConnection;275;1;256;0
WireConnection;315;0;307;0
WireConnection;315;1;316;0
WireConnection;308;1;264;0
WireConnection;258;0;275;0
WireConnection;306;0;281;0
WireConnection;306;1;308;0
WireConnection;306;2;315;0
WireConnection;284;1;258;0
WireConnection;284;2;282;0
WireConnection;0;2;306;0
WireConnection;0;9;284;0
ASEEND*/
//CHKSM=0467D2191B4D26A3B52B9A5E96C48A8D48E4F0CA