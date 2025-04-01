**ADR: Use Flutter + FlutterFlow for UI Development**

**Status:** Accepted  
**Date:** 2025-03-26  
**Author:** Vishwapriyaj

---

### Context
We aim to deliver a visual-first, cross-platform user interface for recruiters and internal users, while also enabling quick prototyping and customizable workflows. Flutter provides a performant, pixel-perfect UI layer, and FlutterFlow accelerates development with visual tooling.

### Alternatives
- React + TypeScript (web-only)
- Native Android/iOS development
- Flutter + FlutterFlow

### PrOACT
- **Problem:** Need for fast, flexible UI development across platforms with minimal duplication
- **Objectives:** Consistent cross-platform experience, low-code capabilities for rapid iteration, option to dive into code when needed
- **Alternatives:** Web-only frameworks, native apps, hybrid with Flutter
- **Consequences:** Developers need to be familiar with Dart and FlutterFlow limitations
- **Tradeoffs:** Initial ramp-up vs. speed of delivery and unified experience

### Decision
Use **Flutter** for building cross-platform UI components and extend it with **FlutterFlow** for rapid prototyping and visual-first workflows. This allows both engineering and product/design teams to iterate quickly while maintaining code extensibility.

### Tradeoffs - Mitigations
- **FlutterFlow Limitations**: Fall back to Flutter/Dart code for complex use cases
- **Learning Curve**: Cross-functional training and documentation