# Project Specification: English Learning Web Platform

---

## Tech Stack

- **Frontend:** Next.js 14+ (App Router), TypeScript, Tailwind CSS, ~~Framer
  Motion (for gamified UI/UX)~~.
- **Backend:** FastAPI (Python) for asynchronous performance~~ and LLM
  integration~~.
- **Database:** SQL Server (SQLModel, pyodbc) for all data (user data, streaks,
  progress). ~~Redis for streaks and leaderboards.~~
- ~~**AI/LLM Integration:** Ollama (Gemma 2 9B or Qwen 2.5) for dynamic lesson
  generation and writing feedback.~~
- **Infrastructure:** Docker, ~~Nginx~~, and ~~GitHub Actions for CI/CD~~.

---

## 1\. Learning Architecture

- **Curriculum Hierarchy:** Course \-\> Units \-\> Lessons \-\> Skills.
  - Course: 2 types:
    - Vietnam - English: Basic, learn translation
    - English: Intermediate, English only

- **Tree Progression:** Nodes represent skills that unlock linearly. Use a DAG
  (Directed Acyclic Graph) structure in the backend to manage dependencies.
- **Placement Assessment:** A diagnostic module to categorize users into CEFR
  levels (A1–B1) upon registration.

## 2\. Gamification Core (Duolingo Mechanics)

- **Streak System:** Logic to track daily activity. Store
  last_activity_timestamp and current_streak in Redis for low-latency updates.
- **Experience Points (XP):** Tiered rewards based on accuracy, lesson
  difficulty, and "combo" bonuses.
- **Hearts/Life System:** 5 hearts maximum; 1 lost per mistake. Automatic
  regeneration (1 per 4 hours) or manual refill using earned currency (Gems).
- ~~**Leagues:** Weekly leaderboard resets using Redis Sorted Sets to group 30
  users of similar activity levels.~~

## 3\. Exercise Engine

- **Word Bank:** Interactive drag-and-drop components for sentence construction.
- **Audio/Oral:**
  - **Listening:** Audio playback with transcription verification.
  - **Speaking:** Integration with the Web Speech API (Google Cloud) for
    real-time pronunciation scoring.
- **Translation:** Bidirectional translation exercises with fuzzy-matching for

- **Matching:** Interactive cards for vocabulary/definition pairing.

## 4\. Admin Management

- **Admin Privilege:** Admins can manage users, courses, units, lessons, and
  exercises with full CRUD operations.
- Admin panel integration for content management and user reporting.

  minor typos.

## 4\. Specialized Modules

- ~~**IELTS Writing Lab:** A specialized section for Writing Task 2\. Use the
  local LLM to analyze submissions based on official criteria: Task Response,
  Coherence and Cohesion, Lexical Resource, and Grammatical Range.~~
- **Spaced Repetition (SRS):** A "Practice" mode that prioritizes words the user
  frequently misses, utilizing the Leitner System logic.

## 5\. Technical Implementation Notes

- **State Management:** Use TanStack Query (React Query) for server state and
  lesson progress synchronization.
- **Offline Support:** Implement a Service Worker for PWA (Progressive Web App)
  capabilities, allowing lesson caching.
- **TTS Integration:** Utilize edge-based Text-to-Speech or high-quality local
  synthesis for all vocabulary.

## 6\. User Doing Exercise Procedure

Implement **Hybrid Client/Server Validation Architecture**

### **1. Pre-fetching and Local Storage (The Initial Load)**

When the user starts a lesson (or while they are on the home screen), the
frontend requests the entire lesson payload from the backend.

- **Payload Structure:** Includes all questions, distractor options, and correct
  answers for deterministic exercises.
- **Storage:** The frontend caches this payload using a Service Worker and
  stores it in IndexedDB or local memory.
- **Audio Assets:** Loaded on-demand only. Audio files are fetched from the
  backend when the user explicitly requests them (e.g., pressing a word for
  searching or hitting the play button), rather than being pre-fetched.

### **2. Client-Side Evaluation (Deterministic Exercises)**

Exercises like multiple-choice, matching, and basic text translation are
evaluated entirely in the browser.

- **Execution:** The frontend compares the user's input directly against the
  cached answer key.
- **State Tracking:** The frontend maintains a local state for `hearts`,
  `current_score`, and `mistakes`.
- **Network Requirement:** None. This works seamlessly offline.

### **3. Graceful Degradation (Non-Deterministic Exercises)**

For features relying on your backend LLM or heavy TTS/STT APIs, implement
network-aware fallbacks using `navigator.onLine` and `try/catch` blocks.

- **Speaking Exercises (STT):**
  - **Logic:** Before initializing the Web Speech API or MediaRecorder, check
    `navigator.onLine`.
  - **Offline Behavior:** If false, the frontend immediately dispatches a "skip"
    action, bypassing the question without penalizing the user's hearts,
    matching the Duolingo behavior you observed.
- **Listening Exercises (TTS):**
  - **Logic:** If the audio file wasn't pre-fetched, the frontend attempts to
    fetch it from the backend API on demand.
  - **Offline Behavior:** The `fetch()` request will throw a network error. The
    frontend catches this error, disables the play button, and displays a toast
    notification ("Audio unavailable offline"), or provides an option to skip
    the exercise.

### **4. Real-Time Submission and Loading State**

The frontend evaluates progress during the lesson, then submits one final
completion payload after the user finishes all exercises.

- **Single Final Submit:** After the last question is completed, the frontend
  sends one POST request containing the full lesson result (answers summary,
  score, hearts left, and timestamps).
- **Loading UX:** While waiting for this final server confirmation, show a
  full-screen loading state (or completion loading modal) and block duplicate
  submit actions.
- **Retry Behavior:** If the final request fails, keep the user on a
  submission-pending screen with a clear Retry button until the submission is
  accepted.
- **Server Source of Truth:** XP, streak updates, and lesson completion are
  finalized only after the backend accepts the final payload.

---

##
