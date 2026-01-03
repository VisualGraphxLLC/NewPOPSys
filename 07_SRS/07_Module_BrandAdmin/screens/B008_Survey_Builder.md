# B008 - Survey Builder

> **Module**: BrandAdmin
> **Screen ID**: B008
> **Route**: `/brand/surveys`
> **Version**: 1.0
> **Last Updated**: 2026-01-03
> **IEEE 830 Compliance**: Section 3.2 - Functional Requirements

---

## 1. Screen Overview

### 1.1 Purpose
Allows Brand Administrators and Campaign Managers to create and edit **Brand Survey Templates**. These are the operational definitions used for actual store visits and campaign reporting.

### 1.2 Users
- **Brand Admin**: Full access.
- **Campaign Manager**: Can create/edit surveys for their campaigns.

---

## 2. Features

### 2.1 Template Source Selection (New Survey)
When creating a new survey, the user chooses a starting point:
1.  **Blank Canvas**: Start from scratch.
2.  **From Master**: Select from the list of `MasterSurveyTemplate`s assigned by the PSP (see A007).
3.  **Clone Existing**: Copy a previous brand survey.

### 2.2 Survey Editor (Canvas)
- **Visual Builder**: Drag-and-drop question types (Text, Photo, Boolean, Multiple Choice).
- **Master Sync Status**: If linked to a Master, show a "Sync Status" indicator.
    -   *Synced*: Matches Master vX.
    -   *Ejected*: Custom changes made that break the link.
- **Logic**: Define visibility rules (e.g., "Show Question B if Question A is Yes").

### 2.3 Metadata & Settings
- **Survey Type**:
    -   *Store Verification*: Tied to Campaign execution.
    -   *Exception Report*: Standalone issue reporting.
    -   *Competitor Analysis*: Market intelligence.
- **Version Control**: Publishing a survey creates an immutable `SurveyVersion`.

---

## 3. Data Requirements

### 3.1 Entities
- `BrandSurveyTemplate` (The working draft).
- `SurveyVersion` (Snapshot used in campaigns).
- `MasterSurveyTemplate` (Read-only source).

### 3.2 Key Logic
- **Locking**: Surveys used in active campaigns cannot be edited; a new version must be created.
- **Inheritance**: If "From Master", pre-populate fields from the Master definition.

---

## 4. Acceptance Criteria
1.  User can creating a new survey using the "Mall Display Master" provided by PSP.
2.  User can add a custom "Promo Price Check" question to this survey.
3.  User can publish the survey and assign it to the "Summer 2026" campaign.
