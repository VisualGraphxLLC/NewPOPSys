Date: 2025-12-18

v0.8 adds computed/override metadata and hidden-field keep/clear semantics to schema/rules and response storage provenance.

# survey_template.schema_json (field metadata additions)

  --------------------------------------------------------------------------------------------------------
  Field Path                    Type                    Notes
  ----------------------------- ----------------------- --------------------------------------------------
  fields\[\].is_computed        bool                    If true, value is derived by COMPUTE action/expr

  fields\[\].compute_expr       json                    Whitelisted expression AST (fn + args)

  fields\[\].read_only          bool                    Default true when computed

  fields\[\].allow_override     bool                    Enables safe override UI

  fields\[\].hidden_default     bool                    If true, field not shown but still stored

  fields\[\].on_hide_behavior   enum                    KEEP \| CLEAR (per-field)

  fields\[\].display_key        string?                 Export column label (optional)
  --------------------------------------------------------------------------------------------------------

# rules_json action parameter additions

  ----------------------------------------------------------------------------------------------------------
  Action                  Params                                    Notes
  ----------------------- ----------------------------------------- ----------------------------------------
  HIDE                    {target_field_id, on_hide_behavior?}      If omitted, use field.on_hide_behavior

  SHOW                    {target_field_id}                         

  COMPUTE                 {target_field_id, expr}                   Expr is whitelisted AST

  AUTO_FILL               {target_field_id, source, const_value?}   As prior
  ----------------------------------------------------------------------------------------------------------

# store_survey_response (provenance storage)

  -----------------------------------------------------------------------------------------------------------------
  Column               Type              Null?             Notes
  -------------------- ----------------- ----------------- --------------------------------------------------------
  input_json           jsonb             Y                 Raw user inputs (including override input)

  response_json        jsonb             N                 Final values after rules + compute

  response_json_meta   jsonb             Y                 Small provenance object: computed map + overrides list
  -----------------------------------------------------------------------------------------------------------------

If input_json/response_json_meta columns are not desired in v1 schema, they can be stored inside response_json under reserved keys; columns are preferred for clarity.

# Override provenance (response_json_meta)

  ------------------------------------------------------------------------------------------------------------------
  Key                     Type                    Example
  ----------------------- ----------------------- ------------------------------------------------------------------
  overrides\[\]           array                   {field_id, value, overridden_by_user_id, overridden_at, reason?}

  computed\[\]            array                   {field_id, computed_at, expr_version}
  ------------------------------------------------------------------------------------------------------------------
