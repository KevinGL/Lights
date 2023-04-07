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

vec4 lighting(vec4 initColor)
{
	vec3 lightColor = vec3(0.0, 0.0, 0.0);
	
	for(int i=0; i<nbLights; i++)
	{
		if(lights[i].on == 1)
		{
			if(lights[i].type == 0)		//Point
			{
				vec3 lightDir = normalize(lights[i].pos - frag);
				
				float lightDiff = dot(normaleFrag, lightDir);
				
				if(lightDiff < 0.0)
				{
					lightDiff = 0.0;
				}
				
				if(lights[i].distMax != -1.0)
				{
					float dist = length(lights[i].pos - frag);
					
					float coef = -1.0/lights[i].distMax;
					
					float att;
					
					if(dist <= lights[i].distMax)
					{
						att = coef * dist + 1.0;
					}
					else
					{
						att = 0.0;
					}
					
					lightDiff *= att;
				}
				
				lightDiff *= lights[i].intensity;
				
				lightDiff += lights[i].ambient;
				
				lightColor += lightDiff * lights[i].color;
			}
			
			else
			if(lights[i].type == 1)		//Sun
			{
				vec3 lightDir = -normalize(lights[i].dir);		//From frag to Sun
				
				float lightDiff = dot(normaleFrag, lightDir);
				
				if(lightDiff < 0.0)
				{
					lightDiff = 0.0;
				}
				
				lightDiff *= lights[i].intensity;
				
				lightDiff += lights[i].ambient;
				
				lightColor += lightDiff * lights[i].color;
			}
			
			else
			if(lights[i].type == 2)		//Direction
			{
				vec3 lightDir = -normalize(lights[i].dir);		//From frag to light
				
				float lightDiff = dot(normaleFrag, lightDir);
				
				if(lightDiff < 0.0)
				{
					lightDiff = 0.0;
				}
				
				if(lights[i].distMax != -1.0)
				{
					float dist = length(lights[i].pos - frag);
					
					float coef = -1.0/lights[i].distMax;
					
					float att;
					
					if(dist <= lights[i].distMax)
					{
						att = coef * dist + 1.0;
					}
					else
					{
						att = 0.0;
					}
					
					lightDiff *= att;
				}
				
				lightDiff *= lights[i].intensity;
				
				lightDiff += lights[i].ambient;
				
				lightColor += lightDiff * lights[i].color;
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
				if(lights[i].type == 0)		//Point
				{
					vec3 lightDir = normalize(lights[i].pos - frag);
					
					float lightDiff = dot(normaleFrag, lightDir);
					
					if(lightDiff < 0.0)
					{
						lightDiff = 0.0;
					}
					
					if(lights[i].distMax != -1.0)
					{
						float dist = length(lights[i].pos - frag);
						
						float coef = -1.0/lights[i].distMax;
						
						float att;
						
						if(dist <= lights[i].distMax)
						{
							att = coef * dist + 1.0;
						}
						else
						{
							att = 0.0;
						}
						
						lightDiff *= att;
					}
					
					lightDiff *= lights[i].intensity;
					
					lightDiff += lights[i].ambient;
					
					lightColor += lightDiff * lights[i].color;
				}
				
				else
				if(lights[i].type == 1)		//Sun
				{
					vec3 lightDir = -normalize(lights[i].dir);		//From frag to Sun
					
					float lightDiff = dot(normaleFrag, lightDir);
					
					if(lightDiff < 0.0)
					{
						lightDiff = 0.0;
					}
					
					lightDiff *= lights[i].intensity;
					
					lightDiff += lights[i].ambient;
					
					lightColor += lightDiff * lights[i].color;
				}
				
				else
				if(lights[i].type == 2)		//Direction
				{
					vec3 lightDir = -normalize(lights[i].dir);		//From frag to light
					
					float lightDiff = dot(normaleFrag, lightDir);
					
					if(lightDiff < 0.0)
					{
						lightDiff = 0.0;
					}
					
					if(lights[i].distMax != -1.0)
					{
						float dist = length(lights[i].pos - frag);
						
						float coef = -1.0/lights[i].distMax;
						
						float att;
						
						if(dist <= lights[i].distMax)
						{
							att = coef * dist + 1.0;
						}
						else
						{
							att = 0.0;
						}
						
						lightDiff *= att;
					}
					
					lightDiff *= lights[i].intensity;
					
					lightDiff += lights[i].ambient;
					
					lightColor += lightDiff * lights[i].color;
				}
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
		if(lights[index].type == 1)		//Sun
		{
			vec3 lightDir = -normalize(lights[index].dir);		//From frag to Sun
			
			float lightDiff = dot(normaleFrag, lightDir);
			
			if(lightDiff < 0.0)
			{
				lightDiff = 0.0;
			}
			
			lightDiff *= lights[index].intensity;
			
			lightDiff += lights[index].ambient;
			
			lightColor += lightDiff * lights[index].color;
		}
	}
	
	return vec4(lightColor * initColor.rgb, initColor.a);
}
