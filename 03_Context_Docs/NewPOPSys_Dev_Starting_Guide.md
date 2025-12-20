NewPOPSys is a campaign orchestration platform. All core system design should reinforce the campaign lifecycle:\
\
Campaign → Store Assignment → PSP Fulfillment → Store Execution → Verification → Visibility\
\
This guide provides the conceptual starting point for development.

# Primary Personas

\- Central Brand Manager: creates campaigns and selects stores\
- Regional Manager: monitors progress and intervenes by exception\
- Store Manager: executes campaigns in the field\
- PSP: fulfills campaigns via kitting, production, and delivery

# Core System Objects

\- Campaign\
- Store / Location\
- Kit\
- Item\
- Order / Fulfillment Job\
- Execution State\
- Photo / Verification Artifact\
- Activity / Audit Event

# v1 Development Priorities

1\. Campaign creation and store assignment logic\
2. Predictable order generation for PSP fulfillment\
3. Mobile-first store execution flows\
4. Clear execution state tracking\
5. Brand and regional visibility dashboards\
6. API scaffolding for future systems

# Out of Scope for v1

\- Installer marketplace\
- PSP MIS / financial tooling\
- Advanced analytics and benchmarking\
- Long-term object storage\
- AI automation beyond data readiness

# Data Retention (v1 Rule)

Operational campaign data is retained for 90 days after completion. After that, brands may export their data or allow deletion.

# Appendix: Core Data Object Model (v1)

![](media/image1.png){width="6.5in" height="5.712890419947507in"}
