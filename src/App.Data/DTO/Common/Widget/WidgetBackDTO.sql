select uuid('00000000-0000-0000-0000-000000000000') as id, '' as caption, prl.*, iml.*, trl.*, msg.*
from (
select COALESCE(sum(case when prl.back_office_app_state = 'Submitted'  then 1 else 0 end),0) as prl_new_applications,
       COALESCE(sum( case when prl.back_office_app_state = 'InReview'  then 1 else 0 end ),0) as prl_review_application,
       COALESCE(sum (case when prl.back_office_app_state = 'Project' then 1 else 0 end),0) as prl_project_application
from prl_applications as prl
where record_state<>4
) as prl, 
(select COALESCE(sum(case when iml.back_office_app_state = 'Submitted'  then 1 else 0 end),0) as iml_new_applications,
				COALESCE(sum( case when iml.back_office_app_state = 'InReview'  then 1 else 0 end ),0) as iml_review_application,
				COALESCE(sum (case when iml.back_office_app_state = 'Project' then 1 else 0 end),0) as iml_project_application
from iml_applications as iml
where record_state<>4
) as iml,
(select COALESCE(sum(case when trl.back_office_app_state = 'Submitted'  then 1 else 0 end),0) as trl_new_applications,
				COALESCE(sum( case when trl.back_office_app_state = 'InReview'  then 1 else 0 end ),0) as trl_review_application,
				COALESCE(sum (case when trl.back_office_app_state = 'Project' then 1 else 0 end),0) as trl_project_application
from trl_applications as trl
where record_state<>4
) as trl,
(select COALESCE(sum(case when msg.is_prl_license = true  then 1 else 0 end),0) as prl_new_message,
				COALESCE(sum( case when msg.is_iml_license = true  then 1 else 0 end ),0) as iml_new_message,
				COALESCE(sum (case when msg.is_trl_license = true then 1 else 0 end),0) as trl_new_message
from messages as msg
where (msg.message_hierarchy_type = 'Single' or msg.message_hierarchy_type = 'Child') and msg.message_state = 'Submitted'
and record_state<>4
) as msg
