create or replace procedure beautify(xmlout in out nocopy clob)
  is
    xml    xmltype := new xmltype(xmlout);
    xsl    xmltype := new xmltype('<?xml version="1.0" encoding="UTF-8"?><emps></emps>');
    tmp    xmltype;
begin
  tmp := xml.transform(xsl,null);
  xmlout := xml.getclobval;

  if tmp is null then null; end if;
end;
/


create or replace function xml_beautify(xmlout in clob, col_name in VARCHAR2) return clob as
    xml    xmltype;
    xsl    xmltype := new xmltype('<?xml version="1.0" encoding="UTF-8"?><'||col_name||'></'||col_name||'>');
    tmp    xmltype;
    xmlout_copy clob;
begin

  xml := new xmltype(xmlout);
  tmp := xml.transform(xsl,null);
  xmlout_copy := xml.getclobval;

  if tmp is null then null; end if;
  return xmlout_copy;
end;
/


select xml_beautify(a.xml_doc,'emps') from 
(select  '<?xml version="1.0" encoding="UTF-8"?>'||xmlelement("emps",
            xmlagg(
                xmlforest(e.empno as "empno",
                          e.ename as "ename",
                          e.job as "job",
                          e.sal as "sal",
                          to_char(e.hiredate,'dd-mon-yyyy') as "hiredate")
                )
        ) xml_doc
     from emp e) a;