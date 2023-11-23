
CREATE FUNCTION SHD_SPLIT_To_Numerate (@input NVARCHAR(MAX), @delim varchar(1))

RETURNS TABLE
AS
RETURN
(
WITH
numbers AS (
             SELECT n = 1, startpos=0, sublen=cast ((select CHARINDEX(@delim, @input + @delim, 0)  ) as int )
             UNION ALL
             SELECT n + 1, startpos +sublen,  sublen = cast (((select CHARINDEX(@delim, @input + @delim, CHARINDEX(@delim, @input + @delim, startpos+sublen)+1) )-(select CHARINDEX(@delim, @input + @delim, startpos+sublen) ) ) as int )
             FROM numbers
             WHERE startpos <  LEN(@input+@delim) and  startpos>=0
),

parts  AS (
             SELECT
                    number = n
                    ,startpos
                    ,sublen
                    ,part  = SUBSTRING(@input+ @delim, startpos+1, CHARINDEX(@delim, @input+@delim+@delim, startpos+1) - startpos-1)
             FROM numbers
)

SELECT
       number
       ,part as strsplit
       ,len(part) as lenstr
       ,LEN(@input+@delim) as strlenght
       ,startpos as delimpos
       ,CHARINDEX(@delim, @input + @delim, startpos+1) as nextpos
       ,sublen

FROM parts

where  CHARINDEX(@delim, @input + @delim, startpos+1) <>0
--OPTION (MAXRECURSION 1000)


);
