# Campaign Manager Persona

**Document ID:** SRS-4.4.2
**Version:** 1.0
**System:** NewPOPSys v1.38
**Category:** Brand Level Persona
**Last Updated:** 2026-01-01

---

## 1. Persona Overview

### 1.1 Role Definition

The Campaign Manager is responsible for building, configuring, and managing POP marketing campaigns within assigned scope. This persona focuses on campaign creation, kit definition, store selection, proof review, and performance monitoring. Campaign Managers operate with restricted access limited to campaigns explicitly assigned to them by a Brand Admin.

### 1.2 Primary Responsibility

Build new campaigns, manage assigned campaigns, define kits and photo rules, review proofs, and approve campaign completions.

### 1.3 Permission Level

**Must be assigned to campaigns** - Access is explicitly scoped to:
- Campaigns where the user has been granted assignment
- Stores participating in assigned campaigns
- Execution data related to assigned campaigns only
- No access to brand-wide configuration or user management

---

## 2. Jobs to Be Done (JTBD)

### 2.1 Primary Jobs

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| CM-J01 | Build and configure new campaigns with complete specifications | Critical |
| CM-J02 | Define kit contents with accurate item-to-location slot mappings | Critical |
| CM-J03 | Select appropriate stores for campaign participation | Critical |
| CM-J04 | Review and approve/reject proof photo submissions | Critical |
| CM-J05 | Monitor campaign performance and identify execution issues | High |
| CM-J06 | Manage retake requests and ensure photo quality standards | High |
| CM-J07 | Generate campaign-specific reports for stakeholder communication | Medium |

### 2.2 Functional Requirements

- **FR-CM-001:** The system shall restrict Campaign Manager access to only campaigns with explicit assignment.
- **FR-CM-002:** The system shall provide Campaign Manager with full campaign builder capabilities for assigned campaigns.
- **FR-CM-003:** The system shall enable Campaign Manager to reject specific photos with mandatory reason codes.
- **FR-CM-004:** The system shall display real-time campaign metrics on the Campaign Manager dashboard.
- **FR-CM-005:** The system shall allow Campaign Manager to export reports for assigned campaigns only.

---

## 3. Primary Workflows

### 3.1 Campaign Creation Workflow

1. **Define Campaign Parameters**
   - Set campaign type: expiring (promotional) or core branding (permanent)
   - Configure timeline: start date, end date, key milestones
   - Write installation instructions and special handling notes
   - Select verification mode: STRICT (requires review) or FAST (auto-complete)
   - Set verification SLA (time allowed for proof review)
   - Define deinstall rules if applicable

2. **Define Kit Configuration**
   - Add items to campaign kit
   - Map each item to required location slots
   - Attach mockup images and reference photos
   - Configure photo rules: required angles, minimum count, quality standards
   - Set defaults and define any campaign-specific overrides

3. **Select Target Stores**
   - Choose selection method: all stores, by region, by group, or custom list
   - Apply inclusion criteria
   - Apply exclusion criteria
   - Preview final store selection recipe
   - Validate store count and distribution

4. **Publish Campaign**
   - Review complete campaign configuration
   - Initiate publish action
   - System generates store assignments and orders
   - PSP receives notification for production planning

### 3.2 Proof Review Workflow

1. Access Review Queue for assigned campaigns.
2. Open proof submission (photo + slot packet).
3. Evaluate photos against quality standards and mockup references.
4. For acceptable submissions: approve proof to complete store execution.
5. For unacceptable submissions:
   - Reject specific photos (not entire submission)
   - Select mandatory reason code for each rejection
   - Store receives retake notification
6. Monitor Retake Queue for resubmissions.
7. Repeat review process until satisfied or waiver applied (by Brand Admin).

### 3.3 Campaign Monitoring Workflow

1. Access Dashboard for assigned campaigns.
2. Review key metrics: completion %, late shipping, anomalies, issue counts, rejection counts.
3. Drill into Store Detail for underperforming locations.
4. Identify patterns requiring intervention.
5. Generate reports for stakeholder updates.
6. Escalate systemic issues to Brand Admin.

---

## 4. Key Screens Accessed

| Screen/Module | Purpose | Access Frequency |
|---------------|---------|------------------|
| Campaign Builder | Create and configure campaign parameters | Weekly |
| Store Selector | Define store participation criteria | Weekly |
| Kit/Items Editor | Configure kit contents and slot mappings | Weekly |
| Photo Rules | Set photo requirements and quality standards | Weekly |
| Dashboard | Monitor campaign performance metrics | Daily |
| Store Detail | View individual store execution status | Daily |
| Review Queue | Approve or reject proof submissions | Daily |
| Retake Queue | Monitor and manage photo retake requests | Daily |
| Exports/Reports | Generate campaign-specific reports | Weekly |

---

## 5. Permission Scope

### 5.1 Data Access

| Resource Type | Create | Read | Update | Delete |
|---------------|--------|------|--------|--------|
| Campaigns (Assigned) | Yes | Yes | Yes | No |
| Campaigns (Unassigned) | No | No | No | No |
| Kits (Assigned Campaigns) | Yes | Yes | Yes | Yes |
| Stores (Assigned Campaigns) | No | Yes | No | No |
| Proofs (Assigned Campaigns) | No | Yes | Yes | No |
| Reports (Assigned Campaigns) | Yes | Yes | N/A | N/A |
| Brand Configuration | No | No | No | No |
| User Management | No | No | No | No |

### 5.2 Campaign Actions

- Create new campaigns (pending Brand Admin assignment for activation)
- Modify campaign configuration before and during execution
- Approve proof submissions
- Reject individual photos with reason codes
- Request retakes from stores
- Export campaign data and reports

### 5.3 Restricted Actions

- Cannot access campaigns without explicit assignment
- Cannot apply completion waivers (Brand Admin only)
- Cannot force-complete campaigns (Brand Admin only)
- Cannot manage user accounts or permissions
- Cannot modify brand-level configuration

---

## 6. Success Metrics

### 6.1 Key Performance Indicators

| Metric ID | Metric Name | Target | Measurement Frequency |
|-----------|-------------|--------|----------------------|
| CM-KPI-01 | Campaign On-Time Launch Rate | 100% | Per campaign |
| CM-KPI-02 | Proof Review Turnaround | <= 24 hours | Daily |
| CM-KPI-03 | First-Pass Approval Rate | >= 80% | Per campaign |
| CM-KPI-04 | Retake Resolution Time | <= 48 hours | Weekly |
| CM-KPI-05 | Campaign Completion Rate | >= 95% | Per campaign |
| CM-KPI-06 | Store Participation Accuracy | 100% correct selection | Per campaign |

### 6.2 Quality Indicators

- Zero campaigns launched with incomplete kit definitions
- All rejections include valid reason codes
- Dashboard reviewed daily for active campaigns
- Escalations to Brand Admin documented appropriately

---

## 7. References

- SUPP-001: Shared Foundations - Persona Workflows JTBD Screens
- SRS-4.1: Persona Matrix
- SRS-4.2: Permission Matrix

---

*Document Control: This persona specification is part of the NewPOPSys v1.38 SRS documentation suite.*
