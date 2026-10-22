# Conventions
- Feature-first Clean Architecture/MVVM; widgets render state, Riverpod Notifier/ViewModel owns behavior, repositories/data sources own data.
- Immutable strongly typed state; explicit errors; no hardcoded exercise/routine IDs in UI.
- Design tokens follow Primitive -> Semantic -> Component; no widget hardcoded colors/spacing/type.
- Accessibility: >=48dp targets, >=4.5:1 contrast, 200% text scale, Vietnamese semantics, small-phone and responsive tests.
- Content entities (Exercise/Routine/MediaAsset) remain independent and catalog-driven; status/review gates are enforced.
- Media safety: decorative/reference art is never instructional. Keep draft/demoOnly until expert technique review, rights review, and synchronized final media exist.
- Important stable pitfalls are in LEARNINGS.md; do not duplicate task-local details into Serena memories.