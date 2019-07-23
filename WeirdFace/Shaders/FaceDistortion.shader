/*
<samplecode>
<abstract>
SceneKit shader (geometry) modifier for texture mapping ARKit camera video onto the face.
</abstract>
</samplecode>
*/

#pragma arguments
float4x4 displayTransform // from ARFrame.displayTransform(for:viewportSize:)
float eyeSize = 1.0;
float noseSize = 1.0;
float mouthSize = 1.0;
float headSize = 1.0;
float xPos = 1.0;
float yPos = 1.0;
float zPos = 1.0;

#pragma body

// Transform the vertex to the camera coordinate system.
float4 vertexCamera = scn_node.modelViewTransform * _geometry.position;

// Camera projection and perspective divide to get normalized viewport coordinates (clip space).
float4 vertexClipSpace = scn_frame.projectionTransform * vertexCamera;
vertexClipSpace /= vertexClipSpace.w;

// XY in clip space is [-1,1]x[-1,1], so adjust to UV texture coordinates: [0,1]x[0,1].
// Image coordinates are Y-flipped (upper-left origin).
float4 vertexImageSpace = float4(vertexClipSpace.xy * 0.5 + 0.5, 0.0, 1.0);
vertexImageSpace.y = 1.0 - vertexImageSpace.y;

// Apply ARKit's display transform (device orientation * front-facing camera flip).
float4 transformedVertex = displayTransform * vertexImageSpace;

// Output as texture coordinates for use in later rendering stages.
_geometry.texcoords[0] = transformedVertex.xy;

/**
* MARK: Post-process special effects
*/

//MODIFICATIONS TO FACE - POST-PROCESSING
// Make head appear big. (You could also apply other geometry modifications here.)

/*
if (_geometry.position.y > 0.02) {
_geometry.position.x += 0.05;
}
*/

// (LEFT EYE)
if (_geometry.position.x < -0.01 && _geometry.position.x > -0.06 && _geometry.position.y > 0.01 && _geometry.position.y < 0.06 && _geometry.position.z > 0.015) {
_geometry.position.xy *= eyeSize;
}

// (RIGHT EYE)
if (_geometry.position.x > 0.01 && _geometry.position.x < 0.06 && _geometry.position.y > 0.01 && _geometry.position.y < 0.06 && _geometry.position.z > 0.015) {
_geometry.position.xy *= eyeSize;
}

// (NOSE)
if ((_geometry.position.x > -0.03 && _geometry.position.x < 0.03 && _geometry.position.y > -0.02 && _geometry.position.y < 0.04 && _geometry.position.z > 0.053)) {
_geometry.position.xy *= noseSize;
}

// (MOUTH)
if (( _geometry.position.y < -0.03 && _geometry.position.z > 0.01)) {
_geometry.position.xy *= mouthSize;
}

// (HEAD)
_geometry.position.xyz *= headSize;

// (HEAD POSITION)
_geometry.position.x += xPos/10;
_geometry.position.y += yPos/10;
_geometry.position.z += zPos/10;
