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

void Lights::SendToShader(GLuint shaderId, const int nbTex)
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

    /////////////////////////////////////////////////////////////////////////////////////

    if(nbTex != -1)
    {
        std::string local = "projectShadow";

        glUniformMatrix4fv(glGetUniformLocation(shaderId, local.c_str()), 1, false, glm::value_ptr(shadow.matrixProj));

        local = "viewShadow";

        glUniformMatrix4fv(glGetUniformLocation(shaderId, local.c_str()), 1, false, glm::value_ptr(shadow.matrixView));

        local = "sizeShadow";

        glUniform1i(glGetUniformLocation(shaderId, local.c_str()), shadow.size);

        glActiveTexture(GL_TEXTURE0 + nbTex);
        glBindTexture(GL_TEXTURE_2D, shadow.tex);

        local = "shadowMap";

        glUniform1i(glGetUniformLocation(shaderId, local.c_str()), nbTex);

        local = "active";

        glUniform1i(glGetUniformLocation(shaderId, local.c_str()), shadow.active);
    }
}

void Lights::setLight(const Light light, const size_t index)
{
    if(index >= lights.size())
    {
        return;
    }

    lights[index] = light;
}

bool Lights::setLightByName(const Light light, const std::string name)
{
    for(size_t i=0; i<lights.size(); i++)
    {
        if(lights[i].name == name)
        {
            lights[i] = light;
            return true;
        }
    }

    return false;
}

void Lights::AddLightIfNotExists(Light light)
{
    for(size_t i=0; i<lights.size(); i++)
    {
        if(lights[i].name == light.name)
        {
            lights[i] = light;
            return;
        }
    }

    lights.push_back(light);
}

Light* Lights::getLight(const size_t index)
{
    if(index >= lights.size())
    {
        return nullptr;
    }

    return &lights[index];
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

float Lights::getIntensity(const size_t index)
{
    if(index >= lights.size())
    {
        return 0;
    }

    return lights[index].intensity;
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

void Lights::InitShadow()
{
    glGenFramebuffers(1, &shadow.fbo);

    // Créer la texture qui stockera les profondeurs
    glGenTextures(1, &shadow.tex);
    glBindTexture(GL_TEXTURE_2D, shadow.tex);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, shadow.size, shadow.size, 0, GL_DEPTH_COMPONENT, GL_FLOAT, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_BORDER);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_BORDER);
    float borderColor[] = {1.0, 1.0, 1.0, 1.0};
    glTexParameterfv(GL_TEXTURE_2D, GL_TEXTURE_BORDER_COLOR, borderColor);

    // Attacher la texture au framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, shadow.fbo);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, shadow.tex, 0);
    glDrawBuffer(GL_NONE); // On n'a pas besoin de color buffer
    glReadBuffer(GL_NONE);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    shadow.active = true;
}
