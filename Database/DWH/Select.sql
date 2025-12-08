use RealEstateDB
go 

-- agent
SELECT 
    a.agent_id,
    a.full_name,
    a.email,
    a.phone,
    o.office_name,
    a.hire_date,
    a.status          
FROM agents a
LEFT JOIN offices o 
    ON a.office_id = o.office_id;  




-- property
SELECT
    p.Property_id,
    p.Property_Name,
    t.type_name AS Property_Type,
    p.size_sqft,
    p.size_sqm,
    p.bedrooms,
    p.maid_rooms,
    p.bathrooms,
    p.down_payment,
    p.payment_method,
    p.price,
    p.available_from AS Listed_Date,
    p.available_from AS Available_From,
	p.status,
    s.source_type,
    s.source_name,
	p.sold_date,
	p.Latitude,
	p.Longitude,
    L.City,
    L.Region,
	l.Country
FROM properties p
LEFT JOIN locations l 
ON p.location_id = l.location_id
LEFT JOIN property_types t
on p.type_id = t.type_id
LEFT JOIN listing_sources s
on s.source_id = p.source_id
;  


-- Campaign
SELECT
    c.campaign_id,
    c.name As Campaign_Name,
    c.start_date,
	c.end_date,
	c.budget,
	c.status,
	ch.channel_name As Channel,
	cp.cost,
	cp.clicks,
	cp.impressions,
	cp.roi,
	cp.deals_closed,
	cp.leads_generated
FROM campaigns c
LEFT JOIN campaign_channels ch 
ON c.channel_id = ch.channel_id
LEFT JOIN campaign_performance cp
on c.campaign_id=cp.campaign_id 

--customer
SELECT 
    l.Lead_id,
    l.full_name AS Customer_Name,
    l.email,
    l.phone,
	ls.source_name,
	ls.source_type,
	fs.stage_name
FROM leads l
Left join lead_sources ls
on l.source_id = ls.source_id
left join funnel_stages fs
on l.funnel_stage_id = fs.funnel_stage_id



-------------------------------------------------------
--fact_sales

SELECT 
   d.DateSK,
    s.sale_id,               
    s.property_id ,
    s.lead_id ,
    s.agent_id ,
    s.campaign_id ,
    s.sale_date,                      -- To convert to Date_SK in Dim_Date
    
    s.sale_price,                     
    c.commission_rate,                
    c.commission_amount,             
    (s.sale_price - c.commission_amount) AS revenue,  
    
    DATEDIFF(DAY, l.created_at, s.sale_date) AS days_to_sell,  -- Derived metric
    1 AS sale_count                   -- Constant for counting
FROM dbo.sales_transactions AS s
INNER JOIN leads AS l 
    ON s.lead_id = l.lead_id
INNER JOIN commissions c
	ON s.commission_id = c.commission_id
 INNER JOIN DimDate d ON CONVERT(INT, FORMAT(s.sale_date,'yyyyMMdd')) = d.DateSK
WHERE s.sale_date IS NOT NULL;



-- fact_Lead
SELECT 
    l.lead_id,                      
    l.property_id,                  
    l.agent_id,                     
    l.campaign_id,                  
    d.DateSK,                       
    
    -- Derived Measures
    CASE WHEN l.converted = 1 THEN 1 ELSE 0 END AS converted_flag,   
    1 AS lead_count                 
FROM dbo.leads AS l
INNER JOIN dbo.DimDate AS d 
    ON CONVERT(INT, FORMAT(l.created_at, 'yyyyMMdd')) = d.DateSK
WHERE l.created_at IS NOT NULL;

