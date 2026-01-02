# Appendix B: Notification Matrix

## B.1 Overview

This appendix defines all system-generated notifications, their recipients, delivery methods, and trigger conditions. Notifications ensure timely communication across all user roles throughout the campaign lifecycle.

### Notification Channels

| Channel | Description | Use Case |
|---------|-------------|----------|
| **Email** | Standard email delivery | Non-urgent notifications, summaries |
| **Push** | Mobile/PWA push notification | Time-sensitive store actions |
| **In-App** | Notification center / badge | All notifications (persistent) |
| **SMS** | Text message (optional) | Critical escalations (premium) |
| **Webhook** | API callback to external systems | Integration with third-party systems |

### Notification Priority Levels

| Priority | Description | Delivery |
|----------|-------------|----------|
| **CRITICAL** | Requires immediate action | Push + Email + In-App |
| **HIGH** | Important, action within 24h | Push + In-App |
| **NORMAL** | Standard notification | In-App + Email (digest) |
| **LOW** | Informational only | In-App only |

---

## B.2 Campaign Lifecycle Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| Campaign Created (Draft) | - | In-App | In-App | - | - | - | In-App | LOW |
| Campaign Published | Email | Email, Push | Email, Push | In-App | Push | Push | Multi | HIGH |
| Campaign Nearing End (7d) | - | Email | Email | In-App | Push | In-App | Multi | NORMAL |
| Campaign Ending Today | - | Push | Push | Push | Push | Push | Push | HIGH |
| Campaign Completed | Email | Email, In-App | Email, In-App | In-App | In-App | - | Multi | NORMAL |
| Campaign Cancelled | Email | Email, Push | Email, Push | In-App | Push | Push | Multi | HIGH |
| Campaign Archived | - | In-App | In-App | - | - | - | In-App | LOW |

---

## B.3 Store Assignment Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| Store Assigned to Campaign | - | In-App | In-App | In-App | Email, Push | Push | Multi | HIGH |
| Store Removed from Campaign | - | In-App | In-App | In-App | Email, Push | Push | Multi | NORMAL |
| Store Ready (Materials Delivered) | - | - | - | - | Push | Push | Push | HIGH |
| Store Started Installation | - | - | In-App | In-App | - | - | In-App | LOW |
| Store Submitted for Review | - | In-App | Push | Push | In-App | - | Multi | NORMAL |
| Store Marked Complete | - | In-App | In-App | In-App | Push | Push | Multi | NORMAL |
| Store Reopened | - | In-App | In-App | In-App | Push | Push | Multi | HIGH |
| Store Waived | - | In-App | In-App | In-App | Email | - | Multi | NORMAL |

---

## B.4 Fulfillment Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| Order Created | In-App | - | - | - | - | - | In-App | NORMAL |
| Order Confirmed | - | - | - | - | Email | - | Email | LOW |
| Order Shipped | In-App | - | - | - | Push, Email | Push | Multi | HIGH |
| Tracking Updated | - | - | - | - | In-App | In-App | In-App | LOW |
| Order Delivered | In-App | - | - | - | Push | Push | Push | HIGH |
| Delivery Exception | Push | In-App | In-App | In-App | Push, Email | Push | Multi | CRITICAL |
| Order Cancelled | In-App | Email | Email | In-App | Push, Email | Push | Multi | HIGH |
| Partial Shipment Sent | In-App | - | - | - | Push | Push | Multi | NORMAL |

---

## B.5 Issue & Reorder Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| Issue Reported | Push | In-App | In-App | Push | In-App | In-App | Multi | HIGH |
| Issue Needs Approval | - | Push, Email | Push, Email | - | - | - | Multi | HIGH |
| Issue Approved | In-App | In-App | In-App | In-App | Push | Push | Multi | NORMAL |
| Issue Denied | - | In-App | In-App | In-App | Push, Email | Push | Multi | NORMAL |
| Reorder Created | Push | In-App | In-App | - | In-App | - | Multi | NORMAL |
| Replacement Shipped | In-App | - | - | - | Push | Push | Multi | HIGH |
| Issue Resolved | In-App | In-App | In-App | In-App | Push | Push | Multi | NORMAL |

---

## B.6 Photo Review & Verification Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| Photo Submitted | - | In-App | In-App | Push | - | - | Multi | NORMAL |
| Photos Pending Review (Batch) | - | Email | Email | Push, Email | - | - | Multi | HIGH |
| Photo Approved | - | - | - | - | In-App | In-App | In-App | LOW |
| Photo Rejected | - | - | - | - | Push | Push | Push | HIGH |
| Retake Requested | - | In-App | In-App | In-App | Push, Email | Push | Multi | CRITICAL |
| Retake Submitted | - | In-App | In-App | Push | In-App | - | Multi | NORMAL |
| All Photos Approved | - | In-App | In-App | In-App | Push | Push | Multi | NORMAL |
| Review Deadline Approaching | - | Push | Push | Push | - | - | Push | HIGH |

---

