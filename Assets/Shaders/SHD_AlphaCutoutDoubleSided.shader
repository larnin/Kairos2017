// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SHD_AlphaCutoutDoubleSided"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTexture("MainTexture", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.5
		_Transmission("Transmission", Float) = 0
		_DisplacementStrength("DisplacementStrength", Float) = 0
		_DisplacementSpeed("DisplacementSpeed", Float) = 0
		_Float0("Float 0", Float) = 0
		_Position("Position", Float) = 0
		_sf_noise_clouds_01("sf_noise_clouds_01", 2D) = "white" {}
		_TurbulenceStrength("TurbulenceStrength", Range( 0 , 1)) = 0
		_CloudsTiling("CloudsTiling", Float) = 0
		_TurbulencesSpeed("TurbulencesSpeed", Float) = 0
		_WindDirection("WindDirection", Vector) = (1,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			fixed3 Transmission;
		};

		uniform sampler2D _MainTexture;
		uniform float4 _MainTexture_ST;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Transmission;
		uniform float _DisplacementSpeed;
		uniform float _DisplacementStrength;
		uniform float3 _WindDirection;
		uniform sampler2D _sf_noise_clouds_01;
		uniform float _CloudsTiling;
		uniform float _TurbulencesSpeed;
		uniform float _TurbulenceStrength;
		uniform float _Float0;
		uniform float _Position;
		uniform float _Cutoff = 0.5;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime10 = _Time.y * _DisplacementSpeed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float mulTime32 = _Time.y * _TurbulencesSpeed;
			float2 componentMask27 = ( ( ase_worldPos * _CloudsTiling ) + mulTime32 ).xy;
			float4 lerpResult28 = lerp( float4( ( sin( mulTime10 ) * _DisplacementStrength * _WindDirection ) , 0.0 ) , tex2Dlod( _sf_noise_clouds_01, float4( componentMask27, 0.0 , 0.0 ) ) , _TurbulenceStrength);
			float4 transform14 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_cast_2 = (( ( ase_worldPos.y + _Position ) - transform14.y )).xxxx;
			float4 lerpResult23 = lerp( float4( 0,0,0,0 ) , lerpResult28 , saturate( CalculateContrast(_Float0,temp_cast_2) ).r);
			v.vertex.xyz += lerpResult23.rgb;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + d;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			UNITY_GI(gi, s, data);
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_MainTexture = i.uv_texcoord * _MainTexture_ST.xy + _MainTexture_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTexture, uv_MainTexture );
			o.Albedo = tex2DNode1.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			float3 temp_cast_1 = (_Transmission).xxx;
			o.Transmission = temp_cast_1;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13201
1927;29;1906;1004;1762.841;-63.1358;1.183046;True;True
Node;AmplifyShaderEditor.RangedFloatNode;31;-1376.938,1248.486;Float;False;Property;_CloudsTiling;CloudsTiling;11;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;13;-1339.659,734.4707;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;33;-1488.465,1353.289;Float;False;Property;_TurbulencesSpeed;TurbulencesSpeed;12;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;11;-1666.368,518.4198;Float;False;Property;_DisplacementSpeed;DisplacementSpeed;6;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1178.938,1227.486;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;21;-1298.835,886.1154;Float;False;Property;_Position;Position;8;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;32;-1218.688,1347.61;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;14;-1004.817,932.1267;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;10;-1406.367,522.4198;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-1006.91,1244.672;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1084.128,802.7757;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;9;-1318.549,620.4807;Float;False;Property;_DisplacementStrength;DisplacementStrength;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;19;-657.7047,1149.9;Float;False;Property;_Float0;Float 0;7;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-697.8561,822.8125;Float;True;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.Vector3Node;34;-1247.36,352.8503;Float;False;Property;_WindDirection;WindDirection;31;0;1,0,0;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ComponentMaskNode;27;-872.9382,1239.486;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SinOpNode;12;-1198.368,521.4198;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleContrastOpNode;18;-421.3743,968.371;Float;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1024.177,566.2746;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT3;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;29;-458.9382,756.4857;Float;False;Property;_TurbulenceStrength;TurbulenceStrength;10;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;24;-228.3764,1074.498;Float;True;Property;_sf_noise_clouds_01;sf_noise_clouds_01;9;0;Assets/Textures/sf_noise_clouds_01.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SaturateNode;22;-243.6669,969.4551;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;28;-41.93823,724.4857;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;23;201.5173,646.5844;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;2;-444,264;Float;False;Property;_Smoothness;Smoothness;3;0;0.5;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;5;-352,351;Float;False;Property;_Transmission;Transmission;4;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;3;-446,180;Float;False;Property;_Metallic;Metallic;2;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-464,-21;Float;True;Property;_MainTexture;MainTexture;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;633.8879,70.77315;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SHD_AlphaCutoutDoubleSided;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;0;False;0;0;Masked;0.5;True;True;0;False;TransparentCutout;AlphaTest;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;13;0
WireConnection;30;1;31;0
WireConnection;32;0;33;0
WireConnection;10;0;11;0
WireConnection;26;0;30;0
WireConnection;26;1;32;0
WireConnection;20;0;13;2
WireConnection;20;1;21;0
WireConnection;15;0;20;0
WireConnection;15;1;14;2
WireConnection;27;0;26;0
WireConnection;12;0;10;0
WireConnection;18;1;15;0
WireConnection;18;0;19;0
WireConnection;8;0;12;0
WireConnection;8;1;9;0
WireConnection;8;2;34;0
WireConnection;24;1;27;0
WireConnection;22;0;18;0
WireConnection;28;0;8;0
WireConnection;28;1;24;0
WireConnection;28;2;29;0
WireConnection;23;1;28;0
WireConnection;23;2;22;0
WireConnection;0;0;1;0
WireConnection;0;3;3;0
WireConnection;0;4;2;0
WireConnection;0;6;5;0
WireConnection;0;10;1;4
WireConnection;0;11;23;0
ASEEND*/
//CHKSM=AF90BD1D245856C2B91951C69E6FDCDDF09CE810