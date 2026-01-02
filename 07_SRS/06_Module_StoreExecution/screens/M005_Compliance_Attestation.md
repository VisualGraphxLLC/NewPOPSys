# M005 - Compliance Attestation

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M005
> **Route**: `/app/campaign/:id/attest`
> **IEEE 830 Section**: 3.2.5 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

---

## 1. Screen Overview

### 1.1 Purpose

The Compliance Attestation screen is the final legal and operational sign-off for a campaign installation. It requires the store manager or authorized personnel to certify that all materials have been installed according to brand standards, documented via photos, and that any issues have been reported. It features a digital signature capture for accountability.

### 1.2 Scope

This specification covers:
- 4-point compliance checklist verification
- Final summary of installed items and captured photos
- Digital signature pad for manager sign-off
- Submission logic with validation for incomplete tasks
- Role-based restriction (Manager only for final sign-off)

### 1.3 Screenshot Reference

| Mobile View | Tablet View | Desktop View |
| :--- | :--- | :--- |
| ![Mobile Attest](../../screenshots/Store_Execution/mobile_attestation.png) | ![Tablet Attest](../../screenshots/Store_Execution/tablet_attestation.png) | ![Desktop Attest](../../screenshots/Store_Execution/desktop_attestation.png) |

### 1.4 Source Documents

| Document | Reference |
|----------|-----------|
| Screen Spec | [M05_Photo_Capture.md](../../../../06_Screen_Specs/M05_Photo_Capture.md) |
| SUPP Reference | SUPP-037 (Survey Builder and Store Surveys) |
| Photo Review | SUPP-018 (Photo Review) |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Description |
|------|--------------|-------------|
| Store Manager (P07) | Full | Can capture and upload photos |
| Store Operator (P08) | Execute | Can capture and upload photos for assigned tasks |

### 2.2 Role Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M005-ROLE-001 | System SHALL allow photo capture for users with STORE_MANAGER or STORE_OPERATOR roles | Must |
| REQ-M005-ROLE-002 | System SHALL associate photos with the authenticated user's store context | Must |
| REQ-M005-ROLE-003 | System SHALL validate user has access to the assignment item before capture | Must |

### 2.3 Permission Constraints

- User must have active `Membership` for the store
- Assignment item must belong to user's current store
- Campaign must be in PUBLISHED status with active install window

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Type | Description | Required |
|--------------|------|-------------|----------|
| COMP-M005-001 | Camera Preview | Full-screen live camera viewfinder | Yes |
| COMP-M005-002 | Ghost Overlay | Semi-transparent image layer at 50% opacity | Conditional |
| COMP-M005-003 | Instructions Banner | PhotoRule.instructions text display | Conditional |
| COMP-M005-004 | Flash Toggle | Icon button cycling Auto/On/Off | Yes |
| COMP-M005-005 | Shutter Button | FAB for photo capture | Yes |
| COMP-M005-006 | Gallery Button | Access existing photos | Yes |
| COMP-M005-007 | Close Button | Cancel and return to parent | Yes |
| COMP-M005-008 | Review Image | Full-resolution captured photo | Yes |
| COMP-M005-009 | Quality Warnings | Alert banners for issues | Conditional |
| COMP-M005-010 | Retake Button | Discard and recapture | Yes |
| COMP-M005-011 | Use Photo Button | Confirm and initiate upload | Yes |

### 3.2 Component Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M005-UI-001 | Camera viewfinder SHALL fill the entire screen | Must |
| REQ-M005-UI-002 | Ghost image SHALL display at 50% opacity when configured | Must |
| REQ-M005-UI-003 | Shutter button SHALL be minimum 60x60 pixels for touch accuracy | Must |
| REQ-M005-UI-004 | Flash toggle SHALL be locked to "On" when PhotoRule.required_flash = true | Must |
| REQ-M005-UI-005 | Review screen SHALL display captured image at full resolution | Must |
| REQ-M005-UI-006 | Quality warnings SHALL display in red/yellow alert banners | Should |

