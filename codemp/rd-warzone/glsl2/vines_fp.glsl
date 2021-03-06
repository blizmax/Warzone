#define _CHRISTMAS_LIGHTS_

#if defined(USE_BINDLESS_TEXTURES)
layout(std140) uniform u_bindlessTexturesBlock
{
uniform sampler2D					u_DiffuseMap;
uniform sampler2D					u_LightMap;
uniform sampler2D					u_NormalMap;
uniform sampler2D					u_DeluxeMap;
uniform sampler2D					u_SpecularMap;
uniform sampler2D					u_PositionMap;
uniform sampler2D					u_WaterPositionMap;
uniform sampler2D					u_WaterHeightMap;
uniform sampler2D					u_HeightMap;
uniform sampler2D					u_GlowMap;
uniform sampler2D					u_EnvironmentMap;
uniform sampler2D					u_TextureMap;
uniform sampler2D					u_LevelsMap;
uniform sampler2D					u_CubeMap;
uniform sampler2D					u_SkyCubeMap;
uniform sampler2D					u_SkyCubeMapNight;
uniform sampler2D					u_EmissiveCubeMap;
uniform sampler2D					u_OverlayMap;
uniform sampler2D					u_SteepMap;
uniform sampler2D					u_SteepMap1;
uniform sampler2D					u_SteepMap2;
uniform sampler2D					u_SteepMap3;
uniform sampler2D					u_WaterEdgeMap;
uniform sampler2D					u_SplatControlMap;
uniform sampler2D					u_SplatMap1;
uniform sampler2D					u_SplatMap2;
uniform sampler2D					u_SplatMap3;
uniform sampler2D					u_RoadsControlMap;
uniform sampler2D					u_RoadMap;
uniform sampler2D					u_DetailMap;
uniform sampler2D					u_ScreenImageMap;
uniform sampler2D					u_ScreenDepthMap;
uniform sampler2D					u_ShadowMap;
uniform sampler2D					u_ShadowMap2;
uniform sampler2D					u_ShadowMap3;
uniform sampler2D					u_ShadowMap4;
uniform sampler2D					u_ShadowMap5;
uniform sampler3D					u_VolumeMap;
uniform sampler2D					u_MoonMaps[4];
};
#else //!defined(USE_BINDLESS_TEXTURES)
uniform sampler2D					u_DiffuseMap;	// Land grass atlas
uniform sampler2D					u_WaterEdgeMap; // Sea grass atlas
#endif //defined(USE_BINDLESS_TEXTURES)

uniform vec3						u_ViewOrigin;
uniform vec2						u_Dimensions;

uniform vec4						u_Settings1; // IS_DEPTH_PASS, 0.0, 0.0, LEAF_ALPHA_MULTIPLIER
uniform vec4						u_Settings5; // MAP_COLOR_SWITCH_RG, MAP_COLOR_SWITCH_RB, MAP_COLOR_SWITCH_GB, ENABLE_CHRISTMAS_EFFECT

#define IS_DEPTH_PASS				u_Settings1.r
#define LEAF_ALPHA_MULTIPLIER		u_Settings1.a

#define MAP_COLOR_SWITCH_RG			u_Settings5.r
#define MAP_COLOR_SWITCH_RB			u_Settings5.g
#define MAP_COLOR_SWITCH_GB			u_Settings5.b
#define ENABLE_CHRISTMAS_EFFECT		u_Settings5.a

uniform vec4						u_Local1; // MAP_SIZE, sway, overlaySway, materialType
uniform vec4						u_Local2; // hasSteepMap, hasWaterEdgeMap, haveNormalMap, SHADER_WATER_LEVEL
uniform vec4						u_Local3; // hasSplatMap1, hasSplatMap2, hasSplatMap3, hasSplatMap4
uniform vec4						u_Local8; // passnum, GRASS_DISTANCE_FROM_ROADS, GRASS_HEIGHT, 0.0
uniform vec4						u_Local9; // testvalue0, 1, 2, 3
uniform vec4						u_Local10; // foliageLODdistance, TERRAIN_TESS_OFFSET, 0.0, GRASS_TYPE_UNIFORMALITY
uniform vec4						u_Local11; // GRASS_WIDTH_REPEATS, 0.0, 0.0, 0.0

