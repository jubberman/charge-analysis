SELECT 
[Invoice No.],  
convert(decimal(20,2), convert(decimal(20,2), [Amount]) / 100) [Amount],
[Charge Description], 
[Charge Start Date],
                                               
case when month([Charge Start Date]) > 7 then 
'FY'+ substring(cast(year([Charge Start Date])as varchar(4)),3,4)+'/'+ substring(cast(year(dateadd(year,1,[Charge Start Date]))as varchar(4)),3,4)
else 'FY'+ substring(cast(year(dateadd(year,-1,[Charge Start Date]))as varchar(4)),3,4)+'/'+substring(cast(year([Charge Start Date]) as varchar(4)),3,4)
end as fiscal_year,
                                               
[Charge End Date],
[Code 1], 
[Code 2], 
[Invoice Date], 
[Quantity], 
convert(decimal(20,2), convert(decimal(20,2), [VAT Amount]) / 100) [VAT Amount],  
convert(decimal(20,2), convert(decimal(20,2), [VAT %]) / 100)[VAT %]

--FROM RS2000.V_RS2000Charges
FROM [RSUniversityOfBathLive].[RS2000].[V_RS2000Charges]
WHERE [Invoiced] = 1
--and [Charge End Date] - [Charge Start Date] <> Quantity
--and Quantity <> 1
--and [Charge Description] <> 'Eat and drink'
AND [Charge End Date] > '2019-07-31 12:00:00'
AND [Charge Start Date] < '2020-08-01 12:00:00'
order by [Invoice No.] desc
