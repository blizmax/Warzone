﻿#define __PROCEDURALS_IN_DEFERRED_SHADER__
#define __SSDM_IN_DEFERRED_SHADER__

#ifdef __SSDM_IN_DEFERRED_SHADER__
	//#define TEST_PARALLAX2
#endif //__SSDM_IN_DEFERRED_SHADER__


#ifndef __LQ_MODE__

#define __AMBIENT_OCCLUSION__
#define __ENHANCED_AO__
#define __SCREEN_SPACE_REFLECTIONS__
#define __CLOUD_SHADOWS__

#ifdef USE_CUBEMAPS
	#define __CUBEMAPS__
#endif //USE_CUBEMAPS

#endif //__LQ_MODE__

uniform sampler2D							u_DiffuseMap;		// Screen image
uniform sampler2D							u_NormalMap;		// Flat normals
uniform sampler2D							u_PositionMap;		// positionMap
uniform sampler2D							u_WaterPositionMap;	// water positions
uniform sampler2D							u_RoadsControlMap;	// Screen Pshadows Map

#ifdef __USE_REAL_NORMALMAPS__
uniform sampler2D							u_OverlayMap;		// Real normals. Alpha channel 1.0 means enabled...
#endif //__USE_REAL_NORMALMAPS__

#ifdef __ENHANCED_AO__
uniform sampler2D							u_SteepMap;			// ssao image
#endif //__ENHANCED_AO__

#ifdef __SCREEN_SPACE_REFLECTIONS__
uniform sampler2D							u_GlowMap;			// anamorphic
#endif //__SCREEN_SPACE_REFLECTIONS__

#ifdef USE_SHADOWMAP
uniform sampler2D							u_ShadowMap;		// Screen Shadow Map
#endif //USE_SHADOWMAP

#ifndef __LQ_MODE__
uniform sampler2D							u_WaterEdgeMap;		// tr.shinyImage
uniform samplerCube							u_SkyCubeMap;		// Day sky cubemap
uniform samplerCube							u_SkyCubeMapNight;	// Night sky cubemap
#endif //__LQ_MODE__

#ifdef __CUBEMAPS__
uniform samplerCube							u_CubeMap;			// Closest cubemap
#endif //__CUBEMAPS__

#ifdef __SSDM_IN_DEFERRED_SHADER__
uniform sampler2D							u_ScreenDepthMap;	// 512 depth map.
uniform sampler2D							u_RoadMap;			// SSDM map.
#endif //__SSDM_IN_DEFERRED_SHADER__

uniform mat4								u_ModelViewProjectionMatrix;

uniform vec2								u_Dimensions;

uniform vec4								u_Local1;	// SUN_PHONG_SCALE,			MAP_USE_PALETTE_ON_SKY,			r_ao,							GAMMA_CORRECTION
uniform vec4								u_Local2;	// MAP_REFLECTION_ENABLED,	SHADOWS_ENABLED,				SHADOW_MINBRIGHT,				SHADOW_MAXBRIGHT
uniform vec4								u_Local3;	// r_testShaderValue1,		r_testShaderValue2,				r_testShaderValue3,				r_testShaderValue4
uniform vec4								u_Local4;	// haveConeAngles,			MAP_EMISSIVE_COLOR_SCALE,		MAP_HDR_MIN,					MAP_HDR_MAX
uniform vec4								u_Local5;	// CONTRAST,				SATURATION,						BRIGHTNESS,						WETNESS
uniform vec4								u_Local6;	// AO_MINBRIGHT,			AO_MULTBRIGHT,					VIBRANCY,						TRUEHDR_ENABLED
uniform vec4								u_Local7;	// cubemapEnabled,			r_cubemapCullRange,				PROCEDURAL_SKY_ENABLED,			r_skyLightContribution
uniform vec4								u_Local8;	// NIGHT_SCALE,				PROCEDURAL_CLOUDS_CLOUDCOVER,	PROCEDURAL_CLOUDS_CLOUDSCALE,	CLOUDS_SHADOWS_ENABLED

#ifdef __PROCEDURALS_IN_DEFERRED_SHADER__
uniform vec4								u_Local9;	// MAP_INFO_PLAYABLE_HEIGHT, PROCEDURAL_MOSS_ENABLED, PROCEDURAL_SNOW_ENABLED, PROCEDURAL_SNOW_ROCK_ONLY
uniform vec4								u_Local10;	// PROCEDURAL_SNOW_LUMINOSITY_CURVE, PROCEDURAL_SNOW_BRIGHTNESS, PROCEDURAL_SNOW_HEIGHT_CURVE, PROCEDURAL_SNOW_LOWEST_ELEVATION
#endif //__PROCEDURALS_IN_DEFERRED_SHADER__

#ifdef __SSDM_IN_DEFERRED_SHADER__
uniform vec4								u_Local11;	// DISPLACEMENT_MAPPING_STRENGTH, 0.0, 0.0, 0.0
#endif //__SSDM_IN_DEFERRED_SHADER__

uniform vec3								u_ViewOrigin;
uniform vec4								u_PrimaryLightOrigin;
uniform vec3								u_PrimaryLightColor;

uniform float								u_Time;

#ifdef __CUBEMAPS__
uniform vec4								u_CubeMapInfo;
uniform float								u_CubeMapStrength;
#endif //__CUBEMAPS__

uniform float								u_MaterialSpeculars[MATERIAL_LAST];
uniform float								u_MaterialReflectiveness[MATERIAL_LAST];

uniform int									u_lightCount;
uniform vec3								u_lightPositions2[MAX_DEFERRED_LIGHTS];
uniform float								u_lightDistances[MAX_DEFERRED_LIGHTS];
uniform vec3								u_lightColors[MAX_DEFERRED_LIGHTS];
uniform float								u_lightConeAngles[MAX_DEFERRED_LIGHTS];
uniform vec3								u_lightConeDirections[MAX_DEFERRED_LIGHTS];
uniform float								u_lightMaxDistance;

uniform vec4								u_Mins; // mins, mins, mins, WATER_ENABLED
uniform vec4								u_Maxs;

varying vec2								var_TexCoords;
varying float								var_CloudShadow;


#define SUN_PHONG_SCALE						u_Local1.r
#define MAP_USE_PALETTE_ON_SKY				u_Local1.g
#define AO_TYPE								u_Local1.b
#define GAMMA_CORRECTION					u_Local1.a

#define REFLECTIONS_ENABLED					u_Local2.r
#define SHADOWS_ENABLED						u_Local2.g
#define SHADOW_MINBRIGHT					u_Local2.b
#define SHADOW_MAXBRIGHT					u_Local2.a

#define HAVE_CONE_ANGLES					u_Local4.r
#define PROCEDURAL_SKY_ENABLED				u_Local4.g
#define MAP_HDR_MIN							u_Local4.b
#define MAP_HDR_MAX							u_Local4.a

#define WETNESS								u_Local5.r
#define CONTRAST_STRENGTH					u_Local5.g
#define SATURATION_STRENGTH					u_Local5.b
#define BRIGHTNESS_STRENGTH					u_Local5.a

#define AO_MINBRIGHT						u_Local6.r
#define AO_MULTBRIGHT						u_Local6.g
#define VIBRANCY							u_Local6.b
#define TRUEHDR_ENABLED						u_Local6.a

#define MAP_EMISSIVE_COLOR_SCALE			u_Local7.r
#define CUBEMAP_ENABLED						u_Local7.g
#define CUBEMAP_CULLRANGE					u_Local7.b
#define SKY_LIGHT_CONTRIBUTION				u_Local7.a

// CLOUDS
#define NIGHT_SCALE							u_Local8.r
#define CLOUDS_CLOUDCOVER					u_Local8.g
#define CLOUDS_CLOUDSCALE					u_Local8.b
#define CLOUDS_SHADOWS_ENABLED				u_Local8.a

#ifdef __PROCEDURALS_IN_DEFERRED_SHADER__
#define MAP_INFO_PLAYABLE_HEIGHT			u_Local9.r
#define PROCEDURAL_MOSS_ENABLED				u_Local9.g
#define PROCEDURAL_SNOW_ENABLED				u_Local9.b
#define PROCEDURAL_SNOW_ROCK_ONLY			u_Local9.a

#define PROCEDURAL_SNOW_LUMINOSITY_CURVE	u_Local10.r
#define PROCEDURAL_SNOW_BRIGHTNESS			u_Local10.g
#define PROCEDURAL_SNOW_HEIGHT_CURVE		u_Local10.b
#define PROCEDURAL_SNOW_LOWEST_ELEVATION	u_Local10.a
#endif //__PROCEDURALS_IN_DEFERRED_SHADER__

#ifdef __SSDM_IN_DEFERRED_SHADER__
#define DISPLACEMENT_STRENGTH				u_Local11.r
#endif //__SSDM_IN_DEFERRED_SHADER__

#define WATER_ENABLED						u_Mins.a

vec2 pixel = vec2(1.0) / u_Dimensions;

#define hdr_const_1 (MAP_HDR_MIN / 255.0)
#define hdr_const_2 (255.0 / MAP_HDR_MAX)

//#define __ENCODE_NORMALS_RECONSTRUCT_Z__
#define __ENCODE_NORMALS_STEREOGRAPHIC_PROJECTION__
//#define __ENCODE_NORMALS_CRY_ENGINE__
//#define __ENCODE_NORMALS_EQUAL_AREA_PROJECTION__

#ifdef __ENCODE_NORMALS_STEREOGRAPHIC_PROJECTION__
vec2 EncodeNormal(vec3 n)
{
	float scale = 1.7777;
	vec2 enc = n.xy / (n.z + 1.0);
	enc /= scale;
	enc = enc * 0.5 + 0.5;
	return enc;
}
vec3 DecodeNormal(vec2 enc)
{
	vec3 enc2 = vec3(enc.xy, 0.0);
	float scale = 1.7777;
	vec3 nn =
		enc2.xyz*vec3(2.0 * scale, 2.0 * scale, 0.0) +
		vec3(-scale, -scale, 1.0);
	float g = 2.0 / dot(nn.xyz, nn.xyz);
	return vec3(g * nn.xy, g - 1.0);
}
#elif defined(__ENCODE_NORMALS_CRY_ENGINE__)
vec3 DecodeNormal(in vec2 N)
{
	vec2 encoded = N * 4.0 - 2.0;
	float f = dot(encoded, encoded);
	float g = sqrt(1.0 - f * 0.25);
	return vec3(encoded * g, 1.0 - f * 0.5);
}
vec2 EncodeNormal(in vec3 N)
{
	float f = sqrt(8.0 * N.z + 8.0);
	return N.xy / f + 0.5;
}
#elif defined(__ENCODE_NORMALS_EQUAL_AREA_PROJECTION__)
vec2 EncodeNormal(vec3 n)
{
	float f = sqrt(8.0 * n.z + 8.0);
	return n.xy / f + 0.5;
}
vec3 DecodeNormal(vec2 enc)
{
	vec2 fenc = enc * 4.0 - 2.0;
	float f = dot(fenc, fenc);
	float g = sqrt(1.0 - f / 4.0);
	vec3 n;
	n.xy = fenc*g;
	n.z = 1.0 - f / 2.0;
	return n;
}
#else //__ENCODE_NORMALS_RECONSTRUCT_Z__
vec3 DecodeNormal(in vec2 N)
{
	vec3 norm;
	norm.xy = N * 2.0 - 1.0;
	norm.z = sqrt(1.0 - dot(norm.xy, norm.xy));
	return norm;
}
vec2 EncodeNormal(vec3 n)
{
	return vec2(n.xy * 0.5 + 0.5);
}
#endif //__ENCODE_NORMALS_RECONSTRUCT_Z__


