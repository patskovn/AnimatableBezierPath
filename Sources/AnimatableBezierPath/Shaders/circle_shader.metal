//
//  circle_shader.metal
//  ios_metal_bezier_renderer
//
//  Created by Nikita Patskov on 05/11/2022.
//  Copyright © 2022 Eldad Eilam. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>

#import "../../_BezierCHeaders/include/RendererTypes.h"

using namespace metal;

struct VertexOut {
    vector_float4 position [[position]];
    vector_float4 color;
};

#define M_PI 3.1415926535897932384626433832795

float rads(float i){
    return (M_PI * i) / 180;
}

vertex VertexOut circle_vertex(constant CircleVertex *circles[[buffer(0)]],
                               uint vertexId[[vertex_id]],
                               uint instanceId[[instance_id]]) {
    
    CircleVertex circleVertex = circles[instanceId];
    VertexOut output;
    float i = vertexId;
    
    float branch = (vertexId + 1) % 2;
    
    output.position.x = circleVertex.center.x + branch * cos(rads(i/2)) * circleVertex.radius;
    output.position.y = circleVertex.center.y + branch * sin(rads(i/2)) * circleVertex.radius;
    
    output.position.zw = float2(0, 1);
    
    output.color = circleVertex.color;
    
    return output;
}

fragment float4 circle_fragment(VertexOut interpolated [[stage_in]]){
    return interpolated.color;
}
