import os

# Define replacements
replacements = [
    {
        "file": r"E:\Docker\PopSystem\SOW\07_SRS\07_Module_BrandAdmin\screens\B004_Kit_Definition.md",
        "chunks": [
            {
                "start": 293, "end": 299,
                "content": "```mermaid\nflowchart TD\n    S1[Step 1: Stores] -->|save| S2[Step 2: Kit]\n    S2 -->|back| S1\n    S2 -->|save| S3[Step 3: Review]\n    S3 -->|back| S2\n```"
            },
            {
                "start": 303, "end": 309,
                "content": "```mermaid\nstateDiagram-v2\n    ListView --> AddModal\n    AddModal --> Saving\n    Saving --> ListView\n    ListView --> EditModal\n    EditModal --> Saving\n    EditModal --> DeleteConfirm\n    DeleteConfirm --> Deleting\n    Deleting --> ListView\n```"
            },
            {
                "start": 313, "end": 317,
                "content": "```mermaid\nstateDiagram-v2\n    Idle --> Dragging\n    Dragging --> OverDropZone\n    OverDropZone --> Dropped\n    Dropped --> Reordering\n    Reordering --> Idle\n    Dragging --> Cancelled\n    OverDropZone --> Cancelled\n    Cancelled --> Idle\n```"
            }
        ]
    },
    {
        "file": r"E:\Docker\PopSystem\SOW\07_SRS\07_Module_BrandAdmin\screens\B006_Store_List.md",
        "chunks": [
            {
                "start": 363, "end": 376,
                "content": "```mermaid\nstateDiagram-v2\n    ONBOARDING --> ACTIVE: Accept Invitation\n    ACTIVE --> INACTIVE: Admin Action\n    ACTIVE --> SUSPENDED: Admin Action\n    INACTIVE --> ACTIVE: Admin Action\n    SUSPENDED --> ACTIVE: Reactivate\n    SUSPENDED --> INACTIVE: Admin Action\n```"
            },
            {
                "start": 391, "end": 399,
                "content": "```mermaid\nstateDiagram-v2\n    Loading --> Loaded\n    Loaded --> Selecting\n    Selecting --> BulkAction\n    Loading --> Error\n    Loaded --> Filtering\n    Filtering --> Loaded\n    Selecting --> Loaded\n```"
            }
        ]
    },
    {
        "file": r"E:\Docker\PopSystem\SOW\07_SRS\07_Module_BrandAdmin\screens\B007_Verification.md",
        "chunks": [
            {
                "start": 415, "end": 425,
                "content": "```mermaid\nstateDiagram-v2\n    PENDING --> APPROVED\n    PENDING --> REJECTED\n    REJECTED --> SUPERSEDED\n    SUPERSEDED --> PENDING\n```"
            },
            {
                "start": 439, "end": 447,
                "content": "```mermaid\nflowchart TD\n    PA[Photo APPROVED] --> S1[assignment_item.status = COMPLETE]\n    S1 -->|All items complete| S2[assignment.status = SUBMITTED]\n    S2 -->|All photos verified| S3[assignment.status = COMPLETE]\n```"
            },
            {
                "start": 451, "end": 459,
                "content": "```mermaid\nstateDiagram-v2\n    Loading --> Loaded\n    Loaded --> Selecting\n    Selecting --> Processing\n    Loading --> Error\n    Loaded --> Filtering\n    Filtering --> Loaded\n    Selecting --> Loaded\n```"
            }
        ]
    },
    {
        "file": r"E:\Docker\PopSystem\SOW\07_SRS\09_Module_StorePortal\screens\S005_Reports.md",
        "chunks": [
            {
                "start": 621, "end": 655,
                "content": "```mermaid\nstateDiagram-v2\n    [*] --> LOADING\n    LOADING --> SUCCESS: Data Ready\n    LOADING --> ERROR: Failure\n    LOADING --> EMPTY: No Data\n    SUCCESS --> REFRESHING: Range Change\n    REFRESHING --> SUCCESS\n    SUCCESS --> EXPORTING: Export\n    EXPORTING --> SUCCESS\n    SUCCESS --> NAVIGATING: Tab Switch\n    NAVIGATING --> SUCCESS\n    ERROR --> LOADING: Retry\n    EMPTY --> LOADING: Change Range\n```"
            }
        ]
    }
]

def apply_replacements():
    for task in replacements:
        path = task['file']
        print(f"Processing {path}...")
        try:
            with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
        except Exception as e:
            print(f"Error reading {path}: {e}")
            continue
        
        # Sort chunks by start line descending
        chunks = sorted(task['chunks'], key=lambda x: x['start'], reverse=True)
        
        for chunk in chunks:
            s = chunk['start'] - 1
            e = chunk['end']
            if s < len(lines):
                if not lines[s].strip().startswith('```'):
                    print(f"  WARNING: Line {chunk['start']} does not start with ```. Found: {lines[s].strip()}")
            print(f"  Replacing {chunk['start']}-{chunk['end']}")
            lines[s:e] = [chunk['content'] + '\n']
            
        with open(path, 'w', encoding='utf-8') as f:
            f.writelines(lines)
        print("Done.")

if __name__ == "__main__":
    apply_replacements()
