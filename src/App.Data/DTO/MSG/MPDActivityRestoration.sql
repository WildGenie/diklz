SELECT 
    subq.id,
    subq.caption,
    subq.modified_on,
    subq.app_type,
    subq.app_sort,
    subq.app_state,
    subq.record_state
FROM
    (
    select
        imla.id,
        imla.caption,
        COALESCE(imla.modified_on, imla.created_on) as modified_on,
        imla.app_type,
        imla.app_sort,
        imla.app_state,
        imla.record_state
    from iml_applications as imla

    UNION

    select
        prla.id,
        prla.caption,
        COALESCE(prla.modified_on, prla.created_on) as modified_on,
        prla.app_type,
        prla.app_sort,
        prla.app_state,
        prla.record_state
    from prl_applications as prla

    UNION

    select
        trla.id,
        trla.caption,
        COALESCE(trla.modified_on, trla.created_on) as modified_on,
        trla.app_type,
        trla.app_sort,
        trla.app_state,
        trla.record_state
    from trl_applications as trla
    ) subq

  where  subq.record_state <> 4