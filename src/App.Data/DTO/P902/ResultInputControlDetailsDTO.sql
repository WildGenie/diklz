SELECT
    ric.id,
    ric.record_state,
    ric.caption,
    ric.modified_by,
    ric.modified_on,
    ric.created_by,
    ric.created_on,
    ric.state,
    enum_state.name as state_enum_name,
    enum_state.ex_param1 as state_lims_id,
    ric.teritorial_service,
    enum_teritorial.name as teritorial_service_enum_name,
    ric.license_id,

		
    coalesce(lic.license_number, 'б/н') as license_string,
		coalesce(orz.edrpou, orz.inn) as edrpou,
		coalesce(ori.name, '') as org_name,
    		--ATU START
    COALESCE ( ori.address_id, '00000000-0000-0000-0000-000000000000' ) AS address_id,
    COALESCE ( street.ID, '00000000-0000-0000-0000-000000000000' ) AS street_id,
    COALESCE ( street.NAME, '' ) AS street_name,
    COALESCE ( city.ID, '00000000-0000-0000-0000-000000000000' ) AS city_id,
    COALESCE ( city.NAME, '' ) AS city_name,
    COALESCE ( city.type_enum, '' ) AS city_enum,
	COALESCE ( city.code, '' ) as koatuu_code,
    COALESCE ( region.ID, '00000000-0000-0000-0000-000000000000' ) AS region_id,
    COALESCE ( region.NAME, '' ) AS region_name,
    COALESCE ( subject_address.post_index, '' ) AS post_index,
    COALESCE ( subject_address.building, '' ) AS building,
    COALESCE ( subject_address.address_type, '' ) AS address_type,
    COALESCE ((SELECT NAME FROM atu_region AS reg WHERE SUBSTRING ( reg.code, 0, 6 ) = SUBSTRING ( city.code, 0, 6 ) LIMIT 1 ),'' ) AS district_name,
		
    ric.lims_rpid,
    lrp.reg_num as register_number,
    ric.end_date,
    ric.drug_name,
    ric.drug_form,
    ric.producer_name,
    ric.producer_country,
    ric.medicine_series,
    ric.medicine_expiration_date,
    ric.size_of_series,
    ric.unit_of_measurement,
	unit_enum.name as unit_of_measurement_enum_name,
	unit_enum.ex_param1 as unit_of_measurement_lims_id,
    ric.amount_of_imported_medicine,
    ric.win_number,
    ric.date_win,
    ric.input_control_result,
	enum_result.name as input_control_result_enum_name,
	enum_result.ex_param1 as input_control_result_lims_id,
    ric.name_of_mismatch,
    ric.comment,
    ric.org_unit_id,
    lic.old_lims_id as old_lims_id,
    lrp.doc_id as doc_id
FROM
    result_input_controls as ric
LEFT JOIN enum_record as enum_state on enum_state.enum_type = 'ResultInputControlState' and enum_state.code = ric.state
LEFT JOIN enum_record as unit_enum on unit_enum.enum_type = 'UnitOfMeasurement' and unit_enum.code = ric.unit_of_measurement
LEFT JOIN enum_record as enum_result on enum_result.enum_type = 'InputControlResult' and enum_result.code = ric.input_control_result
LEFT JOIN enum_record as enum_teritorial on enum_result.enum_type = 'TeritorialService' and enum_result.code = ric.teritorial_service

LEFT JOIN (select qry.license_number, qry.parent_id, qry.id, qry.old_lims_id from 
(SELECT iml_lic.license_number, iml_lic.parent_id, iml_lic.id, iml_lic.old_lims_id from iml_licenses as iml_lic
union
SELECT prl_lic.license_number, prl_lic.parent_id, prl_lic.id, prl_lic.old_lims_id from prl_licenses as prl_lic
union
SELECT trl_lic.license_number, trl_lic.parent_id, trl_lic.id, trl_lic.old_lims_id from trl_licenses as trl_lic) qry) lic on lic.id = ric.license_id

LEFT JOIN (select qry.organization_info_id, qry.org_unit_id, qry.id from 
(SELECT iml_app.organization_info_id, iml_app.org_unit_id, iml_app.id from iml_applications as iml_app
union
SELECT prl_app.organization_info_id, prl_app.org_unit_id, prl_app.id from prl_applications as prl_app
union
SELECT trl_app.organization_info_id, trl_app.org_unit_id, trl_app.id from trl_applications as trl_app) qry) app on app.id = lic.parent_id

LEFT JOIN org_organization_info as ori on app.organization_info_id = ori.id
LEFT JOIN org_organization as orz on app.org_unit_id = orz.id

LEFT JOIN lims_rp as lrp on ric.lims_rpid = lrp.id
--ATU START
LEFT JOIN atu_subject_address AS subject_address ON  subject_address.ID = ori.address_id
LEFT JOIN atu_street AS street ON subject_address.street_id = street.ID
LEFT JOIN atu_city AS city ON street.city_id = city.ID
LEFT JOIN atu_region AS region ON city.region_id = region.ID