### 3.3 Camera View Layout

```
+---------------------------------------+
| [X]                            [Flash]|
|                                       |
|  +-------------------------------+    |
|  |                               |    |
|  |     Camera Viewfinder         |    |
|  |                               |    |
|  |  +-------------------------+  |    |
|  |  |     Ghost Image         |  |    |
|  |  |     (50% opacity)       |  |    |
|  |  +-------------------------+  |    |
|  |                               |    |
|  +-------------------------------+    |
|                                       |
|  "Align poster with outline"          |
|                                       |
|  [Gallery]    [Shutter]    [Switch]   |
+---------------------------------------+
```

### 3.4 Review View Layout

```
+---------------------------------------+
| Review Photo                      [X] |
+---------------------------------------+
|                                       |
|  +-------------------------------+    |
|  |                               |    |
|  |     Captured Image            |    |
|  |     (full resolution)         |    |
|  |                               |    |
|  +-------------------------------+    |
|                                       |
|  [!] Photo resolution too low         |
|                                       |
|  [Retake]             [Use Photo]     |
+---------------------------------------+
```

---

## 4. Data Requirements

### 4.1 Input Data

| Field | Type | Validation | Source |
|-------|------|------------|--------|
| `assignment_item_id` | UUID | Required, valid assignment item | Navigation param |
| `photo_rule_id` | UUID | Required, valid photo rule | From AssignmentItem |
| `image_data` | Blob | JPEG format, meets min_resolution | Device camera |

### 4.2 Output Data

| Field | Type | Description | Destination |
|-------|------|-------------|-------------|
| `photo_id` | UUID | Created PhotoUpload record ID | API response |
| `file_url` | URL | Cloud storage location | Database |
| `thumbnail_url` | URL | Generated thumbnail location | Database |
| `upload_status` | Enum | PENDING, UPLOADING, UPLOADED, FAILED | Database |

### 4.3 Photo Metadata Captured

| Field | Source | Purpose |
|-------|--------|---------|
| `captured_at` | Device timestamp | Audit trail |
| `device_model` | Device info | Troubleshooting |
| `gps_latitude` | Device GPS (if permitted) | Location verification |
| `gps_longitude` | Device GPS (if permitted) | Location verification |
| `file_size_bytes` | Image data | Storage metrics |
| `resolution` | Image dimensions | Quality tracking |

### 4.4 Data Model References

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `PhotoUpload` | id, file_url, thumbnail_url, upload_status, assignment_item_id | Write |
| `PhotoRule` | min_photos, max_photos, ghost_image_url, instructions, required_flash, min_resolution | Read |
| `AssignmentItem` | id, item_status | Read/Write |

### 4.5 Data Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M005-DATA-001 | System SHALL capture GPS coordinates when device permission granted | Should |
| REQ-M005-DATA-002 | System SHALL store device model and timestamp with each photo | Must |
| REQ-M005-DATA-003 | System SHALL generate thumbnails after successful upload | Must |
| REQ-M005-DATA-004 | System SHALL store photos in JPEG format | Must |

---

## 5. Business Rules & Validation

### 5.1 Photo Rule Enforcement

| Rule ID | Rule | Implementation |
|---------|------|----------------|
| BR-M005-001 | Photos must meet minimum resolution | Check image.width >= PhotoRule.min_resolution AND image.height >= PhotoRule.min_resolution |
| BR-M005-002 | Flash must be forced when required | If PhotoRule.required_flash = true, lock flash toggle to "On" |
| BR-M005-003 | Ghost image displays when configured | If PhotoRule.ghost_image_url is not null, overlay at 50% opacity |
| BR-M005-004 | Maximum photos per item enforced | Count existing photos; prevent capture if count >= PhotoRule.max_photos |

### 5.2 Quality Validation (v1)

