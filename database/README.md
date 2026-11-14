# Database

The schema lives in `backend/prisma/schema.prisma` (Prisma ORM, PostgreSQL).

Create the first migration (needs PostgreSQL running):

    cd backend
    npx prisma migrate dev --name init

Commit the generated `backend/prisma/migrations/` folder.
