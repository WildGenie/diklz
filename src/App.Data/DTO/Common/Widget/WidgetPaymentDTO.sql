SELECT 
    qry.id,
    qry.caption,
    (select edocument_status from edocuments where created_on = (select max(created_on) from edocuments where entity_id = qry.id and edocument_type = 'PaymentDocument') and entity_id = qry.id and edocument_type = 'PaymentDocument') as edocument_status,
		qry.app_type,
		qry.reg_number,
		qry.reg_date,
		qry.org_unit_id,
		qry.app_sort,
		decision.date_of_start as decision_date
FROM
    (
    select
        imla.id,
        imla.caption,
				imla.record_state,
				imla.app_type,
				imla.reg_number,
				imla.reg_date,
				imla.org_unit_id,
				imla.app_sort,
				imla.app_decision_id
    from iml_applications as imla
		
    UNION

    select
        prla.id,
        prla.caption,
				prla.record_state,
				prla.app_type,
				prla.reg_number,
				prla.reg_date,
				prla.org_unit_id,
				prla.app_sort,
				prla.app_decision_id
    from prl_applications as prla
		
    UNION

    select
        trla.id,
        trla.caption,
				trla.record_state,
				trla.app_type,
				trla.reg_number,
				trla.reg_date,
				trla.org_unit_id,
				trla.app_sort,
				trla.app_decision_id
    from trl_applications as trla
    ) qry
		left join app_decisions as decision on decision.id = qry.app_decision_id
  where qry.record_state <> 4 and decision.decision_type = 'Accepted'  and qry.app_sort in ('GetLicenseApplication', 'IncreaseToPRLApplication')