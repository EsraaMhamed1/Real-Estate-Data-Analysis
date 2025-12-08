UPDATE l
SET
    l.created_at = DATEADD(day, -(ABS(CHECKSUM(NewId())) % 31 + 10), s.sale_date)
FROM
    Leads AS l
JOIN
    sales_transactions AS s ON l.lead_id = s.lead_id;


select DATEDIFF(DAY, l.created_at, s.sale_date) AS Days_to_Sell
from 
 Leads AS l
JOIN
    sales_transactions AS s ON l.lead_id = s.lead_id;