unit ToLowerMAST;

function Initialize: integer;
var
    i, j : integer;
    f, header, masters, MAST : IInterface;
begin
    // only process loaded files after primary game master and hard coded file
    for i := 2 to Pred(FileCount) do
    begin
        f := FileByIndex(i);
        header := ElementByIndex(f, 0);
        masters := ElementByPath(header, 'Master Files');
        for j := 0 to Pred(ElementCount(masters)) do
        begin
            MAST := ElementByPath(ElementByIndex(masters, j), 'MAST');
            SetEditValue(MAST, LowerCase(GetEditValue(MAST)));
        end;
    end;
end;

end.