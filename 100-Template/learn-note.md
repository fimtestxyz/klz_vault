<%*
const target_topic = await tp.system.prompt("Enter target topic to learn");
const safe_topic = target_topic.replace(/[^a-zA-Z0-9-_ ]/g, "").replace(/\s+/g, "_");
await tp.file.rename(`learn_${safe_topic}`);
-%>


# 🌳 <%= target_topic %> — Rapid Landscape Map

## 1️⃣ AI MASTER PROMPT (Landscape + Tree View)

**Prompt to AI:**

You are an expert teacher and systems thinker.

Deconstruct **<%= target_topic %>** so a fast learner can master it efficiently.

### Output requirements:
1. Present the topic as a **tree structure**:
   - Root → major branches → sub-branches
2. Clearly separate:
   - Core fundamentals
   - Advanced concepts
   - Edge cases & exceptions
3. Use **concise, high-signal explanations**
4. Avoid fluff, maximize clarity

Start with a **one-paragraph big-picture overview**, then show the tree.

---

## 2️⃣ TOPIC TREE (Landscape Map)

- <%= target_topic %>
  - Core Foundations
  - Key Components
  - Processes / Flows
  - Tools / Techniques
  - Trade-offs
  - Failure Modes
  - Advanced / Expert-Level Concepts

---

## 3️⃣ KEY QUESTIONS & ANSWERS

### Core Understanding
- **What problem does <%= target_topic %> solve?**  
- **Why does it matter?**

### How It Works
- **How does <%= target_topic %> work at a high level?**  
- **What are the critical mechanisms?**

### Comparison
- **What is <%= target_topic %> often confused with?**  
- **When should it NOT be used?**

---

## 4️⃣ SCENARIOS & APPLICATIONS

### Typical Scenarios
- Context:
- Why <%= target_topic %> fits:

### Real-World / Industry Examples
- Problem:
- Application:
- Outcome:

### Failure / Misuse Scenarios
- What goes wrong:
- Early warning signs:

---

## 5️⃣ BOUNDARIES & CONSTRAINTS

**What <%= target_topic %> is:**
- …

**What <%= target_topic %> is NOT:**
- …

**Assumptions it relies on:**
- …

**Hard limits / constraints:**
- …

---

## 6️⃣ MENTAL MODELS

### Primary Mental Model
> “Think of <%= target_topic %> as …”

### Supporting Mental Models
- Model 1:
- Model 2:
- Model 3:

---

## 7️⃣ TAGS

#topic/<%= safe_topic %>
#mental-model
#failure-mode
#use-case
#learning-map

---

## 8️⃣ FAST LEARNER PATH

1. Learn the fundamentals
2. Identify failure modes
3. Apply to real scenarios
4. Compare alternatives
5. Teach it simply

---

## 9️⃣ ONE-SENTENCE MASTERY CHECK

> “I understand <%= target_topic %> if I can explain it clearly without notes.”
