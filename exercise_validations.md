### **Validation Rules**

#### **1. COMPLETE_CONVERSATION**

- **`question_data`**
  - `text`: Required. String. Cannot be empty.
  - `options`: Required. Array of objects. Minimum length: 2.
  - `options[].id`: Required. String. Unique within the array.
  - `options[].text`: Required. String. Cannot be empty.
- **`answer_data`**
  - `correct_option_id`: Required. String. Must exactly match an `id` present in
    `question_data.options`.

```json
{
  "type": "COMPLETE_CONVERSATION",
  "question_data": {
    "text": "Can I have some water?",
    "options": [
      { "id": "1", "text": "Yes, here you go." },
      { "id": "2", "text": "I am from Vietnam." }
    ]
  },
  "answer_data": { "correct_option_id": "1" }
}
```

#### **2. COMPLETE_TRANSLATION**

- **`question_data`**
  - `source_sentence`: Required. String. Cannot be empty.
  - `text_template`: Required. String. Must contain sequential positional
    placeholders (e.g., `{0}`, `{1}`).
- **`answer_data`**
  - `correct_words`: Required. Array of strings. Array length must precisely
    equal the count of unique placeholders extracted from `text_template`.

```json
{
  "type": "COMPLETE_TRANSLATION",
  "question_data": {
    "source_sentence": "Chào buổi chiều",
    "text_template": "{0}"
  },
  "answer_data": { "correct_words": ["Good afternoon"] }
}
```

#### **3. ARRANGE_WORDS**

- **`question_data`**
  - `tokens`: Required. Array of strings. Minimum length: 2.
- **`answer_data`**
  - `correct_sequence`: Required. Array of strings. Must be a subset or exact
    match of elements provided in `question_data.tokens`. Length must be > 0.

```json
{
  "type": "ARRANGE_WORDS",
  "question_data": {
    "tokens": ["chicken", "I", "like", "would"]
  },
  "answer_data": { "correct_sequence": ["I", "would", "like", "chicken"] }
}
```

#### **4. PICTURE_MATCH**

- **`question_data`**
  - `word`: Required. String. Cannot be empty.
  - `options`: Required. Array of objects. Minimum length: 2.
  - `options[].id`: Required. String. Unique within the array.
  - `options[].text`: Required. String. Cannot be empty.
  - `options[].image_url`: Required. String. Must be a valid URI path.
- **`answer_data`**
  - `correct_option_id`: Required. String. Must exactly match an `id` present in
    `question_data.options`.

```json
{
  "type": "PICTURE_MATCH",
  "question_data": {
    "word": "Coffee",
    "options": [
      { "id": "1", "text": "Cà phê", "image_url": "/media/coffee.png" },
      { "id": "2", "text": "Trà", "image_url": "/media/tea.png" }
    ]
  },
  "answer_data": { "correct_option_id": "1" }
}
```

#### **5. TYPE_HEAR**

- **`question_data`**: Must be null (none)
  - `text`: Required. String. Cannot be empty. Serves as the TTS payload.
- **`answer_data`**
  - `correct_transcription`: Required. String. Cannot be empty.

```json
{
  "type": "TYPE_HEAR",
  "question_data": null,
  "answer_data": { "correct_transcription": "Nice to meet you." }
}
```

#### **6. LISTEN_FILL**

- **`question_data`**
  - `text`: Required. String. Cannot be empty. Serves as the TTS payload.
  - `word_bank`: Required. Array of objects. Minimum length: 2.
  - `word_bank[].id`: Required. String. Unique within the array.
  - `word_bank[].text`: Required. String. Cannot be empty.
- **`answer_data`**
  - `correct_sequence_ids`: Required. Array of strings. Minimum length: 1. Every
    element must correspond to a valid `id` in `question_data.word_bank`.

```json
{
  "type": "LISTEN_FILL",
  "question_data": {
    "text": "apple juice please",
    "word_bank": [
      { "id": "1", "text": "apple" },
      { "id": "2", "text": "juice" },
      { "id": "3", "text": "please" },
      { "id": "4", "text": "car" }
    ]
  },
  "answer_data": { "correct_sequence_ids": ["1", "2", "3"] }
}
```

#### **7. SPEAK_SENTENCE**

- **`question_data`**: Must be null (none)
- **`answer_data`**
  - `expected_text`: Required. String. Cannot be empty. Used as the STT
    evaluation target.

```json
{
  "type": "SPEAK_SENTENCE",
  "question_data": null,
  "answer_data": { "expected_text": "Hello, how are you?" }
}
```
