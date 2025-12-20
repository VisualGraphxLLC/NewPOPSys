# SUPP-006 — Shared Foundations — Webhooks & Events

> **Version**: v0.5  
> **Status**: Locked  
> **Updated**: 2025-12-18  
> **Dependencies**: All Modules

---

## Purpose
Define the **Event Contract** for internal async handlers AND external webhook consumers (PSP/Brand).

---

## 1. Execution Events (Outbound)

| Topic | Event | Payload Keys |
|-------|-------|--------------|
| `campaign` | `campaign.published` | `id`, `pspCampaignRef`, `storeCount`, `kitId` |
| `order` | `order.generated` | `id`, `orderNumber`, `storeId`, `pspOrderRef` |
| `issue` | `issue.created` | `id`, `type`, `description`, `photoUrl` |
| `issue` | `issue.approved` | `id`, `reorderId` |
| `submission` | `submission.receipt_verified` | `id`, `storeId`, `status` |
| `submission` | `submission.install_completed` | `id`, `storeId` |
| `photo` | `photo.rejected` | `id`, `assignmentItemId`, `reason` |

---

## 2. Inbound Events (From PSP)

| Topic | Event | Required Payload |
|-------|-------|------------------|
| `order` | `order.acknowledged` | `orderId`, `pspOrderRef`, `status` |
| `shipment` | `shipment.created` | `orderId`, `trackingNumbers[]` |
| `shipment` | `shipment.delivered` | `orderId`, `deliveredAt` |

---

## 3. Webhook Security
- **Signing**: HMAC-SHA256 (Header: `X-VG-Signature`).
- **Idempotency**: `Idempotency-Key` required for inbound events.
- **Retry**: Exponential backoff (max 72h).

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.5 | 2025-12-20 | Stable filename adopted; version tracked in file |
