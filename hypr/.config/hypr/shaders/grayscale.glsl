#version 300 es
precision mediump float;

// 'in' is the modern replacement for 'varying'
in vec2 v_texcoord;

uniform sampler2D tex;

// 'out' is the modern replacement for 'gl_FragColor'
out vec4 fragColor;

void main() {
    // 'texture' is the modern replacement for 'texture2D'
    vec4 color = texture(tex, v_texcoord);

    // The luminance logic remains the same
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    fragColor = vec4(vec3(luminance), color.a);
}
