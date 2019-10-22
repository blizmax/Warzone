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
uniform samplerCube					u_CubeMap;
uniform samplerCube					u_SkyCubeMap;
uniform samplerCube					u_SkyCubeMapNight;
uniform samplerCube					u_EmissiveCubeMap;
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
uniform sampler2D					u_TextureMap;
#endif //defined(USE_BINDLESS_TEXTURES)

uniform vec2						u_Dimensions;

varying vec2						var_TexCoords;

const float SamplingRange=1.0; //sharpening or blurring range
const float SharpeningAmount=2.3;

//global variables, already set before executing this code
#define ScreenSize u_Dimensions.x //width of the display resolution (1920 f.e.)

void main (void)
{
	vec4 res;
	vec4 coord = vec4(0.0);

	coord.xy = var_TexCoords.xy;
	coord.w=0.0;

	vec4 origcolor = texture2D(u_TextureMap, coord.st);

	const vec2 offset[8] = vec2[8](vec2(1.0, 1.0), vec2(-1.0, -1.0), vec2(-1.0, 1.0), vec2(1.0, -1.0), vec2(1.41, 0.0), vec2(-1.41, 0.0), vec2(0.0, 1.41), vec2(0.0, -1.41));

	int i=0;

	vec4 tcol=origcolor;
	float invscreensize=1.0/ScreenSize;

	//for (i=0; i<8; i++) //higher quality
//#pragma unroll 4
	for (i=0; i<4; i++)
	{
		vec2 tdir=offset[i].xy;
		coord.xy=var_TexCoords.xy+tdir.xy*invscreensize*SamplingRange;//*1.0;
		vec4 ct=texture2D(u_TextureMap, coord.st);
		tcol+=ct;
	}

	tcol*=0.2; // 1.0/(4+1)
	//tcol*=0.111; // 1.0/(8+1)  //higher quality

	//sharp
	res=origcolor*(1.0+((origcolor-tcol)*SharpeningAmount));

	//less sharpening for bright pixels
	float rgray=origcolor.z; //blue fit well
	rgray=pow(rgray, 3.0);
	res=mix(res, origcolor, clamp(rgray, 0.0, 1.0));

	res.w=1.0;
	//res.a = origcolor.a;
	gl_FragColor = res;
}
