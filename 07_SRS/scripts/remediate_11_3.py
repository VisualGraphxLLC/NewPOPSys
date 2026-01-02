import os
import re

FILE_PATH = r"E:\Docker\PopSystem\SOW\07_SRS\11_API_Specifications\11.3_External_Integrations.md"

M_PSP = """```mermaid
sequenceDiagram
    participant NP as NewPOPSys
    participant PSP as PSP MIS
    NP->>PSP: order.generated webhook
    PSP->>NP: POST /orders/{id}/acknowledge
    PSP->>NP: PUT /orders/{id}/status (in_production)
    PSP->>NP: PUT /orders/{id}/status (ready_to_ship)
    PSP->>NP: POST /orders/{id}/shipments
    NP->>PSP: shipment.created webhook
```"""

M_ERP = """```mermaid
sequenceDiagram
    participant NP as NewPOPSys
    participant ERP as Brand ERP
    NP->>ERP: campaign.published webhook
    NP->>ERP: order.generated webhook
    NP->>ERP: order.shipped webhook
    NP->>ERP: invoice.created webhook
```"""

M_STRIPE = """```mermaid
sequenceDiagram
    participant C as Customer
    participant NP as NewPOPSys
    participant S as Stripe
    C->>NP: Place Order
    NP->>S: Create PaymentIntent
    S-->>NP: client_secret
    NP-->>C: Payment Form
    C->>S: Confirm Payment
    S->>NP: payment_intent.succeeded webhook
    NP-->>C: Order Confirmed
```"""

def remediate():
    if not os.path.exists(FILE_PATH):
        print("File not found.")
        return

    with open(FILE_PATH, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 2.3 Data Flow (PSP)
    # Starts with NewPOPSys ... PSP MIS
    content = re.sub(
        r'(### 2.3 Data Flow.*?\n\s*)```(?:.|[\r\n])*?```', 
        f"\\1{M_PSP}", 
        content, count=1, flags=re.DOTALL
    )

    # 4.2 Integration Patterns (ERP)
    content = re.sub(
        r'(### 4.2 Integration Patterns.*?\n\s*.*?\n\s*)```(?:.|[\r\n])*?```', 
        f"\\1{M_ERP}", 
        content, count=1, flags=re.DOTALL
    )

    # 6.2.2 Payment Intent Flow (Stripe)
    content = re.sub(
        r'(#### 6.2.2 Payment Intent Flow.*?\n\s*)```(?:.|[\r\n])*?```', 
        f"\\1{M_STRIPE}", 
        content, count=1, flags=re.DOTALL
    )

    with open(FILE_PATH, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Fixed 11.3_External_Integrations.md")

if __name__ == "__main__":
    remediate()
