SELECT
	subq.id,
	COALESCE ( subq.app_sort, '' ) AS app_sort,
    COALESCE ( subq.app_state, '' ) AS app_state,
	COALESCE ( subq.back_office_app_state, '' ) AS back_office_app_state,
    COALESCE ( subq.app_type, '' ) AS app_type,
	COALESCE ( subq.caption, '' ) AS caption,
    case when subq.performer_of_expertise is not null then subq.performer_of_expertise::text else '' end AS performer_of_expertise
FROM
    (SELECT
	    prla.id,
	    COALESCE ( prla.app_sort, '' ) AS app_sort,
	    COALESCE ( prla.app_state, '' ) AS app_state,
	    COALESCE ( prla.back_office_app_state, '' ) AS back_office_app_state,
        COALESCE ( prla.app_type, '' ) AS app_type,
	    COALESCE ( prla.caption, '' ) AS caption,
        performer_of_expertise
    FROM
	    prl_applications AS prla 
    WHERE
	    prla.record_state <> 4

    UNION

    SELECT
	    imla.id,
	    COALESCE ( imla.app_sort, '' ) AS app_sort,
        COALESCE ( imla.app_state, '' ) AS app_state,
	    COALESCE ( imla.back_office_app_state, '' ) AS back_office_app_state,
        COALESCE ( imla.app_type, '' ) AS app_type,
	    COALESCE ( imla.caption, '' ) AS caption ,
        imla.performer_of_expertise
    FROM
	    iml_applications AS imla 
    WHERE
	    imla.record_state <> 4

    UNION

    SELECT
	    trla.id,
	    COALESCE ( trla.app_sort, '' ) AS app_sort,
        COALESCE ( trla.app_state, '' ) AS app_state,
	    COALESCE ( trla.back_office_app_state, '' ) AS back_office_app_state,
        COALESCE ( trla.app_type, '' ) AS app_type,
	    COALESCE ( trla.caption, '' ) AS caption,
        performer_of_expertise
    FROM
	    trl_applications AS trla
    WHERE
	    trla.record_state <> 4
        ) subq