
    SELECT
	subq.id,
	subq.is_created_on_portal,
	COALESCE ( subq.reg_date, current_date ) AS reg_date,
	COALESCE ( subq.reg_number, '' ) AS reg_number,
	COALESCE ( subq.app_sort, '' ) AS app_sort,
	COALESCE ( subq.performer_id, '00000000-0000-0000-0000-000000000000' ) AS performer_id,
	COALESCE ( subq.caption, '' ) AS caption ,
	COALESCE ( subq.comment , '') as return_comment,
	subq.return_check as return_check
	
FROM
    (SELECT
	    prla.id,
	    prla.is_created_on_portal,
	    COALESCE ( prla.reg_date, current_date ) AS reg_date,
	    COALESCE ( prla.reg_number, '' ) AS reg_number,
	    COALESCE ( prla.app_sort, '' ) AS app_sort,
	    COALESCE ( prla.performer_id, '00000000-0000-0000-0000-000000000000' ) AS performer_id,
	    COALESCE ( prla.caption, '' ) AS caption,
	    prla.return_comment as comment,
	    prla.return_check as return_check
    FROM
	    prl_applications AS prla 
    WHERE
	    prla.record_state <> 4

    UNION

    SELECT
	    imla.id,
	    imla.is_created_on_portal,
	    COALESCE ( imla.reg_date, current_date ) AS reg_date,
	    COALESCE ( imla.reg_number, '' ) AS reg_number,
	    COALESCE ( imla.app_sort, '' ) AS app_sort,
	    COALESCE ( imla.performer_id, '00000000-0000-0000-0000-000000000000' ) AS performer_id,
	    COALESCE ( imla.caption, '' ) AS caption,
	    imla.return_comment as comment,
	    imla.return_check as return_check
    FROM
	    iml_applications AS imla 
    WHERE
	    imla.record_state <> 4

    UNION

    SELECT
	    trla.id,
	    trla.is_created_on_portal,
	    COALESCE ( trla.reg_date, current_date ) AS reg_date,
	    COALESCE ( trla.reg_number, '' ) AS reg_number,
	    COALESCE ( trla.app_sort, '' ) AS app_sort,
	    COALESCE ( trla.performer_id, '00000000-0000-0000-0000-000000000000' ) AS performer_id,
	    COALESCE ( trla.caption, '' ) AS caption,
	    trla.return_comment as comment,
	    trla.return_check as return_check
    FROM
	    trl_applications AS trla
    WHERE
	    trla.record_state <> 4
        ) subq
