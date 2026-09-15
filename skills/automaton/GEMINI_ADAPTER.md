# Automaton: Gemini / Antigravity Adapter & Engine Configuration

This guide configures the cloned `automaton` engine in `C:\Users\srija\Projects\1M\automaton` to run natively on **Google Gemini / Antigravity**.

---

## 1. Engine Model Configuration

In the original Conway Automaton, inference defaults to Anthropic/Claude. For Gemini, update the model provider in `src/agent/` or runtime config:

```typescript
// Gemini 2.5 / 3.0 Model Tiers for Automaton
export const GEMINI_SURVIVAL_MODELS = {
  normal: "gemini-2.5-pro",          // Full Frontier Reasoning
  low_compute: "gemini-2.5-flash",    // Fast, Cost-Efficient
  critical: "gemini-2.5-flash-lite", // Minimum Resource Survival
};
```

---

## 2. Antigravity Native Integration

When executing inside the **Antigravity CLI / IDE**, the Automaton leverages native subagent and task primitives:

- **Subagent Spawning:** Uses `invoke_subagent` for branching child sandboxes.
- **Background Cron:** Uses `schedule` with `CronExpression="*/15 * * * *"` for non-blocking heartbeats.
- **Git-Audited Tool Expansion:** All code changes are validated with `git status` and test suites before committing.

---

## 3. Quick Test & Build

```powershell
cd C:\Users\srija\Projects\1M\automaton
npm install
npm run build
```
