program bottom_parser_app;
const
  c = 1;
  d = 2;
  dS = 3; //$
  wS = 4; //wrap S -> <S>
  wC = 5; //wrap C -> <C>

  n = 10; //baris
  m = 5; //kolom

type
  table_parsing = array[1..n,1..m] of string;
var
  tparsing : table_parsing;

  procedure set_table_parsing(var tp:table_parsing);
  var i,j : integer;
  begin
    // i0
    tp[1,c]:= 's3';
    tp[1,d]:= 's4';
    tp[1,ds]:= '';
    tp[1,wS]:= '1';
    tp[1,wC]:= '2';
    // i1
    tp[2,c]:= '';
    tp[2,d]:= '';
    tp[2,ds]:= 'ACC';
    tp[2,wS]:= '';
    tp[2,wC]:= '';
    // i2
    tp[3,c]:= 's6';
    tp[3,d]:= 's7';
    tp[3,ds]:= '';
    tp[3,wS]:= '';
    tp[3,wC]:= '5';
    // i3
    tp[4,c]:= 's3';
    tp[4,d]:= 's4';
    tp[4,ds]:= '';
    tp[4,wS]:= '';
    tp[4,wC]:= '8';
    // i4
    tp[5,c]:= 'r3';
    tp[5,d]:= 'r3';
    tp[5,ds]:= '';
    tp[5,wS]:= '';
    tp[5,wC]:= '';
    // i5
    tp[6,c]:= '';
    tp[6,d]:= '';
    tp[6,ds]:= 'r1';
    tp[6,wS]:= '';
    tp[6,wC]:= '';
    // i6
    tp[7,c]:= 's6';
    tp[7,d]:= 's7';
    tp[7,ds]:= '';
    tp[7,wS]:= '';
    tp[7,wC]:= '9';
    // i7
    tp[8,c]:= '';
    tp[8,d]:= '';
    tp[8,ds]:= 'r3';
    tp[8,wS]:= '';
    tp[8,wC]:= '';
    // i8
    tp[9,c]:= 'r2';
    tp[9,d]:= 'r2';
    tp[9,ds]:= '';
    tp[9,wS]:= '';
    tp[9,wC]:= '';
    // i9
    tp[10,c]:= '';
    tp[10,d]:= '';
    tp[10,ds]:= 'r2';
    tp[10,wS]:= '';
    tp[10,wC]:= '';
  end;

  procedure show_table(var tp:table_parsing);
  var i,j : integer;
  begin
    for i:=1 to m do
      begin
        for j:=1 to n do
          begin
            write(tp[i,j], ' ');
          end;
          writeln();
      end;//endfor

  end;
begin
  set_table_parsing(tparsing);
  show_table(tparsing);
  readln;
end.
