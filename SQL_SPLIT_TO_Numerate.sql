

------------------------------------------------------------------------------------------------
DECLARE @input NVARCHAR(MAX) = N'Lorem,ipsum,dolor,sit,amet,123,abc,000,555';
declare @m int =1;

WITH
numbers AS (
             SELECT n = 1, m=(select CHARINDEX(',', @input + ',', 0))
             UNION ALL
             SELECT n + 1, m +  ((select CHARINDEX(',', @input + ',', CHARINDEX(',', @input + ',', m)+1) )-(select CHARINDEX(',', @input + ',', m) ) )
             FROM numbers
             WHERE m <  LEN(@input+',') and m>=0
),

parts  AS (
             SELECT
                    number = n
                    ,m 
                    ,part  = SUBSTRING(@input+ ',', m+1, CHARINDEX(',', @input+ ',,', m+1) - m-1)
             FROM numbers
)

SELECT
       number
       ,part as strsplit
       ,len(part) as lenstr
       ,LEN(@input+',') as strlenght
       ,m as delimpos
       ,CHARINDEX(',', @input + ',', m+1) as nextpos

FROM parts
where  CHARINDEX(',', @input + ',', m+1) <>0
OPTION (MAXRECURSION 1000);
---------------------------------------------------------------------------------------------
