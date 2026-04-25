#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// ============================================================
//  CRT SHADER — Dramatic, punchy, faithful brightness
//  S-curve contrast, spatial bloom, no curvature
//  7 texture reads, no time uniforms, single pass
// ============================================================

// --- Tunables -----------------------------------------------

// Contrast S-curve blend (0.0 = off, 1.0 = full smoothstep)
const float CONTRAST_MIX   = 0.45;

// Scanlines
const float SCAN_STRENGTH  = 0.22;
const float SCAN_SHARPNESS = 0.60;

// Shadow mask (Trinitron aperture-grille)
const float MASK_STRENGTH  = 0.10;

// Chromatic aberration
const float ABERR          = 0.0018;

// Bloom — spatial glow from bright areas
const float BLOOM_AMOUNT   = 0.55;
const float BLOOM_THRESH   = 0.35;
const float BLOOM_RADIUS   = 6.0;

// Brightness boost (compensates scanline + mask darkening)
const float BRIGHT_BOOST   = 1.12;

// Phosphor grain
const float GRAIN          = 0.028;

// Vignette
const float VIGNETTE       = 0.08;

// ============================================================

float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void main() {
    vec2 uv = v_texcoord;
    ivec2 texSz = textureSize(tex, 0);
    vec2 res = vec2(texSz);
    vec2 px = uv * res;
    vec2 fromCenter = uv - 0.5;

    // ----------------------------------------------------------
    //  1. CHROMATIC ABERRATION — edge-weighted RGB gun misalign
    // ----------------------------------------------------------
    vec2 aberr = fromCenter * ABERR;

    float r = texture(tex, clamp(uv + aberr, 0.0, 1.0)).r;
    vec4 cen = texture(tex, uv);
    float g = cen.g;
    float alpha = cen.a;
    float b = texture(tex, clamp(uv - aberr, 0.0, 1.0)).b;

    vec3 color = vec3(r, g, b);

    // ----------------------------------------------------------
    //  2. CONTRAST — S-curve (smoothstep polynomial)
    //     Darkens darks, brightens brights, midtones ~unchanged
    //     Blended to control intensity
    // ----------------------------------------------------------
    vec3 curved = color * color * (3.0 - 2.0 * color);
    color = mix(color, curved, CONTRAST_MIX);

    // ----------------------------------------------------------
    //  3. BRIGHTNESS BOOST — compensate for scanline + mask loss
    // ----------------------------------------------------------
    color *= BRIGHT_BOOST;

    // ----------------------------------------------------------
    //  4. SCANLINES — brightness-adaptive beam spot
    //     Bright = wider beam = weaker scanlines (authentic CRT)
    //     Dark = narrow beam = stronger scanlines
    // ----------------------------------------------------------
    float luma = dot(color, vec3(0.299, 0.587, 0.114));

    float scan = sin(mod(px.y, 2.0) * 3.14159265);
    scan = pow(abs(scan), mix(SCAN_SHARPNESS, 2.5, luma));
    float scanMul = 1.0 - SCAN_STRENGTH * scan * (1.0 - 0.55 * luma);
    color *= scanMul;

    // ----------------------------------------------------------
    //  5. SHADOW MASK — Trinitron vertical RGB stripes (branchless)
    // ----------------------------------------------------------
    float maskPos = mod(px.x, 3.0);
    float isR = step(maskPos, 0.999);
    float isG = step(1.0, maskPos) * step(maskPos, 1.999);
    float isB = step(2.0, maskPos);
    vec3 mask = vec3(
        1.0 - MASK_STRENGTH * (1.0 - isR),
        1.0 - MASK_STRENGTH * (1.0 - isG),
        1.0 - MASK_STRENGTH * (1.0 - isB)
    );
    color *= mask;

    // ----------------------------------------------------------
    //  6. BLOOM — real spatial glow, 4-tap cross sample
    //     Bright areas bleed light into surroundings
    //     Sampled at large radius for wide, soft glow
    // ----------------------------------------------------------
    vec2 bOff = BLOOM_RADIUS / res;

    vec3 bloomAcc  = texture(tex, clamp(uv + vec2(bOff.x, 0.0), 0.0, 1.0)).rgb;
    bloomAcc      += texture(tex, clamp(uv - vec2(bOff.x, 0.0), 0.0, 1.0)).rgb;
    bloomAcc      += texture(tex, clamp(uv + vec2(0.0, bOff.y), 0.0, 1.0)).rgb;
    bloomAcc      += texture(tex, clamp(uv - vec2(0.0, bOff.y), 0.0, 1.0)).rgb;
    bloomAcc *= 0.25;

    // S-curve the bloom samples too for consistent look
    vec3 bloomCurved = bloomAcc * bloomAcc * (3.0 - 2.0 * bloomAcc);
    bloomAcc = mix(bloomAcc, bloomCurved, CONTRAST_MIX);

    float bloomLuma = dot(bloomAcc, vec3(0.299, 0.587, 0.114));
    float bloomMask = smoothstep(BLOOM_THRESH, 1.0, bloomLuma);

    // Additive glow — only adds light, never darkens
    color += bloomAcc * bloomMask * BLOOM_AMOUNT;

    // ----------------------------------------------------------
    //  7. PHOSPHOR GRAIN — static sparkle, stronger in darks
    // ----------------------------------------------------------
    float noise = hash(px);
    noise = (noise - 0.5) * GRAIN * (1.0 - luma * 0.85);
    color += noise;

    // ----------------------------------------------------------
    //  8. VIGNETTE — subtle edge darkening
    // ----------------------------------------------------------
    float dist2 = dot(fromCenter, fromCenter);
    color *= 1.0 - dist2 * VIGNETTE * 4.0;

    // ----------------------------------------------------------
    //  9. OUTPUT — clamp and preserve alpha, no gamma mangling
    // ----------------------------------------------------------
    color = clamp(color, 0.0, 1.0);

    fragColor = vec4(color, alpha);
}
