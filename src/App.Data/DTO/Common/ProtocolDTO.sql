SELECT 
    ID,
	status_name,
	protocol_number,
	protocol_date,
	COALESCE(order_number, '') as order_number,
	COALESCE(order_date, '01-01-1990') as order_date,
	COALESCE ( caption, '' ) AS caption,
    type
FROM
	app_protocols 
WHERE
	record_state <> 4