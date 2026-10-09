# ADR 0001 – Stack backend et web
**Statut :** accepté
**Décision :** monorepo pnpm/Turborepo, NestJS + PostgreSQL + Redis, Next.js.
**Raisons :** TypeScript partout (types et validation partagés), monolithe modulaire plus simple et plus sûr qu'une architecture microservices pour démarrer, PostgreSQL pour ACID et Row-Level Security.
**Conséquences :** discipline de modules ; extraction éventuelle de services plus tard.
