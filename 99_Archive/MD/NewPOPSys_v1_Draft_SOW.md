**STATEMENT OF WORK (SOW)**

*NewPOPSys v1 --- Draft for Development Scoping*

  ---------------------------------------------------------------------------
  **Project Name**                       NewPOPSys v1
  -------------------------------------- ------------------------------------
  **Client / Sponsor**                   \[PSP / Sponsor Name\]

  **Service Provider / Delivery Team**   \[Delivery Team / AI Agent Swarm\]

  **Version**                            v0.1 (Draft)

  **Date**                               \[YYYY-MM-DD\]
  ---------------------------------------------------------------------------

# Document Control Sheet

  -----------------------------------------------------------------------
  **Current Version**                 v0.1
  ----------------------------------- -----------------------------------
  **Project Code**                    NEWPOPSYS-V1-SOW

  **Project Name**                    NewPOPSys v1

  **Document Type**                   Statement of Work (SOW) --- Draft

  **Author**                          \[Name\]

  **Reviewed By**                     \[Name(s)\]

  **Frequency of Document Review**    Bi-weekly (written update)

  **Document Creation Date**          \[YYYY-MM-DD\]

  **Last Updated Date**               \[YYYY-MM-DD\]
  -----------------------------------------------------------------------

# Revision History

  -----------------------------------------------------------------------------------------
  **Version**       **Date**          **Author**        **Comments**
  ----------------- ----------------- ----------------- -----------------------------------
  v0.1              \[YYYY-MM-DD\]    \[Name\]          Initial draft from reference docs

  -----------------------------------------------------------------------------------------

# Document References

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  **\#**            **File Name**                                                    **Description**                                                     **Link / Location**
  ----------------- ---------------------------------------------------------------- ------------------------------------------------------------------- ---------------------
  1                 NewPOPSys -- Platform Direction & Execution Guide (v1 PSP-Led)   Canonical direction for v1 scope, UX principles, delivery targets   \[Attach/link\]

  2                 NewPOPSys -- Developer Starting Guide                            Personas, core loop, core objects, v1 priorities, retention         \[Attach/link\]

  3                 NewPOPSys v1 -- What This Platform Will Never Be                 Explicit out-of-scope constraints to prevent creep                  \[Attach/link\]

  4                 NewPOPSys -- SaaS Evolution & Market Expansion Strategy          Future phases; architecture implications; optionality               \[Attach/link\]

  5                 PrecisionPOP Product Walkthrough                                 Legacy workflows to be modernized in v1                             \[Attach/link\]
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Contents

Insert an auto-updating Table of Contents in Word: **References → Table of Contents → Automatic Table**

After updates, right-click the table and select **Update Field**

# 1. Document Preamble

This draft SOW is intended to scope NewPOPSys v1 development in a way that supports AI-agent assisted delivery while keeping strict control of scope, schedule, and acceptance.

## 1.1 Purpose of the Document

Define v1 scope, deliverables, timeline, and acceptance criteria for building NewPOPSys as a PSP-led campaign orchestration platform.

## 1.2 Document Audience

• Product / business sponsor(s)

• Engineering and delivery team (human + AI agents)

• PSP operational stakeholders

• Brand and regional oversight stakeholders

## 1.3 Definitions and Acronyms

• PSP: Print Service Provider

• v1: Version 1 initial release

• Not-Now List: Protected list of excluded features for v1

# 2. Project Summary

## 2.1 Executive Summary

NewPOPSys v1 is a PSP-led campaign orchestration platform that records what was ordered, what was shipped, what was installed, and what proof exists---without spreadsheets or email chains. v1 is a modernized, feature-matched evolution of the legacy PrecisionPOP system with a mobile-first store experience, clean workflows, and a scalable foundation.

## 2.2 Objectives and Success Criteria

Objectives:

• Deliver a feature-matched modernization of PrecisionPOP core workflows (campaigns → stores → kits/orders → execution → verification → reporting).

• Improve store execution clarity with mobile-first UX and fast paths for common actions.

• Improve PSP operational efficiency with predictable order generation and clear specs.

• Maintain clean APIs and data models so future integrations can be added without rewrites.

Success criteria (initial):

• Beta v1 delivered by end of Q1 (calendar year to be specified).

• Core workflows operational end-to-end for at least one pilot brand and store set.

• No expansion into MIS, marketplace, or advanced analytics features in v1.

## 2.3 Background and Current State

Legacy PrecisionPOP workflows include store profiles (attribute surveys), kits & inventory tracking, status updates, issue/reorder requests, photo uploads, and activity logs. These workflows inform v1 requirements but will be re-implemented with modern UX and a scalable backend.

## 2.4 Assumptions About AI-Assisted Delivery

The delivery approach assumes extensive use of AI agents for decomposing requirements, generating code scaffolding, writing tests, and maintaining documentation. Human approval points are required at milestone boundaries and for any scope change.

# 3. Scope of Work

## 3.1 In-Scope (v1)

