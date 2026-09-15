# GitLab Duo & Free-Trial Multi-Model Pipeline Setup

## 1. GitLab Duo Chat (Direct Web / IDE Access)
Your GitLab Duo / Ultimate trial unlocks direct multi-model assistance. Here is how to trigger it:
1. **Web UI:** Open your GitLab project (`gitlab.com/<username>/1M`).
2. **Bottom-Left / Right Sidebar:** Click on the **GitLab Duo Chat** icon (`Help` / `Duo Chat`).
3. **Model Selection:** Select available models (Claude Opus / Duo Advanced) in the prompt box settings.
4. **VS Code / Cursor Integration:**
   - Install extension: `GitLab Workflow`.
   - Run `GitLab: Authenticate with GitLab.com` using your Personal Access Token.
   - Access **GitLab Duo Chat** right inside your editor sidebar.

---

## 2. API / CLI Key Extraction (For Scripted Loops)
To use frontier models via curl or scripts:
1. Go to **GitLab.com** $\to$ **Edit Profile** $\to$ **Access Tokens** (`Personal Access Tokens`).
2. Generate a token with scopes: `api`, `read_api`, `ai_features`.
3. Use the GraphQL endpoint to query AI completions or configure OpenRouter / Anthropic trial endpoints:

```bash
# Example GraphQL Duo Chat Prompt query
curl -X POST https://gitlab.com/api/graphql \
  -H "Authorization: Bearer <YOUR_GITLAB_PAT>" \
  -H "Content-Type: application/json" \
  -d '{"query": "mutation { aiAction(input: { chat: { resourceId: \"gid://gitlab/Project/<PROJECT_ID>\", content: \"Analyze this circuit lower bound...\" } }) { errors } }"}'
```

---

## 3. Feeding Hardened Prompts to Adversarial Models
When querying Claude Opus or Astra, always feed the sealed 5-module prompt artifact:
- File path: `C:/Users/srija/.gemini/antigravity-cli/brain/a6654128-e23d-4ba4-8188-b14a2596f07d/claude_opus_cdal_master_prompt.md`
- Target focus: Request adversarial red-teaming on **Spira DAG Decomposition** vs **Graph Topography Invariants**.
