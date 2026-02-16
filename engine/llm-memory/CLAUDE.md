# LLM Memory Engine — Agent Context

## What This Is

Rails engine that collects facts from llm-state, Rails log files, OpenTelemetry event streams, and other sources. Applies medallion processing (bronze/silver/gold) to produce refined inputs for engine/lifecycle.

Encapsulated by `top/service/container/service-llm/`.

## Table Prefix

All tables use the `lm_` prefix (e.g., `lm_bronze_facts`, `lm_silver_facts`, `lm_gold_insights`).

## Medallion Tiers

- **Bronze** — Raw fact ingestion from source collectors
- **Silver** — Correlated and normalized facts
- **Gold** — Refined insights with scoring, published to lifecycle

## Source Types

- `llm_state` — LLM request/response traffic from llm-state engine
- `rails_log` — Parsed Rails log entries
- `open_telemetry` — OpenTelemetry event stream data

## Biological-IT Integration

Communication through MessageModerator via LlmMemoryBindable (6-method Bindable interface). ServiceNode subclass registers the bindable for message routing.

## Key Files

- `lib/llm_memory/collectors/` — Source-specific data collectors
- `lib/llm_memory/processors/` — Medallion tier processors (bronze → silver → gold)
- `lib/llm_memory/bindables/llm_memory_bindable.rb` — 6-method Bindable
- `lib/llm_memory/node.rb` — ServiceNode subclass
- `app/controllers/llm_memory/api/v1/` — JSON API endpoints
