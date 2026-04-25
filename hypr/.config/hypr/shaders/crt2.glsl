// Uniforms (Tweaking knobs, Sir)
uniform sampler2D u_texture; // Your screen/image
uniform vec2 u_resolution;   // Screen resolution
uniform float u_time;        // Time (for moving scanlines)

// CONFIGURATION ---------------------------
// 1. DISPERSION (Color splitting)
#define ABERRATION_OFFSET 0.003  // How far the RGB channels split. 

// 2. SCANLINES
#define SCANLINE_INTENSITY 0.25  // How dark the lines are (0.0 to 1.0)
#define SCANLINE_COUNT 800.0     // Number of horizontal lines

// 3. VIGNETTE (Corner Shadows)
#define VIGNETTE_INTENSITY 0.5   // Darkness of corners
#define VIGNETTE_ROUNDNESS 0.25  // How circular the shadow is
// -----------------------------------------

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    
    // --- STEP 1: CHROMATIC ABERRATION (Dispersion) ---
    // We sample the Red, Green, and Blue channels at slightly different coordinates.
    // This mimics the electron guns being slightly misaligned at the edges.
    
    float r = texture(u_texture, uv + vec2(ABERRATION_OFFSET, 0.0)).r;
    float g = texture(u_texture, uv).g; // Green stays center
    float b = texture(u_texture, uv - vec2(ABERRATION_OFFSET, 0.0)).b;
    
    vec3 color = vec3(r, g, b);

    // --- STEP 2: SCANLINES ---
    // We use a sine wave based on the Y coordinate to create alternating dark bands.
    // Adding u_time makes them slowly crawl or jitter if desired, here it's static for stability.
    
    float scanline = sin(uv.y * SCANLINE_COUNT * 3.14159);
    // Convert sine wave (-1 to 1) to a darkening factor (1.0 to 1.0 - INTENSITY)
    float scanline_effect = 1.0 - (SCANLINE_INTENSITY * (0.5 * scanline + 0.5));
    
    color *= scanline_effect;

    // --- STEP 3: VIGNETTE (Corner Shadows) ---
    // We calculate the distance from the center of the screen (0.5, 0.5).
    
    vec2 position = uv - 0.5;
    float len = length(position);
    
    // Smoothstep creates a soft gradient for the shadow
    float vignette = smoothstep(0.7, 0.7 - VIGNETTE_ROUNDNESS, len);
    
    // Apply Vignette (Darken the color)
    color *= (1.0 - VIGNETTE_INTENSITY) + (vignette * VIGNETTE_INTENSITY);

    // Output final color
    gl_FragColor = vec4(color, 1.0);
}