| Check | Status | User Feedback |
|-------|--------|---------------|
| Resolution | v1 Implemented | "Photo resolution too low. Minimum: {min_resolution}px" |
| Brightness | v2 Future | "Image may be too dark" |
| Blur Detection | v2 Future | "Image appears blurry" |
| Orientation | v2 Future | "Please rotate device" |

### 5.3 Upload Queue Rules

| Rule ID | Rule | Value |
|---------|------|-------|
| BR-M005-005 | Maximum queued photos | 50 photos |
| BR-M005-006 | Retry attempts | 3 attempts with exponential backoff |
| BR-M005-007 | Retry delay | 1s, 2s, 4s (exponential) |
| BR-M005-008 | Queue full behavior | Warning shown, oldest synced first |

### 5.4 Flash Mode Settings

| Mode | Behavior | Icon |
|------|----------|------|
| Auto | Device decides based on lighting | Auto flash icon |
| On | Always fire flash | Flash on icon |
| Off | Never fire flash | Flash off icon |

### 5.5 Validation Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M005-VAL-001 | System SHALL validate resolution before allowing "Use Photo" | Must |
| REQ-M005-VAL-002 | System SHALL enforce PhotoRule.max_photos limit | Must |
| REQ-M005-VAL-003 | System SHALL display quality warnings but allow override | Should |
| REQ-M005-VAL-004 | System SHALL validate assignment item belongs to user's store | Must |

---

## 6. API Integration Points

### 6.1 Get Photo Rule

| Property | Value |
|----------|-------|
| **Endpoint** | `GET /api/v1/photo-rules/{ruleId}` |
| **Auth Required** | Yes (Bearer token) |

#### Response Schema (Success - 200)

```json
{
  "id": "uuid",
  "min_photos": 1,
  "max_photos": 3,
  "ghost_image_url": "https://cdn.example.com/ghost/poster-template.png",
  "instructions": "Align poster with outline",
  "required_flash": false,
  "min_resolution": 1024
}
```

### 6.2 Create Photo Upload

| Property | Value |
|----------|-------|
| **Endpoint** | `POST /api/v1/photos` |
| **Auth Required** | Yes (Bearer token) |

#### Request Schema

```json
{
  "assignment_item_id": "uuid",
  "captured_at": "2026-01-01T10:30:00Z",
  "device_model": "iPhone 14",
  "gps_latitude": 40.7128,
  "gps_longitude": -74.0060,
  "file_size_bytes": 524288,
  "resolution": "1920x1080"
}
```

#### Response Schema (Success - 201)

```json
{
  "id": "uuid",
  "presigned_url": "https://s3.example.com/upload?signature=...",
  "expires_at": "2026-01-01T10:45:00Z"
}
```

### 6.3 Confirm Upload

| Property | Value |
|----------|-------|
| **Endpoint** | `PATCH /api/v1/photos/{id}/confirm` |
| **Auth Required** | Yes (Bearer token) |

#### Response Schema (Success - 200)

```json
{
  "id": "uuid",
  "file_url": "https://cdn.example.com/photos/uuid.jpg",
  "thumbnail_url": "https://cdn.example.com/thumbs/uuid.jpg",
  "upload_status": "UPLOADED"
}
```

### 6.4 API Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M005-API-001 | System SHALL use presigned URLs for direct S3 upload | Must |
| REQ-M005-API-002 | System SHALL confirm upload completion via API call | Must |
| REQ-M005-API-003 | System SHALL include device metadata in upload request | Must |
| REQ-M005-API-004 | System SHALL handle expired presigned URLs with refresh | Should |

---

## 7. State Transitions

### 7.1 Photo Upload State Machine

```
[PENDING] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                       â”‚
   â”‚ Get presigned URL     â”‚ Error
   â–¼                       â”‚
[UPLOADING] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
   â”‚                       â”‚
   â”‚ Upload complete       â”‚ Network error
   â–¼                       â–¼
[UPLOADED]             [FAILED]
   â”‚                       â”‚
   â”‚ Thumbnail             â”‚ Retry < 3
   â”‚ generated             â–¼
   â–¼                   [PENDING] (retry)
[COMPLETE]
```