## B.7 User & Access Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| User Invited | Email | Email | Email | Email | Email | Email | Email | HIGH |
| User Activated | In-App | In-App | In-App | In-App | In-App | In-App | In-App | LOW |
| User Deactivated | Email | Email | Email | Email | Email | Email | Email | HIGH |
| Password Reset Requested | Email | Email | Email | Email | Email | Email | Email | CRITICAL |
| Role Changed | - | Email | Email | Email | Email | Email | Email | NORMAL |
| Access Revoked | Email | Email | Email | Email | Email | Email | Email | HIGH |

---

## B.8 Report & Export Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| Scheduled Report Ready | Email | Email | Email | Email | - | - | Email | NORMAL |
| Export Complete | Email | Email | Email | Email | Email | - | Email | NORMAL |
| Export Failed | Email | Email | Email | Email | - | - | Email | HIGH |
| Dashboard Threshold Alert | Push | Push | Push | Push | - | - | Push | HIGH |

---

## B.9 Escalation Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| Store Overdue (No Activity) | - | Email | Email | Push, Email | Push, Email | Push | Multi | CRITICAL |
| Retake Overdue (48h) | - | Push | Push | Push, Email | Push, Email | Push | Multi | CRITICAL |
| Campaign Compliance Risk | - | Push, Email | Push, Email | Push | - | - | Multi | CRITICAL |
| SLA Breach Warning | Push, Email | Push, Email | Push | - | - | - | Multi | CRITICAL |

---

## B.10 Deinstall Notifications

| Event | PSP Admin | Brand Admin | Campaign Mgr | Regional Mgr | Store Mgr | Store Staff | Method | Priority |
|-------|:---------:|:-----------:|:------------:|:------------:|:---------:|:-----------:|--------|----------|
| Deinstall Task Created | - | In-App | In-App | In-App | Push | Push | Multi | HIGH |
| Deinstall Reminder (3d before) | - | - | - | - | Push | Push | Push | NORMAL |
| Deinstall Due Today | - | In-App | In-App | In-App | Push | Push | Multi | HIGH |
| Deinstall Overdue | - | Email | Email | Push, Email | Push, Email | Push | Multi | CRITICAL |
| Deinstall Completed | - | In-App | In-App | In-App | In-App | - | In-App | NORMAL |

---

## B.11 Notification Preferences

### B.11.1 User-Configurable Preferences

Users can customize notification delivery for non-critical events:

| Preference | Options | Default |
|------------|---------|---------|
| Email Frequency | Immediate, Daily Digest, Weekly | Immediate |
| Push Notifications | On, Off | On |
| Quiet Hours | Time range (e.g., 10pm-7am) | None |
| Email Format | HTML, Plain Text | HTML |

### B.11.2 Non-Configurable (Mandatory) Notifications

The following notification types cannot be disabled:

- Password reset
- Account deactivation
- Critical escalations (SLA breach)
- Security alerts
- System maintenance

---

## B.12 Notification Templates

### B.12.1 Email Subject Line Patterns

| Event Category | Subject Pattern |
|----------------|-----------------|
| Campaign | `[NewPOPSys] {Campaign Name}: {Action}` |
| Store | `[NewPOPSys] Store {Store Name}: {Action Required}` |
| Fulfillment | `[NewPOPSys] Order #{OrderID}: {Status Update}` |
| Issue | `[NewPOPSys] Issue #{IssueID}: {Status}` |
| User | `[NewPOPSys] Account: {Action}` |
| Escalation | `[URGENT] NewPOPSys: {Escalation Type}` |

### B.12.2 Push Notification Character Limits

| Platform | Title Limit | Body Limit |
|----------|-------------|------------|
| iOS | 50 chars | 150 chars |
| Android | 65 chars | 240 chars |
| Web Push | 50 chars | 120 chars |

---

## B.13 Webhook Events

For integration users, the following events trigger webhooks:

| Event | Payload | Retry Policy |
|-------|---------|--------------|
| `campaign.published` | Campaign object | 3 retries, exponential backoff |
| `campaign.completed` | Campaign object + summary | 3 retries |
| `order.created` | Order + lines | 3 retries |
| `order.shipped` | Order + shipment + tracking | 3 retries |
| `order.delivered` | Order + delivery confirmation | 3 retries |
| `issue.created` | Issue object | 3 retries |
| `issue.resolved` | Issue object + resolution | 3 retries |
| `store.completed` | StoreAssignment + rollup | 3 retries |
| `photo.submitted` | Photo metadata (no image) | 3 retries |
| `photo.reviewed` | Photo + decision | 3 retries |

---

## B.14 Notification Delivery SLAs

| Priority | Delivery Target | Retry Attempts |
|----------|-----------------|----------------|
| CRITICAL | < 30 seconds | 5 |
| HIGH | < 2 minutes | 3 |
| NORMAL | < 10 minutes | 3 |
| LOW | < 1 hour | 2 |

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: SOW Functional Requirements, SUPP-002*
