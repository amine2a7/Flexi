/**
 * Container images used by integration tests. Pinned by version AND sha256 digest (threat SC-7).
 * Must stay identical to infra/docker-compose.yml (checked by test/unit/images.test.ts).
 */
export const POSTGRES_IMAGE =
  'postgres:16.15-alpine@sha256:721873c34ceb9f8d8fc265984940dc982404c105f19ad51be9fdc5970a6080ea';

export const REDIS_IMAGE =
  'redis:7.4.11-alpine@sha256:858f009f9709ce576febc734aa78b8f6d624b82571f9ddb6bda4377c833b3499';