### 7.2 Camera Flow State Machine

```
[INITIALIZING] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                       â”‚
   â”‚ Camera ready          â”‚ Permission denied
   â–¼                       â–¼
[VIEWFINDER]           [ERROR]
   â”‚
   â”‚ Shutter pressed
   â–¼
[CAPTURING]
   â”‚
   â”‚ Image captured
   â–¼
[REVIEWING]
   â”‚         â”‚
   â”‚ Retake  â”‚ Use Photo
   â–¼         â–¼
[VIEWFINDER] [UPLOADING]
               â”‚
               â”‚ Complete
               â–¼
           [SUCCESS]
```

### 7.3 Offline Queue State Machine

```
[QUEUED] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                      â”‚
   â”‚ Network available    â”‚ Queue full
   â–¼                      â–¼
[UPLOADING]           [WARNING]
   â”‚         â”‚
   â”‚ Success â”‚ Failure
   â–¼         â–¼
[SYNCED]  [RETRY_PENDING]
             â”‚
             â”‚ Retry attempt
             â–¼
         [UPLOADING]
```

### 7.4 State Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M005-STATE-001 | System SHALL persist queued photos in IndexedDB | Must |
| REQ-M005-STATE-002 | System SHALL resume uploads when connectivity restored | Must |
| REQ-M005-STATE-003 | System SHALL update parent screen on upload completion | Must |
| REQ-M005-STATE-004 | System SHALL handle camera permission denial gracefully | Must |

---

## 8. Error Handling

### 8.1 Error Categories

| Category | Handling Approach |
|----------|-------------------|
| Camera Permission | Display permission request with explanation |
| Camera Initialization | Retry with fallback to gallery selection |
| Quality Validation | Display warning, allow user override |
| Upload Failure | Queue for retry, show pending indicator |
| Storage Full | Alert user to free space |

### 8.2 Error Messages

| Error Code | User Message | Technical Action |
|------------|--------------|------------------|
| `CAMERA_PERMISSION_DENIED` | "Camera access required. Please enable in settings." | Link to device settings |
| `CAMERA_INIT_FAILED` | "Unable to start camera. Try again." | Retry button |
| `RESOLUTION_TOO_LOW` | "Photo resolution too low. Minimum: {X}px" | Prevent submission |
| `UPLOAD_FAILED` | "Upload failed. Will retry automatically." | Queue for background retry |
| `STORAGE_FULL` | "Device storage full. Please free up space." | Cannot capture |
| `QUEUE_FULL` | "Too many pending uploads. Please wait for sync." | Block new captures |

### 8.3 Offline Behavior

| Scenario | Behavior |
|----------|----------|
| Capture while offline | Photo saved to IndexedDB queue |
| Review while offline | Works normally (local image) |
| Upload while offline | Queued for background upload |
| Queue limit reached | Warning shown, block new captures |
| Connection restored | Background sync resumes |

### 8.4 Local Storage Structure

```javascript
{
  "photoQueue": [
    {
      "localId": "uuid-123",
      "assignmentItemId": "uuid-456",
      "imagePath": "/local/photos/uuid-123.jpg",
      "capturedAt": "2026-01-01T10:30:00Z",
      "status": "queued", // queued | uploading | failed
      "retryCount": 0,
      "metadata": {
        "device_model": "iPhone 14",
        "gps_latitude": 40.7128,
        "gps_longitude": -74.0060
      }
    }
  ]
}
```