vec4 positionMapAtCoord ( vec2 coord, out bool changedToWater, out vec3 originalPosition )
{
	changedToWater = false;

	vec4 pos = textureLod(u_PositionMap, coord, 0.0);
	/*originalPosition = pos.xyz;

	if (WATER_ENABLED > 0.0)
	{
		bool isSky = (pos.a - 1.0 >= MATERIAL_SKY) ? true : false;

		vec4 wMap = textureLod(u_WaterPositionMap, coord, 0.0);

		if (wMap.a > 0.0 || (wMap.a > 0.0 && isSky))
		{
			if ((wMap.z > pos.z || isSky) && u_ViewOrigin.z > wMap.z)
			{
				pos.xyz = wMap.xyz;

				if (!isSky)
				{// So we know if this is a shoreline or water in skybox...
					changedToWater = true;
				}
				else
				{// Also change the material...
					pos.a = MATERIAL_WATER + 1.0;
				}
			}
		}
	}*/

	return pos;
}


vec2 RB_PBR_DefaultsForMaterial(float MATERIAL_TYPE)
{// I probably should use an array of const's instead, but this will do for now...
	vec2 settings = vec2(0.0);

	float specularReflectionScale = 0.0;
	float cubeReflectionScale = 0.0;

	switch (int(MATERIAL_TYPE))
	{
	case MATERIAL_WATER:			// 13			// light covering of water on a surface
		specularReflectionScale = 0.1;
		cubeReflectionScale = 0.7;
		break;
	case MATERIAL_SHORTGRASS:		// 5			// manicured lawn
		specularReflectionScale = 0.0055;
		cubeReflectionScale = 0.35;
		break;
	case MATERIAL_LONGGRASS:		// 6			// long jungle grass
		specularReflectionScale = 0.0065;
		cubeReflectionScale = 0.35;
		break;
	case MATERIAL_SAND:				// 8			// sandy beach
		specularReflectionScale = 0.0055;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_CARPET:			// 27			// lush carpet
		specularReflectionScale = 0.0015;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_GRAVEL:			// 9			// lots of small stones
		specularReflectionScale = 0.0015;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_ROCK:				// 23			//
	case MATERIAL_STONE:
		specularReflectionScale = 0.002;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_TILES:			// 26			// tiled floor
		specularReflectionScale = 0.026;
		cubeReflectionScale = 0.15;
		break;
	case MATERIAL_SOLIDWOOD:		// 1			// freshly cut timber
	case MATERIAL_TREEBARK:
		specularReflectionScale = 0.0015;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_HOLLOWWOOD:		// 2			// termite infested creaky wood
		specularReflectionScale = 0.00075;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_POLISHEDWOOD:		// 3			// shiny polished wood
		specularReflectionScale = 0.026;
		cubeReflectionScale = 0.35;
		break;
	case MATERIAL_SOLIDMETAL:		// 3			// solid girders
		specularReflectionScale = 0.098;
		cubeReflectionScale = 0.98;
		break;
	case MATERIAL_HOLLOWMETAL:		// 4			// hollow metal machines -- UQ1: Used for weapons to force lower parallax and high reflection...
		specularReflectionScale = 0.098;
		cubeReflectionScale = 0.98;
		break;
	case MATERIAL_DRYLEAVES:		// 19			// dried up leaves on the floor
		specularReflectionScale = 0.0026;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_GREENLEAVES:		// 20			// fresh leaves still on a tree
		specularReflectionScale = 0.0055;
		cubeReflectionScale = 0.35;
		break;
	case MATERIAL_PROCEDURALFOLIAGE:
		specularReflectionScale = 0.0055;
		cubeReflectionScale = 0.35;
		break;
	case MATERIAL_FABRIC:			// 21			// Cotton sheets
		specularReflectionScale = 0.0055;
		cubeReflectionScale = 0.35;
		break;
	case MATERIAL_CANVAS:			// 22			// tent material
		specularReflectionScale = 0.0045;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_MARBLE:			// 12			// marble floors
		specularReflectionScale = 0.025;
		cubeReflectionScale = 0.46;
		break;
	case MATERIAL_SNOW:				// 14			// freshly laid snow
		specularReflectionScale = 0.025;
		cubeReflectionScale = 0.65;
		break;
	case MATERIAL_MUD:				// 17			// wet soil
		specularReflectionScale = 0.003;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_DIRT:				// 7			// hard mud
		specularReflectionScale = 0.002;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_CONCRETE:			// 11			// hardened concrete pavement
		specularReflectionScale = 0.00175;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_FLESH:			// 16			// hung meat, corpses in the world
		specularReflectionScale = 0.0045;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_RUBBER:			// 24			// hard tire like rubber
		specularReflectionScale = 0.0015;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_PLASTIC:			// 25			//
		specularReflectionScale = 0.028;
		cubeReflectionScale = 0.48;
		break;
	case MATERIAL_PLASTER:			// 28			// drywall style plaster
		specularReflectionScale = 0.0025;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_SHATTERGLASS:		// 29			// glass with the Crisis Zone style shattering
		specularReflectionScale = 0.025;
		cubeReflectionScale = 0.67;
		break;
	case MATERIAL_ARMOR:			// 30			// body armor
		specularReflectionScale = 0.055;
		cubeReflectionScale = 0.66;
		break;
	case MATERIAL_ICE:				// 15			// packed snow/solid ice
		specularReflectionScale = 0.045;
		cubeReflectionScale = 0.78;
		break;
	case MATERIAL_GLASS:			// 10			//
	case MATERIAL_DISTORTEDGLASS:
	case MATERIAL_DISTORTEDPUSH:
	case MATERIAL_DISTORTEDPULL:
	case MATERIAL_CLOAK:
		specularReflectionScale = 0.035;
		cubeReflectionScale = 0.70;
		break;
	case MATERIAL_BPGLASS:			// 18			// bulletproof glass
		specularReflectionScale = 0.033;
		cubeReflectionScale = 0.70;
		break;
	case MATERIAL_COMPUTER:			// 31			// computers/electronic equipment
		specularReflectionScale = 0.042;
		cubeReflectionScale = 0.68;
		break;
	case MATERIAL_PUDDLE:
		specularReflectionScale = 0.098;
		cubeReflectionScale = 0.098;
		break;
	case MATERIAL_LAVA:
		specularReflectionScale = 0.002;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_EFX:
	case MATERIAL_BLASTERBOLT:
	case MATERIAL_FIRE:
	case MATERIAL_SMOKE:
	case MATERIAL_MAGIC_PARTICLES:
	case MATERIAL_MAGIC_PARTICLES_TREE:
	case MATERIAL_FIREFLIES:
	case MATERIAL_PORTAL:
	case MATERIAL_MENU_BACKGROUND:
		specularReflectionScale = 0.0;
		cubeReflectionScale = 0.0;
		break;
	case MATERIAL_SKYSCRAPER:
		specularReflectionScale = 0.055;
		cubeReflectionScale = 0.66;
		break;
	default:
		specularReflectionScale = 0.0075;
		cubeReflectionScale = 0.2;
		break;
	}

	// TODO: Update original values with these modifications that I added after... Save time on the math, even though it's minor...
	//specularReflectionScale = specularReflectionScale * 0.5 + 0.5;
	//specularReflectionScale = specularReflectionScale * u_Local3.b + u_Local3.a;
	
	cubeReflectionScale = cubeReflectionScale * 0.75 + 0.25;
	//cubeReflectionScale = cubeReflectionScale * u_Local3.r + u_Local3.g;

	if (int(MATERIAL_TYPE) < MATERIAL_LAST)
	{// Check for game specified overrides...
		if (u_MaterialSpeculars[int(MATERIAL_TYPE)] != 0.0)
		{
			specularReflectionScale = u_MaterialSpeculars[int(MATERIAL_TYPE)];
		}

		if (u_MaterialReflectiveness[int(MATERIAL_TYPE)] != 0.0)
		{
			cubeReflectionScale = u_MaterialReflectiveness[int(MATERIAL_TYPE)];
		}
	}

	settings.x = specularReflectionScale;
	settings.y = cubeReflectionScale;

	return settings;
}

float proceduralHash( const in float n ) {
	return fract(sin(n)*4378.5453);
}

#ifdef __PROCEDURALS_IN_DEFERRED_SHADER__
float proceduralNoise(in vec3 o) 
{
	vec3 p = floor(o);
	vec3 fr = fract(o);
		
	float n = p.x + p.y*57.0 + p.z * 1009.0;

	float a = proceduralHash(n+  0.0);
	float b = proceduralHash(n+  1.0);
	float c = proceduralHash(n+ 57.0);
	float d = proceduralHash(n+ 58.0);
	
	float e = proceduralHash(n+  0.0 + 1009.0);
	float f = proceduralHash(n+  1.0 + 1009.0);
	float g = proceduralHash(n+ 57.0 + 1009.0);
	float h = proceduralHash(n+ 58.0 + 1009.0);
	
	
	vec3 fr2 = fr * fr;
	vec3 fr3 = fr2 * fr;
	
	vec3 t = 3.0 * fr2 - 2.0 * fr3;
	
	float u = t.x;
	float v = t.y;
	float w = t.z;

	// this last bit should be refactored to the same form as the rest :)
	float res1 = a + (b-a)*u +(c-a)*v + (a-b+d-c)*u*v;
	float res2 = e + (f-e)*u +(g-e)*v + (e-f+h-g)*u*v;
	
	float res = res1 * (1.0- w) + res2 * (w);
	
	return res;
}

const mat3 proceduralMat = mat3( 0.00,  0.80,  0.60,
                    -0.80,  0.36, -0.48,
                    -0.60, -0.48,  0.64 );

float proceduralSmoothNoise( vec3 p )
{
    float f;
    f  = 0.5000*proceduralNoise( p ); p = proceduralMat*p*2.02;
    f += 0.2500*proceduralNoise( p ); 
	
    return clamp(f * 1.3333333333333333333333333333333, 0.0, 1.0);
	//return proceduralNoise(p);
}

vec3 splatblend(vec3 color1, float a1, vec3 color2, float a2)
{
    float depth = 0.2;
	float ma = max(a1, a2) - depth;

    float b1 = max(a1 - ma, 0);
    float b2 = max(a2 - ma, 0);

    return ((color1.rgb * b1) + (color2.rgb * b2)) / (b1 + b2);
}

//
// Procedural texturing variation...
//
void AddProceduralMoss(inout vec4 outColor, in vec4 position, in bool changedToWater, in vec3 originalPosition)
{
	vec3 usePos = changedToWater ? originalPosition.xyz : position.xyz;
	float moss = clamp(proceduralNoise( usePos.xyz * 0.00125 ), 0.0, 1.0);

	if (moss > 0.25)
	{
		const vec3 colorLight = vec3(0.0, 0.65, 0.0);
		const vec3 colorDark = vec3(0.0, 0.0, 0.0);
			
		float mossClr = proceduralSmoothNoise(usePos.xyz * 0.25);
		vec3 mossColor = mix(colorDark, colorLight, mossClr*0.25);

		moss = pow((moss - 0.25) * 3.0, 0.35);
		outColor.rgb = splatblend(outColor.rgb, 1.0 - moss*0.75, mossColor, moss*0.25);
	}
}
#endif //__PROCEDURALS_IN_DEFERRED_SHADER__

