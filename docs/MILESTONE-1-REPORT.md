# Milestone 1 report - project foundation

## Created
- Monorepo structure, .gitignore, .env.example, docker-compose (PostgreSQL, Redis, backend), README.
- Flutter app: splash, welcome, login, registration, dashboard shell (Chats/Status/Calls/Profile), light and dark theme, official logo used as-is.
- Next.js website: landing, login, register, dashboard shell, favicon and logo from the official logo.
- NestJS backend: health endpoint (checks PostgreSQL and Redis), Swagger docs, Redis service, Prisma service.
- Prisma schema with all 17 required models, relations, constraints and indexes.
- GitHub Actions for APK, website and backend.

## Not verified yet (no network in the build sandbox)
- `flutter analyze`, `flutter test`, APK build
- `npm install`, `next build`, backend `jest`, `nest build`
- `prisma validate` and the initial migration
These run for the first time on GitHub Actions or on your machine. Send the error logs and they will be fixed.

## Intentionally not done yet
- Real OTP login (Milestone 2). The "Send OTP" button only validates the number.
- Dashboards show empty states, not fake chats.
- Prisma migration folder (needs a running database).
- package-lock.json files (run `npm install` once and commit them).
- Launcher icon is the full logo (rounded square); adaptive-icon polish can come later.
- "Preview dashboard" buttons are temporary and are removed in Milestone 2.
