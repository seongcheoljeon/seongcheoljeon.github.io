---
layout: about
icon: fas fa-info-circle
order: 6
# 터미널 출력 내용 — _layouts/about.html이 이 리스트를 그대로 렌더링한다.
# type: prompt(명령 타이핑) | output(출력 한 줄) | blank(빈 줄)
# html: 출력 줄의 마크업 (t-value/t-key/t-tag/t-sep 클래스는 레이아웃 CSS 참조)
terminal:
  - { type: prompt, cmd: whoami }
  - { type: output, html: '<span class="t-value">Seongcheol Jeon</span>' }
  - { type: blank }

  - { type: prompt, cmd: cat profile.json }
  - { type: output, html: '<span class="t-sep">{</span>' }
  - type: output
    cls: indent
    html: '<span class="t-key indent">  "role"</span><span class="t-sep">: </span><span class="t-tag">"Graphics Programmer"</span><span class="t-sep">,</span>'
  - type: output
    cls: indent
    html: '<span class="t-key indent">  "engine"</span><span class="t-sep">: </span><span class="t-tag">"Unreal Engine"</span><span class="t-sep">,</span>'
  - type: output
    cls: indent
    html: '<span class="t-key indent">  "focus"</span><span class="t-sep">: </span><span class="t-tag">"Rendering Pipeline, RDG, Custom Shader"</span>'
  - { type: output, html: '<span class="t-sep">}</span>' }
  - { type: blank }

  - { type: prompt, cmd: cat skills.txt }
  - { type: output, html: '<span class="t-value">Vulkan</span>' }
  - { type: output, html: '<span class="t-value">OpenGL</span>' }
  - { type: output, html: '<span class="t-value">DirectX</span>' }
  - { type: output, html: '<span class="t-value">Unreal Engine (RDG, SceneViewExtension)</span>' }
  - { type: output, html: '<span class="t-value">GLSL / HLSL</span>' }
  - { type: output, html: '<span class="t-value">Houdini / PCG</span>' }
  - { type: blank }

  - { type: prompt, cmd: cat interests.txt }
  - { type: output, html: '<span class="t-tag">▸</span> <span class="t-value">Real-Time Rendering</span>' }
  - { type: output, html: '<span class="t-tag">▸</span> <span class="t-value">Ray Tracing</span>' }
  - { type: output, html: '<span class="t-tag">▸</span> <span class="t-value">Path Tracing</span>' }
  - { type: output, html: '<span class="t-tag">▸</span> <span class="t-value">BVH Algorithm</span>' }
  - { type: output, html: '<span class="t-tag">▸</span> <span class="t-value">GPGPU</span>' }
  - { type: output, html: '<span class="t-tag">▸</span> <span class="t-value">Procedural Generation</span>' }
  - { type: output, html: '<span class="t-tag">▸</span> <span class="t-value">Physics Simulation</span>' }
  - { type: blank }

  - { type: prompt, cmd: cat contact.txt }
  - type: output
    html: '<span class="t-key">GitHub</span>  <span class="t-sep">→</span>  <a href="https://github.com/seongcheoljeon" target="_blank" style="color:#8ab4f8;">github.com/seongcheoljeon</a>'
  - type: output
    html: '<span class="t-key">Email</span>   <span class="t-sep">→</span>  <span class="t-value">seongcheoljeon@icloud.com</span>'
  - { type: blank }

  # 마지막 프롬프트 + 커서
  - { type: prompt, cmd: '' }
---