### 8.5 Error Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M005-ERR-001 | System SHALL queue failed uploads for automatic retry | Must |
| REQ-M005-ERR-002 | System SHALL display pending upload count to user | Must |
| REQ-M005-ERR-003 | System SHALL retry uploads with exponential backoff | Should |
| REQ-M005-ERR-004 | System SHALL notify user when offline queue is full | Must |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Req ID | Requirement | WCAG Criterion | Priority |
|--------|-------------|----------------|----------|
| REQ-M005-A11Y-001 | Camera controls SHALL be operable via keyboard/switch | 2.1.1 Keyboard | Must |
| REQ-M005-A11Y-002 | Status messages SHALL be announced by screen readers | 4.1.3 Status Messages | Must |
| REQ-M005-A11Y-003 | Touch targets SHALL be minimum 44x44 pixels | 2.5.5 Target Size | Must |
| REQ-M005-A11Y-004 | Quality warnings SHALL use icons and text, not color alone | 1.4.1 Use of Color | Must |
| REQ-M005-A11Y-005 | Shutter button SHALL have audio feedback option | Non-visual feedback | Should |

### 9.2 Assistive Technology Support

| Feature | Implementation |
|---------|----------------|
| Screen Reader | ARIA live regions for capture/upload status |
| Voice Control | Named buttons ("Take Photo", "Use Photo") |
| Haptic Feedback | Vibration on shutter press |
| Audio Feedback | Optional shutter sound |

### 9.3 ARIA Implementation

```html
<div role="application" aria-label="Photo Capture">
  <button aria-label="Close camera" id="close-btn">X</button>
  <button aria-label="Flash mode: Auto" id="flash-toggle">Flash</button>

  <div role="img" aria-label="Camera viewfinder">
    <!-- Camera preview -->
  </div>

  <p aria-live="polite" id="instructions">
    Align poster with outline
  </p>

  <button aria-label="Take photo" id="shutter-btn">Capture</button>

  <div role="alert" id="quality-warning" aria-live="assertive">
    Photo resolution too low
  </div>
</div>
```

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance

| AC ID | Criterion | Verification Method |
|-------|-----------|---------------------|
| AC-M005-001 | Camera opens with full-screen viewfinder | Manual test |
| AC-M005-002 | Ghost image overlay displays at 50% opacity when configured | Manual test |
| AC-M005-003 | Instructions banner shows PhotoRule.instructions | API integration test |
| AC-M005-004 | Flash toggle respects required_flash setting | Manual test |
| AC-M005-005 | Review screen shows captured image full-size | Manual test |
| AC-M005-006 | Quality warning displays for low resolution (v1) | Automated test |
| AC-M005-007 | "Use Photo" initiates background upload | E2E test |
| AC-M005-008 | Upload progress visible in parent screen | E2E test |
| AC-M005-009 | Failed uploads retry automatically | Automated test |
| AC-M005-010 | Offline photos queue for later upload | Offline test |

### 10.2 Non-Functional Acceptance

| AC ID | Criterion | Target | Verification |
|-------|-----------|--------|--------------|
| AC-M005-NF-001 | Camera initialization time | < 2 seconds | Performance test |
| AC-M005-NF-002 | Photo capture latency | < 500ms | Performance test |
| AC-M005-NF-003 | Upload queue capacity | 50 photos | Stress test |
| AC-M005-NF-004 | Retry mechanism reliability | 99% eventual success | Reliability test |

### 10.3 Security Acceptance

| AC ID | Criterion | Verification |
|-------|-----------|--------------|
| AC-M005-SEC-001 | Presigned URLs expire within 15 minutes | Security audit |
| AC-M005-SEC-002 | Photos stored with tenant isolation | Security audit |
| AC-M005-SEC-003 | GPS data only captured with user consent | Permission flow test |
| AC-M005-SEC-004 | Local queue encrypted at rest | Security audit |

---

## 11. Traceability Matrix

| Requirement | Source | Test Case |
|-------------|--------|-----------|
| REQ-M005-ROLE-001 | SUPP-037 | TC-M005-001 |
| REQ-M005-UI-002 | SUPP-037 | TC-M005-002 |
| REQ-M005-VAL-001 | PhotoRule Schema | TC-M005-003 |
| REQ-M005-API-001 | SUPP-037 | TC-M005-004 |
| REQ-M005-A11Y-003 | WCAG 2.1 | TC-M005-005 |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.5 - User Interface Requirements*
