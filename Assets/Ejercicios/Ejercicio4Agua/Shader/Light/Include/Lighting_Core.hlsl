#ifndef LIGHTING_CORE
#define LIGHTING_CORE

void GetMainLight_float(float3 positionWS, out float3 directionWS, out float3 color, out float shadowAttenuation) //float - decimal 32 bits,  Half - 16 bits, fixed - 12 bits
{
    #if defined (SHADERGRAPH_PREVIEW)
    directionWS = float3(1, 1, -1);
    color = 1;
    shadowAttenuation = 1;
    #else 
    float4 shadowCoord = TransformWorldToShadowCoord(positionWS);
    Light mainLight = GetMainLight(shadowCoord);
    
    directionWS = mainLight.direction;
    color = mainLight.color;
    shadowAttenuation = mainLight.shadowAttenuation;
    #endif

}

void SimpleLightingAdditional_float(float3 positionWS, float2 uvSS, float3 normalWS, float3 viewDirWS, out float3 lit)
{
    #if defined(SHADERGRAPH_PREVIEW)
    lit =0;   
    #else
    uint additionalLightCount = GetAdditionalLightsCount();
    
    #ifdef USE_FORWARD_PLUS
    InputData inputData = (InputData)0;
    InputData.normalizedScreenSpaceUV = uvSS;
    InputData.normalWS = normalWS;
    InputData.positionWS = positionWS;
    #endif
    
    LIGHT_LOOP_BEGIN(additionalLightCount)

    Light light = GetAdditionalLight(lightIndex, positionWS, 1);
    
    float lambert = max(dot(normalWS, light.direction), 0); //Lambert
    float3 halfwayVector = normalize(light.direction + viewDirWS);
    float blinnPhong = max(dot(halfwayVector, normalWS), 0); //Blinn-Phong
    
    float3 diffuse = lambert * light.distanceAttenuation * light.color;
    float3 specular = blinnPhong * light.distanceAttenuation * light.color;
    
    
    lit += (diffuse + specular) * light.shadowAttenuation;
    
    LIGHT_LOOP_END
    
    #endif
}

void BlinnPhongAdditional_float(float3 positionWS, float2 uvSS, float3 normalWS, float3 viewDirWS, out float3 lit)
{
    #if defined(SHADERGRAPH_PREVIEW)
    lit =0;   
    #else
    uint additionalLightCount = GetAdditionalLightsCount();
    
    #ifdef USE_FORWARD_PLUS
    InputData inputData = (InputData)0;
    InputData.normalizedScreenSpaceUV = uvSS;
    InputData.normalWS = normalWS;
    InputData.positionWS = positionWS;
    #endif
    
    LIGHT_LOOP_BEGIN(additionalLightCount)

    Light light = GetAdditionalLight(lightIndex, positionWS, 1);
    
    float3 halfwayVector = normalize(light.direction + viewDirWS);
    float blinnPhong = max(dot(halfwayVector, normalWS), 0); //Blinn-Phong
    
    float3 specular = pow(blinnPhong, 500) * light.distanceAttenuation * light.color;
    
    
    lit += specular * light.shadowAttenuation;
    
    LIGHT_LOOP_END
    
    #endif
}

#endif