#define SHADER_MAP_SIZE				u_Local1.r
#define SHADER_SWAY					u_Local1.g
#define SHADER_OVERLAY_SWAY			u_Local1.b
#define SHADER_MATERIAL_TYPE		u_Local1.a

#define SHADER_HAS_STEEPMAP			u_Local2.r
#define SHADER_HAS_WATEREDGEMAP		u_Local2.g
#define SHADER_HAS_NORMALMAP		u_Local2.b
#define SHADER_WATER_LEVEL			u_Local2.a

#define SHADER_HAS_SPLATMAP1		u_Local3.r
#define SHADER_HAS_SPLATMAP2		u_Local3.g
#define SHADER_HAS_SPLATMAP3		u_Local3.b
#define SHADER_HAS_SPLATMAP4		u_Local3.a

#define PASS_NUMBER					u_Local8.r
#define GRASS_DISTANCE_FROM_ROADS	u_Local8.g
#define GRASS_HEIGHT				u_Local8.b

#define MAX_RANGE					u_Local10.r
#define TERRAIN_TESS_OFFSET			u_Local10.g
#define GRASS_TYPE_UNIFORMALITY		u_Local10.a

#define GRASS_WIDTH_REPEATS			u_Local11.r

smooth in vec2		vTexCoord;
smooth in vec3		vVertPosition;
//flat in float		vVertNormal;
smooth in vec2		vVertNormal;
flat in int			iGrassType;

out vec4			out_Glow;
out vec4			out_Normal;
#ifdef USE_REAL_NORMALMAPS
out vec4			out_NormalDetail;
#endif //USE_REAL_NORMALMAPS
out vec4			out_Position;

const float xdec = 1.0/255.0;
const float ydec = 1.0/65025.0;
const float zdec = 1.0/16581375.0;

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

vec4 DecodeFloatRGBA( float v ) {
  vec4 enc = vec4(1.0, 255.0, 65025.0, 16581375.0) * v;
  enc = fract(enc);
  enc -= enc.yzww * vec4(xdec,xdec,xdec,0.0);
  return enc;
}

#ifdef _CHRISTMAS_LIGHTS_
float hash( const in float n ) {
	return fract(sin(n)*4378.5453);
}

