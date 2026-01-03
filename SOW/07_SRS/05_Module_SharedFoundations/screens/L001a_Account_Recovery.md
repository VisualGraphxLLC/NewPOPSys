# L001a Account Recovery - Screen Specification

> **SRS Section**: 5.1.2 | **Screen ID**: L001a | **Version**: 1.0
> **Module**: SharedFoundations
> **Route**: `/login/recovery`
> **Last Updated**: 2026-01-03

---

## 1. Screen Overview

### 1.1 Purpose
The Account Recovery screen enables users to reset their forgotten passwords. It follows a secure workflow involving email verification to prevent account enumeration and unauthorized access.

### 1.2 Screenshot Reference

| Request Reset | Reset Link Sent |
| :---: | :---: |
| ![Forgot Password](../../screenshots/Auth_Login/forgot_password.png) | ![Reset Sent](../../screenshots/Auth_Login/reset_password_sent.png) |

---

## 2. Functional Requirements

### 2.1 Request Flow
| ID | Requirement | Priority |
| :--- | :--- | :--- |
| REQ-L001a-FR-001 | User enters email address to request reset map | Must |
| REQ-L001a-FR-002 | System sends email with time-limited token (1 hour) | Must |
| REQ-L001a-FR-003 | success message displayed even if email not found (Security) | Must |

### 2.2 Reset Flow
| ID | Requirement | Priority |
| :--- | :--- | :--- |
| REQ-L001a-FR-004 | User clicks email link to access Reset Password form | Must |
| REQ-L001a-FR-005 | Password complexity rules enforced (12+ chars, special chars) | Must |
| REQ-L001a-FR-006 | Confirm password field required | Must |

---

## 3. Data Requirements

### 3.1 API Endpoints
- `POST /auth/recovery/request` - Initiate reset
- `POST /auth/recovery/confirm` - Validate token and set new password

---

*Document Status: Active*
