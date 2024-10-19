#version 400 core

in vec3 frag;

out vec4 FragColor;

//include("../../Mini-libs/lights/frag_lighting.glsl");

void main(void)
{
    vec4 color = ...;
	
	color = lighting(color, normal, frag);
	
	FragColor = color;
}
