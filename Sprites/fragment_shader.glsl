uniform sampler2D texture;
varying highp vec2 texCoordInterpolated;
varying highp vec4 colorInterpolated;

void main() {
    /*gl_FragColor = texCoordInterpolated;*/
    gl_FragColor = texture2D(texture, texCoordInterpolated);
}
