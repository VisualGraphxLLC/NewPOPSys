-- ==============================================================================
-- DEFAULT PHOTO RULES SEED DATA - NewPOPSys v1
-- ==============================================================================
-- Creates baseline photo requirement templates for common scenarios.
-- These default photo rules can be referenced when creating kit definitions
-- and provide standard photography requirements for different proof types.
--
-- Note: This requires the photo_rules table to exist, which is defined in
-- the store/campaign module schemas. This seed data should be loaded AFTER
-- those schemas are created.
--
-- Dependencies:
--   - 00_foundation_ddl.sql (brands table)
--   - store_module_ddl.sql or equivalent (photo_rules table)
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- IMPORTANT: Brand Context Required
-- ==============================================================================
-- Photo rules are brand-specific (each rule has a brand_id FK).
-- The examples below use the default development brand ID.
-- In production, these would be created for each brand during onboarding.

-- Default development brand: 00000000-0000-0000-0000-000000000200

-- ==============================================================================
-- DEFAULT PHOTO RULE: Standard Proof
-- ==============================================================================
-- Purpose: Standard proof-of-execution photo showing installed materials
-- Use Case: Basic campaign completion verification
-- Requirements: Clear frontal view, good lighting, materials visible

INSERT INTO photo_rules (
  id,
  brand_id,
  name,
  description,
  requirements_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000301'::UUID,
  '00000000-0000-0000-0000-000000000200'::UUID,  -- dev brand
  'Standard Proof',
  'Standard proof-of-execution photo showing installed materials in their final location',
  '{
    "angle": {
      "type": "frontal",
      "description": "Photo should be taken from directly in front of the installation",
      "min_distance_feet": 3,
      "max_distance_feet": 8
    },
    "lighting": {
      "min_brightness": "adequate",
      "avoid_glare": true,
      "avoid_shadows": true
    },
    "visibility": {
      "materials_fully_visible": true,
      "no_obstructions": true,
      "context_visible": true
    },
    "technical": {
      "min_resolution": {
        "width": 1024,
        "height": 768
      },
      "max_blur_score": 0.3,
      "max_file_size_mb": 10,
      "allowed_formats": ["image/jpeg", "image/png", "image/heic"]
    },
    "content": {
      "show_installation_complete": true,
      "show_materials_undamaged": true,
      "show_placement_correct": true
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- DEFAULT PHOTO RULE: Detail Shot
-- ==============================================================================
-- Purpose: Close-up detail photo showing specific features or quality
-- Use Case: Quality verification, brand compliance checking
-- Requirements: Close-up view, focus on specific details

INSERT INTO photo_rules (
  id,
  brand_id,
  name,
  description,
  requirements_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000302'::UUID,
  '00000000-0000-0000-0000-000000000200'::UUID,  -- dev brand
  'Detail Shot',
  'Close-up detail photo showing specific features, quality, or brand elements',
  '{
    "angle": {
      "type": "close_up",
      "description": "Photo should be taken 1-3 feet from subject with clear focus",
      "min_distance_feet": 1,
      "max_distance_feet": 3
    },
    "lighting": {
      "min_brightness": "good",
      "avoid_glare": true,
      "avoid_shadows": true,
      "even_lighting_required": true
    },
    "visibility": {
      "detail_area_fills_frame": true,
      "no_obstructions": true,
      "sharp_focus_required": true
    },
    "technical": {
      "min_resolution": {
        "width": 1280,
        "height": 960
      },
      "max_blur_score": 0.15,
      "max_file_size_mb": 10,
      "allowed_formats": ["image/jpeg", "image/png", "image/heic"]
    },
    "content": {
      "show_brand_elements": true,
      "show_quality_indicators": true,
      "show_specific_features": true
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- DEFAULT PHOTO RULE: Location Context
-- ==============================================================================
-- Purpose: Wide-angle photo showing materials in store context
-- Use Case: Store layout verification, placement context
-- Requirements: Wide view showing surrounding area

INSERT INTO photo_rules (
  id,
  brand_id,
  name,
  description,
  requirements_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000303'::UUID,
  '00000000-0000-0000-0000-000000000200'::UUID,  -- dev brand
  'Location Context',
  'Wide-angle photo showing materials in context of store location and surrounding area',
  '{
    "angle": {
      "type": "wide_angle",
      "description": "Photo should show installation plus surrounding 6-10 feet of context",
      "min_distance_feet": 8,
      "max_distance_feet": 15
    },
    "lighting": {
      "min_brightness": "adequate",
      "avoid_glare": true,
      "natural_lighting_ok": true
    },
    "visibility": {
      "materials_visible": true,
      "context_area_visible": true,
      "surrounding_fixtures_visible": true
    },
    "technical": {
      "min_resolution": {
        "width": 1280,
        "height": 960
      },
      "max_blur_score": 0.4,
      "max_file_size_mb": 10,
      "allowed_formats": ["image/jpeg", "image/png", "image/heic"]
    },
    "content": {
      "show_store_context": true,
      "show_placement_location": true,
      "show_traffic_flow_area": true,
      "show_adjacent_fixtures": true
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- DEFAULT PHOTO RULE: Damage Documentation
-- ==============================================================================
-- Purpose: Photo documenting damaged materials for issue requests
-- Use Case: Issue request evidence, damage claims
-- Requirements: Clear view of damage, context visible

INSERT INTO photo_rules (
  id,
  brand_id,
  name,
  description,
  requirements_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000304'::UUID,
  '00000000-0000-0000-0000-000000000200'::UUID,  -- dev brand
  'Damage Documentation',
  'Photo documenting damaged materials for issue requests and replacement claims',
  '{
    "angle": {
      "type": "focused",
      "description": "Photo should clearly show damage plus enough context to identify item",
      "min_distance_feet": 1,
      "max_distance_feet": 5
    },
    "lighting": {
      "min_brightness": "good",
      "avoid_glare": true,
      "avoid_shadows": true,
      "even_lighting_required": true
    },
    "visibility": {
      "damage_clearly_visible": true,
      "item_identifiable": true,
      "context_sufficient": true
    },
    "technical": {
      "min_resolution": {
        "width": 1024,
        "height": 768
      },
      "max_blur_score": 0.2,
      "max_file_size_mb": 10,
      "allowed_formats": ["image/jpeg", "image/png", "image/heic"]
    },
    "content": {
      "show_damage_clearly": true,
      "show_item_identification": true,
      "show_damage_extent": true,
      "include_context": true
    },
    "notes": {
      "required_for_issue_types": ["DAMAGED", "PACKAGING"],
      "multiple_angles_recommended": true
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- DEFAULT PHOTO RULE: Packaging/Shipping Receipt
-- ==============================================================================
-- Purpose: Photo showing received package/materials before unpacking
-- Use Case: Receipt verification, packaging condition documentation
-- Requirements: Clear view of package, labels visible

INSERT INTO photo_rules (
  id,
  brand_id,
  name,
  description,
  requirements_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000305'::UUID,
  '00000000-0000-0000-0000-000000000200'::UUID,  -- dev brand
  'Packaging Receipt',
  'Photo of received package showing shipping labels and package condition',
  '{
    "angle": {
      "type": "frontal",
      "description": "Photo should show shipping label and package condition clearly",
      "min_distance_feet": 2,
      "max_distance_feet": 6
    },
    "lighting": {
      "min_brightness": "adequate",
      "avoid_glare": true,
      "label_readable_required": true
    },
    "visibility": {
      "shipping_label_visible": true,
      "package_condition_visible": true,
      "tracking_number_readable": true
    },
    "technical": {
      "min_resolution": {
        "width": 1024,
        "height": 768
      },
      "max_blur_score": 0.25,
      "max_file_size_mb": 10,
      "allowed_formats": ["image/jpeg", "image/png", "image/heic"]
    },
    "content": {
      "show_shipping_label": true,
      "show_tracking_number": true,
      "show_package_condition": true,
      "show_full_package": true
    },
    "notes": {
      "capture_before_opening": true,
      "required_for_damage_claims": true
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- DEFAULT PHOTO RULE: Installation Progress
-- ==============================================================================
-- Purpose: Photo showing installation in-progress state
-- Use Case: Progress tracking, step-by-step documentation
-- Requirements: Clear view of partial installation, next steps visible

INSERT INTO photo_rules (
  id,
  brand_id,
  name,
  description,
  requirements_json,
  created_at,
  updated_at
) VALUES (
  '00000000-0000-0000-0000-000000000306'::UUID,
  '00000000-0000-0000-0000-000000000200'::UUID,  -- dev brand
  'Installation Progress',
  'Photo documenting installation in-progress for step-by-step tracking',
  '{
    "angle": {
      "type": "frontal",
      "description": "Photo should show current progress and work area",
      "min_distance_feet": 3,
      "max_distance_feet": 10
    },
    "lighting": {
      "min_brightness": "adequate",
      "avoid_glare": true
    },
    "visibility": {
      "progress_clearly_visible": true,
      "work_area_visible": true,
      "materials_visible": true
    },
    "technical": {
      "min_resolution": {
        "width": 1024,
        "height": 768
      },
      "max_blur_score": 0.35,
      "max_file_size_mb": 10,
      "allowed_formats": ["image/jpeg", "image/png", "image/heic"]
    },
    "content": {
      "show_current_state": true,
      "show_progress_made": true,
      "show_remaining_work": true
    },
    "notes": {
      "optional_step": true,
      "useful_for_complex_installations": true
    }
  }'::jsonb,
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- USAGE NOTES
-- ==============================================================================

-- These default photo rules should be used when creating kit definitions.
-- Example: Referencing a photo rule in a kit item

/*
INSERT INTO kit_items (
  kit_definition_id,
  item_sku,
  item_name,
  quantity,
  photo_rule_id
) VALUES (
  '...',  -- kit_definition_id
  'POSTER-001',
  '24x36 Promotional Poster',
  1,
  '00000000-0000-0000-0000-000000000301'::UUID  -- Standard Proof rule
);
*/

-- Multiple photo rules can be required for complex items:
/*
-- Require both standard proof AND detail shot
INSERT INTO kit_items (
  kit_definition_id,
  item_sku,
  item_name,
  quantity,
  photo_rule_id
) VALUES
  ('...', 'DISPLAY-001', 'Premium Display Unit', 1, '00000000-0000-0000-0000-000000000301'),
  ('...', 'DISPLAY-001-DETAIL', 'Premium Display Unit (Detail)', 1, '00000000-0000-0000-0000-000000000302');
*/

-- ==============================================================================
-- VALIDATION QUERIES
-- ==============================================================================

-- List all default photo rules
/*
SELECT
  id,
  name,
  description,
  requirements_json->>'angle' AS angle_requirements,
  requirements_json->'technical'->>'min_resolution' AS min_resolution,
  created_at
FROM photo_rules
WHERE brand_id = '00000000-0000-0000-0000-000000000200'::UUID
ORDER BY name;
*/

-- Count photo rules by brand
/*
SELECT
  b.name AS brand_name,
  COUNT(pr.id) AS photo_rule_count
FROM brands b
LEFT JOIN photo_rules pr ON pr.brand_id = b.id
WHERE b.deleted_at IS NULL
  AND (pr.deleted_at IS NULL OR pr.deleted_at IS NOT NULL)
GROUP BY b.id, b.name
ORDER BY photo_rule_count DESC;
*/

-- ==============================================================================
-- REPLICATION FOR PRODUCTION BRANDS
-- ==============================================================================

-- To replicate these default rules for a new brand:
/*
INSERT INTO photo_rules (brand_id, name, description, requirements_json)
SELECT
  '...'::UUID AS brand_id,  -- New brand ID
  name,
  description,
  requirements_json
FROM photo_rules
WHERE brand_id = '00000000-0000-0000-0000-000000000200'::UUID  -- Copy from dev brand
  AND deleted_at IS NULL;
*/

-- ==============================================================================
-- END OF DEFAULT PHOTO RULES SEED DATA
-- ==============================================================================