#if 0
vec3 TangentFromNormal ( vec3 normal )
{
	vec3 tangent;
	vec3 c1 = cross(normal, vec3(0.0, 0.0, 1.0)); 
	vec3 c2 = cross(normal, vec3(0.0, 1.0, 0.0)); 

	if( length(c1) > length(c2) )
	{
		tangent = c1;
	}
	else
	{
		tangent = c2;
	}

	return normalize(tangent);
}
#endif

#if defined(__SCREEN_SPACE_REFLECTIONS__)
#define pw pixel.x
#define ph pixel.y
vec3 AddReflection(vec2 coord, vec4 positionMap, vec3 flatNorm, vec3 inColor, float reflectiveness)
{
	if (reflectiveness <= 0.0)
	{// Top of screen pixel is water, don't check...
		return inColor;
	}

	//return vec3(reflectiveness, 0.0, 0.0);

	bool changedToWater = false;
	vec3 originalPosition;
	float pixelDistance = distance(positionMap.xyz, u_ViewOrigin.xyz);

	//const float scanSpeed = 48.0;// 16.0;// 5.0; // How many pixels to scan by on the 1st rough pass...
	const float scanSpeed = 16.0;

	// Quick scan for pixel that is not water...
	float QLAND_Y = 0.0;
	float topY = min(coord.y + 0.6, 1.0); // Don'y scan further then this, waste of time as it will be bleneded out...

	for (float y = coord.y; y <= topY; y += ph * scanSpeed)
	{
		vec3 norm = DecodeNormal(textureLod(u_NormalMap, vec2(coord.x, y), 0.0).xy);
		vec4 pMap = positionMapAtCoord(vec2(coord.x, y), changedToWater, originalPosition);

		float pMapDistance = distance(pMap.xyz, u_ViewOrigin.xyz);

		if (pMap.a > 1.0 && pMap.xyz != vec3(0.0) && distance(pMap.xyz, u_ViewOrigin.xyz) <= pixelDistance)
		{
			continue;
		}

		if (norm.z * 0.5 + 0.5 < 0.75 && distance(norm.xyz, flatNorm.xyz) > 0.0)
		{
			QLAND_Y = y;
			break;
		}
		else if (positionMap.a != pMap.a && pMap.a == 0.0)
		{
			QLAND_Y = y;
			break;
		}
	}

	if (QLAND_Y <= 0.0 || QLAND_Y >= 1.0)
	{// Found no non-water surfaces...
		return inColor;
	}
	
	QLAND_Y -= ph * scanSpeed;
	
	// Full scan from within 5 px for the real 1st pixel...
	float upPos = coord.y;
	float LAND_Y = 0.0;

	for (float y = QLAND_Y; y <= topY && y <= QLAND_Y + (ph * scanSpeed); y += ph * 2.0)
	{
		vec3 norm = DecodeNormal(textureLod(u_NormalMap, vec2(coord.x, y), 0.0).xy);
		vec4 pMap = positionMapAtCoord(vec2(coord.x, y), changedToWater, originalPosition);
		
		float pMapDistance = distance(pMap.xyz, u_ViewOrigin.xyz);

		if (pMap.a > 1.0 && pMap.xyz != vec3(0.0) && distance(pMap.xyz, u_ViewOrigin.xyz) <= pixelDistance)
		{
			continue;
		}

		if (norm.z * 0.5 + 0.5 < 0.75 && distance(norm.xyz, flatNorm.xyz) > 0.0)
		{
			LAND_Y = y;
			break;
		}
		else if (positionMap.a != pMap.a && pMap.a == 0.0)
		{
			LAND_Y = y;
			break;
		}
	}

	if (LAND_Y <= 0.0 || LAND_Y >= 1.0)
	{// Found no non-water surfaces...
		return inColor;
	}

	float d = 1.0 / ((1.0 - (LAND_Y - coord.y)) * 1.75);

	upPos = clamp(coord.y + ((LAND_Y - coord.y) * 2.0 * d), 0.0, 1.0);

	if (upPos > 1.0 || upPos < 0.0)
	{// Not on screen...
		return inColor;
	}

	vec4 pMap = positionMapAtCoord(vec2(coord.x, upPos), changedToWater, originalPosition);

	if (pMap.a > 1.0 && pMap.xyz != vec3(0.0) && distance(pMap.xyz, u_ViewOrigin.xyz) <= pixelDistance)
	{// The reflected pixel is closer then the original, this would be a bad reflection.
		return inColor;
	}

	float heightDiff = clamp(distance(upPos, coord.y) * 3.0, 0.0, 1.0);
	float heightStrength = 1.0 - clamp(pow(heightDiff, 0.025), 0.0, 1.0);

	float strength = 1.0 - clamp(pow(upPos, 4.0), 0.0, 1.0);
	strength *= heightStrength;
	strength = clamp(strength, 0.0, 1.0);

	if (strength <= 0.0)
	{
		return inColor;
	}

	// Offset the final pixel based on the height of the wave at that point, to create randomization...
	float hoff = proceduralHash(upPos+(u_Time*0.0004)) * 2.0 - 1.0;
	float offset = hoff * pw;

	vec3 glowColor = textureLod(u_GlowMap, vec2(coord.x + offset, 1.0-upPos), 0.0).rgb;
	vec3 landColor = textureLod(u_DiffuseMap, vec2(coord.x + offset, upPos), 0.0).rgb;
	return mix(inColor.rgb, inColor.rgb + landColor.rgb + (glowColor.rgb * /*2.0*/4.0 * reflectiveness), clamp(strength * reflectiveness * 4.0, 0.0, 1.0));
}
#endif //defined(__SCREEN_SPACE_REFLECTIONS__)

vec4 normalVector(vec3 color) {
	vec4 normals = vec4(color.rgb, length(color.rgb) / 3.0);
	normals.rgb = vec3(length(normals.r - normals.a), length(normals.g - normals.a), length(normals.b - normals.a));

	// Contrast...
//#define normLower ( 128.0 / 255.0 )
//#define normUpper (255.0 / 192.0 )
#define normLower ( 32.0 / 255.0 )
#define normUpper (255.0 / 212.0 )
	vec3 N = clamp((clamp(normals.rgb - normLower, 0.0, 1.0)) * normUpper, 0.0, 1.0);

	return vec4(vec3(1.0) - (normalize(pow(N, vec3(4.0))) * 0.5 + 0.5), 1.0 - normals.a);
}

#if defined(__AMBIENT_OCCLUSION__)
float drawObject(in vec3 p){
    p = abs(fract(p)-.5);
    return dot(p, vec3(.5));
}

float cellTile(in vec3 p)
{
    p /= 5.5;
    // Draw four overlapping objects at various positions throughout the tile.
    vec4 v, d; 
    d.x = drawObject(p - vec3(.81, .62, .53));
    p.xy = vec2(p.y-p.x, p.y + p.x)*.7071;
    d.y = drawObject(p - vec3(.39, .2, .11));
    p.yz = vec2(p.z-p.y, p.z + p.y)*.7071;
    d.z = drawObject(p - vec3(.62, .24, .06));
    p.xz = vec2(p.z-p.x, p.z + p.x)*.7071;
    d.w = drawObject(p - vec3(.2, .82, .64));

    v.xy = min(d.xz, d.yw), v.z = min(max(d.x, d.y), max(d.z, d.w)), v.w = max(v.x, v.y); 
   
    d.x =  min(v.z, v.w) - min(v.x, v.y); // Maximum minus second order, for that beveled Voronoi look. Range [0, 1].
    //d.x =  min(v.x, v.y); // First order.
        
    return d.x*2.66; // Normalize... roughly.
}

float aomap(vec3 p)
{
    float n = (.5-cellTile(p))*1.5;
    return p.y + dot(sin(p/2. + cos(p.yzx/2. + 3.14159/2.)), vec3(.5)) + n;
}

vec2 GetMapTC(vec3 pos)
{
	vec2 mapSize = u_Maxs.xy - u_Mins.xy;
	return (pos.xy - u_Mins.xy) / mapSize;
}

float calculateAO(in vec3 pos, in vec3 nor, in vec2 texCoords)
{
	float sca = 0.00013/*2.0*/, occ = 0.0;

	for( int i=0; i<5; i++ ) {
		float hr = 0.01 + float(i)*0.5/4.0;        
		float dd = aomap(nor * hr + pos);
		occ += (hr - dd)*sca;
		sca *= 0.7;
	}

	return clamp( 1.0 - occ, 0.0, 1.0 );    
}
#endif //defined(__AMBIENT_OCCLUSION__)


vec3 TrueHDR ( vec3 color )
{
	return clamp((clamp(color.rgb - hdr_const_1, 0.0, 1.0)) * hdr_const_2, 0.0, 1.0);
}

vec3 Vibrancy ( vec3 origcolor, float vibrancyStrength )
{
	vec3	lumCoeff = vec3(0.212656, 0.715158, 0.072186);  				//Calculate luma with these values
	float	max_color = max(origcolor.r, max(origcolor.g,origcolor.b)); 	//Find the strongest color
	float	min_color = min(origcolor.r, min(origcolor.g,origcolor.b)); 	//Find the weakest color
	float	color_saturation = max_color - min_color; 						//Saturation is the difference between min and max
	float	luma = dot(lumCoeff, origcolor.rgb); 							//Calculate luma (grey)
	return mix(vec3(luma), origcolor.rgb, (1.0 + (vibrancyStrength * (1.0 - (sign(vibrancyStrength) * color_saturation))))); 	//Extrapolate between luma and original by 1 + (1-saturation) - current
}


//
// Full lighting... Blinn phong and basic lighting as well...
//
float getspecularLight(vec3 surfaceNormal, vec3 lightDirection, vec3 viewDirection, float shininess)
{
	//Calculate Blinn-Phong power
	vec3 H = normalize(viewDirection + lightDirection);
	return clamp(pow(max(0.0, dot(surfaceNormal, H)), shininess), 0.0, 1.0);
}

float wetSpecular(vec3 n,vec3 l,vec3 e,float s) {    
    float nrm = (s + 8.0) / (3.1415 * 8.0);
    return pow(max(dot(reflect(e,n),l),0.0),s) * nrm;
}

float getSpecialSauce(vec3 color)
{
	// Secret sauce diffuse adaption.
	float b = clamp(length(clamp(color.rgb, 0.0, 1.0))/3.0, 0.0, 1.0);
	b = clamp(clamp(pow(b, 3.5), 0.0, 1.0) * 512.0, 2.0, 4.0);
	return b;
}

