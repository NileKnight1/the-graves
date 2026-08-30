shader_type canvas_item;

uniform float threshold : hint_range(0.0, 1.0) = 0.05;
uniform float softness : hint_range(0.0, 0.5) = 0.05;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    float brightness = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    
    float alpha = smoothstep(threshold, threshold + softness, brightness);
    COLOR = vec4(col.rgb, col.a * alpha);
}