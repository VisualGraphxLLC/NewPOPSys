# Appendix C: Export Formats

## C.1 Overview

This appendix defines the specifications for all data exports supported by the NewPOPSys platform. Exports enable offline analysis, integration with external systems, and archival of campaign data.

### Supported Export Formats

| Format | Extension | Use Case | Max Records |
|--------|-----------|----------|-------------|
| CSV | `.csv` | Data analysis, spreadsheet import | 100,000 |
| Excel | `.xlsx` | Formatted reports with multiple sheets | 50,000 |
| PDF | `.pdf` | Printable reports, compliance documentation | N/A |
| JSON | `.json` | API integration, data migration | 100,000 |

### Export Access by Role

| Role | Campaign Data | Store Data | Order Data | Photo Data | Financial |
|------|:-------------:|:----------:|:----------:|:----------:|:---------:|
| Platform Admin | Full | Full | Full | Full | Full |
| PSP Admin | Full | Full | Full | Metadata | Full |
| Brand Admin | Own Brands | Own Brands | Own Brands | Full | Limited |
| Campaign Manager | Assigned | Assigned | Assigned | Full | No |
| Regional Manager | Region Only | Region Only | Region Only | Region Only | No |
| Store Manager | Own Store | Own Store | Own Store | Own Store | No |

---

## C.2 CSV Export Specifications

### C.2.1 General CSV Format

| Property | Specification |
|----------|---------------|
| Encoding | UTF-8 with BOM |
| Delimiter | Comma (`,`) |
| Quote Character | Double quote (`"`) |
| Escape Character | Double quote (`""`) |
| Line Ending | CRLF (`\r\n`) |
| Header Row | Required (first row) |
| Date Format | ISO 8601 (`YYYY-MM-DD`) |
| DateTime Format | ISO 8601 (`YYYY-MM-DDTHH:mm:ssZ`) |
| Boolean Format | `true` / `false` |
| Null Values | Empty string |

### C.2.2 Campaign Export (CSV)

**Filename Pattern:** `campaigns_{tenant}_{YYYYMMDD}.csv`

| Column | Type | Description |
|--------|------|-------------|
| campaign_id | ULID | Unique campaign identifier |
| campaign_name | String | Campaign display name |
| brand_name | String | Associated brand name |
| campaign_type | Enum | PROMOTIONAL / CORE_BRANDING |
| status | Enum | Current campaign status |
| start_date | Date | Campaign start date |
| end_date | Date | Campaign end date (nullable) |
| store_count | Integer | Total assigned stores |
| completed_count | Integer | Stores completed |
| completion_rate | Decimal | Percentage complete (0.00-100.00) |
| created_at | DateTime | Creation timestamp |
| created_by | String | Creator email |
| published_at | DateTime | Publication timestamp (nullable) |

### C.2.3 Store Assignment Export (CSV)

**Filename Pattern:** `store_assignments_{campaign_id}_{YYYYMMDD}.csv`

| Column | Type | Description |
|--------|------|-------------|
| assignment_id | ULID | Unique assignment identifier |
| campaign_id | ULID | Parent campaign ID |
| campaign_name | String | Campaign display name |
| store_id | ULID | Store identifier |
| store_number | String | Store number/code |
| store_name | String | Store display name |
| region | String | Region name |
| district | String | District name (nullable) |
| territory | String | Territory name (nullable) |
| status | Enum | Assignment status |
| phase | Enum | Computed store phase |
| items_total | Integer | Total kit items |
| items_received | Integer | Items received |
| items_installed | Integer | Items installed |
| items_satisfied | Integer | Items approved |
| photos_submitted | Integer | Photos uploaded |
| photos_approved | Integer | Photos approved |
| photos_pending | Integer | Photos awaiting review |
| photos_rejected | Integer | Photos rejected |
| issues_open | Integer | Open issue count |
| assigned_at | DateTime | Assignment timestamp |
| completed_at | DateTime | Completion timestamp (nullable) |

### C.2.4 Order Export (CSV)

**Filename Pattern:** `orders_{campaign_id}_{YYYYMMDD}.csv`

