#include <stdio.h>
#include <string>
#include <vector>
#include <iostream>
#include "../glm/glm.hpp"
#include "../glm/gtx/transform.hpp"
#include "../glm/gtc/type_ptr.hpp"

enum LightType
{
    LIGHT_POINT,
    LIGHT_SUN,
    LIGHT_DIR,
    LIGHT_PROJ,
    LIGHT_UNDEFINED,
};

enum LightEffect
{
    LIGHT_EFFECT_DEF,
    LIGHT_EFFECT_BEACON,
    LIGHT_EFFECT_BLINK,
};

struct Light
{
    glm::vec3 pos;
    glm::vec3 dir;
    glm::vec3 color;
    float distMax;
    float angle;
    float intensity;
    float ambient;
    LightType type;
    bool on = true;
    std::string name;
};

struct Shadow
{
    GLuint tex = 0;
    GLuint fbo = 0;
    unsigned int size = 1024;
    glm::mat4 matrixProj;
    glm::mat4 matrixView;
    bool active = false;
};

class Lights
{
    private :

    std::vector<Light> lights;
    Shadow shadow;

    public :

    void AddLight(Light light);
    void AddLightIfNotExists(Light light);
    void setLight(const Light light, const size_t index);
    Light* getLight(const size_t index);
    bool setLightByName(const Light light, const std::string name);
    void setDir(const glm::vec3 dir, const size_t index);
    void setPos(const glm::vec3 pos, const size_t index);
    void setColor(const glm::vec3 color, const size_t index);
    void setDistMax(const float distMax, const size_t index);
    void setAngle(const float angle, const size_t index);
    void setIntensity(const float intensity, const size_t index);
    void setType(const LightType type, const size_t index);
    LightType getType(const size_t index);
    void setOn(const size_t index);
    void setOff(const size_t index);
    bool getOn(const size_t index);
    std::string getName(const size_t index);
    float getAmbient(const size_t index);
    float getIntensity(const size_t index);
    void setAmbient(const float ambient, const size_t index);
    std::vector<Light> getLights();
    void SendToShader(GLuint shaderId, const int nbTex = -1);
    void Clear()
    {
        lights.clear();
    }
    size_t getSize()
    {
        return lights.size();
    }
    void InitShadow();

    Shadow *getShadow()
    {
        return &shadow;
    }
};