• Campaign management fundamentals (campaigns, store assignment, timelines, instructions)

• Store profiles and attributes (as required by current workflows)

• Surveys (modernized UX; progressive disclosure)

• Kits and kit contents (including large kits)

• Order/fulfillment intake for PSP operations

• Execution status tracking (item and kit level)

• Issue reporting (missing/damaged) and reorder signaling

• Photo upload / verification artifacts

• Activity logging / audit history

• Role-based access (PSP admin, brand, regional, store)

• Baseline reporting for brand/regional + PSP operational views

## 3.2 Out-of-Scope / Protected Not-Now List (v1)

• Installer marketplace / bidding system

• Full PSP MIS (costing, accounting, scheduling, payroll)

• Advanced analytics / benchmarking beyond baseline visibility

• Long-term archival storage beyond the retention policy

• AI automation features beyond data readiness and scaffolding

Rule of thumb: if it does not directly support campaign orchestration, PSP fulfillment efficiency, or store execution clarity, it is not v1.

## 3.3 Deliverables

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  **Deliverable**                           **Description**                                                                                   **Acceptance Criteria (Summary)**   **Notes**
  ----------------------------------------- ------------------------------------------------------------------------------------------------- ----------------------------------- -----------------
  **Requirements & Scope Package**          Approved SOW + prioritized backlog (epics/stories) + acceptance criteria                          \[To be defined per deliverable\]   

  **Information Architecture & UX Flows**   Key screens and mobile-first store flows; progressive survey and large kit UX patterns            \[To be defined per deliverable\]   

  **Core Domain Backend**                   API + data model for campaigns, stores, kits, orders, execution states, photos, activity events   \[To be defined per deliverable\]   

  **Role-Based Access Control**             PSP admin, brand, regional, store roles; permissions enforced in UI + API                         \[To be defined per deliverable\]   

  **Store Execution Experience**            Mobile-first flows: receive → install → issue/reorder → photo → confirm                           \[To be defined per deliverable\]   

  **PSP Fulfillment Views**                 Order/fulfillment intake and operational views for fulfillment processing                         \[To be defined per deliverable\]   

  **Baseline Reporting**                    Brand/regional visibility dashboards + PSP operational views                                      \[To be defined per deliverable\]   

  **CI/CD + Environments**                  Dev/Staging/Prod pipeline, logging, and auditing                                                  \[To be defined per deliverable\]   

  **Testing & UAT**                         Automated tests + UAT plan + resolved critical defects                                            \[To be defined per deliverable\]   

  **Documentation**                         User guides + admin guides + developer/runbook docs (including agent harness docs)                \[To be defined per deliverable\]   
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 3.4 Acceptance and Sign-Off

Acceptance is based on meeting deliverable criteria, passing agreed test plan, and resolving Sev 1--2 defects.

# 4. Timeline and Milestones

Delivery targets (from platform direction):

• SOW finalized by end of year (Christmas preferred)

• Beta v1 delivered by end of Q1

• Target budget: \$150,000

If a feature threatens timeline or budget, it moves to the Not-Now list.

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  **Milestone**                                               **Start**      **End**        **Dependencies**                      **Exit / Acceptance Criteria**
  ----------------------------------------------------------- -------------- -------------- ------------------------------------- ---------------------------------------------------
  Milestone 0: Scope Freeze + Backlog                         \[Start\]      \[End\]        Reference docs + stakeholder review   Signed SOW + prioritized backlog

  Milestone 1: Foundations                                    \[Start\]      \[End\]        Tech stack decisions                  Repo + CI/CD + auth + tenant model

  Milestone 2: Core Domain (Campaign → Assignment → Orders)   \[Start\]      \[End\]        Milestone 1                           Core APIs and basic UI flows

  Milestone 3: Store Execution + Verification                 \[Start\]      \[End\]        Milestone 2                           Mobile-first execution flows + photo upload

  Milestone 4: Reporting + UAT + Beta                         \[Start\]      \[End\]        Milestone 3                           Baseline dashboards + UAT sign-off + beta release
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 5. Target Platforms and Users

## 5.1 Target Platforms

• Mobile-first experience for store execution

• Desktop web supports administration and reporting

• API-first backend for future integrations

## 5.2 Primary Personas

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  **Persona**                 **Goals**                                                 **Primary Workflows**
  --------------------------- --------------------------------------------------------- -------------------------------------------------------------------------
  **PSP Admin**               Configures programs, fulfills campaigns, supports users   Program setup, fulfillment intake, operational dashboards

  **Central Brand Manager**   Creates campaigns and selects stores                      Campaign creation, store assignment, visibility dashboards

  **Regional Manager**        Monitors progress and intervenes by exception             Exception-first oversight, escalation, progress monitoring

  **Store Manager**           Executes campaigns in the field                           Receive kits, install, submit issues, upload photos, confirm completion
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 6. Roles, Responsibilities, and Governance

## 6.1 Communication Cadence

• Bi-weekly written updates: summary, progress, risks/blockers, decisions needed, next two-week plan.