| Column | Type | Description |
|--------|------|-------------|
| order_id | ULID | Order identifier |
| order_number | String | Human-readable order number |
| campaign_id | ULID | Campaign identifier |
| store_id | ULID | Store identifier |
| store_number | String | Store number |
| store_name | String | Store name |
| status | Enum | Order status |
| item_count | Integer | Total line items |
| total_quantity | Integer | Total units ordered |
| shipped_quantity | Integer | Units shipped |
| delivered_quantity | Integer | Units delivered |
| created_at | DateTime | Order creation timestamp |
| confirmed_at | DateTime | PSP confirmation (nullable) |
| shipped_at | DateTime | First shipment (nullable) |
| delivered_at | DateTime | Delivery confirmed (nullable) |
| tracking_numbers | String | Comma-separated tracking numbers |
| carrier | String | Carrier name |

### C.2.5 Issue Export (CSV)

**Filename Pattern:** `issues_{campaign_id}_{YYYYMMDD}.csv`

| Column | Type | Description |
|--------|------|-------------|
| issue_id | ULID | Issue identifier |
| issue_number | String | Human-readable issue number |
| campaign_id | ULID | Campaign identifier |
| store_id | ULID | Store identifier |
| store_number | String | Store number |
| issue_type | Enum | MISSING / DAMAGED / INCORRECT / PACKAGING |
| status | Enum | Issue status |
| item_sku | String | Affected item SKU |
| item_name | String | Affected item name |
| quantity_affected | Integer | Units affected |
| reported_by | String | Reporter email |
| reported_at | DateTime | Report timestamp |
| resolution | String | Resolution notes (nullable) |
| resolved_at | DateTime | Resolution timestamp (nullable) |
| reorder_id | ULID | Linked reorder (nullable) |

---

## C.3 Excel Export Specifications

### C.3.1 General Excel Format

| Property | Specification |
|----------|---------------|
| Format | Office Open XML (`.xlsx`) |
| Excel Version | Compatible with Excel 2010+ |
| Max Rows per Sheet | 50,000 |
| Date Format | Localized (user preference) |
| Number Format | Localized (user preference) |
| Header Row | Frozen, bold, filtered |

### C.3.2 Campaign Summary Report (XLSX)

**Filename Pattern:** `campaign_report_{campaign_name}_{YYYYMMDD}.xlsx`

**Sheet 1: Summary**

| Row | Content |
|-----|---------|
| 1-5 | Report header (title, date range, generated by) |
| 7 | Campaign details (name, brand, dates) |
| 9-15 | KPI summary (stores, completion %, issues, etc.) |

**Sheet 2: Store Details**

Full store assignment data with conditional formatting:
- Green: Complete stores
- Yellow: In progress
- Red: Overdue/Exception

**Sheet 3: Item Breakdown**

Kit item summary with quantities:
- Ordered vs Shipped vs Delivered vs Installed

**Sheet 4: Issues**

All issues with status and resolution

**Sheet 5: Timeline**

Daily progress chart data

### C.3.3 Compliance Report (XLSX)

**Filename Pattern:** `compliance_report_{campaign_name}_{YYYYMMDD}.xlsx`

**Sheet 1: Executive Summary**
- Overall compliance rate
- Regional breakdown
- Risk highlights

**Sheet 2: Store Compliance**

| Column | Description |
|--------|-------------|
| Store | Store name and number |
| Region | Geographic region |
| Items Required | Total required items |
| Items Satisfied | Approved items |
| Compliance % | Satisfaction rate |
| Status | COMPLIANT / NON-COMPLIANT / WAIVED |
| Outstanding Items | Items still pending |
| Days Since Start | Days in campaign |

**Sheet 3: Non-Compliant Stores**

Filtered list of non-compliant stores with:
- Missing items detail
- Pending retakes
- Open issues
- Last activity date

**Sheet 4: Waiver Log**

All waived items with justification

---

## C.4 PDF Report Specifications

### C.4.1 General PDF Format

| Property | Specification |
|----------|---------------|
| Page Size | Letter (8.5" x 11") or A4 |
| Orientation | Portrait (default) or Landscape |
| Margins | 0.75" all sides |
| Font | Sans-serif (Helvetica/Arial) |
| Logo | Tenant logo in header |
| Page Numbers | Bottom right |
| Generated Date | Bottom left |

### C.4.2 Campaign Completion Certificate (PDF)

