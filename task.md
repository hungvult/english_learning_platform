### AI Agent Instruction Protocol: Exercise Implementation Phase

**Objective** Execute full-stack implementation of 7 polymorphic exercise types
for an English learning platform using Next.js (Frontend) and FastAPI +
PostgreSQL (Backend).

#### 1. Server Implementation (FastAPI)

**1.1 Pydantic Model Expansion** Extend the existing `ExerciseValidator`
discriminated union to support all 7 types defined in the specification.

```python
# Required Types:
Literal[
    "COMPLETE_CONVERSATION",
    "ARRANGE_WORDS",
    "COMPLETE_TRANSLATION",
    "PICTURE_MATCH",
    "TYPE_HEAR",
    "LISTEN_FILL",
    "SPEAK_SENTENCE"
]
```

Map the exact JSON schemas from the specification document to Pydantic models.

- `COMPLETE_CONVERSATION`: `QuestionData` requires `instruction`, `text`,
  `options` (id, text). `AnswerData` requires `correct_option_id`.
- `ARRANGE_WORDS`: `QuestionData` requires `instruction`, `tokens` (array).
  `AnswerData` requires `correct_sequence` (array).
- `COMPLETE_TRANSLATION`: `QuestionData` requires `instruction`,
  `source_sentence`, `text_template`. `AnswerData` requires `correct_words`
  (array).
- `PICTURE_MATCH`: `QuestionData` requires `instruction`, `word`, `options` (id,
  text, image_url). `AnswerData` requires `correct_option_id`.
- `TYPE_HEAR`: `QuestionData` requires `instruction`, `text` (for TTS).
  `AnswerData` requires `correct_transcription`.
- `LISTEN_FILL`: `QuestionData` requires `instruction`, `word_bank` (id, text).
  `AnswerData` requires `correct_sequence_ids`.
- `SPEAK_SENTENCE`: `QuestionData` requires `instruction`, `sentence`.
  `AnswerData` requires `expected_text`.

**1.2 REST API Endpoints**

- `GET /api/lessons/{lesson_id}/exercises`: Retrieve an array of exercises.
  Strip `AnswerData` (validation payload) from the response if the request
  originates from a client learning session. Retain `AnswerData` if the request
  originates from the admin panel (authenticated via role).
- `POST /api/exercises/evaluate`: Accept `exercise_id` and raw user input. Route
  the evaluation logic through a factory pattern based on `exercise.type` to
  compute correctness. Return boolean `is_correct` and the `AnswerData` payload.

#### 2. Client Implementation (Next.js)

**Note**:

- Some components is reusable in duolingo-clone repo.
- @exercise.md is the file which contains sample payload and UI, rely on it

**2.1 Component Architecture** Construct a polymorphic `<ExerciseEngine />`
component.

- **Props:**
  - `exerciseData`: The `QuestionData` payload.
  - `type`: The exercise discriminator string.
  - `mode`: `Literal["PRACTICE", "ADMIN_PREVIEW"]`.
  - `onComplete`: Callback function transmitting the user's localized state
    payload.

**2.2 Sub-Component Routing** Map `type` to discrete UI components.

- `<CompleteConversation />`: Render standard radio-style selection buttons.
- `<ArrangeWords />`: Implement drag-and-drop sortable lists (e.g., using
  `dnd-kit`).
- `<CompleteTranslation />`: Parse `text_template`. Render standard text nodes
  for static strings and `<input type="text">` for `{0}`, `{1}` markers.
- `<PictureMatch />`: Render CSS grid of cards with image sub-components.
- `<TypeHear />`: Integrate HTML5 Audio element. Implement dual-speed playback
  (1x and 0.5x).
- `<ListenFill />`: Combine audio playback UI with word bank selection logic.
- `<SpeakSentence />`: Integrate `MediaRecorder` API to capture audio blobs for
  submission.

**2.3 Reusability Logic** If `mode === "ADMIN_PREVIEW"`, bypass network
evaluation. Provide immediate visual feedback based on the full payload
injection (which includes `AnswerData` in admin mode).

#### 3. Seed Data Injection (Tiếng Anh - A1)

Construct the database insertion script using the Pydantic models. Target:
Lesson 1, Unit 1. Theme: Basic greetings, self-introduction, airplane requests.

**Payload Structures:**

- **Type:** `COMPLETE_CONVERSATION`
  - `QuestionData`:
    `{"instruction": "Choose the best response", "text": "Can I have some water?", "options": [{"id": "1", "text": "Yes, here you go."}, {"id": "2", "text": "I am from Vietnam."}]}`
  - `AnswerData`: `{"correct_option_id": "1"}`

- **Type:** `COMPLETE_TRANSLATION`
  - `QuestionData`:
    `{"instruction": "Translate the missing word", "source_sentence": "My name is Hung.", "text_template": "Tên của tôi là {0}."}`
  - `AnswerData`: `{"correct_words": ["Hung"]}`

- **Type:** `ARRANGE_WORDS`
  - `QuestionData`:
    `{"instruction": "Arrange the words", "tokens": ["chicken", "I", "like", "would"]}`
  - `AnswerData`: `{"correct_sequence": ["I", "would", "like", "chicken"]}`

- **Type:** `PICTURE_MATCH`
  - `QuestionData`:
    `{"instruction": "Select the correct image for 'Coffee'", "word": "Coffee", "options": [{"id": "1", "text": "Cà phê", "image_url": "/media/coffee.png"}, {"id": "2", "text": "Trà", "image_url": "/media/tea.png"}]}`
  - `AnswerData`: `{"correct_option_id": "1"}`

- **Type:** `TYPE_HEAR`
  - `QuestionData`:
    `{"instruction": "Type what you hear", "text": "Nice to meet you."}`
  - `AnswerData`: `{"correct_transcription": "Nice to meet you."}`

- **Type:** `LISTEN_FILL`
  - `QuestionData`:
    `{"instruction": "Listen and select the words", "word_bank": [{"id": "1", "text": "apple"}, {"id": "2", "text": "juice"}, {"id": "3", "text": "please"}, {"id": "4", "text": "car"}]}`
  - _(Audio represents: "Apple juice please")_
  - `AnswerData`: `{"correct_sequence_ids": ["1", "2", "3"]}`

- **Type:** `SPEAK_SENTENCE`
  - `QuestionData`:
    `{"instruction": "Speak this sentence", "sentence": "Hello, how are you?"}`
  - `AnswerData`: `{"expected_text": "Hello, how are you?"}`
