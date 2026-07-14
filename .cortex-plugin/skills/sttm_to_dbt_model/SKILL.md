---
name: sttm_to_dbt_model
description: "Generate a dbt staging model from a Source-to-Target Mapping (STTM) Excel file. Use when: user has an .xlsx STTM document and wants to create a dbt model from it, convert STTM to SQL, generate staging model from mapping spreadsheet. Triggers: sttm, source to target mapping, mapping spreadsheet, xlsx to dbt, generate model from mapping, sttm to dbt, convert mapping to model."
---

# STTM to dbt Model

Generate a dbt staging model SQL file from a Source-to-Target Mapping (STTM) Excel document.

## Workflow

### Step 1: Gather Inputs

**Ask the user for:**

1. **STTM file path** — The `.xlsx` file containing the source-to-target mapping. The Excel file should have columns for: Source Column, Target Column, and Transformation/Business Logic (column names are flexible — match by intent).

2. **Source reference** — How the source is referenced in dbt:
   - A `ref('model_name')` for seeds or other models
   - A `source('source_name', 'table_name')` for raw sources

3. **Target model name** — The filename for the output `.sql` file (e.g., `stg_payments`)

4. **Additional comments** (optional) — Any extra context like special handling, config blocks, or materialization overrides.

Use `ask_user_question` with these fields:
- STTM file path (type: text)
- Source reference (type: text, e.g., `ref('raw_payments')` or `source('raw', 'payments')`)
- Target model name (type: text)
- Additional comments (type: text, optional)

### Step 2: Read and Parse the STTM

1. **Read** the Excel file using the `Read` tool (it supports `.xlsx`).
2. **Identify columns** — Look for columns matching these intents (case-insensitive, flexible naming):
   - Source column name (e.g., "Source Column", "Source Field", "Column Name")
   - Target column name (e.g., "Target Column", "Target Field", "Destination Column")
   - Transformation logic (e.g., "Transformation", "Business Logic", "Logic", "Mapping Rule")
   - Notes (optional, e.g., "Notes", "Comments", "Description")

3. **Extract mappings** — Build a list of:
   - `source_column`: Original column name
   - `target_column`: Desired output column name
   - `transformation`: SQL expression or "direct" if simple rename/passthrough

### Step 3: Generate the dbt Model

**Build the SQL using these rules:**

- For **direct mappings** (no transformation, or transformation says "direct", "passthrough", "rename"):
  ```sql
  source_column AS target_column
  ```

- For **transformations** with SQL expressions:
  ```sql
  <expression> AS target_column
  ```
  Use the transformation text as the SQL expression. If it references the source column by name, use that name directly (it's selecting FROM the source).

- For **derived fields** (target has no direct source column, only a transformation):
  ```sql
  <expression> AS target_column
  ```

**Template:**
```sql
SELECT
    <column_1_expression> AS <target_col_1>,
    <column_2_expression> AS <target_col_2>,
    ...
FROM {{ <source_reference> }}
```

If the user provided additional comments requesting config blocks, add them:
```sql
{{
  config(
    materialized='<type>'
  )
}}
```

### Step 4: Write the Model File

1. Determine the output path. Default: `models/staging/<target_model_name>.sql` relative to the dbt project root.
2. **Write** the generated SQL to that file.
3. **Present** a summary of what was generated:
   - Number of direct mappings
   - Number of derived/transformed fields
   - Output file path

## Stopping Points

- After Step 1: Wait for all user inputs before proceeding.
- After Step 4: Present summary and ask if any adjustments are needed.

## Output

A dbt model `.sql` file in `models/staging/` that implements the STTM mappings with proper column aliases and business logic transformations.