**Purpose:** Official documentation of successful campaign completion at a store.

**Template Structure:**

![Export Format](../../screenshots/Appendices/export_format.png)

### C.4.3 Photo Proof Report (PDF)

**Purpose:** Visual documentation of installed materials with approval status.

**Template Structure:**

- Page 1: Cover page with campaign and store info
- Pages 2-N: Photo grid (2x2 per page)
  - Photo thumbnail (300x300px)
  - Item name
  - Location slot
  - Status (Approved/Rejected)
  - Reviewer notes
  - Timestamp

### C.4.4 Executive Summary Report (PDF)

**Purpose:** High-level campaign performance for stakeholders.

**Sections:**

1. **Cover Page**
   - Campaign name, brand, date range
   - Report generated date

2. **KPI Dashboard** (1 page)
   - Total stores / Complete / In Progress
   - Completion rate gauge chart
   - Issue rate
   - Photo approval rate

3. **Regional Breakdown** (1 page)
   - Bar chart by region
   - Top/bottom performers

4. **Timeline** (1 page)
   - Cumulative completion curve
   - Daily submission rates

5. **Issues Summary** (1 page)
   - Issue counts by type
   - Resolution rates

6. **Appendix** (as needed)
   - Detailed store list

---

## C.5 JSON Export Specifications

### C.5.1 General JSON Format

| Property | Specification |
|----------|---------------|
| Encoding | UTF-8 |
| Format | Pretty-printed (2-space indent) |
| Date Format | ISO 8601 |
| Null Handling | Explicit `null` |
| Empty Arrays | `[]` |
| Root Element | Object with metadata + data array |

### C.5.2 Standard JSON Wrapper

```json
{
  "export": {
    "type": "campaign_data",
    "version": "1.0",
    "generated_at": "2026-01-01T12:00:00Z",
    "generated_by": "user@example.com",
    "tenant_id": "01ABC...",
    "filters": {
      "campaign_id": "01DEF...",
      "date_from": "2026-01-01",
      "date_to": "2026-01-31"
    },
    "record_count": 150,
    "page": 1,
    "total_pages": 1
  },
  "data": [
    { ... },
    { ... }
  ]
}
```

### C.5.3 Campaign Object (JSON)

```json
{
  "id": "01HXYZ...",
  "name": "Summer 2026 Promo",
  "brand": {
    "id": "01HABC...",
    "name": "Brand Co"
  },
  "type": "PROMOTIONAL",
  "status": "PUBLISHED",
  "dates": {
    "start": "2026-06-01",
    "end": "2026-08-31"
  },
  "kit": {
    "id": "01HKIT...",
    "item_count": 5,
    "items": [
      {
        "id": "01HITM...",
        "sku": "WC-24x36-001",
        "name": "Window Cling 24x36",
        "quantity": 2
      }
    ]
  },
  "rollup": {
    "stores_total": 500,
    "stores_complete": 425,
    "stores_in_progress": 50,
    "stores_not_started": 25,
    "completion_rate": 85.0
  },
  "metadata": {
    "created_at": "2026-05-01T10:00:00Z",
    "created_by": "admin@example.com",
    "published_at": "2026-05-15T09:00:00Z"
  }
}
```

### C.5.4 Store Assignment Object (JSON)

```json
{
  "id": "01HASG...",
  "campaign_id": "01HXYZ...",
  "store": {
    "id": "01HSTR...",
    "number": "1234",
    "name": "Downtown Location",
    "address": {
      "street": "123 Main St",
      "city": "Anytown",
      "state": "CA",
      "postal_code": "90210",
      "country": "US"
    },
    "geography": {
      "region": "West",
      "district": "SoCal",
      "territory": "LA Metro"
    }
  },
  "status": "COMPLETE",
  "phase": "COMPLETE",
  "items": {
    "total": 5,
    "received": 5,
    "installed": 5,
    "satisfied": 5
  },
  "photos": {
    "required": 5,
    "submitted": 6,
    "approved": 5,
    "rejected": 1
  },
  "issues": {
    "total": 1,
    "open": 0,
    "resolved": 1
  },
  "timeline": {
    "assigned_at": "2026-06-01T00:00:00Z",
    "ready_at": "2026-06-05T14:30:00Z",
    "started_at": "2026-06-06T10:00:00Z",
    "submitted_at": "2026-06-06T16:00:00Z",
    "completed_at": "2026-06-07T09:30:00Z"
  }
}
```

