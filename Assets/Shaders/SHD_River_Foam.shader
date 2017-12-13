// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/SHD_River_Foam"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Foam("Foam", Range( 0 , 1)) = 0
		_Vector3("Vector 3", Vector) = (0,0,0,0)
		_Offset("Offset", Float) = 0
		_Scale("Scale", Float) = 0
		_Texture1("Texture 1", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Vector1("Vector 1", Vector) = (0,0,0,0)
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
			float2 texcoord_1;
		};

		uniform sampler2D _TextureSample3;
		uniform sampler2D _Texture1;
		uniform float2 _Vector3;
		uniform float2 _Vector1;
		uniform float _Foam;
		uniform float _Scale;
		uniform float _Offset;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			o.texcoord_1.xy = v.texcoord.xy * _Vector1 + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 temp_cast_0 = (1.0).xxx;
			o.Albedo = temp_cast_0;
			float2 panner38 = ( i.texcoord_1 + 1.0 * _Time.y * _Vector3);
			float lerpResult29 = lerp( i.texcoord_0.x , tex2D( _Texture1, panner38 ).r , _Foam);
			float2 temp_cast_1 = ((lerpResult29*_Scale + _Offset)).xx;
			o.Alpha = tex2D( _TextureSample3, temp_cast_1 ).r;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13201
1927;29;1906;1004;718.2198;496.2148;1.137595;True;True
Node;AmplifyShaderEditor.Vector2Node;34;-1800.682,-15.57594;Float;False;Property;_Vector1;Vector 1;6;0;0,0;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-1581.496,-14.28861;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.Vector2Node;35;-1554.408,-168.4389;Float;False;Property;_Vector3;Vector 3;1;0;0,0;0;3;FLOAT2;FLOAT;FLOAT
Node;AmplifyShaderEditor.TexturePropertyNode;37;-1570.698,-398.5378;Float;True;Property;_Texture1;Texture 1;4;0;Assets/Blockout/Ile03/Textures/Ua5Mn_edited.jpg;False;white;Auto;0;1;SAMPLER2D
Node;AmplifyShaderEditor.PannerNode;38;-922.6842,-17.81303;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SamplerNode;39;-687.6843,-23.81303;Float;True;Property;_TextureSample4;Texture Sample 4;4;0;Assets/Blockout/Ile03/Textures/Ua5Mn_edited.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;27;-902.4951,509.8254;Float;False;Property;_Foam;Foam;0;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1167.54,183.6655;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;31;-422.5552,535.0355;Float;False;Property;_Offset;Offset;2;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;29;-520.9275,278.6273;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;30;-431.2972,443.9494;Float;False;Property;_Scale;Scale;3;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ScaleAndOffsetNode;32;-97.59946,448.0753;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;1;215,43;Float;False;Constant;_Float0;Float 0;0;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;33;155.6524,432.8194;Float;True;Property;_TextureSample3;Texture Sample 3;5;0;Assets/Blockout/Ile03/Textures/T_PaintMask02.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;695.2062,52.96668;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Custom/SHD_River_Foam;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;0;False;0;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;34;0
WireConnection;38;0;36;0
WireConnection;38;2;35;0
WireConnection;39;0;37;0
WireConnection;39;1;38;0
WireConnection;29;0;24;1
WireConnection;29;1;39;1
WireConnection;29;2;27;0
WireConnection;32;0;29;0
WireConnection;32;1;30;0
WireConnection;32;2;31;0
WireConnection;33;1;32;0
WireConnection;0;0;1;0
WireConnection;0;9;33;1
ASEEND*/
//CHKSM=8077D47EB6D76122CE820E0E53A59E8B74363B4F