float noise(in vec3 o, in float seed) 
{
	vec3 p = floor(o);
	vec3 fr = fract(o);
		
	float n = p.x + p.y*57.0 + p.z * seed;

	float a = hash(n+  0.0);
	float b = hash(n+  1.0);
	float c = hash(n+ 57.0);
	float d = hash(n+ 58.0);
	
	float e = hash(n+  0.0 + 1009.0);
	float f = hash(n+  1.0 + 1009.0);
	float g = hash(n+ 57.0 + 1009.0);
	float h = hash(n+ 58.0 + 1009.0);
	
	
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

const mat3 m = mat3( 0.00,  0.80,  0.60,
                    -0.80,  0.36, -0.48,
                    -0.60, -0.48,  0.64 );

float SmoothNoise( vec3 p, in float seed )
{
    float f;
    f  = 0.5000*noise( p, seed ); p = m*p*2.02;
    f += 0.2500*noise( p, seed ); 
	
    return f * (1.0 / (0.5000 + 0.2500));
}
#endif //_CHRISTMAS_LIGHTS_

bool isDithered(vec2 pos, float alpha)
{
	pos *= u_Dimensions.xy * 12.0;

	// Define a dither threshold matrix which can
	// be used to define how a 4x4 set of pixels
	// will be dithered
	float DITHER_THRESHOLDS[16] = float[]
	(
		1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
		13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
		4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
		16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
	);

	int index = (int(pos.x) % 4) * 4 + int(pos.y) % 4;
	return (alpha - DITHER_THRESHOLDS[index] < 0) ? true : false;
}

void main() 
{
	vec4 diffuse;
#ifdef _CHRISTMAS_LIGHTS_
	vec4 lights = vec4(0.0);
#endif //_CHRISTMAS_LIGHTS_

	vec2 tc = vTexCoord;

	if (GRASS_WIDTH_REPEATS > 0.0) tc.x *= (GRASS_WIDTH_REPEATS * 2.0);

	if (IS_DEPTH_PASS > 0.0)
	{
		if (iGrassType >= 1)
		{
			diffuse = vec4(1.0, 1.0, 1.0, texture(u_WaterEdgeMap, tc).a);
		}
		else
		{
			diffuse = vec4(1.0, 1.0, 1.0, texture(u_DiffuseMap, tc).a);
		}
	}
	else if (iGrassType >= 1)
	{
		diffuse = texture(u_WaterEdgeMap, tc);
	}
	else
	{
		diffuse = texture(u_DiffuseMap, tc);
	}

	if (MAP_COLOR_SWITCH_RG > 0.0)
	{
		diffuse.rg = diffuse.gr;
	}

	if (MAP_COLOR_SWITCH_RB > 0.0)
	{
		diffuse.rb = diffuse.br;
	}

	if (MAP_COLOR_SWITCH_GB > 0.0)
	{
		diffuse.gb = diffuse.bg;
	}

	// Amp up alphas on tree leafs, etc, so they draw at range instead of being blurred out...
	diffuse.a = clamp(diffuse.a * 1.5/*LEAF_ALPHA_MULTIPLIER*/, 0.0, 1.0);

	if (diffuse.a > 0.5)
	{
#if 1
		// Screen-door transparancy on distant and extremely close vines...
		float dist = distance(vVertPosition, u_ViewOrigin);
		float alpha = 1.0 - (dist / MAX_RANGE);
		float afar = clamp(alpha * 2.0, 0.0, 1.0);
		float anear = clamp(dist / 48.0, 0.0, 1.0);

		if (isDithered(tc, afar))
		{
			diffuse.a = 0.0;
		}
		else if (isDithered(tc, anear))
		{
			diffuse.a = 0.0;
		}
		else
		{
			diffuse.a = 1.0;
		}
#else
		diffuse.a = 1.0;
#endif

#ifdef _CHRISTMAS_LIGHTS_
		if (ENABLE_CHRISTMAS_EFFECT > 0.0 && diffuse.a > 0.05)
		{
			float mapmult = 0.05;
			float f = SmoothNoise(vVertPosition.xyz * mapmult, 1009.0);
			f = pow(f, 32.0);
			vec3 bri = pow(vec3(SmoothNoise(vVertPosition.yzx * mapmult, 1009.0), SmoothNoise(vVertPosition.xzy * mapmult, 1009.0), SmoothNoise(vVertPosition.zyx * mapmult, 1009.0)), vec3(8.0));
			lights.rgb = bri*f*10240.0;
			lights.a = clamp(max(lights.r, max(lights.g, lights.b)), 0.0, 1.0);
		}
#endif //_CHRISTMAS_LIGHTS_
	}
	else
	{
		diffuse.a = 0.0;
	}

	if (diffuse.a > 0.0/*0.05*//*0.5*/)
	{
	#ifdef _CHRISTMAS_LIGHTS_
		gl_FragColor = vec4(clamp(diffuse.rgb + (lights.rgb * lights.a), 0.0, 1.0), diffuse.a);
		out_Glow = vec4(lights);
	#else //!_CHRISTMAS_LIGHTS_
		gl_FragColor = vec4(diffuse);
		out_Glow = vec4(0.0);
	#endif //_CHRISTMAS_LIGHTS_
		out_Normal = vec4(vVertNormal.xy/*EncodeNormal(DecodeNormal(vVertNormal.xy))*/, 0.0, 1.0);
#ifdef USE_REAL_NORMALMAPS
		out_NormalDetail = vec4(0.0);
#endif //USE_REAL_NORMALMAPS
		out_Position = vec4(vVertPosition, MATERIAL_PROCEDURALFOLIAGE+1.0);
	}
	else
	{
		gl_FragColor = vec4(0.0);
		out_Glow = vec4(0.0);
		out_Normal = vec4(0.0);
#ifdef USE_REAL_NORMALMAPS
		out_NormalDetail = vec4(0.0);
#endif //USE_REAL_NORMALMAPS
		out_Position = vec4(0.0);
	}
}
