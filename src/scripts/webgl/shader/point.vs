attribute vec3 position;

uniform float uTime;

varying float vY;

const float PI = acos(-1.0);

#include './modules/noise.glsl';

float x1(float t) {
  return snoise(sin(t + PI * 0.50) * 1.5, sin(t + PI * 0.15));
}

float y1(float t) {
  return snoise(sin(t - PI * 0.75) + t, sin(t + PI * 1.00) - t);
}

float x2(float t) {
  return snoise(sin(t + PI * 0.75), sin(t + PI * 0.25));
}

float y2(float t) {
  return snoise(sin(t + PI * 1.00), sin(t + PI * 0.50));
}

float parabola(float x, float k) {
  return pow(4. * x * (1. - x), k);
}

void main() {
  vec3 pos = position;
  float time = uTime * 0.7;
  float delay = 3.0;

  vec2 p1 = vec2(x1(time - delay * pos.x + pos.y), y1(time - delay * pos.x - pos.y));
  vec2 p2 = vec2(x2(-time - delay * (1.0 - pos.x) + pos.y), y2(-time - delay * (1.0 - pos.x) - pos.y * 2.0));

  float scale = parabola(pos.x, 3.0);

  p1 *= scale;
  p1.x -= 1.1;

  p2 *= scale * 0.5;
  p2.x += 1.1;

  pos.xy = mix(p1, p2, pos.x);
  pos.xy *= 0.7;

  pos.y += (position.y - 0.5) * scale * 0.2;

  vY = position.y;

  gl_Position = vec4(pos, 1.0);
  gl_PointSize = 5.0;
}