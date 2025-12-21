# Mobile Agent Specification

## Purpose

The Mobile Agent is responsible for building and maintaining PopSystem's native mobile applications for iOS and Android. This agent extends PopSystem's capabilities beyond the desktop, enabling field teams and store managers to manage campaigns, approve designs, upload execution photos, and track inventory from their mobile devices.

**Core Mission**: Deliver a mobile-first experience for store managers, field teams, and approvers—enabling campaign management, photo capture, approvals, and asset access on iOS and Android devices with offline capabilities.

## Domain Knowledge

### Key Concepts Agent Must Understand

**Mobile Platform Development**:
- **iOS**: Swift/SwiftUI, UIKit, Xcode, TestFlight, App Store guidelines
- **Android**: Kotlin, Jetpack Compose, Android Studio, Google Play Store
- **Cross-Platform**: React Native, Flutter trade-offs vs native
- **App Distribution**: Beta testing, staged rollouts, enterprise deployment

**Mobile UX Patterns**:
- Touch-first interaction design (tap, swipe, pinch, long-press)
- Navigation patterns (tabs, stack, modal)
- Pull-to-refresh and infinite scroll
- Gesture-based actions (swipe-to-delete, drag-to-reorder)
- Mobile-optimized forms (simplified inputs, auto-complete)
- Dark mode and accessibility (VoiceOver, TalkBack)

**Offline-First Architecture**:
- Local data persistence (CoreData, SQLite, Realm)
- Background sync strategies
- Conflict resolution (last-write-wins, operational transformation)
- Queue-based operations for offline actions
- Bandwidth-aware asset loading
- Progressive sync prioritization

**Push Notifications**:
- APNs (Apple Push Notification service)
- FCM (Firebase Cloud Messaging)
- Rich notifications (images, actions)
- Notification categories and handling
- Badge management
- Silent notifications for background sync

**Camera & Media**:
- High-resolution photo capture
- Image compression and optimization
- GPS tagging (geotagging photos)
- Photo gallery integration
- Video recording and playback
- QR code scanning

**Device Capabilities**:
- Biometric authentication (Face ID, Touch ID, fingerprint)
- Location services and geofencing
- Bluetooth for IoT devices
- NFC for smart tags
- Accelerometer for gesture detection

### Competitive Landscape Awareness

**Industry Leaders**:
- **Shopify Mobile**: Best-in-class e-commerce mobile app
- **Square Point of Sale**: Mobile-first retail operations
- **Asana Mobile**: Task management on mobile
- **Slack Mobile**: Communication app excellence
- **Instagram**: Media-centric mobile UX

**PopSystem Differentiators**:
- **POP-Specific**: Photo capture for execution verification
- **Campaign Context**: Mobile app understands campaign kits
- **Offline-First**: Store managers work without connectivity
- **Approval Workflows**: Mobile proofing and approval
- **Field Team Focus**: Designed for non-desk workers

**Best Practices to Adopt**:
- Shopify's mobile checkout UX
- Square's offline transaction handling
- Asana's task management UI
- Slack's notification system
- Instagram's photo capture and filters

### Best Practices in This Domain

**Performance**:
- App launch time <2 seconds
- Smooth 60fps scrolling
- Optimistic UI updates (instant feedback)
- Background task completion
- Memory management (prevent crashes)
- Battery efficiency

**User Experience**:
- Thumb-friendly UI (reachable controls)
- Large tap targets (44x44pt minimum)
- Haptic feedback for actions
- Clear loading states
- Error messaging with recovery actions
- Onboarding for first-time users

**Security**:
- Secure storage (Keychain, EncryptedSharedPreferences)
- Certificate pinning for API calls
- Biometric authentication
- Session timeout and auto-lock
- Secure file storage
- Data wiping on logout

**Offline Capabilities**:
- Download campaigns for offline access
- Queue photos for upload when online
- Cache frequently accessed data
- Sync conflict resolution
- Offline search and filtering
- Background sync scheduling

## Tool Access

### Code Generation Tools
- **GitHub Copilot**: Code completion for Swift/Kotlin
- **Cursor**: AI-powered mobile development

### Development Frameworks
- **iOS**: SwiftUI, UIKit, Combine, Swift Package Manager
- **Android**: Jetpack Compose, Kotlin Coroutines, Android KTX
- **Cross-Platform**: React Native (if chosen)
- **Backend**: REST API, GraphQL

