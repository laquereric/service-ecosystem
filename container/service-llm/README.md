# Service LLM

Container service that continuously operates as the LLM gateway for the ecosystems platform. Service LLM hosts and manages LLM provider connections, routing requests from any engine or service to the appropriate LLM provider and returning responses.

It wraps llm-service (the library) in a long-running container process, managing connection pooling, rate limiting, and provider failover.

## Encapsulated Engines

Service LLM encapsulates two engines:

- **llm-state** — Persists all LLM request/response traffic with full audit trail and queryable schema
- **llm-memory** — Collects facts from llm-state, Rails log files, OpenTelemetry event streams, and other sources, then applies medallion processing (bronze, silver, gold) to produce refined inputs for engine/lifecycle

## Ecosystem Oversight

Service LLM provides ecosystem-wide LLM communication oversight, serving as the single gateway through which all engines and services access LLM providers. It enables observation and control of all LLM traffic across the entire ecosystem, complementing planner's workflow view, lifecycle's temporal view, filer's infrastructure view, and service-switch's communication fabric.

## Biological-IT Integration

All linkages between service-llm and other engines use biological-IT (service-biological-it). Communication is by value through the MessageModerator, never by direct calls. Service LLM exposes the standard 6-method Bindable interface: create, read, update, delete, list, execute.

## JSON-RPC-LD Integration

Service LLM uses JSON-RPC-LD as its wire protocol, enabling publish/subscribe messaging that hides all implementation details from consumers. Engines publish LLM requests and subscribe to responses through the MessageFabric using JSON-RPC-LD over WebSocket transport.
