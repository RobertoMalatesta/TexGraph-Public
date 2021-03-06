/*
 * @file    Polygon2D.comp.glsl
 * @author  David Gallardo Moreno
 */

#version 430
precision highp float;

#define M_PI 3.1415926535897932384626433832795
#define M_TWO_PI 6.28318530718

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(binding = 0, rgba8) uniform image2D uOutputBuffer0;
//layout(binding = 1, rgba8) uniform image2D uInputBuffer0;

layout(location = 0)  uniform int      uSides;
layout(location = 1)  uniform float    uFalloff;
layout(location = 2)  uniform float    uZoom;

void main(void)
{
    ivec2 lBufferCoord = ivec2(gl_GlobalInvocationID.xy);
    vec2 lImageSize = vec2(gl_NumWorkGroups.xy);
    //vec2 lUV = (vec2(lBufferCoord.xy) / vec2(gl_NumWorkGroups.xy));         
    vec2 st = (vec2(lBufferCoord.x, lBufferCoord.y) - 0.5f * lImageSize) / lImageSize;
    st *= uZoom;
    st.y -= (uSides == 3) ? 0.25f : 0.0f;
    float ata = atan(st.x, -st.y) + M_PI;
    float r = M_TWO_PI / float(uSides);
    float dist = cos(floor(.5f + ata / r) * r - ata) *length(st);
    float polygon = 1.0f - smoothstep(0.5f - uFalloff, .51f, dist);
    vec4 lOutputColor = vec4(vec3(polygon), 1.0);
    imageStore (uOutputBuffer0, lBufferCoord, lOutputColor);
}
