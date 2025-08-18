// License: MIT
shader_type canvas_item;

// BOUNCE
uniform float y_scale : hint_range(0.2, 1.0, 0.01) = 1.0;


// WOBBLE
uniform float fov : hint_range(1, 179) = 90;
uniform bool cull_back = true;
uniform float y_rot : hint_range(-180, 180) = 0.0;
uniform float x_rot : hint_range(-180, 180) = 0.0;
uniform float inset : hint_range(0, 1) = 0.0;
varying flat vec2 o;
varying vec3 p;


// SPIN
uniform float zDegrees: hint_range(0, 360);


float degToRad(float angle) {
	return angle * PI / 180.0;
}

// Creates rotation matrix
void vertex(){
	// WOBBLE
	float sin_b = sin(y_rot / 180.0 * PI);
	float cos_b = cos(y_rot / 180.0 * PI);
	float sin_c = sin(x_rot / 180.0 * PI);
	float cos_c = cos(x_rot / 180.0 * PI);

	mat3 inv_rot_mat;
	inv_rot_mat[0][0] = cos_b;
	inv_rot_mat[0][1] = 0.0;
	inv_rot_mat[0][2] = -sin_b;

	inv_rot_mat[1][0] = sin_b * sin_c;
	inv_rot_mat[1][1] = cos_c;
	inv_rot_mat[1][2] = cos_b * sin_c;

	inv_rot_mat[2][0] = sin_b * cos_c;
	inv_rot_mat[2][1] = -sin_c;
	inv_rot_mat[2][2] = cos_b * cos_c;

	float t = tan(fov / 360.0 * PI);
	p = inv_rot_mat * vec3((UV - 0.5), 0.5 / t);
	float v = (0.5 / t) + 0.5;
	p.xy *= v * inv_rot_mat[2].z;
	o = v * inv_rot_mat[2].xy;
	VERTEX += (UV - 0.5) / TEXTURE_PIXEL_SIZE * t * (1.0 - inset);


	// SPIN
	float radX = degToRad(x_rot);
	float radY = degToRad(y_rot);
	float radZ = degToRad(zDegrees);

	float cosX = cos(radX);
	float cosY = cos(radY);
	float cosZ = cos(radZ);

	float sinX = sin(radX);
	float sinY = sin(radY);
	float sinZ = sin(radZ);

	mat3 finalRot;
	finalRot[0][0] = cosZ * cosY;
	finalRot[1][0] = cosZ * sinY * sinX - sinZ * cosX;
	finalRot[2][0] = sinZ * sinX + cosZ * sinY * cosX;

	finalRot[0][1] = sinZ * cosY;
	finalRot[1][1] = cosZ * cosX + sinZ * sinY * sinX;
	finalRot[2][1] = sinZ * sinY * cosX - cosZ * sinX;

	finalRot[0][2] = -sinY;
	finalRot[1][2] = cosY * sinX;
	finalRot[2][2] = cosY * cosX;

	vec3 pos = vec3(VERTEX.xy, 0) * finalRot;
	VERTEX = pos.xy;
}

void fragment() {
	// WOBBLE
	if (cull_back && p.z <= 0.0) discard;
	vec2 uv = (p.xy / p.z).xy - o;

	// BOUNCE
	uv.y = (uv.y - 0.5) / y_scale + 0.5;

	COLOR = texture(TEXTURE, uv + 0.5);
	COLOR.a *= step(max(abs(uv.x), abs(uv.y)), 0.5);
}
