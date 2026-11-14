# HamWhatsApp

Connect. Chat. Share. Android (Flutter) + web (Next.js) messaging platform with a NestJS backend.

Status: **Milestone 1 - project foundation** (see `docs/MILESTONE-1-REPORT.md`).

## Structure

    mobile/    Flutter Android app
    website/   Next.js + Tailwind website
    backend/   NestJS API (Prisma, Redis, Swagger)
    database/  Database notes (schema is in backend/prisma)
    infrastructure/  Redis config and later STUN/TURN
    docs/      API, signing, reports

## Run the backend

    cp .env.example .env
    docker compose up -d postgres redis
    cd backend
    cp ../.env.example .env
    npm install
    npx prisma migrate dev --name init
    npm run start:dev

Check `http://localhost:3001/api/health` and `http://localhost:3001/docs`.

Everything in Docker instead: `docker compose up --build` (run the `init` migration first so the migrations folder exists).

## Run the website

    cd website
    npm install
    npm run dev        # http://localhost:3000

## Build the Android APK

Easiest: push this repo to GitHub, open the **Actions** tab, run **Android Build**, then download the `hamwhatsapp-apk` artifact.

Locally (needs Flutter):

    cd mobile
    flutter create --platforms=android --org com.hamwhatsapp --project-name hamwhatsapp .
    flutter pub get
    dart run flutter_launcher_icons
    flutter run

Signing: `docs/SIGNING.md`.