#if defined(__LQ_MODE__) || defined(__FAST_LIGHTING__)
vec3 blinn_phong(vec3 pos, vec3 color, vec3 bump, vec3 view, vec3 light, vec3 lightColor, float specPower, vec3 lightPos, float wetness) {
	// Ambient light.
	float ambience = 0.24;

	// Diffuse lighting.
	float ndotl = clamp(dot(bump, light), 0.0, 1.0);
	float diff = pow(ndotl, 2.0);
	diff *= getSpecialSauce(color);

	// Specular lighting.
	//float fre = clamp(pow(clamp(dot(bump, -view) + 1.0, 0.0, 1.0), -2.0), 0.0, 1.0);
	//float spec = pow(max(dot(reflect(-light, bump), view), 0.0), 1.2);
	float fre = 1.0;
	float nvl = clamp(dot(bump, normalize(view+light)), 0.0, 1.0);
	float spec = pow(nvl, 22.0);

	float wetSpec = 0.0;

	if (wetness > 0.0)
	{// Increase specular strength when the ground is wet during/after rain...
		wetSpec = wetSpecular(bump, -light, view, 256.0) * wetness * 0.5;
		wetSpec += wetSpecular(bump, -light, view, 4.0) * wetness * 8.0;
		wetSpec *= 0.5;
	}

	return (lightColor * ambience) + (lightColor * diff) + (lightColor * spec * fre) + (lightColor * wetSpec);
}
#elif defined(__NAYAR_LIGHTING__)
float orenNayar( in vec3 n, in vec3 v, in vec3 ldir, float specPower )
{
    float r2 = pow(specPower, 2.0);
    float a = 1.0 - 0.5*(r2/(r2+0.57));
    float b = 0.45*(r2/(r2+0.09));

    float nl = dot(n, ldir);
    float nv = dot(n, v);

    float ga = dot(v-n*nv,n-n*nl);

	return max(0.0,nl) * (a + b*max(0.0,ga) * sqrt((1.0-nv*nv)*(1.0-nl*nl)) / max(nl, nv));
}

vec3 blinn_phong(vec3 pos, vec3 color, vec3 bump, vec3 view, vec3 light, vec3 lightColor, float specPower, vec3 lightPos, float wetness) {
	// Ambient light.
	float ambience = 0.24;

	// Nayar diffuse light.
	float base = orenNayar( bump, view, light, specPower );
	base *= getSpecialSauce(color);

	// Specular light.
	vec3 reflection = normalize(reflect(-view, bump));
    float specular = clamp(pow(clamp(dot(light, reflection), 0.0, 1.0), 15.0), 0.0, 1.0) * 0.25;

	float wetSpec = 0.0;

	if (wetness > 0.0)
	{// Increase specular strength when the ground is wet during/after rain...
		wetSpec = wetSpecular(bump, -light, view, 256.0) * wetness * 0.5;
		wetSpec += wetSpecular(bump, -light, view, 4.0) * wetness * 8.0;
		wetSpec *= 0.5;
	}
	
	return (lightColor * ambience) + (base * lightColor) + (lightColor * specular) + (lightColor * wetSpec);
}
#else // PBR LIGHTING
float specTrowbridgeReitz(float HoN, float a, float aP)
{
	float a2 = a * a;
	float aP2 = aP * aP;
	return (a2 * aP2) / pow(HoN * HoN * (a2 - 1.0) + 1.0, 2.0);
}

float visSchlickSmithMod(float NoL, float NoV, float r)
{
	float k = pow(r * 0.5 + 0.5, 2.0) * 0.5;
	float l = NoL * (1.0 - k) + k;
	float v = NoV * (1.0 - k) + k;
	return 1.0 / (4.0 * l * v);
}

float fresSchlickSmith(float HoV, float f0)
{
	return f0 + (1.0 - f0) * pow(1.0 - HoV, 5.0);
}

float sphereLight(vec3 pos, vec3 N, vec3 V, vec3 r, float f0, float roughness, float NoV, out float NoL, vec3 lightPos)
{
#define sphereRad 0.2//0.3

	vec3 L = normalize(lightPos - pos);
	vec3 centerToRay = dot(L, r) * r - L;
	vec3 closestPoint = L + centerToRay * clamp(sphereRad / length(centerToRay), 0.0, 1.0);
	vec3 l = normalize(closestPoint);
	vec3 h = normalize(V + l);


	NoL = clamp(dot(N, l), 0.0, 1.0);
	float HoN = clamp(dot(h, N), 0.0, 1.0);
	float HoV = dot(h, V);

	float distL = length(L);
	float alpha = roughness * roughness;
	float alphaPrime = clamp(sphereRad / (distL * 2.0) + alpha, 0.0, 1.0);

	float specD = specTrowbridgeReitz(HoN, alpha, alphaPrime);
	float specF = fresSchlickSmith(HoV, f0);
	float specV = visSchlickSmithMod(NoL, NoV, roughness);

	return specD * specF * specV * NoL;
}

float tubeLight(vec3 pos, vec3 N, vec3 V, vec3 r, float f0, float roughness, float NoV, out float NoL, vec3 tubeStart, vec3 tubeEnd)
{
	vec3 L0 = tubeStart - pos;
	vec3 L1 = tubeEnd - pos;
	float distL0 = length(L0);
	float distL1 = length(L1);

	float NoL0 = dot(L0, N) / (2.0 * distL0);
	float NoL1 = dot(L1, N) / (2.0 * distL1);
	NoL = (2.0 * clamp(NoL0 + NoL1, 0.0, 1.0))
		/ (distL0 * distL1 + dot(L0, L1) + 2.0);

	vec3 Ld = L1 - L0;
	float RoL0 = dot(r, L0);
	float RoLd = dot(r, Ld);
	float L0oLd = dot(L0, Ld);
	float distLd = length(Ld);
	float t = (RoL0 * RoLd - L0oLd)
		/ (distLd * distLd - RoLd * RoLd);

	float tubeRad = distLd;// 0.2

	vec3 closestPoint = L0 + Ld * clamp(t, 0.0, 1.0);
	vec3 centerToRay = dot(closestPoint, r) * r - closestPoint;
	closestPoint = closestPoint + centerToRay * clamp(tubeRad / length(centerToRay), 0.0, 1.0);
	vec3 l = normalize(closestPoint);
	vec3 h = normalize(V + l);

	float HoN = clamp(dot(h, N), 0.0, 1.0);
	float HoV = dot(h, V);

	float distLight = length(closestPoint);
	float alpha = roughness * roughness;
	float alphaPrime = clamp(tubeRad / (distLight * 2.0) + alpha, 0.0, 1.0);

	float specD = specTrowbridgeReitz(HoN, alpha, alphaPrime);
	float specF = fresSchlickSmith(HoV, f0);
	float specV = visSchlickSmithMod(NoL, NoV, roughness);

	return specD * specF * specV * NoL;
}

float getdiffuse(vec3 n, vec3 l, float p) {
	float ndotl = clamp(dot(n, l), 0.5, 0.9);
	return pow(ndotl, p);
}

vec3 blinn_phong(vec3 pos, vec3 color, vec3 bump, vec3 view, vec3 light, vec3 lightColor, float specPower, vec3 lightPos, float wetness) {
	vec3 albedo = pow(color, vec3(2.2));
	float roughness = 0.7 - clamp(0.5 - dot(albedo, albedo), 0.05, 0.95);
	float f0 = 0.3;

	// Ambient light.
	float ambience = 0.24;

	// Diffuse lighting.
	float ndotl = clamp(dot(bump, light), 0.0, 1.0);
	float diff = pow(ndotl, 2.0);
	diff *= getSpecialSauce(color);

	// Specular light.
	vec3 v = view;
	float NoV = clamp(dot(bump, v), 0.0, 1.0);
	vec3 r = reflect(-v, bump);

#if 1
	float NdotLSphere;
	float specSph = clamp(sphereLight(pos, bump, v, r, f0, roughness, NoV, NdotLSphere, lightPos), 0.0, 1.0/*0.2*/);
	float spec = clamp(/*0.3183 **/ NdotLSphere+specSph, 0.0, 1.0/*0.2*/);
#else
	float NdotLTube;
	float specTube = clamp(tubeLight(pos, bump, v, r, f0, roughness, NoV, NdotLTube, lightPosStart, lightPosEnd), 0.0, 1.0/*0.2*/);
	float spec = clamp(/*0.3183 **/ NdotLTube+specTube, 0.0, 1.0/*0.2*/);
#endif
	
	spec = clamp(pow(spec, 1.0 / 2.2), 0.0, 1.0);

	float wetSpec = 0.0;

	if (wetness > 0.0)
	{// Increase specular strength when the ground is wet during/after rain...
		wetSpec = wetSpecular(bump, -light, view, 256.0) * wetness * 0.5;
		wetSpec += wetSpecular(bump, -light, view, 4.0) * wetness * 8.0;
		wetSpec *= 0.5;
	}

	return (lightColor * ambience) + (lightColor * diff) + (lightColor * albedo * spec) + (lightColor * albedo * wetSpec);
}
#endif //defined(__LQ_MODE__) || defined(__FAST_LIGHTING__)

#ifdef __CLOUD_SHADOWS__

#define RAY_TRACE_STEPS 2 //55

//float gTime;
float cloudy = 0.0;
float cloudShadeFactor = 0.6;

#define CLOUD_LOWER 2800.0
#define CLOUD_UPPER 6800.0

#define MOD2 vec2(.16632,.17369)
#define MOD3 vec3(.16532,.17369,.15787)


//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
float Hash( float p )
{
	vec2 p2 = fract(vec2(p) * MOD2);
	p2 += dot(p2.yx, p2.xy+19.19);
	return fract(p2.x * p2.y);
}
float Hash(vec3 p)
{
	p  = fract(p * MOD3);
	p += dot(p.xyz, p.yzx + 19.19);
	return fract(p.x * p.y * p.z);
}

//--------------------------------------------------------------------------

float Noise( in vec2 x )
{
	vec2 p = floor(x);
	vec2 f = fract(x);
	f = f*f*(3.0-2.0*f);
	float n = p.x + p.y*57.0;
	float res = mix(mix( Hash(n+  0.0), Hash(n+  1.0),f.x),
					mix( Hash(n+ 57.0), Hash(n+ 58.0),f.x),f.y);
	return res;
}
float Noise(in vec3 p)
{
    vec3 i = floor(p);
	vec3 f = fract(p); 
	f *= f * (3.0-2.0*f);

	return mix(
		mix(mix(Hash(i + vec3(0.,0.,0.)), Hash(i + vec3(1.,0.,0.)),f.x),
			mix(Hash(i + vec3(0.,1.,0.)), Hash(i + vec3(1.,1.,0.)),f.x),
			f.y),
		mix(mix(Hash(i + vec3(0.,0.,1.)), Hash(i + vec3(1.,0.,1.)),f.x),
			mix(Hash(i + vec3(0.,1.,1.)), Hash(i + vec3(1.,1.,1.)),f.x),
			f.y),
		f.z);
}


const mat3 cm = mat3( 0.00,  0.80,  0.60,
                    -0.80,  0.36, -0.48,
                    -0.60, -0.48,  0.64 ) * 1.7;
//--------------------------------------------------------------------------
float FBM( vec3 p )
{
	p *= .0005;
	p *= CLOUDS_CLOUDSCALE;

	float f;
	
	f = 0.5000 * Noise(p); p = cm*p; //p.y -= gTime*.2;
	f += 0.2500 * Noise(p); p = cm*p; //p.y += gTime*.06;
	f += 0.1250 * Noise(p); p = cm*p;
	f += 0.0625   * Noise(p); p = cm*p;
	f += 0.03125  * Noise(p); p = cm*p;
	f += 0.015625 * Noise(p);
	return f;
}

//--------------------------------------------------------------------------