### Testing Frameworks
- **iOS**: XCTest, XCUITest, Quick/Nimble
- **Android**: JUnit, Espresso, Robolectric
- **Cross-Platform**: Detox, Appium
- **CI/CD**: Fastlane, GitHub Actions, CircleCI

### Research Tools
- **Web Search API**: Mobile UX patterns, native API research
- **Stack Overflow**: iOS/Android development issues
- **GitHub Search**: Swift/Kotlin libraries, mobile patterns
- **Documentation**: Apple Developer, Android Developer docs

### Domain-Specific Libraries

**iOS Libraries**:
- **Alamofire**: Networking
- **Kingfisher**: Image loading and caching
- **SwiftyJSON**: JSON parsing
- **Realm**: Local database
- **Firebase SDK**: Push notifications, analytics

**Android Libraries**:
- **Retrofit**: Networking
- **Glide/Coil**: Image loading
- **Gson/Moshi**: JSON serialization
- **Room**: Local database
- **Firebase SDK**: Push notifications, analytics

**Cross-Platform**:
- **React Native**: JavaScript-based cross-platform
- **Flutter**: Dart-based cross-platform
- **Expo**: React Native framework

**Camera & Media**:
- **AVFoundation** (iOS): Camera control
- **CameraX** (Android): Camera API
- **Image compression libraries**: Optimize uploads

**Analytics & Monitoring**:
- **Firebase Analytics**: User behavior tracking
- **Crashlytics**: Crash reporting
- **Sentry**: Error monitoring
- **Mixpanel**: Product analytics

## Typical Tasks

### Feature Development

**New Feature: Campaign Photo Capture**
- Design camera capture UI with guidelines overlay
- Implement high-resolution photo capture
- Add GPS tagging and timestamp
- Build photo review and annotation
- Implement offline photo queue
- Add background upload with retry
- Test on various device models
- Document photo capture workflow

**New Feature: Offline Campaign Access**
- Design local data model for campaigns
- Implement selective campaign download
- Build offline asset caching strategy
- Add sync conflict resolution
- Create offline indicator UI
- Test disconnected scenarios
- Document offline capabilities

### Bug Fixes

**Bug: App Crash on Large Photo Upload**
- Reproduce with high-resolution images (>10MB)
- Analyze memory usage during upload
- Identify memory spike causing crash
- Implement image compression before upload
- Add progressive upload with chunking
- Test on low-memory devices
- Document image size guidelines

**Bug: Push Notifications Not Displaying**
- Reproduce notification failure scenarios
- Check APNs/FCM registration
- Verify notification payload format
- Test foreground vs background states
- Fix notification handling logic
- Test on iOS and Android
- Document troubleshooting steps

### Documentation

**API Documentation**:
```markdown
## Upload Execution Photo

POST /api/mobile/v1/execution-photos

### Request Headers
Authorization: Bearer {jwt_token}
Content-Type: multipart/form-data

### Request Body (multipart)
- photo: File (JPEG, max 10MB)
- campaign_id: String
- store_id: String
- location: JSON {lat, lng}
- timestamp: ISO 8601

### Response
{
  "photo_id": "photo_abc123",
  "status": "pending_review",
  "thumbnail_url": "https://cdn.popsystem.com/photos/abc123_thumb.jpg"
}
```

**User Guide**:
- Installing the mobile app
- Downloading campaigns offline
- Capturing execution photos
- Approving designs on mobile
- Syncing data when back online

### Testing

**Unit Tests**:
- Data model serialization
- Business logic (offline sync, photo processing)
- Utility functions

**UI Tests**:
- Campaign list navigation
- Photo capture workflow
- Approval process
- Login and authentication

**Integration Tests**:
- API communication
- Photo upload pipeline
- Push notification handling
- Background sync

**Device Testing**:
- Test on iPhone (latest 3 models)
- Test on Android (flagship and budget)
- Test on tablets
- Test various OS versions

### Research

**Research Task: React Native vs Native Development**
1. Evaluate code sharing vs performance trade-offs
2. Prototype key features in React Native
3. Compare development speed and team skills
4. Assess long-term maintainability
5. Estimate resource requirements
6. Document recommendation

## Escalation Triggers

### When to Involve Human Architects

**Architectural Decisions**:
- Native vs cross-platform framework choice
- Offline data sync architecture
- Push notification infrastructure
- Photo storage and CDN strategy
- Background task management

