# Sprint S2: Mobile App Core

## Sprint Overview

| Attribute | Value |
|-----------|-------|
| **Sprint Number** | S2 |
| **Theme** | Mobile App Core |
| **Start Date** | 2026-02-03 |
| **End Date** | 2026-02-14 |
| **Duration** | 2 weeks (10 working days) |
| **Sprint Goal** | Build the essential mobile app functionality for store associates |

## Sprint Goals

1. Create store dashboard with campaign overview
2. Implement campaign list with status indicators
3. Build photo capture with AI-powered quality validation
4. Develop checklist execution with offline support
5. Integrate push notification system

---

## Task Breakdown

| Task ID | Description | Priority | Estimate | Assignee | Status |
|---------|-------------|----------|----------|----------|--------|
| S2-01 | Create store associate dashboard screen | Critical | 8h | TBD | Not Started |
| S2-02 | Implement campaign summary cards | High | 6h | TBD | Not Started |
| S2-03 | Build quick action buttons (scan, photo, checklist) | High | 6h | TBD | Not Started |
| S2-04 | Create notification banner component | Medium | 4h | TBD | Not Started |
| S2-05 | Implement bottom navigation bar | Critical | 6h | TBD | Not Started |
| S2-06 | Build campaign list screen | Critical | 8h | TBD | Not Started |
| S2-07 | Create campaign card component with status | High | 6h | TBD | Not Started |
| S2-08 | Implement campaign filtering (status, date) | High | 6h | TBD | Not Started |
| S2-09 | Build campaign detail screen | High | 8h | TBD | Not Started |
| S2-10 | Create campaign timeline/progress view | Medium | 6h | TBD | Not Started |
| S2-11 | Implement photo capture screen | Critical | 8h | TBD | Not Started |
| S2-12 | Build camera controls (flash, switch, zoom) | High | 6h | TBD | Not Started |
| S2-13 | Create photo preview and retake flow | High | 6h | TBD | Not Started |
| S2-14 | Implement AI quality validation service | Critical | 16h | TBD | Not Started |
| S2-15 | Build quality feedback UI (blur, lighting, framing) | High | 8h | TBD | Not Started |
| S2-16 | Create photo gallery for campaign submissions | Medium | 6h | TBD | Not Started |
| S2-17 | Build checklist execution screen | Critical | 8h | TBD | Not Started |
| S2-18 | Implement checklist item components (checkbox, photo, text) | High | 8h | TBD | Not Started |
| S2-19 | Create progress indicator for checklists | Medium | 4h | TBD | Not Started |
| S2-20 | Build offline data persistence (AsyncStorage/WatermelonDB) | Critical | 12h | TBD | Not Started |
| S2-21 | Implement background sync service | Critical | 12h | TBD | Not Started |
| S2-22 | Create sync status indicator | High | 4h | TBD | Not Started |
| S2-23 | Set up Firebase Cloud Messaging | Critical | 8h | TBD | Not Started |
| S2-24 | Implement push notification handlers | High | 6h | TBD | Not Started |
| S2-25 | Create in-app notification center | Medium | 6h | TBD | Not Started |
| S2-26 | Build notification preferences screen | Medium | 4h | TBD | Not Started |
| S2-27 | Implement deep linking for notifications | High | 6h | TBD | Not Started |
| S2-28 | Add error handling and retry logic | High | 8h | TBD | Not Started |
| S2-29 | Create loading and empty states | Medium | 4h | TBD | Not Started |
| S2-30 | Implement haptic feedback for interactions | Low | 2h | TBD | Not Started |

---

## Task Details

### S2-01: Create Store Associate Dashboard Screen

**Description:** Build the main dashboard that store associates see upon login.

**Technical Details:**
- Today's tasks summary with counts
- Active campaign cards (max 3, with "view all" link)
- Quick action buttons for common tasks
- Greeting with user name and store location
- Pull-to-refresh functionality
- Real-time updates via WebSocket

**Acceptance Criteria:**
- [ ] Dashboard loads within 2 seconds
- [ ] Campaign summaries show accurate counts
- [ ] Quick actions navigate to correct screens
- [ ] Pull-to-refresh updates data
- [ ] Offline mode shows cached data with indicator

---

### S2-11: Implement Photo Capture Screen

**Description:** Create the camera interface for capturing display verification photos.

**Technical Details:**
- Full-screen camera preview
- Capture button with visual feedback
- Flash toggle (auto, on, off)
- Camera switch (front/back)
- Grid overlay option for composition
- Zoom controls (pinch and buttons)
- Resolution optimization for upload

**Acceptance Criteria:**
- [ ] Camera launches within 1 second
- [ ] Capture provides haptic and visual feedback
- [ ] Photos captured at appropriate resolution (2MP-5MP)
- [ ] Flash controls work correctly
- [ ] Camera permissions handled gracefully

---

### S2-14: Implement AI Quality Validation Service

