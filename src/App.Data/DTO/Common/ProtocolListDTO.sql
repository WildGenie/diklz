SELECT 
    ID,
	status_name,
	protocol_number,
	protocol_date,
	COALESCE(order_number, '') as order_number,
	order_date,
	COALESCE ( caption, '' ) AS caption,
    type
FROM
	app_protocols 
WHERE
	record_state <> 4  and protocol_date is not null