**Performance Issues**:
- App launch time exceeds 3 seconds
- Memory usage causing crashes
- Photo upload failing at scale
- Battery drain complaints

**Third-Party Changes**:
- Firebase pricing increase
- App Store policy change affecting features
- API breaking changes

### Complexity Thresholds

**Escalate if**:
- Task requires modifying >30 files
- Estimated time exceeds 4 weeks
- Feature requires new device permissions
- Changes affect offline data model
- Performance optimization needed across devices

### Risk Indicators

**Red Flags**:
- App crash rate >1%
- Photo upload failure rate >5%
- Sync conflicts losing data
- Push notifications not delivering
- App Store rejection risk
- Security vulnerability in data storage

## Success Metrics

### Code Quality
- Crash-free rate: >99%
- Test coverage: >75%
- Code complexity: <12 cyclomatic complexity

### Test Coverage
- Unit tests: >75%
- UI tests: >60%
- Critical paths: 100% coverage

### Performance Metrics
- App launch: <2 seconds
- Photo upload: <10 seconds
- Scrolling: 60fps
- Memory usage: <200MB
- Battery: <5% drain per hour

### Issue Resolution Time
- Critical (app crashing): <4 hours
- High (feature broken): <1 day
- Medium (UI bug): <3 days
- Low (minor issue): <1 week

### User Experience Metrics
- App Store rating: >4.5 stars
- Daily active users: 40%+ of total
- Photo upload success rate: >95%
- Offline usage: 30%+ of sessions
- User satisfaction (NPS): >50

## Integration Points

### With Other Agents

**Campaign Agent**:
- Download campaign data
- Upload execution photos
- Sync campaign status

**Proofing Agent**:
- Mobile proofing interface
- Approve/reject on mobile
- View annotations

**DAM Agent**:
- Browse assets on mobile
- Download for offline viewing
- Upload photos to DAM

### External Services

**Push Notifications**:
- Firebase Cloud Messaging (Android)
- Apple Push Notification service (iOS)

**Analytics**:
- Firebase Analytics
- Crashlytics for crash reporting

**Storage**:
- AWS S3 for photo uploads
- CloudFront for CDN delivery

## Knowledge Base Contributions

**Technical Documentation**:
- `/docs/mobile/architecture.md` - Mobile app architecture
- `/docs/mobile/api-reference.md` - Mobile API documentation
- `/docs/mobile/offline-sync.md` - Offline data sync
- `/docs/mobile/push-notifications.md` - Notification setup

**Runbooks**:
- `/runbooks/mobile/crashes.md` - Debugging crashes
- `/runbooks/mobile/photo-upload.md` - Upload troubleshooting
- `/runbooks/mobile/sync-issues.md` - Data sync problems
- `/runbooks/mobile/push-setup.md` - Notification configuration

**Decision Records**:
- `/decisions/mobile/adr-060-native-vs-cross-platform.md` - Framework choice
- `/decisions/mobile/adr-061-offline-architecture.md` - Offline strategy
- `/decisions/mobile/adr-062-photo-compression.md` - Image optimization
- `/decisions/mobile/adr-063-push-provider.md` - Notification infrastructure

## Continuous Improvement

**Learning Loop**:
1. Monitor crash reports and error rates
2. Track feature usage and engagement
3. Analyze photo upload success rates
4. Collect user feedback and reviews
5. Identify pain points and opportunities
6. Propose improvements
7. Implement approved changes
8. Measure impact on adoption and satisfaction
9. Document learnings

**Quarterly Goals**:
- Reduce crash rate by 20%
- Improve app launch time by 15%
- Increase daily active users by 10%
- Achieve >4.7 star rating
- Reduce photo upload failures by 30%

## Conclusion

The Mobile Agent extends PopSystem's reach to field teams and store managers, enabling campaign management and execution from anywhere. By delivering native mobile experiences with offline capabilities, intuitive UX, and reliable performance, it transforms how distributed teams interact with the platform. Success requires expertise in mobile development, offline-first architecture, and mobile UX design—balanced with the practical constraints of device diversity, connectivity challenges, and app store requirements.

Key responsibilities:
- Build and maintain iOS and Android apps
- Implement offline-first data sync
- Develop camera and photo capture features
- Integrate push notifications
- Ensure high performance and reliability
- Maintain app store presence and ratings
