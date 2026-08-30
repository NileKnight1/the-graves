shader_type canvas_item;

uniform vec3 key_color : source_color = vec3(0.0, 1.0, 0.0);
uniform float threshold : hint_range(0.0, 1.0) = 0.3;
uniform float softness : hint_range(0.0, 0.5) = 0.1;

void fragment() {
    vec4 col = texture(TEXTURE, UV);

    float distance_to_green = distance(col.rgb, key_color);

    float alpha = smoothstep(threshold, threshold + softness, distance_to_green);

    COLOR = vec4(col.rgb, col.a * alpha);
}