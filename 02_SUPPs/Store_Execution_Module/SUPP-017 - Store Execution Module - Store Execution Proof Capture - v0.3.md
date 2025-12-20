# SUPP-017 — Store Execution Module — Mobile Workflows

> **Version**: v0.3  
> **Status**: Locked  
> **Updated**: 2025-12-18  
> **Dependencies**: SUPP-015 (Task Gen), SUPP-014 (Layouts)

---

## Purpose
Define the mobile-first execution workflow for stores: The "Two-Stage" Survey Model (Receipt & Install).

---

## 1. Mobile Journey Overview

1.  **Notification**: "New Campaign: Spring Promo. Shipment arriving soon."
2.  **Stage 1: Receipt Survey** (Logistics)
    - Triggered when shipment is In Transit/Delivered.
    - Goal: Confirm inventory before install day.
3.  **Stage 2: Install Survey** (Execution)
    - Triggered on Campaign Start.
    - Goal: Prove correct installation via photos.
4.  **Completion**: Attestation & Submit.

---

## 2. Stage 1: Receipt Survey (UX)
*Design Goal: Fast confirmation.*

- **View**: Checklist of all items in `StoreOrder`.
- **Interaction**:
    - "Select All" to confirm receipt.
    - Tap item to report exception (Missing/Damaged).
- **Exceptions**:
    - Reporting "Missing" or "Damaged" automatically triggers an **Issue Report** (SUPP-019).
    - Requires photo evidence if "Damaged".
- **Outcome**: `ReceiveVerification` record saved.

---

## 3. Stage 2: Install Survey (UX)
*Design Goal: "Walk the Store".*

![One Item @ One Slot](../04_Reference/One%20item%20@%20one%20slot.png)

- **View**: Items grouped by **Location Slot** (defined in Store Layout).
    - *Example Group*: "Front Entrance"
        - Item 1: Window Cling (Photo Required)
        - Item 2: Door Decal (Photo Required)
- **Photo Capture**:
    - User taps "Take Photo".
    - Camera overlay shows **Ghost Image / Mockup** (if available).
    - Validation: "Too dark" / "Blurry" warnings (future scope, v1 placeholder).
- **Progress**: visual progress bar (e.g. "3/5 Slots Complete").

![Status Interrelation](../04_Reference/Promo%20Item%20-%20Slot%20status%20interrelation.png)

---

## 4. Completion & Uploads
- **Sync**: "Upload as you go" (background) to minimize wait at end.
- **Offline**: Full support for drafting. "Sync Status" indicator.
- **Attestation**: Final screen requires signature/checkbox: "I certify these items are installed correctly."

---

## 5. Acceptance Criteria
1.  **Receipt**: Checklist matches shipment line items.
2.  **Exceptions**: Reporting damage prompts for photo and creates IssueRequest.
3.  **Install**: Items are grouped by Location Slot (not big flat list).
4.  **Photos**: Camera launches from task; photo links to item+slot.
5.  **Offline**: User can complete survey without data; syncs when online.