float Map(vec3 p)
{
	//float h = -(FBM((p*vec3(0.3, 3.0, 0.3))+(u_Time*128.0))-cloudy-.6);
	//float h = -(FBM((p*vec3(0.3, 3.0, 0.3))+(u_Time*128.0))-pow(cloudy, 0.3));
	float h = -(FBM((p*vec3(0.3, 3.0, 0.3))+(u_Time*128.0))-cloudy-cloudShadeFactor);
	return h;
}

//--------------------------------------------------------------------------
// Grab all sky information for a given ray from camera
float GetCloudAlpha(in vec3 pos,in vec3 rd, out vec2 outPos)
{
	// Find the start and end of the cloud layer...
	float beg = ((CLOUD_LOWER-pos.y) / rd.y);
	float end = ((CLOUD_UPPER-pos.y) / rd.y);
	
	// Start position...
	vec3 p = vec3(pos.x + rd.x * beg, 0.0, pos.z + rd.z * beg);
	outPos = p.xz;
    beg +=  Hash(p)*150.0;

	// Trace clouds through that layer...
	float d = 0.0;
	vec3 add = rd * ((end-beg) / float(RAY_TRACE_STEPS));
	float shadeSum = 0.0;
	
	// I think this is as small as the loop can be
	// for a reasonable cloud density illusion.
	for (int i = 0; i < RAY_TRACE_STEPS; i++)
	{
		if (shadeSum >= 1.0) break;

		float h = clamp(Map(p)*2.0, 0.0, 1.0);
		shadeSum += max(h, 0.0) * (1.0 - shadeSum);
		p += add;
	}

	return clamp(shadeSum, 0.0, 1.0);
}

float CloudShadows(vec3 position)
{
	cloudy = clamp(CLOUDS_CLOUDCOVER*0.3, 0.0, 0.3);
	cloudShadeFactor = 0.5+(cloudy*0.333);
	
	vec3 cameraPos = vec3(0.0);
    vec3 dir = normalize(u_PrimaryLightOrigin.xzy - position.xzy*0.25);
	//dir.y *= -1.0;
	dir = normalize(vec3(dir.x, -1.0, dir.z));

	vec2 pos;
	float alpha = GetCloudAlpha(cameraPos, dir, pos);
	//alpha *= clamp(-dir.y, 0.0, 0.75);

	return (1.0 - (alpha*0.75));
}
#endif //__CLOUD_SHADOWS__

/*
** Contrast, saturation, brightness
** Code of this function is from TGM's shader pack
** http://irrlicht.sourceforge.net/phpBB2/viewtopic.php?t=21057
*/

// For all settings: 1.0 = 100% 0.5=50% 1.5 = 150%
vec3 ContrastSaturationBrightness(vec3 color, float con, float sat, float brt)
{
	// Increase or decrease theese values to adjust r, g and b color channels seperately
	const float AvgLumR = 0.5;
	const float AvgLumG = 0.5;
	const float AvgLumB = 0.5;
	
	const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);
	
	vec3 AvgLumin = vec3(AvgLumR, AvgLumG, AvgLumB);
	vec3 brtColor = color * brt;
	vec3 intensity = vec3(dot(brtColor, LumCoeff));
	vec3 satColor = mix(intensity, brtColor, sat);
	vec3 conColor = mix(AvgLumin, satColor, con);
	return conColor;
}

vec3 GetScreenPixel(inout vec2 texCoords)
{
#ifndef __SSDM_IN_DEFERRED_SHADER__
	return texture(u_DiffuseMap, texCoords).rgb;
#elif defined(TEST_PARALLAX2)
	vec3 dMap = texture(u_RoadMap, texCoords).rgb;
	vec3 color = texture(u_DiffuseMap, texCoords).rgb;

	if (dMap.r <= 0.0 || DISPLACEMENT_STRENGTH == 0.0)
	{
		return color;
	}
	
	float invDepth = clamp((1.0 - texture(u_ScreenDepthMap, texCoords).r) /** 2.0 - 1.0*/, 0.0, 1.0);

	if (invDepth <= 0.0)
	{
		return color;
	}

	float Ray = dMap.x;
	vec2 Displace = dMap.yz * 2.0 - 1.0;

	vec2 distFromCenter = vec2(length(texCoords.x - 0.5), length(texCoords.y - 0.5));
	float screenEdgeScale = clamp(max(distFromCenter.x, distFromCenter.y) * 2.0, 0.0, 1.0);
	screenEdgeScale = 1.0 - pow(screenEdgeScale, 1.5);
	Ray *= screenEdgeScale;

	texCoords = (texCoords + Displace * Ray * invDepth);

	color = texture(u_DiffuseMap, texCoords).rgb;
	
	/*vec3 NormalMap = texture(u_NormalMap, NewUv).xyy;
	NormalMap = DecodeNormal(NormalMap.xy);

	float Normal = clamp(dot(reflect(-View, NormalMap), LightV), 0.0, 1.0);

	Normal = pow(Normal, SpecularPow) + saturate(dot(NormalMap, LightV));

	float PixelLight = 1.0 - clamp(dot(IN.Attenuation, IN.Attenuation), 0.0, 1.0);

	vec3 Light = PixelLight * LightColor;

	return vec4(color * ((Normal * Light) + Ambient), 1.0);
	*/
	return color;
#else //__SSDM_IN_DEFERRED_SHADER__
	vec3 dMap = texture(u_RoadMap, texCoords).rgb;
	vec3 color = texture(u_DiffuseMap, texCoords).rgb;

	if (dMap.r <= 0.0 || DISPLACEMENT_STRENGTH == 0.0)
	{
		return color;
	}
	
	float invDepth = clamp((1.0 - texture(u_ScreenDepthMap, texCoords).r) * 2.0 - 1.0, 0.0, 1.0);

	if (invDepth <= 0.0)
	{
		return color;
	}

	float material = texture(u_PositionMap, texCoords).a - 1.0;
	float materialMultiplier = 1.0;

	if (material == MATERIAL_ROCK || material == MATERIAL_STONE || material == MATERIAL_SKYSCRAPER)
	{// Rock gets more displacement...
		materialMultiplier = 3.0;
	}
	else if (material == MATERIAL_TREEBARK)
	{// Rock gets more displacement...
		materialMultiplier = 1.5;
	}

	vec3 norm = vec3(dMap.gb, 0.0) * 2.0 - 1.0;
	//norm.z = sqrt(1.0 - dot(norm.xy, norm.xy)); // reconstruct Z from X and Y

	vec2 distFromCenter = vec2(length(texCoords.x - 0.5), length(texCoords.y - 0.5));
	float displacementStrengthMod = ((DISPLACEMENT_STRENGTH * materialMultiplier) / 18.0); // Default is 18.0. If using higher displacement, need more screen edge flattening, if less, less flattening.
	float screenEdgeScale = clamp(max(distFromCenter.x, distFromCenter.y) * 2.0, 0.0, 1.0);
	screenEdgeScale = 1.0 - pow(screenEdgeScale, 16.0/displacementStrengthMod);

	float finalModifier = invDepth;

	float offset = -DISPLACEMENT_STRENGTH * materialMultiplier * finalModifier * screenEdgeScale * dMap.r;

	texCoords += norm.xy * pixel * offset;

	vec3 col = vec3(0.0);
	col = texture(u_DiffuseMap, texCoords).rgb;

	color = col;

	float shadow = 1.0 - clamp(dMap.r * 0.5 + 0.5, 0.0, 1.0);
	shadow = 1.0 - (shadow * finalModifier);
	color.rgb *= shadow;

	return color;
#endif //__SSDM_IN_DEFERRED_SHADER__
}

void main(void)
{
	vec2 texCoords = var_TexCoords;
	bool changedToWater = false;
	vec3 originalPosition;
	vec4 position = positionMapAtCoord(texCoords, changedToWater, originalPosition);

	vec4 color = vec4(GetScreenPixel(texCoords), 1.0);
	vec4 outColor = color;

	if (position.a - 1.0 >= MATERIAL_SKY
		|| position.a - 1.0 == MATERIAL_SUN
		|| position.a - 1.0 == MATERIAL_GLASS
		|| position.a - 1.0 == MATERIAL_DISTORTEDGLASS
		|| position.a - 1.0 == MATERIAL_DISTORTEDPUSH
		|| position.a - 1.0 == MATERIAL_DISTORTEDPULL
		|| position.a - 1.0 == MATERIAL_CLOAK
		|| position.a - 1.0 == MATERIAL_EFX
		|| position.a - 1.0 == MATERIAL_BLASTERBOLT
		|| position.a - 1.0 == MATERIAL_FIRE
		|| position.a - 1.0 == MATERIAL_SMOKE
		|| position.a - 1.0 == MATERIAL_MAGIC_PARTICLES
		|| position.a - 1.0 == MATERIAL_MAGIC_PARTICLES_TREE
		|| position.a - 1.0 == MATERIAL_FIREFLIES
		|| position.a - 1.0 == MATERIAL_PORTAL
		|| position.a - 1.0 == MATERIAL_MENU_BACKGROUND)
	{// Skybox... Skip...
		if (MAP_USE_PALETTE_ON_SKY > 0.0)
		{
			if (!(CONTRAST_STRENGTH == 1.0 && SATURATION_STRENGTH == 1.0 && BRIGHTNESS_STRENGTH == 1.0))
			{// C/S/B enabled...
				outColor.rgb = ContrastSaturationBrightness(outColor.rgb, CONTRAST_STRENGTH, SATURATION_STRENGTH, BRIGHTNESS_STRENGTH);
			}
		}

		if (TRUEHDR_ENABLED > 0.0)
		{// TrueHDR enabled...
			outColor.rgb = TrueHDR(outColor.rgb);
		}

		if (VIBRANCY > 0.0)
		{// Vibrancy enabled...
			outColor.rgb = Vibrancy(outColor.rgb, VIBRANCY);
		}

		outColor.rgb = clamp(outColor.rgb, 0.0, 1.0);
		gl_FragColor = outColor;

		gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3(1.0 / GAMMA_CORRECTION));
		gl_FragColor.a = 1.0;
		return;
	}


	vec2 materialSettings = RB_PBR_DefaultsForMaterial(position.a-1.0);
	bool isPuddle = (position.a - 1.0 == MATERIAL_PUDDLE) ? true : false;


	//
	// Grab and set up our normal value, from lightall buffers, or fallback to offseting the flat normal buffer by pixel luminances, etc...
	//

	vec4 norm = textureLod(u_NormalMap, texCoords, 0.0);
	norm.xyz = DecodeNormal(norm.xy);


	vec3 flatNorm = norm.xyz = normalize(norm.xyz);

#if defined(__SCREEN_SPACE_REFLECTIONS__)
	// If doing screen space reflections on floors, we need to know what are floor pixels...
	float ssReflection = norm.z * 0.5 + 0.5;

	// Allow only fairly flat surfaces for reflections (floors), and not roofs (for now)...
	if (ssReflection < 0.8)
	{
		ssReflection = 0.0;
	}
	else
	{
		ssReflection = clamp(ssReflection - 0.8, 0.0, 0.2) * 5.0;
	}

	if (isPuddle)
	{// Puddles always reflect and are considered flat, even if it's just an illusion...
		ssReflection = 1.0;
	}
#endif //defined(__SCREEN_SPACE_REFLECTIONS__)

