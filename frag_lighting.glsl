struct Light
{
	vec3 pos;
	vec3 dir;
	vec3 color;
	float distMax;
	float angle;
	float intensity;
	float ambient;
	int type;
	int on;
};

uniform Light lights[100];
uniform int nbLights;

uniform sampler2D shadowMap;
uniform int sizeShadow;
uniform int active = 0;

in vec4 projShadow;

float PI = 3.1415926535897932384626433832795;

float calculShadow(Light light, vec3 normalApp)
{
	vec3 projCoords = projShadow.xyz / projShadow.w;
	projCoords = projCoords * 0.5 + 0.5;
	
	if(active == 0 || projCoords.z < 0 || projCoords.z > 1)
	{
		return 1.0;
	}
	
	float shadow = 0.0;
	float currentDepth = projCoords.z;
	float totalWeight = 0.0;
	float texelSize = 1.0 / sizeShadow;
	
	int res = 3;
	
	for(int y = -res; y <= res; y++)
	{
		for(int x = -res; x <= res; x++)
		{
			vec2 offset = vec2(x, y) * texelSize;
			float closestDepth = texture(shadowMap, projCoords.xy + offset).r;
			
			float weight = 1.0;
			totalWeight += weight;
			
			float biasMin = 0.0005;
			float biasMax = 0.04;
			float dotProd = abs(dot(normalApp, light.dir));
			float coef = (biasMax - biasMin) / 1.0;
			//float bias = coef * dotProd + biasMax;
			
			float baseBias = 0.005;
			float dynamicBias = 0.005 * dot(normalApp, light.dir);
			float bias = baseBias + clamp(dynamicBias, 0.0, 0.002);

			shadow += currentDepth - bias > closestDepth ? 1.0 : 0.0;
		}
	}
	
	shadow /= totalWeight;
	
	return 1.0 - shadow;
}

float calculDiff(Light light, vec3 normalApp, vec3 fragApp)
{
	float lightDiff;
	
	if(light.type == 0)		//Point
	{
		vec3 rayDir = normalize(light.pos - fragApp);
		
		lightDiff = dot(normalApp, rayDir);
		
		if(lightDiff < 0.0)
		{
			lightDiff = 0.0;
		}
		
		if(light.distMax != -1.0)
		{
			float dist = length(light.pos - fragApp);
			
			float coef = -1.0/light.distMax;
			
			float att;
			
			if(dist <= light.distMax)
			{
				att = coef * dist + 1.0;
			}
			else
			{
				att = 0.0;
			}
			
			lightDiff *= att;
		}
	}
	
	else
	if(light.type == 1)		//Sun
	{
		vec3 rayDir = -normalize(light.dir);		//From frag to Sun
		
		lightDiff = dot(normalApp, rayDir);
		
		if(lightDiff < 0.0)
		{
			lightDiff = 0.0;
		}
		
		lightDiff *= calculShadow(light, normalApp);
	}
	
	else
	if(light.type == 2)		//Direction
	{
		vec3 rayDir = -normalize(light.dir);		//From frag to light
		
		lightDiff = dot(normalApp, rayDir);
		
		if(lightDiff < 0.0)
		{
			lightDiff = 0.0;
		}
		
		if(light.distMax != -1.0)
		{
			float dist = length(light.pos - fragApp);
			
			float coef = -1.0/light.distMax;
			
			float att;
			
			if(dist <= light.distMax)
			{
				att = coef * dist + 1.0;
			}
			else
			{
				att = 0.0;
			}
			
			lightDiff *= att;
		}
	}
	
	else
	if(light.type == 3)		//Projector
	{
		vec3 rayDir = normalize(light.pos - fragApp);
		
		lightDiff = dot(normalApp, rayDir);
		
		if(lightDiff < 0.0)
		{
			lightDiff = 0.0;
		}
		
		if(light.distMax != -1.0)
		{
			float dist = length(light.pos - fragApp);
			
			float coef = -1.0/light.distMax;
			
			float att;
			
			if(dist <= light.distMax)
			{
				att = coef * dist + 1.0;
			}
			else
			{
				att = 0.0;
			}
			
			lightDiff *= att;
		}
		
		/*float angleLightDir_RayDir = acos(dot(normalize(light.dir), -rayDir)) * 180/PI;
		
		float att;
		
		if(angleLightDir_RayDir <= light.angle/2)
		{
			float coef = -1.0/(light.angle/2);
			
			att = coef * angleLightDir_RayDir + 1.0;
		}
		else
		{
			att = 0.0;
		}
		
		lightDiff *= att;*/
	}
	
	return lightDiff;
}

vec4 lighting(vec4 initColor, vec3 normalApp, vec3 fragApp)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	for(int i=0; i<nbLights; i++)
	{
		if(lights[i].on == 1)
		{
			float lightDiff = calculDiff(lights[i], normalApp, fragApp);
			
			lightColor += (lightDiff + lights[i].ambient) * lights[i].intensity * lights[i].color;
		}
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}

vec4 lightingSetAmbient(int index, float ambient, vec4 initColor, vec3 normalApp, vec3 fragApp)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	for(int i=0; i<nbLights; i++)
	{
		if(lights[i].on == 1)
		{
			float lightDiff = calculDiff(lights[i], normalApp, fragApp);
			
			if(i == index)
			{
				lightColor += (lightDiff + ambient) * lights[i].intensity * lights[i].color;
			}
			
			else
			{
				lightColor += (lightDiff + lights[i].ambient) * lights[i].intensity * lights[i].color;
			}
		}
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}

vec4 lightingWithAttenuation(vec4 initColor, int indexAtt, float att, vec3 normalApp, vec3 fragApp)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	for(int i=0; i<nbLights; i++)
	{
		if(lights[i].on == 1)
		{
			float lightDiff = calculDiff(lights[i], normalApp, fragApp);
			
			if(i != indexAtt)
			{
				lightColor += (lightDiff + lights[i].ambient) * lights[i].intensity * lights[i].color;
			}
			else
			{
				lightColor += (lightDiff + lights[i].ambient) * att * lights[i].intensity * lights[i].color;
			}
		}
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}

vec4 lightingExceptOne(int index, vec4 initColor, vec3 normalApp, vec3 fragApp)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	for(int i=0; i<nbLights; i++)
	{
		if(i != index)
		{
			if(lights[i].on == 1)
			{
				float lightDiff = calculDiff(lights[i], normalApp, fragApp);
			
				lightColor += (lightDiff + lights[i].ambient) * lights[i].intensity * lights[i].color;
			}
		}
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}

vec4 lightingOne(int index, vec4 initColor, vec3 normalApp, vec3 fragApp)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	if(lights[index].on == 1)
	{
		float lightDiff = calculDiff(lights[index], normalApp, fragApp);
			
		lightColor += (lightDiff + lights[index].ambient) * lights[index].intensity * lights[index].color;
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}

vec4 addLight(int index, vec4 initColor, vec3 normalApp, vec3 fragApp)
{
	vec3 lightColor;
	
	if(lights[index].on == 1)
	{
		float lightDiff = calculDiff(lights[index], normalApp, fragApp);
			
		lightColor = (lightDiff + lights[index].ambient) * lights[index].intensity * lights[index].color;
	}
	
	return vec4(initColor.rgb + initColor.rgb * lightColor, 1.0);
}