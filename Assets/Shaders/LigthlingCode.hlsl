// include Guard

#ifndef CUSTOM_LIGHTING
#define CUSTOM_LIGHTING 


//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"


void MainLight_float(float3 PositionWS, out float3 Direction, out float3 Color, out float ShadowAttenuation)
{
    #ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(1,1,-1));
    Color = 1.0f;
    ShadowAttenuation =  1.0f; 
    #else 
    float4 shadowCoord = TransformWorldToShadowCoord(PositionWS);
    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    ShadowAttenuation = mainLight.shadowAttenuation;
    #endif 
}

void AdditionalLightSimple_float (float2 UVSS, float3 PositionWS, float3 ViewDirectionWS,  float3 NormalWS, out float3 Lit)
{  
    #ifdef SHADERGRAPH_PREVIEW
    Lit = 0;
    #else
    uint addtionalLightCount = GetAdditionalLightsCount();

    #ifdef USE_FORWARD_PLUS
    InputData inputData = (InputData)0;
    inputData.normalizedScreenSpaceUV = UVSS;
    inputData.positionWS = PositionWS; 
    #endif 

    LIGHT_LOOP_BEGIN(addtionalLightCount)
    Light currentLight = GetAdditionalLight(lightIndex, PositionWS);

    //Diffuse

    float lambert = dot(currentLight.direction, NormalWS);
    lambert = max (0, lambert * 0.5f + 0.5f); // Half Lambert
    float3 diffuse = lambert
    * currentLight.color
    * currentLight.shadowAttenuation
    * currentLight.distanceAttenuation;

    //Specular


    float3 h = normalize(ViewDirectionWS + currentLight.direction);
    float blinnPhong = dot(h, NormalWS);
    blinnPhong = max(0, blinnPhong);
    blinnPhong = pow(blinnPhong, 60.0f);
    float3 specular = blinnPhong
    * currentLight.color
    * currentLight.shadowAttenuation
    * currentLight.distanceAttenuation;

    Lit += diffuse + specular;
    LIGHT_LOOP_END

    #endif

}

#endif