• Escalation outside cadence only for material budget impact, major architectural pivot, or directional change request.

## 6.2 Scope Control Rule

All scope changes require tradeoffs; anything new pushes something else out.

# 7. Requirements and Design

## 7.1 Authoritative Artifacts

Authoritative sources for v1 scope and constraints: Platform Direction, Developer Starting Guide, and What-It-Will-Never-Be.

## 7.2 Functional Modules (Proposed)

• Tenant / Program configuration (PSP-managed environment)

• User management and role-based access

• Campaign management + store assignment

• Store profiles + surveys (progressive disclosure)

• Kits + kit contents

• Order generation + PSP fulfillment intake

• Store execution (receive → install → confirm)

• Issue reporting + reorder signaling

• Photo upload + verification artifacts

• Activity logging / audit history

• Baseline reporting (brand/regional + PSP operations)

• Notifications (email/in-app) --- if required for workflow completion

# 8. Non-Functional Requirements (Initial)

• Data retention: operational campaign data retained 90 days after completion; export option offered; otherwise deleted.

• Auditability: activity/audit events for key actions (campaign changes, status updates, uploads).

• Mobile-first performance for store workflows (fast paths).

• Security: role-based access and tenant separation.

# 9. Technology and Environment Specifications (Direction)

• Campaign-centric domain model: campaign → assignments → kits/orders → execution states → verification artifacts.

• Tenant awareness: PSP-managed environment with separation of brand/store data inside PSP context.

• API-first services for future integrations and internal modularity.

• Event hooks/webhooks readiness for downstream systems (DAM, prepress, W2P, AI).

• Cloud-ready deployment with CI/CD, logging, and role-aware auditing.

## 9.1 Integration Scaffolding (Build Later, Don't Block Now)

v1 must not block future integrations to:

• Digital Asset Management (DAM)

• Prepress automation

• Shipping/fulfillment systems

• Web2Print + online designer tools

• AI services (verification, insights, automation)

# 10. Testing, QA, and Acceptance Plan (Initial)

• Automated tests for core workflows (campaign creation, assignment, execution updates, photo upload).

• UAT includes PSP operations + store execution + brand/regional dashboards.

# 11. Change Control and Scope Management

If a feature threatens timeline/budget it moves to Not-Now. All scope changes require explicit tradeoffs.

# 12. Agentic Delivery Plan

This section describes how to run development with AI agents while preserving quality and traceability.

## 12.1 Proposed Agent Roster

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  **Agent / Role**          **Responsibilities**                                                              **Outputs**                     **Escalation Triggers**
  ------------------------- --------------------------------------------------------------------------------- ------------------------------- -------------------------------------------------
  **Product Owner Agent**   Maintains backlog, decomposes epics into stories, keeps SOW in sync               \[PRs, docs, tests, designs\]   Any scope change, ambiguous requirements

  **Architect Agent**       Defines domain model, API contracts, integration scaffolding                      \[PRs, docs, tests, designs\]   Breaking changes, security concerns

  **Backend Agent**         Implements APIs, data model, business rules; writes unit/integration tests        \[PRs, docs, tests, designs\]   Complex data migrations, unclear business rules

  **Frontend Agent**        Builds mobile-first store UI + admin/reporting UI; writes e2e tests               \[PRs, docs, tests, designs\]   UX ambiguity, accessibility issues

  **QA Agent**              Builds test plan; automates critical path tests; manages defect triage            \[PRs, docs, tests, designs\]   Repeated failures, unclear acceptance criteria

  **DevOps Agent**          Sets up CI/CD, environments, logging, monitoring, deployments                     \[PRs, docs, tests, designs\]   Infrastructure access/permissions

  **Documentation Agent**   Keeps docs current; produces runbooks and user guides; maintains prompt library   \[PRs, docs, tests, designs\]   Conflicting sources of truth
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 12.2 Harness / Orchestration (Recommended)

Autonomous loop with gates: Plan → Implement → Verify → Review → Merge.

Gates (minimum): lint + unit tests + integration tests + security scan + PR checklist.

Traceability: every PR references a story/use-case; every story has acceptance criteria; every acceptance criteria has a test.

## 12.3 Prompting Standards

All prompts must specify: objective, constraints (Not-Now list), inputs (authoritative docs), output format, verification steps, and done criteria.

# 13. Appendices

## 13.1 Starter Prompt Library (Copy/Paste)

Example --- Story decomposition prompt:

Context: Use the Platform Direction + Starting Guide as source of truth.

Task: Convert the \'Store execution\' workflow into 10--20 user stories with acceptance criteria and edge cases.

Constraints: Do not include MIS, marketplace, advanced analytics, or long-term storage.

Output: Markdown list of stories grouped by epic; each story has AC and test notes.

## 13.2 Glossary

• Campaign: A defined promotion initiative with assigned stores and associated kits/tasks.

• Kit: A collection of items shipped/assigned to a store for execution.

• Execution State: The status of kit/items as they move through receive/install/confirm.
