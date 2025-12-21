# Pseudo SaaS Flow (Brand-Scalable, Multi-PSP Network)

**Status: Post-v1 Future Vision**

This diagram represents the future SaaS architecture where brands can work with multiple PSPs through a unified network.

```mermaid
flowchart TB
    subgraph BrandLayer["Brand Layer (Multi-Brand)"]
        Brand1["Brand A"]
        Brand2["Brand B"]
        Brand3["Brand C"]
    end

    subgraph Network["PopSystem Network Hub"]
        Router["Campaign Router"]
        Visibility["Unified Visibility"]
        Analytics["Cross-Network Analytics"]
    end

    subgraph PSPNetwork["PSP Network"]
        PSP1["PSP Alpha"]
        PSP2["PSP Beta"]
        PSP3["PSP Gamma"]
    end

    subgraph Stores["Store Network"]
        StoreGroup1["Stores (West)"]
        StoreGroup2["Stores (Central)"]
        StoreGroup3["Stores (East)"]
    end

    %% Brand to Network
    Brand1 -->|"campaign request"| Router
    Brand2 -->|"campaign request"| Router
    Brand3 -->|"campaign request"| Router

    %% Network Routes to PSPs
    Router -->|"route by region/capability"| PSP1
    Router -->|"route by region/capability"| PSP2
    Router -->|"route by region/capability"| PSP3

    %% PSPs Execute
    PSP1 -->|"fulfill & manage"| StoreGroup1
    PSP2 -->|"fulfill & manage"| StoreGroup2
    PSP3 -->|"fulfill & manage"| StoreGroup3

    %% Visibility flows back
    StoreGroup1 -->|"execution data"| Visibility
    StoreGroup2 -->|"execution data"| Visibility
    StoreGroup3 -->|"execution data"| Visibility

    %% Brands see unified view
    Visibility -->|"unified dashboard"| Brand1
    Visibility -->|"unified dashboard"| Brand2
    Visibility -->|"unified dashboard"| Brand3

    %% Analytics
    Visibility --> Analytics
    Analytics -->|"insights"| Network
```

## Key Differences from v1

| Aspect | v1 (PSP-Led) | Post-v1 (SaaS Network) |
|--------|--------------|------------------------|
| **Ownership** | PSP owns brand relationship | Network facilitates connections |
| **Routing** | Single PSP per brand | Dynamic routing by region/capability |
| **Visibility** | PSP provides reports | Unified cross-PSP dashboard |
| **Onboarding** | PSP onboards stores | Network-level store registry |
| **Billing** | PSP invoices brand | Network handles settlement |

## Network Benefits

### For Brands
- Single dashboard across all PSP partners
- Unified analytics and reporting
- Simplified vendor management
- Competitive PSP routing

### For PSPs
- Access to larger brand network
- Reduced sales overhead
- Standardized integration
- Focus on fulfillment expertise

### For the Platform
- Network effects (more brands → more PSPs → more value)
- Transaction-based revenue model
- Data insights across industry
- Marketplace dynamics

## Migration Path

1. **v1**: Build robust PSP-led platform
2. **v1.x**: Add multi-brand support per PSP
3. **v2**: Introduce network routing layer
4. **v2.x**: Enable cross-PSP visibility
5. **v3**: Full SaaS marketplace

---

*This represents future architectural direction. Current v1 focuses on the single-PSP model.*
