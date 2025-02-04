SELECT distinct
    cnt.id,
    coalesce(cnt.name, '') as name,
    coalesce(cnt.contractor_type, '') as contractor_type,
    coalesce(er.name, '') as contractor_type_name,
    coalesce(cnt.edrpou, '') as edrpou,
    coalesce(cnt.address, '') as address,
    coalesce(cnt.license_contractor_id, '00000000-0000-0000-0000-000000000000') as license_contractor_id,
    coalesce(cnt.license_delete_check, false) as license_delete_check,
    coalesce(cnt.record_state, 1) as record_state,
    coalesce(cnt.caption, '') as caption,
    coalesce(brn.organization_id, '00000000-0000-0000-0000-000000000000') as org_unit_id,
    coalesce(cnt.is_from_license, false) as is_from_license
    FROM prl_contractors as cnt
    left JOIN prl_branch_contractors as brcnt on brcnt.contractor_id = cnt.id and brcnt.record_state <> 4
    JOIN org_branches as brn on brn.id = brcnt.branch_id and brn.record_state <> 4
    left JOIN enum_record as er on cnt.contractor_type = er.code and er.enum_type = 'ContractorType'