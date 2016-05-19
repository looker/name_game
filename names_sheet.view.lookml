- explore: names_sheet
  persist_for: 0 seconds
  joins: 
  - join: names_facts
    sql_on: ${names_sheet.normalized_name} = ${names_facts.normalized_name}
    sql_where: ${names_facts.is_dominant_gender}
    relationship: one_to_one

- view: names_sheet
  derived_table:
    sql: |
      SELECT * FROM (
        SELECT row_number() over() as id 
          , name
          , UPPER(
            CASE WHEN REGEXP_MATCH(name, r'\,')
              THEN REGEXP_EXTRACT(name, r', (\w+)')
              ELSE REGEXP_EXTRACT(name, r'^(\w+)')
            END
          ) as normalized_name
        FROM namesheet.names
      ) WHERE id > 1
  
  fields:
  - dimension: id
    type: number
    
  - dimension: name 
    order_by_field: id    # keep the rows in the original order
    
  - dimension: normalized_name

  - measure: count
    type: count
    drill_fields: [id, name, names_facts.gender]
    
  - measure: count_male
    type: count
    filters: 
      names_facts.gender: M
      
  - measure: percentage_male
    type: number
    sql: ${count_male}/${count}
    value_format_name: percent_2
      
  - measure: average_year_median
    type: average
    sql: ${names_facts.year_median}
    value_format: "0000"