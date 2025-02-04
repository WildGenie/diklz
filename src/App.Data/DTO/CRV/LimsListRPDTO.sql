SELECT
     id,
	 doc_id,
	 reg_num,
	 reg_proc_code,
	 state_id,
	 reg_date,
	 end_date,
	 ord_reg_num,
	 ord_reg_date,
	 COALESCE(drug_name_ukr, '') as drug_name_ukr,
	 COALESCE(drug_name_eng, '') as drug_name_eng,
	 formtype_desc as form_type_desc,
	 COALESCE(farm_group, '') as farm_group,
	 producer_name,
	 country_name,
	 COALESCE(off_order_num, '') as off_order_num,
	 off_order_date,
	 COALESCE(atc_code, '') as atc_code,
     COALESCE(caption,'') as caption
FROM
	lims_rp