# 🤖 AI Tools – RecruitX Next

This document outlines the AI tools explored or integrated in RecruitX, their intended purpose, justification, and
evaluation criteria. Tools are grouped by capability area and mapped to their current usage or planning stage.

---

## 🤖 AI Capabilities Aligned to RecruitX

| Capability                 | Purpose                                                                                | Tool(s)                                                | Scope          |
|----------------------------|----------------------------------------------------------------------------------------|--------------------------------------------------------|----------------|
| **NLP Intent Recognition** | Parse recruiter messages in the chatbot (e.g., “Who’s available for Python tomorrow?”) | Custom interpreter, `spaCy`, `transformers`            | ✅ MVP          |
| **AI Summarization**       | Summarize interview/report trends in human-readable format                             | Generic LLM APIs (e.g., Gemini), Ollama                | ✅ MVP          |
| **Anomaly Detection**      | Auto-flag missing feedback, unbalanced load, or rescheduling spikes                    | Manual logic in MVP, ML planned via EvidentlyAI/custom | ⏳ Post-MVP     |
| **Agentic Automation**     | Scrape/configure APIs, assist in fallback config or DLQ replay later                   | `Agno`, `LangChain`, `Autogen`                         | 🧪 Exploratory |
| **Auto-recommendation**    | Suggest interviewer assignment or flag process bottlenecks                             | LLM-based prompt templates or retrieval logic          | ⏳ Post-MVP     |

---

## 📈 AI-Enhanced Reporting & Insights

> RecruitX is designed to support recruiter-facing reports for interview throughput, interviewer workload, and
> rescheduling trends. AI enhances this by making data more actionable.

### Key Use Cases:

- **Daily summary cards**: e.g., “Python interviews declined 3x more this week than last.”
- **Smart alerts**: “Load imbalance across EMEA region; John is overbooked.”
- **Guided filtering**: e.g., “Show interviewers with low decline rate and high feedback compliance.”

### Integration Notes:

- Report summaries generated using a **generic LLM API** (e.g., Gemini or Ollama)
- Anomalies flagged via rules or AI pipelines
- Shown in dashboard widgets or chatbot replies

---

## 🔐 Evaluation Criteria

| Criteria               | Applied To                                                               | Notes                                 |
|------------------------|--------------------------------------------------------------------------|---------------------------------------|
| 🔌 Ease of Integration | Chatbot, DLQ workflows, reporting                                        | JSON input/output preferred           |
| ⚡ Latency Budget       | NLP/chatbot replies                                                      | Target: <1 sec                        |
| 🧠 Local vs Cloud      | Ollama for local fallback; Gemini as cloud default (via service account) | Configurable per environment          |
| 🔍 Observability       | All AI-generated outputs                                                 | Logged and explainable where possible |
| 🔄 Feedback Loops      | Reporting, recommendations                                               | Post-MVP capability                   |

---

## 🛠️ Tool Usage Summary

| Tool                               | Usage                                                         | Scope          |
|------------------------------------|---------------------------------------------------------------|----------------|
| **Generic LLM API (e.g., Gemini)** | Reporting summaries, fallback reasoning, chatbot enhancements | ✅ MVP          |
| **Ollama**                         | Local summarizer fallback                                     | ✅ MVP (POC)    |
| **Agno**                           | API orchestration / automation assistant                      | 🧪 Exploratory |
| **LangChain**                      | Task orchestration / prompt chaining                          | 🧪 Exploratory |
| **spaCy / Transformers**           | NLP parsing for chatbot                                       | ✅ MVP          |
| **EvidentlyAI**                    | Anomaly detection for post-event data                         | ⏳ Post-MVP     |

---

## 📎 Related Docs

- [`AssumptionsAndFAQ.md`](./AssumptionsAndFAQ.md) – Section 4, Section 5
- [`UserJourneys.md`](./UserJourneys.md) – Reporting & Chatbot Flows
- [`Tradeoffs.md`](./Tradeoffs.md) – Simplicity vs Automation
- [`ADR-009-nlp-chatbot.md`](./adrs/ADR-009-nlp-chatbot.md) – NLP capability decision
- [`ADR-004-quality-tradeoffs.md`](./adrs/ADR-004-quality-tradeoffs.md) – Extensibility & observability considerations
