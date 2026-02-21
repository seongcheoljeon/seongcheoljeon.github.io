---
title: "[UE5/Rendering] Color Correct Regions 플러그인 심화"
description: >-
  Unreal Engine5 Rndering
series: "UnrealEngine Rendering - ColorCorrectRegions 플러그인 정복"
series_part: 2
author: seongcheol
date: 2026-02-22 02:30:00 +0900
categories: [Unreal Engine, Rendering]
tags: [Unreal Engine, Rendering]
pin: true
image:
  path: "/assets/img/common/title/ue_title.jpg"
mermaid: true
---

## [UE5] Color Correct Regions 플러그인 (2/5)

```mermaid
graph LR
  A[SceneRenderer] --> B[RDG Builder]
  B --> C[Depth Pass]
  B --> D[BasePass]
  D --> E[Lighting Pass]
```