#ifdef __USE_REAL_NORMALMAPS__

	// Now add detail offsets to the normal value...
	vec4 normalDetail = textureLod(u_OverlayMap, texCoords, 0.0);

	if (normalDetail.a < 1.0)
	{// If we don't have real normalmap, generate fallback normal offsets for this pixel from luminances...
		normalDetail = normalVector(outColor.rgb);
	}

#else //!__USE_REAL_NORMALMAPS__

	vec4 normalDetail = normalVector(outColor.rgb);

#endif //__USE_REAL_NORMALMAPS__

	// Simply offset the normal value based on the detail value... It looks good enough, but true PBR would probably want to use the tangent/bitangent below instead...
	normalDetail.rgb = normalize(clamp(normalDetail.xyz, 0.0, 1.0) * 2.0 - 1.0);

	norm.xyz = normalize(mix(norm.xyz, normalDetail.xyz, 0.25 * (length((norm.xyz * 0.5 + 0.5) - (normalDetail.xyz * 0.5 + 0.5)) / 3.0)));

	//
	// Set up the general directional stuff, to use throughout the shader...
	//

	vec3 N = norm.xyz;
	vec3 E = normalize(u_ViewOrigin.xyz - position.xyz);
	vec3 rayDir = reflect(E, N);
	vec3 cubeRayDir = reflect(E, flatNorm);
	vec3 sunDir = normalize(position.xyz - u_PrimaryLightOrigin.xyz);
	float NE = clamp(length(dot(N, E)), 0.0, 1.0);

	float b = clamp(length(outColor.rgb/3.0), 0.0, 1.0);
	b = clamp(pow(b, 64.0), 0.0, 1.0);
	vec3 of = clamp(pow(vec3(b*65536.0), -N), 0.0, 1.0) * 0.25;
	vec3 bump = normalize(N+of);


#ifdef __PROCEDURALS_IN_DEFERRED_SHADER__
	if (PROCEDURAL_MOSS_ENABLED > 0.0 && (position.a - 1.0 == MATERIAL_TREEBARK || position.a - 1.0 == MATERIAL_ROCK))
	{// Add any procedural moss...
		AddProceduralMoss(outColor, position, changedToWater, originalPosition);
	}

	if (PROCEDURAL_SNOW_ENABLED > 0.0 
		&& (PROCEDURAL_SNOW_ROCK_ONLY <= 0.0 || (position.a - 1.0 == MATERIAL_ROCK)))
	{// Add any procedural snow...
		if (position.z >= PROCEDURAL_SNOW_LOWEST_ELEVATION)
		{
			float snowHeightFactor = 1.0;

			if (PROCEDURAL_SNOW_LOWEST_ELEVATION > -999999.0)
			{// Elevation is enabled...
				float elevationRange = MAP_INFO_PLAYABLE_HEIGHT - PROCEDURAL_SNOW_LOWEST_ELEVATION;
				float pixelElevation = position.z - PROCEDURAL_SNOW_LOWEST_ELEVATION;
			
				snowHeightFactor = clamp(pixelElevation / elevationRange, 0.0, 1.0);
				snowHeightFactor = clamp(pow(snowHeightFactor, PROCEDURAL_SNOW_HEIGHT_CURVE), 0.0, 1.0);
			}

			float snow = clamp(dot(normalize(bump.xyz), vec3(0.0, 0.0, 1.0)), 0.0, 1.0);

			if (position.a - 1.0 == MATERIAL_GREENLEAVES || position.a - 1.0 == MATERIAL_PROCEDURALFOLIAGE)
				snow = pow(snow * 0.25 + 0.75, 1.333);
			else
				snow = pow(snow, 0.4);

			snow *= snowHeightFactor;
		
			if (snow > 0.0)
			{
				vec3 snowColor = vec3(PROCEDURAL_SNOW_BRIGHTNESS);
				float snowColorFactor = max(outColor.r, max(outColor.g, outColor.b));
				snowColorFactor = clamp(pow(snowColorFactor, PROCEDURAL_SNOW_LUMINOSITY_CURVE), 0.0, 1.0);
				float snowMix = clamp(snow*snowColorFactor, 0.0, 1.0);
				outColor.rgb = splatblend(outColor.rgb, 1.0 - snowMix, snowColor, snowMix);
			}
		}
	}
#endif //__PROCEDURALS_IN_DEFERRED_SHADER__


	float wetness = 0.0;

	if (WETNESS > 0.0)
	{
		if ((position.a - 1.0 == MATERIAL_PUDDLE)
			|| (position.a - 1.0 == MATERIAL_TREEBARK)
			|| (position.a - 1.0 == MATERIAL_GREENLEAVES)
			|| (position.a - 1.0 == MATERIAL_PROCEDURALFOLIAGE)
			|| (position.a - 1.0 == MATERIAL_SHORTGRASS)
			|| (position.a - 1.0 == MATERIAL_LONGGRASS)
			|| (position.a - 1.0 == MATERIAL_ROCK)
			|| (position.a - 1.0 == MATERIAL_SAND)
			|| (position.a - 1.0 == MATERIAL_DIRT)
			|| (position.a - 1.0 == MATERIAL_MUD))
		{
			// Hmm. this really should check for splat mapped pixels, but I dont have buffer room, and dont want to add a new screen buffer
			// unless I must... For now i'll use materials that generally get splat mapped, but should not be used indoors...
			wetness = WETNESS;

#if defined(__SCREEN_SPACE_REFLECTIONS__)
			// Allow only fairly flat surfaces for reflections...
			if (norm.z * 0.5 + 0.5 >= 0.8)
			{
				ssReflection = WETNESS;
			}
#endif //defined(__SCREEN_SPACE_REFLECTIONS__)
		}
	}

	// If we ever need a tangent/bitangent, we can get one like this... But I'm just working in world directions, so it's not required...
	//vec3 tangent = TangentFromNormal( norm.xyz );
	//vec3 bitangent = normalize( cross(norm.xyz, tangent) );
	//mat3 tangentToWorld = mat3(tangent.xyz, bitangent.xyz, norm.xyz);
	//norm.xyz = tangentToWorld * normalDetail.xyz;

	//
	// Default material settings... PBR inputs could go here instead...
	//

#define specularReflectivePower		materialSettings.x
#define reflectionPower				materialSettings.y


	//
	// This is the basics of creating a fake PBR look to the lighting. It could be replaced, or overridden by actual PBR pixel buffer inputs.
	//

	// This should give me roughly how close to grey this color is... For light colorization.. Highly colored stuff should get less color added to it...
	float greynessFactor = 1.0 - clamp((length(outColor.r - outColor.g) + length(outColor.r - outColor.b) + length(outColor.g - outColor.b)) / 3.0, 0.0, 1.0);

	// Also check how bright it is, so we can scale the lighting up/down...
	float brightnessFactor = 1.0 - clamp(max(outColor.r, max(outColor.g, outColor.b)), 0.0, 1.0);
	brightnessFactor = 1.0 - clamp(pow(brightnessFactor,  6.0), 0.0, 1.0);

	// It looks better to use slightly different cube and light reflection multipliers... Lights should always add some light, cubes should allow none on some pixels..
	float cubeReflectionFactor = clamp(greynessFactor * brightnessFactor, 0.5, 1.0) * reflectionPower;
	float lightsReflectionFactor = (greynessFactor * brightnessFactor * specularReflectivePower) * 0.5 + 0.5;

#if defined(__SCREEN_SPACE_REFLECTIONS__)
	float ssrReflectivePower = lightsReflectionFactor * reflectionPower * ssReflection;
	if (isPuddle) ssrReflectivePower = WETNESS * 3.0; // 3x - 8x seems about right...
	else if (wetness > 0.0) ssrReflectivePower = ssReflection * 0.333;
	else if (ssrReflectivePower < 0.5) ssrReflectivePower = 0.0; // cull on non-wet stuff, when theres little point...
#endif //defined(__SCREEN_SPACE_REFLECTIONS__)


	float diffuse = clamp(pow(clamp(dot(-sunDir.rgb, bump.rgb), 0.0, 1.0), 8.0) * 0.2 + 0.8, 0.0, 1.0);
	color.rgb = outColor.rgb = outColor.rgb * diffuse;

	float origColorStrength = clamp(max(color.r, max(color.g, color.b)), 0.0, 1.0) * 0.75 + 0.25;


	//
	// Now all the hard work...
	//

	float finalShadow = 1.0;

#if defined(USE_SHADOWMAP) && !defined(__LQ_MODE__)
	if (SHADOWS_ENABLED > 0.0 && NIGHT_SCALE < 1.0)
	{
		float shadowValue = texture(u_ShadowMap, texCoords).r;

		shadowValue = pow(shadowValue, 1.5);

#define sm_cont_1 ( 64.0 / 255.0)
#define sm_cont_2 (255.0 / 200.0)
		shadowValue = clamp((clamp(shadowValue - sm_cont_1, 0.0, 1.0)) * sm_cont_2, 0.0, 1.0);
		finalShadow = clamp(shadowValue + SHADOW_MINBRIGHT, SHADOW_MINBRIGHT, SHADOW_MAXBRIGHT);
	}
#endif //defined(USE_SHADOWMAP) && !defined(__LQ_MODE__)

	vec3 specularColor = vec3(0.0);
	vec3 skyColor = vec3(0.0);

#ifndef __LQ_MODE__
	if (SKY_LIGHT_CONTRIBUTION > 0.0 && (cubeReflectionFactor > 0.0 || reflectionPower > 0.0))
	{// Sky cube light contributions... If enabled...
		vec4 cubeInfo = vec4(0.0, 0.0, 0.0, 1.0);
		cubeInfo.xyz -= u_ViewOrigin.xyz;

		cubeInfo.w = pow(distance(u_ViewOrigin.xyz, vec3(0.0, 0.0, 0.0)), 3.0);

		cubeInfo.xyz *= 1.0 / cubeInfo.w;
		cubeInfo.w = 1.0 / cubeInfo.w;
					
		vec3 parallax = cubeInfo.xyz + cubeInfo.w * E;
		parallax.z *= -1.0;
		
		vec3 reflected = cubeRayDir + parallax;

		if (PROCEDURAL_SKY_ENABLED <= 0.0)
		{
			reflected = vec3(-reflected.y, -reflected.z, -reflected.x); // for old sky cubemap generation based on sky textures
		}

		const float lod1 = 4.0;
		const float lod2 = 5.0;
		const float lod3 = 7.0;
		const float lod4 = 10.0;

		if (NIGHT_SCALE > 0.0 && NIGHT_SCALE < 1.0)
		{// Mix between night and day colors...
			vec3 skyColorDay = textureLod(u_SkyCubeMap, reflected, lod1).rgb;
			skyColorDay += textureLod(u_SkyCubeMap, reflected, lod2).rgb;
			skyColorDay += textureLod(u_SkyCubeMap, reflected, lod3).rgb;
			skyColorDay += textureLod(u_SkyCubeMap, reflected, lod4).rgb;
			skyColorDay /= 4.0;

			vec3 skyColorNight = textureLod(u_SkyCubeMapNight, reflected, lod1).rgb;
			skyColorNight += textureLod(u_SkyCubeMapNight, reflected, lod2).rgb;
			skyColorNight += textureLod(u_SkyCubeMapNight, reflected, lod3).rgb;
			skyColorNight += textureLod(u_SkyCubeMapNight, reflected, lod4).rgb;
			skyColorNight /= 4.0;

			skyColor = mix(skyColorDay, skyColorNight, clamp(NIGHT_SCALE, 0.0, 1.0));
		}
		else if (NIGHT_SCALE >= 1.0)
		{// Night only colors...
			skyColor = textureLod(u_SkyCubeMapNight, reflected, lod1).rgb;
			skyColor += textureLod(u_SkyCubeMapNight, reflected, lod2).rgb;
			skyColor += textureLod(u_SkyCubeMapNight, reflected, lod3).rgb;
			skyColor += textureLod(u_SkyCubeMapNight, reflected, lod4).rgb;
			skyColor /= 4.0;
		}
		else
		{// Day only colors...
			skyColor = textureLod(u_SkyCubeMap, reflected, lod1).rgb;
			skyColor += textureLod(u_SkyCubeMap, reflected, lod2).rgb;
			skyColor += textureLod(u_SkyCubeMap, reflected, lod3).rgb;
			skyColor += textureLod(u_SkyCubeMap, reflected, lod4).rgb;
			skyColor /= 4.0;
		}

		skyColor = clamp(ContrastSaturationBrightness(skyColor, 1.0, 2.0, 0.333), 0.0, 1.0);
		skyColor = clamp(Vibrancy( skyColor, 0.4 ), 0.0, 1.0);
	}