---

## C.6 Data Export Schemas

### C.6.1 Available Export Endpoints

| Endpoint | Description | Formats |
|----------|-------------|---------|
| `/exports/campaigns` | Campaign list with rollups | CSV, XLSX, JSON |
| `/exports/campaigns/{id}/stores` | Store assignments for campaign | CSV, XLSX, JSON |
| `/exports/campaigns/{id}/orders` | Orders for campaign | CSV, XLSX, JSON |
| `/exports/campaigns/{id}/issues` | Issues for campaign | CSV, XLSX, JSON |
| `/exports/campaigns/{id}/photos` | Photo metadata (not images) | CSV, JSON |
| `/exports/campaigns/{id}/report` | Formatted report | XLSX, PDF |
| `/exports/stores/{id}/history` | Store campaign history | CSV, JSON |

### C.6.2 Export Request Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `format` | Enum | csv, xlsx, pdf, json |
| `date_from` | Date | Filter start date |
| `date_to` | Date | Filter end date |
| `status` | Enum[] | Filter by status(es) |
| `region` | String[] | Filter by region(s) |
| `include_photos` | Boolean | Include photo URLs (JSON only) |
| `page` | Integer | Page number (pagination) |
| `per_page` | Integer | Records per page (max 10000) |

### C.6.3 Export Response

```json
{
  "export_id": "01HEXP...",
  "status": "PROCESSING",
  "progress": 45,
  "estimated_completion": "2026-01-01T12:05:00Z",
  "download_url": null,
  "expires_at": null
}
```

When complete:

```json
{
  "export_id": "01HEXP...",
  "status": "COMPLETE",
  "progress": 100,
  "completed_at": "2026-01-01T12:03:00Z",
  "download_url": "https://cdn.example.com/exports/01HEXP....csv",
  "expires_at": "2026-01-02T12:03:00Z",
  "file_size_bytes": 1048576,
  "record_count": 5000
}
```

---

## C.7 Photo Export Specifications

### C.7.1 Photo Metadata Export (CSV/JSON)

Photos are exported as metadata with signed URLs (not embedded images).

| Field | Description |
|-------|-------------|
| photo_id | Unique photo identifier |
| assignment_id | Parent assignment |
| item_id | Associated kit item |
| location_slot | Location slot name |
| status | PENDING / APPROVED / REJECTED |
| original_url | Signed URL (expires 24h) |
| thumbnail_url | Signed thumbnail URL |
| uploaded_at | Upload timestamp |
| reviewed_at | Review timestamp |
| reviewer | Reviewer email |
| rejection_reason | Reason code (if rejected) |

### C.7.2 Photo Archive Export (ZIP)

For bulk photo download, a ZIP archive is generated:

**Structure:**
![Export Format](../../screenshots/Appendices/export_format.png)

**Manifest.json:**
```json
{
  "campaign_id": "01HXYZ...",
  "export_date": "2026-01-01",
  "total_photos": 2500,
  "total_size_mb": 1250,
  "stores": [
    {
      "store_number": "1234",
      "photo_count": 5,
      "files": [
        {
          "filename": "item_ABC_slot_1.jpg",
          "item_sku": "WC-24x36-001",
          "status": "APPROVED"
        }
      ]
    }
  ]
}
```

---

## C.8 Scheduled Exports

### C.8.1 Schedule Configuration

| Field | Description |
|-------|-------------|
| frequency | DAILY / WEEKLY / MONTHLY |
| day_of_week | For weekly (0-6) |
| day_of_month | For monthly (1-28) |
| time | UTC time (HH:MM) |
| format | Export format |
| recipients | Email addresses |
| filters | Standard filter criteria |

### C.8.2 Delivery Options

| Option | Description |
|--------|-------------|
| Email Attachment | Attached to email (max 10MB) |
| Email Link | Download link in email |
| SFTP | Upload to configured SFTP server |
| Webhook | POST to configured URL |
| S3 Bucket | Upload to customer S3 bucket |

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: SOW Functional Requirements, SUPP-002*
