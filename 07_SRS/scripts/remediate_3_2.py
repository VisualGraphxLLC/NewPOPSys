import os
import re

FILE_PATH = r"E:\Docker\PopSystem\SOW\07_SRS\03_System_Architecture\3.2_Application_Architecture.md"

# 1. Monorepo Structure
# Replace the ASCII tree with a Markdown list
MD_MONOREPO = """
- **apps/**
  - **web/**: Next.js frontend application
    - `app/`: App router pages
    - `components/`: React components
    - `hooks/`: Custom React hooks
    - `styles/`: CSS/Tailwind styles
  - **api/**: Fastify API server
    - `routes/`: API route handlers
    - `services/`: Business logic services
    - `middleware/`: Auth, validation, tenant context
    - `plugins/`: Fastify plugins
  - **worker/**: BullMQ background workers
    - `jobs/`: Job processors
    - `queues/`: Queue definitions
    - `handlers/`: Event handlers
- **packages/**
  - **shared/**: Shared types, utilities, Zod schemas
    - `types/`: TypeScript type definitions
    - `schemas/`: Zod validation schemas
    - `utils/`: Common utility functions
  - **db/**: Prisma schema and migrations
    - `prisma/`: Schema and migrations
    - `client/`: Generated Prisma client
  - **ui/**: Shared UI component library
    - `components/`: Reusable React components
    - `primitives/`: Base design system components
- **tooling/**
  - `eslint/`: Shared ESLint configuration
  - `typescript/`: Shared TypeScript configuration
  - `tailwind/`: Shared Tailwind configuration
"""

# 2. Frontend Routes
MD_FRONTEND = """
- **app/**
  - **(auth)/**: Authentication routes
    - `login/`
    - `forgot-password/`
  - **(psp)/**: PSP Operations module
    - `dashboard/`
    - `orders/`
    - `shipments/`
    - `batches/`
  - **(brand)/**: Brand Admin module
    - `campaigns/`
    - `stores/`
    - `kits/`
    - `reviews/`
  - **(store)/**: Store Portal / Mobile PWA
    - `tasks/`
    - `campaigns/`
    - `receive/`
    - `install/`
  - **(admin)/**: Platform Admin module
    - `tenants/`
    - `users/`
    - `settings/`
"""

# 3. API Routes
MD_API = """
- **routes/**
  - **v1/**
    - `auth/`: Authentication endpoints
    - `campaigns/`: Campaign CRUD + publish
    - `stores/`: Store management
    - `orders/`: Order/fulfillment operations
    - `shipments/`: Shipment tracking
    - `issues/`: Issue/reorder management
    - `reviews/`: Photo review queue
    - `exports/`: Report generation
    - `webhooks/`: Inbound webhook handlers
  - **internal/**: Internal service endpoints
    - `health/`
    - `metrics/`
"""

def remediate():
    if not os.path.exists(FILE_PATH):
        print("File not found.")
        return

    with open(FILE_PATH, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex to replace the trees (Code blocks)
    
    # 1. Monorepo Structure
    # Look for block containing "apps/" "web/" "packages/"
    content = re.sub(
        r'(### 1.2 Monorepo Structure.*?\n\s*)```(?:.|[\r\n])*?```',
        f"\\1{MD_MONOREPO}",
        content,
        count=1,
        flags=re.DOTALL
    )

    # 2. Frontend Routes
    # Block containing "app/" "(auth)/"
    content = re.sub(
        r'(Route Organization by Module:.*?\n\s*)```(?:.|[\r\n])*?```',
        f"\\1{MD_FRONTEND}",
        content,
        count=1,
        flags=re.DOTALL
    )

    # 3. API Routes
    # Block containing "routes/" "v1/"
    content = re.sub(
        r'(API Route Organization:.*?\n\s*)```(?:.|[\r\n])*?```',
        f"\\1{MD_API}",
        content,
        count=1,
        flags=re.DOTALL
    )

    with open(FILE_PATH, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Fixed 3.2_Application_Architecture.md")

if __name__ == "__main__":
    remediate()