#endif //__LQ_MODE__

	if (specularReflectivePower > 0.0)
	{// If this pixel is ging to get any specular reflection, generate (PBR would instead look up image buffer) specular color, and grab any cubeMap lighting as well...
		// Construct generic specular map by creating a greyscale, contrasted, saturation removed, color from the screen color... Then multiply by the material's default specular modifier...
#define spec_cont_1 ( 16.0 / 255.0)
#define spec_cont_2 (255.0 / 192.0)
			specularColor = clamp((clamp(outColor.rgb - spec_cont_1, 0.0, 1.0)) * spec_cont_2, 0.0, 1.0);
			specularColor = clamp(Vibrancy( specularColor.rgb, 1.0 ), 0.0, 1.0);

			//vec3 s = (outColor.rgb + ((outColor.r+outColor.g+outColor.b) / 3.0)) * 0.5;
			//float df = clamp(distance(outColor.rgb, vec3((outColor.r+outColor.g+outColor.b) / 3.0)), 0.0, 1.0);
			//s = mix(s, outColor.rgb, df);

			//specularColor = clamp(pow(s *2.5, vec3(1.5)), 0.0, 1.0);
			//specularColor = vec3(df);
			//specularColor = clamp(outColor.rgb * vec3(pow(df, 1.0-df)*8.0), 0.0, 1.0);
			//gl_FragColor = vec4(specularColor.rgb, 1.0);
			//return;


#ifndef __LQ_MODE__
#if defined(__CUBEMAPS__)
		if (CUBEMAP_ENABLED > 0.0 && cubeReflectionFactor > 0.0 && NE > 0.0 && u_CubeMapStrength > 0.0)
		{// Cubemaps enabled...
			vec3 cubeLightColor = vec3(0.0);
			
			// This used to be done in rend2 code, now done here because I need u_CubeMapInfo.xyz to be cube origin for distance checks above... u_CubeMapInfo.w is now radius.
			vec4 cubeInfo = u_CubeMapInfo;
			cubeInfo.xyz -= u_ViewOrigin.xyz;

			cubeInfo.w = pow(distance(u_ViewOrigin.xyz, u_CubeMapInfo.xyz), 3.0);

			cubeInfo.xyz *= 1.0 / cubeInfo.w;
			cubeInfo.w = 1.0 / cubeInfo.w;

			vec3 parallax = cubeInfo.xyz + cubeInfo.w * E;
			parallax.z *= -1.0;

			float curDist = distance(u_ViewOrigin.xyz, position.xyz);
			float cubeDist = distance(u_CubeMapInfo.xyz, position.xyz);
			float cubeFade = (1.0 - clamp(curDist / CUBEMAP_CULLRANGE, 0.0, 1.0)) * (1.0 - clamp(cubeDist / CUBEMAP_CULLRANGE, 0.0, 1.0));

			if (cubeFade > 0.0)
			{
				cubeLightColor = textureLod(u_CubeMap, cubeRayDir + parallax, 7.0 - (cubeReflectionFactor * 7.0)).rgb;
				cubeLightColor += texture(u_CubeMap, cubeRayDir + parallax).rgb;
				cubeLightColor /= 2.0;
				outColor.rgb = mix(outColor.rgb, outColor.rgb + cubeLightColor.rgb, clamp(NE * cubeFade * (u_CubeMapStrength * 20.0) * cubeReflectionFactor, 0.0, 1.0));
			}
		}
		else
		{
			if (cubeReflectionFactor > 0.0 && NE > 0.0)
			{
				vec2 shinyTC = ((cubeRayDir.xy + cubeRayDir.z) / 2.0) * 0.5 + 0.5;

				//vec3 shiny = textureLod(u_WaterEdgeMap, shinyTC, 5.5 - (cubeReflectionFactor * 5.5)).rgb;
				vec3 shiny = textureLod(u_WaterEdgeMap, shinyTC, 4.0 - (cubeReflectionFactor * 4.0)).rgb;
				shiny += textureLod(u_WaterEdgeMap, shinyTC, 5.0 - (cubeReflectionFactor * 5.0)).rgb;
				shiny += textureLod(u_WaterEdgeMap, shinyTC, 7.0 - (cubeReflectionFactor * 7.0)).rgb;
				shiny += textureLod(u_WaterEdgeMap, shinyTC, 10.0 - (cubeReflectionFactor * 10.0)).rgb;
				shiny /= 4.0;

				shiny = clamp(ContrastSaturationBrightness(shiny, 1.75, 1.0, 0.333), 0.0, 1.0);
				outColor.rgb = mix(outColor.rgb, outColor.rgb + shiny.rgb, clamp(NE * cubeReflectionFactor * (origColorStrength * 0.75 + 0.25), 0.0, 1.0));
			}
		}
#else //!defined(__CUBEMAPS__)
		if (cubeReflectionFactor > 0.0 && NE > 0.0)
		{
			vec2 shinyTC = ((cubeRayDir.xy + cubeRayDir.z) / 2.0) * 0.5 + 0.5;

			//vec3 shiny = textureLod(u_WaterEdgeMap, shinyTC, 5.5 - (cubeReflectionFactor * 5.5)).rgb;
			vec3 shiny = textureLod(u_WaterEdgeMap, shinyTC, 4.0 - (cubeReflectionFactor * 4.0)).rgb;
			shiny += textureLod(u_WaterEdgeMap, shinyTC, 5.0 - (cubeReflectionFactor * 5.0)).rgb;
			shiny += textureLod(u_WaterEdgeMap, shinyTC, 7.0 - (cubeReflectionFactor * 7.0)).rgb;
			shiny += textureLod(u_WaterEdgeMap, shinyTC, 10.0 - (cubeReflectionFactor * 10.0)).rgb;
			shiny /= 4.0;

			shiny = clamp(ContrastSaturationBrightness(shiny, 1.75, 1.0, 0.333), 0.0, 1.0);
			outColor.rgb = mix(outColor.rgb, outColor.rgb + shiny.rgb, clamp(NE * cubeReflectionFactor * (origColorStrength * 0.75 + 0.25), 0.0, 1.0));
		}
#endif //defined(__CUBEMAPS__)
#endif //!__LQ_MODE__
	}


	float SE = clamp(dot(/*E*/rayDir, sunDir), 0.0, 1.0);
	float specPower = ((clamp(SE, 0.0, 1.0) + clamp(pow(SE, 2.0), 0.0, 1.0)) * 0.5) * 0.333;


	outColor.rgb = clamp(outColor.rgb + (specularColor.rgb * specularReflectivePower * specPower * finalShadow), 0.0, 1.0);


	if (SKY_LIGHT_CONTRIBUTION > 0.0 && cubeReflectionFactor > 0.0)
	{// Sky light contributions...
#ifndef __LQ_MODE__
		outColor.rgb = mix(outColor.rgb, outColor.rgb + skyColor, clamp(NE * SKY_LIGHT_CONTRIBUTION * cubeReflectionFactor * (origColorStrength * 0.75 + 0.25), 0.0, 1.0));
#endif //__LQ_MODE__
		float reflectVectorPower = pow(specularReflectivePower*NE, 16.0) * reflectionPower;
		outColor.rgb = mix(outColor.rgb, outColor.rgb + specularColor, clamp(pow(reflectVectorPower, 2.0) * cubeReflectionFactor * (origColorStrength * 0.75 + 0.25), 0.0, 1.0));
		//outColor.rgb = skyColor;
	}

	if (SUN_PHONG_SCALE > 0.0 && specularReflectivePower > 0.0)
	{// If r_blinnPhong is <= 0.0 then this is pointless...
		float phongFactor = (SUN_PHONG_SCALE * 12.0);

		float PshadowValue = 1.0 - texture(u_RoadsControlMap, texCoords).a;

#define LIGHT_COLOR_POWER			4.0

		if (phongFactor > 0.0 && NIGHT_SCALE < 1.0 && finalShadow > 0.0)
		{// this is blinn phong
			float maxBright = clamp(max(outColor.r, max(outColor.g, outColor.b)), 0.0, 1.0);
			float power = clamp(pow(maxBright * 0.75, LIGHT_COLOR_POWER) + 0.333, 0.0, 1.0);
			vec3 lightColor = Vibrancy(u_PrimaryLightColor.rgb, 1.0);
			float lightMult = clamp(specularReflectivePower * power, 0.0, 1.0);

			if (lightMult > 0.0)
			{
				lightColor *= lightMult;
				//lightColor *= max(outColor.r, max(outColor.g, outColor.b)) * 0.9 + 0.1;
				lightColor *= clamp(1.0 - NIGHT_SCALE, 0.0, 1.0); // Day->Night scaling of sunlight...
				//lightColor = clamp(lightColor, 0.0, 0.7);

				lightColor.rgb *= lightsReflectionFactor * phongFactor * origColorStrength * 8.0;

				vec3 addColor = blinn_phong(position.xyz, outColor.rgb, bump, E, -sunDir, clamp(lightColor, 0.0, 1.0), 1.0, u_PrimaryLightOrigin.xyz, wetness);

				if (position.a - 1.0 == MATERIAL_GREENLEAVES || position.a - 1.0 == MATERIAL_PROCEDURALFOLIAGE)
				{// Light bleeding through tree leaves...
					float ndotl = clamp(dot(bump, sunDir), 0.0, 1.0);
					float diffuse = pow(ndotl, 2.0) * 1.25;

					addColor += lightColor * diffuse;
				}

				float puddleMult = 1.0;
				if (isPuddle) puddleMult = 0.25;
				outColor.rgb = outColor.rgb + max(addColor * PshadowValue * finalShadow * puddleMult, vec3(0.0));
			}
		}

		if (u_lightCount > 0.0)
		{
			phongFactor = 12.0;

			vec3 addedLight = vec3(0.0);
			float maxBright = clamp(max(outColor.r, max(outColor.g, outColor.b)), 0.0, 1.0);
			float power = maxBright * 0.85;
			power = clamp(pow(power, LIGHT_COLOR_POWER) + 0.5/*0.333*/, 0.0, 1.0);

			if (power > 0.0)
			{
				for (int li = 0; li < u_lightCount; li++)
				{
					vec3 lightPos = u_lightPositions2[li].xyz;
					vec3 lightDir = normalize(lightPos - position.xyz);
					float lightDist = distance(lightPos, position.xyz);
					float coneModifier = 1.0;

					if (HAVE_CONE_ANGLES > 0.0 && u_lightConeAngles[li] > 0.0)
					{
						vec3 coneDir = normalize(u_lightConeDirections[li]);

						float lightToSurfaceAngle = degrees(acos(dot(-lightDir, coneDir)));
					
						if (lightToSurfaceAngle > u_lightConeAngles[li])
						{// Outside of this light's cone...
							continue;
						}
					}

					float lightPlayerDist = distance(lightPos.xyz, u_ViewOrigin.xyz);

					float lightDistMult = 1.0 - clamp((lightPlayerDist / MAX_DEFERRED_LIGHT_RANGE), 0.0, 1.0);
					lightDistMult = pow(lightDistMult, 2.0);

					if (lightDistMult > 0.0)
					{
						// Attenuation...
						float lightFade = 1.0 - clamp((lightDist * lightDist) / (u_lightDistances[li] * u_lightDistances[li]), 0.0, 1.0);
						lightFade = pow(lightFade, 2.0);

						if (lightFade > 0.0)
						{
							float lightStrength = coneModifier * lightDistMult * lightFade * specularReflectivePower * 0.5;
							float maxLightsScale = mix(0.01, 1.0, clamp(pow(1.0 - (lightPlayerDist / u_lightMaxDistance), 0.5), 0.0, 1.0));
							lightStrength *= maxLightsScale;

							if (lightStrength > 0.0)
							{
								vec3 lightColor = (u_lightColors[li].rgb / length(u_lightColors[li].rgb)) * MAP_EMISSIVE_COLOR_SCALE * maxLightsScale;
								float selfShadow = clamp(pow(clamp(dot(-lightDir.rgb, bump.rgb), 0.0, 1.0), 8.0) * 0.6 + 0.6, 0.0, 1.0);
				
								lightColor = lightColor * power * origColorStrength;

								float lightSpecularPower = mix(0.1, 0.5, clamp(lightsReflectionFactor, 0.0, 1.0)) * clamp(lightStrength * phongFactor, 0.0, 1.0);

								addedLight.rgb += blinn_phong(position.xyz, outColor.rgb, bump, E, lightDir, clamp(lightColor, 0.0, 1.0), lightSpecularPower, lightPos, wetness) * lightFade * selfShadow;

								if (position.a - 1.0 == MATERIAL_GREENLEAVES || position.a - 1.0 == MATERIAL_PROCEDURALFOLIAGE)
								{// Light bleeding through tree leaves...
									float ndotl = clamp(dot(bump, -lightDir), 0.0, 1.0);
									float diffuse = pow(ndotl, 2.0) * 4.0;

									addedLight.rgb += lightColor * diffuse * lightFade * selfShadow * lightSpecularPower;
								}
							}
						}
					}
				}

				addedLight.rgb *= lightsReflectionFactor; // More grey colors get more colorization from lights...
				outColor.rgb = outColor.rgb + max(addedLight * PshadowValue, vec3(0.0));
			}
		}
	}

