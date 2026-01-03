# A007 - Global Templates (Masters)

> **Module**: PlatformAdmin
> **Screen ID**: A007
> **Route**: `/admin/templates`
> **Version**: 1.0
> **Last Updated**: 2026-01-03
> **IEEE 830 Compliance**: Section 3.2 - Functional Requirements

---

## 1. Screen Overview

### 1.1 Purpose
Allows PSP Admins to create, manage, and distribute **Master Survey Templates** and **Master Store Layouts**. These masters serve as the baseline that Brands can "inherit" from to jumpstart their own operational setup.

### 1.2 Users
- **Platform Admin / PSP Admin**: Full access to create/edit/push masters.

---

## 2. Features

### 2.1 Survey Template Library
- **List View**: Display all Master Survey Templates.
- **Columns**: Name, Version, Type (Layout, Exception, Campaign), Assigned Brands, Status (Draft, Active, Archived).
- **Actions**:
    -   `Create New Master`: Opens the shared Survey Builder component in "Master Mode".
    -   `Push Update`: Notifies assigned brands of a new master version.
    -   `Force Sync`: (Admin Only) Overwrites brand templates (use with caution).

### 2.2 Layout Template Library
- **List View**: Display Master Store Layouts (e.g., "Standard Mall Store", "Airport Kiosk").
- **Features**:
    -   Define standard nodes (Windows, Gondolas, Endcaps).
    -   Define distinct "Store Types" that these layouts apply to.

### 2.3 Brand Availability Matrix
- **Purpose**: Control which brands have access to which masters.
- **UI**: A matrix or multi-select list to "Publish" a master to specific tenants (e.g., "Good2Go" sees "Standard k-stop" layout, but "RetailCo" does not).

---

## 3. Data Requirements

### 3.1 Entities
- `MasterSurveyTemplate`: The definition.
- `MasterStoreLayout`: The definition.
- `BrandSubscription`: Link table (MasterID <-> BrandID).

### 3.2 Key Logic
- **Inheritance**: When a Brand "uses" a Master, the system creates a `BrandSurveyTemplate` copy.
- **Linkage**: The copy retains a `originMasterId` reference to allow future diffs/updates.

---

## 4. Acceptance Criteria
1.  Admin can create a standard "Receipt Verification" master survey.
2.  Admin can assign this master to "Acme Corp" brand.
3.  Acme Corp (in B008) sees this master available to import.
4.  Admin can update the master to v2 and "Push" the notification.
