# LLM State

Library that holds all LLM traffic state — every request and response exchanged between the ecosystem and LLM providers is captured and persisted here.

LLM State provides a complete audit trail of LLM interactions, enabling replay, debugging, cost tracking, and analytics across all providers and engines.

## Responsibilities

- **Request capture**: Records every outbound LLM request (prompt, model, parameters, timestamp)
- **Response capture**: Records every inbound LLM response (content, tokens, latency, finish reason)
- **Traffic correlation**: Links requests to responses with unique correlation IDs
- **Streaming state**: Tracks in-flight streaming sessions and their accumulated chunks
- **Audit trail**: Immutable log of all LLM traffic for compliance and debugging

## Ecosystem Oversight

LLM State provides ecosystem-wide visibility into all LLM traffic. Any engine or service can query LLM State to observe request/response history, monitor costs, detect anomalies, and analyze usage patterns across the entire ecosystem.

## Biological-IT Integration

All linkages between llm-state and other components use biological-IT (service-biological-it). Communication is by value through the MessageModerator, never by direct calls. LLM State exposes the standard 6-method Bindable interface: create, read, update, delete, list, execute.
