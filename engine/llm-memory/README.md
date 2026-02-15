# LLM Memory

Rails engine that collects facts from multiple sources and applies medallion architecture processing to produce refined inputs for engine/lifecycle.

## Sources

- **llm-state** — LLM request/response history
- **Rails log files** — Application-level events and errors
- **OpenTelemetry event streams** — Distributed traces, metrics, and spans
- **Other sources** — Any additional event or fact streams available in the ecosystem

## Medallion Processing

LLM Memory applies a three-tier medallion architecture to progressively refine raw facts into actionable lifecycle inputs:

| Tier | Role |
|------|------|
| **Bronze** | Raw ingestion — captures facts as-is from all sources with minimal transformation, preserving original fidelity |
| **Silver** | Cleansed and correlated — deduplicates, normalizes timestamps, correlates facts across sources, resolves entities |
| **Gold** | Refined and actionable — aggregated insights, detected patterns, and scored events ready for lifecycle consumption |

## Lifecycle Integration

Gold-tier outputs are published to engine/lifecycle via biological-IT, providing lifecycle with enriched temporal inputs for ecosystem-wide oversight and decision-making.

## Ecosystem Oversight

LLM Memory provides ecosystem-wide observability by collecting and refining facts from across the entire ecosystem. Any engine or service can query LLM Memory to understand what has happened, what is happening, and what patterns are emerging.

## Biological-IT Integration

All linkages between llm-memory and other components use biological-IT (service-biological-it). Communication is by value through the MessageModerator, never by direct calls. LLM Memory exposes the standard 6-method Bindable interface: create, read, update, delete, list, execute.