**Description:** Build the AI-powered service that validates photo quality before submission.

**Technical Details:**
- Integration with Cloud Vision or custom ML model
- Check for blur detection
- Verify adequate lighting
- Confirm display is fully in frame
- Detect obstructions or reflections
- Provide actionable feedback messages
- Allow override with confirmation

**Acceptance Criteria:**
- [ ] Validation completes within 3 seconds
- [ ] Blur detection accuracy > 90%
- [ ] Lighting assessment provides clear guidance
- [ ] Framing detection identifies cut-off displays
- [ ] Users can override with acknowledgment

---

### S2-20: Build Offline Data Persistence

**Description:** Implement offline-first data architecture for checklist and photo data.

**Technical Details:**
- WatermelonDB for structured data
- AsyncStorage for user preferences
- Image caching for offline access
- Conflict resolution strategy
- Data encryption at rest
- Storage quota management

**Acceptance Criteria:**
- [ ] Checklists accessible without network
- [ ] Photos cached locally before upload
- [ ] Data persists across app restarts
- [ ] Sync conflicts resolved correctly
- [ ] Storage usage under 500MB

---

## Acceptance Criteria

### Sprint Completion Criteria

- [ ] Store associates can view dashboard with campaigns
- [ ] Campaign list shows all assigned campaigns with status
- [ ] Photos can be captured with quality validation
- [ ] Checklists can be completed offline
- [ ] Data syncs when connectivity restored
- [ ] Push notifications received and displayed
- [ ] App works offline for core functionality

### Definition of Done

- [ ] Code reviewed and approved
- [ ] Unit tests with >70% coverage
- [ ] Integration tests for critical paths
- [ ] Manual testing on iOS and Android
- [ ] Performance profiling completed
- [ ] No memory leaks detected
- [ ] Deployed to TestFlight and Play Store Internal

---

## Dependencies

### Incoming Dependencies

| From Sprint | Task | Required By | Status |
|-------------|------|-------------|--------|
| S1 | S1-01 Universal Login | S2-01 | TBD |
| S1 | S1-03 Core Layouts | S2-01 | TBD |
| S1 | S1-04 Role-based Routing | S2-06 | TBD |
| S1 | S1-05 Design System | S2-01 | TBD |

### Outgoing Dependencies

| Blocked Task | Blocked Sprint | Impact |
|--------------|----------------|--------|
| S3-02 Campaign Management | S3 | High - Campaign data |
| S3-04 Analytics Dashboard | S3 | Medium - Photo data |
| S5-03 Display Compliance | S5 | High - Checklist data |

---

## Risks and Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Camera API differences iOS/Android | Medium | High | Early testing on both platforms |
| AI validation accuracy | Medium | Medium | Training data review, fallback |
| Offline sync complexity | High | High | Thorough edge case testing |
| Push notification delivery | Medium | Medium | Fallback to in-app polling |
| Performance on older devices | Medium | Medium | Performance budgets, testing |

---

## Team Allocation

| Role | Team Member | Capacity | Focus Areas |
|------|-------------|----------|-------------|
| Tech Lead | TBD | 25% | Architecture, reviews |
| Mobile Dev 1 | TBD | 100% | Dashboard, campaigns |
| Mobile Dev 2 | TBD | 100% | Photo capture, AI validation |
| Backend Dev | TBD | 50% | APIs, push notifications |
| ML Engineer | TBD | 50% | AI quality validation |
| QA Engineer | TBD | 50% | Mobile testing |

---

## Sprint Ceremonies

| Ceremony | Date | Time | Duration |
|----------|------|------|----------|
| Sprint Planning | Feb 3, 2026 | 10:00 AM | 2 hours |
| Daily Standup | Daily | 9:00 AM | 15 minutes |
| Mid-Sprint Review | Feb 7, 2026 | 2:00 PM | 1 hour |
| Sprint Review | Feb 14, 2026 | 2:00 PM | 1 hour |
| Sprint Retrospective | Feb 14, 2026 | 3:30 PM | 1 hour |

---

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| App launch time | < 3 seconds | Performance monitoring |
| Photo capture to validation | < 5 seconds | In-app timing |
| Offline mode reliability | 99% | Error tracking |
| Push notification delivery | > 95% | FCM analytics |
| Crash-free rate | > 99% | Crashlytics |

---

## Notes

- Week 5 focus: Dashboard, campaign list, navigation
- Week 6 focus: Photo capture, checklists, offline sync
- Daily testing on physical devices required
- AI validation model training in parallel
- Consider React Native performance optimizations

---

## Related Documents

- [Sprint Roadmap](../SPRINT_ROADMAP.md)
- [Sprint Calendar](../SPRINT_CALENDAR.md)
- [Dependency Map](../DEPENDENCY_MAP.md)
- [Sprint S1: Auth & Core UI](./SPRINT_S1_Auth_CoreUI.md)

---

*Last Updated: 2026-01-01*
