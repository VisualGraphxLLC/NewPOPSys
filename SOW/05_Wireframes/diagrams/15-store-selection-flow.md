# Store Selection Flow

Shows the campaign store targeting UX workflow.

```mermaid
flowchart TD
    START([Start Selection]) --> BASE{Base Set?}
    BASE -->|All Stores| ALL[Load all active stores]
    BASE -->|Start Empty| EMPTY[Empty set]

    ALL --> INCL
    EMPTY --> INCL

    INCL[Add Inclusions] --> INCL_TYPE{Add by?}
    INCL_TYPE -->|Region| ADD_REG[Select regions]
    INCL_TYPE -->|District| ADD_DIST[Select districts]
    INCL_TYPE -->|Group| ADD_GRP[Select groups]
    INCL_TYPE -->|Store| ADD_STORE[Search stores]

    ADD_REG --> PREVIEW
    ADD_DIST --> PREVIEW
    ADD_GRP --> PREVIEW
    ADD_STORE --> PREVIEW

    PREVIEW[Update Preview Counter] --> MORE{More changes?}
    MORE -->|Yes| INCL
    MORE -->|Add Exclusion| EXCL[Add Exclusions]

    EXCL --> EXCL_TYPE{Exclude by?}
    EXCL_TYPE -->|Region| REM_REG[Select regions]
    EXCL_TYPE -->|Store| REM_STORE[Select stores]

    REM_REG --> PREVIEW
    REM_STORE --> PREVIEW

    MORE -->|Done| REVIEW[Review Store List]
    REVIEW --> SAVE[Save SelectionRecipe]
    SAVE --> DONE([Selection Complete])
```

## Selection Methods

| Method | Description |
|--------|-------------|
| **All Stores** | Start with entire active store list |
| **Start Empty** | Build selection from scratch |
| **By Region** | Add/remove entire regions |
| **By District** | Add/remove districts |
| **By Group** | Add/remove store groups |
| **By Store** | Add/remove individual stores |

## UX Features

- Live preview counter updates as selections change
- Inclusions and exclusions can be combined
- Selection saved as "recipe" for reuse
