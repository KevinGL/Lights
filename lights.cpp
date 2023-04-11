#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>
#include <GL/glew.h>
#include <GL/gl.h>
#include "lights.h"

void Lights::AddLight(Light light)
{
    /*if(light.type == LIGHT_SUN)
    {
        light.dist = -1.0f;         //Infinite
    }*/

    lights.push_back(light);
}

void Lights::SendToShader(GLuint shaderId)
{
    for(size_t i=0; i<lights.size(); i++)
    {
        std::ostringstream os;

        os << i;

        std::string local = "lights[" + os.str() + "].pos";

        glUniform3f(glGetUniformLocation(shaderId, local.c_str()), lights[i].pos.x, lights[i].pos.y, lights[i].pos.z);

        local = "lights[" + os.str() + "].dir";

        glUniform3f(glGetUniformLocation(shaderId, local.c_str()), lights[i].dir.x, lights[i].dir.y, lights[i].dir.z);

        local = "lights[" + os.str() + "].color";

        glUniform3f(glGetUniformLocation(shaderId, local.c_str()), lights[i].color.x, lights[i].color.y, lights[i].color.z);

        local = "lights[" + os.str() + "].distMax";

        glUniform1f(glGetUniformLocation(shaderId, local.c_str()), lights[i].distMax);

        local = "lights[" + os.str() + "].angle";

        glUniform1f(glGetUniformLocation(shaderId, local.c_str()), lights[i].angle);

        local = "lights[" + os.str() + "].intensity";

        glUniform1f(glGetUniformLocation(shaderId, local.c_str()), lights[i].intensity);

        local = "lights[" + os.str() + "].ambient";

        glUniform1f(glGetUniformLocation(shaderId, local.c_str()), lights[i].ambient);

        local = "lights[" + os.str() + "].type";

        glUniform1i(glGetUniformLocation(shaderId, local.c_str()), lights[i].type);

        local = "lights[" + os.str() + "].on";

        glUniform1i(glGetUniformLocation(shaderId, local.c_str()), lights[i].on);
    }

    glUniform1i(glGetUniformLocation(shaderId, "nbLights"), lights.size());
}

void Lights::setLight(const Light light, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index] = light;
}

void Lights::setDir(const glm::vec3 dir, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].dir = dir;
}

void Lights::setPos(const glm::vec3 pos, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].pos = pos;
}

void Lights::setColor(const glm::vec3 color, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].color = color;
}

void Lights::setDistMax(const float distMax, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].distMax = distMax;
}

void Lights::setAngle(const float angle, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].angle = angle;
}

void Lights::setIntensity(const float intensity, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].intensity = intensity;
}

void Lights::setType(const LightType type, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].type = type;
}

void Lights::setOn(const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].on = true;
}

void Lights::setOff(const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].on = false;
}

bool Lights::getOn(const size_t index)
{
    if(index >= lights.size())
    {
        return false;
    }

    return lights[index].on;
}

LightType Lights::getType(const size_t index)
{
    if(index >= lights.size())
    {
        return LIGHT_UNDEFINED;
    }

    return lights[index].type;
}

std::vector<Light> Lights::getLights()
{
    return lights;
}

float Lights::getAmbient(const size_t index)
{
    if(index >= lights.size())
    {
        return 0;
    }

    return lights[index].ambient;
}

std::string Lights::getName(const size_t index)
{
    if(index >= lights.size())
    {
        return "";
    }

    return lights[index].name;
}

void Lights::setAmbient(const float ambient, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index].ambient = ambient;
}
