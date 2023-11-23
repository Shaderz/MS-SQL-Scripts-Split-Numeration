
CREATE FUNCTION SHD_SPLIT_To_Numerate (@input NVARCHAR(MAX), @delim varchar(1))

RETURNS TABLE
AS
RETURN
(

WITH
numbers AS (
             SELECT n = 1, m=(select CHARINDEX(@delim, @input +@delim, 0))
             UNION ALL
             SELECT n + 1, m +  ((select CHARINDEX(@delim, @input + @delim, CHARINDEX(@delim, @input + @delim, m)+1) )-(select CHARINDEX(@delim, @input + @delim, m) ) )
             FROM numbers
             WHERE m <  LEN(@input+@delim) and  m>=0
),

parts  AS (
             SELECT
                    number = n
                    ,m 
                    ,part  = SUBSTRING(@input+ @delim, m+1, CHARINDEX(@delim, @input+@delim+@delim, m+1) - m-1)
             FROM numbers
)

SELECT
       number
       ,part as strsplit
       ,len(part) as lenstr
       ,LEN(@input+@delim) as strlenght
       ,m as delimpos
       ,CHARINDEX(@delim, @input + @delim, m+1) as nextpos

FROM parts
where  CHARINDEX(@delim, @input + @delim, m+1) <>0
--OPTION (MAXRECURSION 1000)

);
