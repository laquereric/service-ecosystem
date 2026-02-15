# LLM Service

Library providing a unified interface for multiple LLM providers in Ruby/Rails applications. This is the service-ecosystem counterpart of llm-engine-gem, restructured for use within the biological-IT architecture.

## Features

- **Multi-provider support**: Anthropic, OpenAI, Gemini, Ollama, Mistral, Cohere
- **Standardized responses**: Consistent response format across providers
- **Streaming support**: Real-time streaming for all providers
- **Simple client**: Quick usage without database setup
- **Rails engine**: Full database-backed provider management (optional)

## Ecosystem Oversight

LLM Service provides the shared library logic for ecosystem-wide LLM access. All engines and services that need LLM capabilities depend on this library, ensuring consistent provider interfaces, response formats, and error handling across the ecosystem.

## Biological-IT Integration

All linkages between llm-service and other components use biological-IT (service-biological-it). Communication is by value through the MessageModerator, never by direct calls. LLM Service exposes the standard 6-method Bindable interface: create, read, update, delete, list, execute.
