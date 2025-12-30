BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "agent_findings" (
    "id" bigserial PRIMARY KEY,
    "pullRequestId" bigint NOT NULL,
    "agentType" text NOT NULL,
    "severity" text NOT NULL,
    "category" text NOT NULL,
    "message" text NOT NULL,
    "filePath" text,
    "lineNumber" bigint,
    "codeSnippet" text,
    "suggestedFix" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "applied_fixes" (
    "id" bigserial PRIMARY KEY,
    "findingId" bigint NOT NULL,
    "fixCode" text NOT NULL,
    "appliedAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "prUrl" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "generated_documentation" (
    "id" bigserial PRIMARY KEY,
    "pullRequestId" bigint NOT NULL,
    "filePath" text NOT NULL,
    "functionName" text,
    "originalCode" text NOT NULL,
    "generatedDoc" text NOT NULL,
    "verificationStatus" text NOT NULL,
    "verificationIssues" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pattern_libraries" (
    "id" bigserial PRIMARY KEY,
    "pattern" text NOT NULL,
    "language" text NOT NULL,
    "category" text NOT NULL,
    "fixTemplate" text NOT NULL,
    "confidence" double precision NOT NULL,
    "occurrenceCount" bigint NOT NULL,
    "lastSeen" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "performance_logs" (
    "id" bigserial PRIMARY KEY,
    "agentType" text NOT NULL,
    "filePath" text,
    "executionTimeMs" bigint NOT NULL,
    "memoryUsageMB" double precision,
    "queryCount" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "pull_requests" (
    "id" bigserial PRIMARY KEY,
    "repositoryId" bigint NOT NULL,
    "prNumber" bigint NOT NULL,
    "title" text NOT NULL,
    "status" text NOT NULL,
    "baseBranch" text NOT NULL,
    "headBranch" text NOT NULL,
    "filesChanged" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "repositories" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "url" text NOT NULL,
    "owner" text NOT NULL,
    "defaultBranch" text NOT NULL,
    "lastReviewedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review_jobs" (
    "id" bigserial PRIMARY KEY,
    "pullRequestId" bigint NOT NULL,
    "status" text NOT NULL,
    "priority" bigint NOT NULL,
    "retryCount" bigint NOT NULL,
    "errorMessage" text,
    "createdAt" timestamp without time zone NOT NULL,
    "startedAt" timestamp without time zone,
    "completedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review_notifications" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "reviewSessionId" bigint NOT NULL,
    "type" text NOT NULL,
    "message" text NOT NULL,
    "read" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "review_sessions" (
    "id" bigserial PRIMARY KEY,
    "pullRequestId" bigint NOT NULL,
    "status" text NOT NULL,
    "currentFile" text,
    "filesProcessed" bigint NOT NULL,
    "totalFiles" bigint NOT NULL,
    "progressPercent" double precision NOT NULL,
    "errorMessage" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_preferences" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "findingType" text NOT NULL,
    "action" text NOT NULL,
    "frequency" bigint NOT NULL,
    "lastUpdated" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "webhook_events" (
    "id" bigserial PRIMARY KEY,
    "eventType" text NOT NULL,
    "payload" text NOT NULL,
    "signature" text,
    "processed" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR code_butler_new
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('code_butler_new', '20251230073029919', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251230073029919', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
