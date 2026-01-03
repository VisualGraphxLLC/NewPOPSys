# Module Responsibility & Hand-offs

Shows portal ownership and data hand-offs between the three main modules.

```mermaid
flowchart LR
  subgraph BRAND["Brand Portal<br/>(BRAND / REGIONAL)"]
    BC["Owns configuration + approvals<br/>• Stores/Regions/Groups<br/>• Surveys + Layout + Photo Rules<br/>• Campaigns/Kits/Assignments<br/>• Verification/Retakes/Waivers<br/>• Reporting/Exports"]
  end

  subgraph PSP["PSP Portal<br/>(PSP_ADMIN / PSP_OPS / INTEGRATION)"]
    PC["Owns production + logistics<br/>• Tenant settings (admin)<br/>• Orders/Shipments/Batches<br/>• Tracking + exceptions<br/>• Reorders/replacements<br/>• API + Webhooks"]
  end

  subgraph STORE["Store App<br/>(STORE_USER)"]
    SC["Owns execution<br/>• Receive/Verify<br/>• Install<br/>• Proof Capture<br/>• Attestation/Complete<br/>• Issues/Retakes/Deinstall"]
  end

  BC -->|"Publish → Orders Created"| PC
  PC -->|"Shipments + Tracking"| SC
  SC -->|"Issue / Reorder Request"| PC
  PC -->|"Replacement Shipped"| SC
  SC -->|"Proofs Submitted"| BC
  BC -->|"Retake Requested"| SC
```

## Hand-off Summary

| From | To | Trigger |
|------|-----|---------|
| Brand → PSP | Campaign published | Orders auto-generated |
| PSP → Store | Shipment created | Tracking info sent |
| Store → PSP | Issue reported | Reorder request created |
| Store → Brand | Photos submitted | Verification queue updated |
| Brand → Store | Photo rejected | Retake notification sent |

---

*From [Complete Diagram Collection](../../04_Reference/NewPOPSys_v1_Mermaid_Charts.md)*
