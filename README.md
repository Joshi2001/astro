# Astro — Vedic Astrology Matchmaking

Full-stack project:

- **`backend/`** — Node.js / Express / MongoDB API (auth, profile, questionnaire, horoscope, matchmaking, AI astrologer Q&A with RAG)
- **repo root** — Flutter mobile app (GetX state management, MVVM architecture)

## Run the backend

```bash
cd backend
npm install
cp .env.example .env   # fill in MONGO_URI, JWT_SECRET, GEMINI_API_KEY
npm start
```

The mobile app authenticates with a bearer token returned by `/api/auth/login` and `/api/auth/register`, so it works without cookie handling (cookies remain supported for web clients).

## Run the Flutter app

```bash
flutter pub get
flutter run
```

If your backend is not on `localhost:5000`, point the app at it while running:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000/api   # Android emulator
```# astro
