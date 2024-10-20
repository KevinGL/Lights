#include "../Mini-libs/lights/lights.h"

int main(void)
{
    Lights lights;

    Light sun;

    sun.color = glm::vec3(1.0f, 1.0f, 1.0f);
    sun.name = "sun";
    sun.type = LIGHT_SUN;
    sun.intensity = 1.0f;
    sun.dir = glm::vec3(0.0f, 1.0f, -1.0f);
    sun.ambient = 1.0f;

    lights.AddLight(sun);       //Add a light as sun

    lights.InitShadow();        //If you want shadows

    while(1)
    {
        //1st draw

        glViewport(0, 0, lights.getShadow()->size, lights.getShadow()->size);
        glBindFramebuffer(GL_FRAMEBUFFER, lights.getShadow()->fbo);

        const glm::vec3 toLight = //to the sun, fix a distance
        const glm::vec3 posLight = posOfYourCam + toLight;

        const float frustumSize = 60.0f;

        matProj = glm::ortho(-frustumSize / 2, frustumSize / 2, -frustumSize / 2, frustumSize / 2, 1.0f, frustumSize);
        matView = glm::lookAt(posLight, posOfYourCam, glm::vec3(0.0f, 0.0f, 1.0f));

        lights->getShadow()->matrixProj = matProj;
        lights->getShadow()->matrixView = matView;

        glClear(GL_DEPTH_BUFFER_BIT);

        //////////////////////

        //2nd draw

        glViewport(0, 0, w, h);
        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        glUseProgram(yourShader);

        lights.SendToShader(yourShader, 30)       //Second param is id of shadow map

        //Scene...
    }

    return 0;
}
