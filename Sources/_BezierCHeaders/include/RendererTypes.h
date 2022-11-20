// MIT License
//
// Copyright (c) 2016
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#ifndef RendererTypes_h
#define RendererTypes_h


#include <simd/simd.h>

struct GlobalParameters
{
    float lineWidth;
    uint elementsPerInstance;
    uint gradientStepsCount;
    uint vectorsCount;
    float filledPercent;
};



// BezierParameters represent a per-curve buffer specifying curve parameters. Note that
// even though the vertex shader is obviously called per-vertex, it actually uses the same
// BezierParameters instance (identified through the instance_id) for all vertexes in a given
// curve.
struct BezierParameters
{
    simd_float2 a;
    simd_float2 b;
    simd_float2 p1;
    simd_float2 p2;
};

struct CircleVertex
{
    simd_float2 center;
    simd_float4 color;
    float radius;
};

#endif /* RendererTypes_h */
