- view: names_step_4
  extends: names_step_3
  fields:
  
  - measure: percentage_of_cohort
    type: number
    sql: 100.0 * ${total_population} / ${cohorts.cohort_size}
    value_format_name: percent_2