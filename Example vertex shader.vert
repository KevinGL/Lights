#version 400 core

layout (location = 0) in vec3 vertex;

uniform mat4 project;
uniform mat4 model;
uniform mat4 view;

uniform mat4 projectShadow;
uniform mat4 viewShadow;

out vec4 projShadow;

out vec3 frag;

void main(void)
{
    vec4 vertex2 = vec4(vertex, 1.0);

    gl_Position = project * view * model * vertex2;
	
	frag = vertex;
	
	projShadow = projectShadow * viewShadow * model * vertex2;
}
