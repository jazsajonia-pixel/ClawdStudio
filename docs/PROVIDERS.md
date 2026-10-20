# Provider support
**Checked:** 2026-10-20

No provider adapter is implemented in this branch. Upstream README advertises Anthropic, OpenAI and GLM, but ClawdStudio has not made a real request through the engine, so none is marked supported/tested here.

| Provider | ClawdStudio status | Free tier |
|---|---|---|
| Google Gemini API | Not implemented | Limited free tier for selected models; quotas and eligibility vary. Official pricing checked 2026-10-20. |
| OpenAI, OpenRouter, xAI/Grok, Anthropic, Z.AI/GLM | Not implemented | Not verified here |
| DeepSeek, Groq, Cerebras, Mistral, Hugging Face, GitHub Models | Not implemented | Not verified here |
| Jules | Not a direct provider | Do not invent a direct model API adapter |

Official Gemini pricing: https://ai.google.dev/gemini-api/docs/pricing. A free consumer chat product does not imply a free API. Refresh provider support, pricing and model capability data from official docs before releases. Requests may send relevant source/context to the selected provider; explain this before agent use.