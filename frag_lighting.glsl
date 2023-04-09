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

uniform Light lights[20];
uniform int nbLights;

float attenuations[20];

float calculDiff(Light light)
{
	float lightDiff;
	
	if(light.type == 0)		//Point
	{
		vec3 lightDir = normalize(light.pos - frag);
		
		lightDiff = dot(normaleFrag, lightDir);
		
		if(lightDiff < 0.0)
		{
			lightDiff = 0.0;
		}
		
		if(light.distMax != -1.0)
		{
			float dist = length(light.pos - frag);
			
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
		vec3 lightDir = -normalize(light.dir);		//From frag to Sun
		
		lightDiff = dot(normaleFrag, lightDir);
		
		if(lightDiff < 0.0)
		{
			lightDiff = 0.0;
		}
	}
	
	else
	if(light.type == 2)		//Direction
	{
		vec3 lightDir = -normalize(light.dir);		//From frag to light
		
		lightDiff = dot(normaleFrag, lightDir);
		
		if(lightDiff < 0.0)
		{
			lightDiff = 0.0;
		}
		
		if(light.distMax != -1.0)
		{
			float dist = length(light.pos - frag);
			
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
	
	return lightDiff;
}

vec4 lighting(vec4 initColor)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	for(int i=0; i<nbLights; i++)
	{
		if(lights[i].on == 1)
		{
			float lightDiff = calculDiff(lights[i]);
			
			lightColor += (lightDiff + lights[i].ambient) * lights[i].intensity * lights[i].color;
		}
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}

vec4 lightingWithAttenuation(vec4 initColor, int indexAtt, float att)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	for(int i=0; i<nbLights; i++)
	{
		if(lights[i].on == 1)
		{
			float lightDiff = calculDiff(lights[i]);
			
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

vec4 lightingExceptOne(int index, vec4 initColor)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	for(int i=0; i<nbLights; i++)
	{
		if(i != index)
		{
			if(lights[i].on == 1)
			{
				float lightDiff = calculDiff(lights[i]);
			
				lightColor += (lightDiff + lights[i].ambient) * lights[i].intensity * lights[i].color;
			}
		}
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}

vec4 lightingOne(int index, vec4 initColor)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	if(lights[index].on == 1)
	{
		float lightDiff = calculDiff(lights[index]);
			
		lightColor += (lightDiff + lights[index].ambient) * lights[index].intensity * lights[index].color;
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}

vec4 addLight(int index, vec4 initColor)
{
	vec3 lightColor;
	
	if(lights[index].on == 1)
	{
		float lightDiff = calculDiff(lights[index]);
			
		lightColor = (lightDiff + lights[index].ambient) * lights[index].intensity * lights[index].color;
	}
	
	return vec4(initColor.rgb + initColor.rgb * lightColor, 1.0);
}