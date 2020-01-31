DECLARE @s DATE = '20170801', @e DATE = '20250731';

with trans as (
SELECT convert(decimal(20,2), convert(decimal(20,2), [Amount]) / 100) [Amount],
[Charge Description], 
[Charge Start Date], 
[Charge End Date],
[Invoice No.],
[Code 1], 
[Code 2], 
[Invoice Date], 
[Quantity], 
convert(decimal(20,2), convert(decimal(20,2), [VAT Amount]) / 100) [VAT Amount],  
convert(decimal(20,2), convert(decimal(20,2), [VAT %]) / 100)[VAT %],
datediff(day,[Charge Start Date],[Charge End Date])+1 as days_in_period,
(convert(decimal(20,2), convert(decimal(20,2), [Amount]) / 100.0))/(datediff(day,[Charge Start Date],[Charge End Date])+1) as amount_per_day
FROM RS2000.V_RS2000Charges 
WHERE [Invoiced] = 1
AND [Charge End Date] > '2017-07-31 12:00:00'
AND [Charge Start Date] < '2025-08-01 12:00:00'
),

dates as (

 SELECT TOP (DATEDIFF(DAY, @s, @e)+1)
 DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY number)-1, @s) as cal_date
 FROM (select number
 FROM [master].dbo.spt_values
 WHERE [type] = N'P' 
 union all
 select number+2029
 FROM [master].dbo.spt_values
 WHERE [type] = N'P' ) d
 ORDER BY number
)


select *,case when month(t1.cal_date) > 7 then 
'FY'+ substring(cast(year(t1.cal_date)as varchar(4)),3,4)+'/'+ substring(cast(year(dateadd(year,1,t1.cal_date))as varchar(4)),3,4)
else 'FY'+ substring(cast(year(dateadd(year,-1,t1.cal_date))as varchar(4)),3,4)+'/'+substring(cast(year(t1.cal_date) as varchar(4)),3,4)
end as fiscal_year2 from
dates t1 inner join trans t2
on t1.cal_date between cast(t2.[Charge Start Date] as date) and cast(t2.[Charge End Date] as date)
order by cal_date
