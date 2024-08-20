--All the 3 collection methods are given below

--associative array
set serverout on;
declare
TYPE t_tab is table of number(10)
index by binary_integer;

l_tab t_tab;
l_idx   number;
begin
    for i in 1..5 loop
        l_tab(i):=i;
    end loop;
    
    l_tab.delete(3);
    l_idx:=l_tab.FIRST;
    while l_idx is not null loop
        dbms_output.put_line('l_tab('||l_idx||'): '||l_tab(l_idx));
        l_idx:=l_tab.NEXT(l_idx);
    end loop;

end;
/

--nested table example
set serverout on;
declare
TYPE t_tab is table of number(10);

l_tab t_tab:=t_tab();
l_idx   number;
begin
    for i in 1..5 loop
        l_tab.extend;
        l_tab(i):=i;
    end loop;
    
    l_tab.delete(4);
    l_idx:=l_tab.FIRST;
    while l_idx is not null loop
        dbms_output.put_line('l_tab('||l_idx||'): '||l_tab(l_idx));
        l_idx:=l_tab.NEXT(l_idx);
    end loop;

end;
/

--varray example
set serverout on;
declare
TYPE t_tab is varray(5) of number(10);

l_tab t_tab:=t_tab();
begin
    for i in 1..5 loop
        l_tab.extend;
        l_tab(i):=i;
    end loop;
    
    --l_tab.delete(4); cannot delete varray elements
    for i in l_tab.FIRST..l_tab.LAST loop
        dbms_output.put_line('l_tab('||i||'): '||l_tab(i));
    end loop;

end;
/