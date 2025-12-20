Date: 2025-12-17

Purpose: v1-appropriate offline strategy for store execution in mobile browsers (iOS/Android) with PWA scaffold; supports draft saving and queued submissions with sync-on-open.

# Locked Decisions (v1)

  -----------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- -----------------------------------------------------------------------------
  Delivery                            Responsive web app (mobile-first) + PWA scaffold

  Offline approach                    Local drafts + queued submissions + sync-on-open (not true background sync)

  Storage                             IndexedDB for drafts/outbox; object storage for media via presigned uploads

  Native apps                         Future: true background sync + richer integrations
  -----------------------------------------------------------------------------------------------------------------

# Minimum Offline Capabilities (v1)

- Save progress offline (survey drafts + task progress).

- Stage photos locally with storage warnings and a clear "queued uploads" count.

- Auto-upload queued submissions when app is opened online (with retries).

- Sync Status screen: queued / failed / last sync / retry button.

# Implementation Notes (Draft)

- Service Worker caches app shell + critical assets for resilience (offline UI).

- Outbox pattern on client (IndexedDB queue) + server-side outbox/audit events per submission.

- Photo upload: presigned URLs; resumable/chunking where possible; retry with backoff.

- Conflict handling: server is source of truth; prevent overwriting verified/approved submissions without admin action.

# Failure Modes & UX

- If storage is full: block new photo capture and prompt user to upload/sync or delete drafts.

- If upload fails repeatedly: keep in failed queue with last error; allow manual retry; surface contact/help text.

- If user logs out: drafts remain on device; protect with user scoping and optional device purge on logout.

# Acceptance Criteria

1.  Store can complete steps offline and return later without losing progress.

2.  Queued uploads sync when app is opened online; retries work; failures are visible.

3.  User can see what is queued vs submitted; submissions are not duplicated.

4.  Verified/reviewed artifacts are never overwritten by stale offline drafts.

# Open Decisions / TODOs (Need Inputs)

- Offline photo capture expectations for pilot stores (best-effort is current).

- Max offline storage assumption per device; recommended guidance text for stores.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
