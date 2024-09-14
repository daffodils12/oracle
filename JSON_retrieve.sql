select * from json_documents 

select jt.*
from json_documents j,
    json_table(j.data,'$[*]'
        COLUMNS
            PONumber number PATH '$.PONumber',
            Requestor varchar2(20) PATH '$.Requestor',
            POUser varchar2(10) PATH '$.User',
            NESTED PATH '$.LineItems[*]'
            COLUMNS
            (   ItemNumber number PATH '$.ItemNumber',
                Description varchar2(200) PATH '$.Part.Description',
                UnitPrice number PATH '$.Part.UnitPrice',
                UPCCode number PATH '$.Part.UPCCode',
                Qty number PATH '$.Quantity'
            )
    ) jt