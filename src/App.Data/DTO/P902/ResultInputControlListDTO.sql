SELECT
    ric.id,
    ric.caption,
    ric.created_on,
    ric.state,
    enum_state.name as state_enum_name,
    ric.drug_name,
    ric.medicine_series,
    ric.size_of_series,
    ric.amount_of_imported_medicine,
    ric.date_win,
    enum_result.name as input_control_result_enum_name,
    ric.input_control_result,
    ric.org_unit_id,
    ric.send_check
FROM
    result_input_controls as ric
LEFT JOIN enum_record as enum_state on enum_state.enum_type = 'ResultInputControlState' and enum_state.code = ric.state
LEFT JOIN enum_record as enum_result on enum_result.enum_type = 'InputControlResult' and enum_result.code = ric.input_control_result