#if defined(__SCREEN_SPACE_REFLECTIONS__)
	if (REFLECTIONS_ENABLED > 0.0 && ssrReflectivePower > 0.0 && position.a - 1.0 != MATERIAL_WATER && !changedToWater)
	{
		if (isPuddle)
		{// Just basic water color addition for now with reflections... Maybe raindrops at some point later...
			outColor.rgb += vec3(0.0, 0.1, 0.15);
		}

		outColor.rgb = AddReflection(texCoords, position, flatNorm, outColor.rgb, ssrReflectivePower);
	}
#endif //defined(__SCREEN_SPACE_REFLECTIONS__)

#if defined(__AMBIENT_OCCLUSION__)
	#if 0
	if (AO_TYPE == 1.0)
	{// Fast AO enabled...
		const float MAX_AO_DIST = 32.0;
		float ao = 0.0;

		float vdist1 = distance(u_ViewOrigin.xy, position.xy);

		//for (int x = 1; x < 12; x++)
		for (int x = 1; x < 6; x++)
		{
			//float fx = pixel.x * pow(float(x), 1.5);
			float fx = pixel.x * float(x) * 4.0/*2.0*/;//pow(float(x), 1.25);

			//for (int y = 1; y < 4; y++)
			for (int y = 1; y < 6; y++)
			{
				//float fy = pixel.y * pow(float(y), 1.5);
				float fy = pixel.y * float(y) * float(y);//pow(float(y), 1.25);
				vec2 off = vec2(fx,fy);

				if (ao < 1.0)
				{
					//bool changedToWater3 = false;
					//vec3 originalPosition3;

					vec4 pMap3 = texture(u_PositionMap, texCoords + off);//positionMapAtCoord(texCoords + off, changedToWater3, originalPosition3);
					float dist = distance(position.xyz, pMap3.xyz);
					float vdist2 = distance(u_ViewOrigin.xy, pMap3.xy);
					
					float vmod = vdist1 - vdist2;
					if (vmod > 0.0)
						vmod = 1.0 - clamp(vmod / 8.0, 0.0, 1.0);
					else
						vmod = 1.0;

					float hdiff = pMap3.z - position.z;

					if (/*dist <= MAX_AO_DIST &&*/ hdiff > 0.0)
					{
						//float dmod = 1.0 - clamp(dist / MAX_AO_DIST, 0.0, 1.0);
						//float hmod = clamp(hdiff / MAX_AO_DIST, 0.0, 1.0);
						//ao = max(ao, dmod*hmod);
						ao = max(ao, clamp(hdiff/dist, 0.0, 1.0) * vmod);
					}
				}

				if (ao < 1.0)
				{
					//bool changedToWater3 = false;
					//vec3 originalPosition3;

					vec4 pMap3 = texture(u_PositionMap, texCoords + vec2(-off.x, off.y));//positionMapAtCoord(texCoords + vec2(-off.x, off.y), changedToWater3, originalPosition3);
					float dist = distance(position.xyz, pMap3.xyz);
					float vdist2 = distance(u_ViewOrigin.xy, pMap3.xy);

					float vmod = vdist1 - vdist2;
					if (vmod > 0.0)
						vmod = 1.0 - clamp(vmod / 8.0, 0.0, 1.0);
					else
						vmod = 1.0;

					float hdiff = pMap3.z - position.z;

					if (/*dist <= MAX_AO_DIST &&*/ hdiff > 0.0)
					{
						//float dmod = 1.0 - clamp(dist / MAX_AO_DIST, 0.0, 1.0);
						//float hmod = clamp(hdiff / MAX_AO_DIST, 0.0, 1.0);
						//ao = max(ao, dmod*hmod);
						ao = max(ao, clamp(hdiff/dist, 0.0, 1.0) * vmod);
					}
				}
			}
		}

		if (ao > 0.0)
		{
			//ao = clamp(pow(ao, 0.25), 0.0, 1.0);
			//ao = clamp(pow(ao, 1.5), 0.0, 1.0);
			//outColor.rgb *= 1.0 - ao;
			ao *= norm.b * 0.5 + 0.5;
			ao = (1.0 - ao) * 0.7 + 0.3;

			//float selfShadow = clamp(pow(clamp(dot(-sunDir.rgb, bump.rgb), 0.0, 1.0), 8.0), 0.0, 1.0);
			//ao = clamp(((ao + selfShadow) / 2.0) * AO_MULTBRIGHT + AO_MINBRIGHT, AO_MINBRIGHT, 1.0);
			ao = clamp(ao * AO_MULTBRIGHT + AO_MINBRIGHT, AO_MINBRIGHT, 1.0);
			outColor.rgb *= ao;
		}
	}
	#else
	if (AO_TYPE == 1.0)
	{// Fast AO enabled...
		float ao = calculateAO(sunDir, N * 10000.0, texCoords);
		float selfShadow = clamp(pow(clamp(dot(-sunDir.rgb, bump.rgb), 0.0, 1.0), 8.0), 0.0, 1.0);
		ao = clamp(((ao + selfShadow) / 2.0) * AO_MULTBRIGHT + AO_MINBRIGHT, AO_MINBRIGHT, 1.0);
		outColor.rgb *= ao;
	}
	#endif
#endif //defined(__AMBIENT_OCCLUSION__)

#if defined(__ENHANCED_AO__)
	if (AO_TYPE >= 2.0)
	{// Better, HQ AO enabled...
		float msao = 0.0;

		if (AO_TYPE >= 3.0)
		{
			int width = int(AO_TYPE-2.0);
			float numSamples = 0.0;
		
			for (int x = -width; x <= width; x+=2)
			{
				for (int y = -width; y <= width; y+=2)
				{
					vec2 coord = texCoords + (vec2(float(x), float(y)) * pixel);
					msao += textureLod(u_SteepMap, coord, 0.0).x;
					numSamples += 1.0;
				}
			}

			msao /= numSamples;
		}
		else
		{
			msao = textureLod(u_SteepMap, texCoords, 0.0).x;
		}

		float sao = clamp(msao, 0.0, 1.0);
		sao = clamp(sao * AO_MULTBRIGHT + AO_MINBRIGHT, AO_MINBRIGHT, 1.0);
		outColor.rgb *= sao;
	}
#endif //defined(__ENHANCED_AO__)

	finalShadow = mix(finalShadow, 1.0, clamp(NIGHT_SCALE, 0.0, 1.0)); // Dampen out shadows at sunrise/sunset...

#ifdef __CLOUD_SHADOWS__
	if (CLOUDS_SHADOWS_ENABLED == 1.0)
	{
		finalShadow = min(finalShadow, clamp(var_CloudShadow + 0.1, 0.0, 1.0));
	}
	else if (CLOUDS_SHADOWS_ENABLED >= 2.0)
	{
		float cShadow = CloudShadows(position.xyz) * 0.5 + 0.5;
		cShadow = mix(cShadow, 1.0, clamp(NIGHT_SCALE, 0.0, 1.0)); // Dampen out cloud shadows at sunrise/sunset...
		finalShadow = min(finalShadow, clamp(cShadow + 0.1, 0.0, 1.0));
	}
#endif //__CLOUD_SHADOWS__

	outColor.rgb *= finalShadow;


	if (!(CONTRAST_STRENGTH == 1.0 && SATURATION_STRENGTH == 1.0 && BRIGHTNESS_STRENGTH == 1.0))
	{// C/S/B enabled...
		outColor.rgb = ContrastSaturationBrightness(outColor.rgb, CONTRAST_STRENGTH, SATURATION_STRENGTH, BRIGHTNESS_STRENGTH);
	}

	if (TRUEHDR_ENABLED > 0.0)
	{// TrueHDR enabled...
		outColor.rgb = TrueHDR( outColor.rgb );
	}

	if (VIBRANCY > 0.0)
	{// Vibrancy enabled...
		outColor.rgb = Vibrancy( outColor.rgb, VIBRANCY );
	}

	outColor.rgb = clamp(outColor.rgb, 0.0, 1.0);
	gl_FragColor = outColor;
	
	gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3(1.0 / GAMMA_CORRECTION));
	gl_FragColor.a = 1.0;
}

