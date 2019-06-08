program bottom_parser_app;
uses sysutils;
const
  c = 1;
  d = 2;
  dS = 3; // $
  wS = 4; //wrap S -> <S>
  wC = 5; //wrap C -> <C>

  n = 10; //baris
  m = 5; //kolom

type
  table_parsing = array[1..n,1..m] of string;
  stack_pointer = ^stack;
  stack = Record
    info: string;
    next: stack_pointer;
  end;
  array_string = array of char;
var
  tparsing: table_parsing;
  top_stack: stack_pointer;

  function set_table_parsing(tp:table_parsing):table_parsing;
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
    set_table_parsing := tp;
  end;


procedure push_stack(data:string;var top_stack:stack_pointer);
  var baru:stack_pointer;
begin
  new(baru);
  baru^.info := data;
  baru^.next := nil;

  if top_stack = nil then
    top_stack := baru
  else
  begin
    baru^.next := top_stack;
    top_stack := baru;
  end;   
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

procedure pop_stack(var awal:stack_pointer);
  var phapus: stack_pointer;
begin
  if awal = nil then
    writeln('Stack Empty')
  else
    begin
      phapus := awal;
      awal := awal^.next;
      dispose(phapus);
    end;
end;

procedure show_stack(awal:stack_pointer);
var
   bantu:stack_pointer;
begin
     write('Data : ');
     if awal=nil then
        writeln('Data kosong')
     else
     begin
          bantu:=awal;
          while bantu<>nil do
          begin
               write(bantu^.info:4);
               bantu:=bantu^.next;
          end;
          writeln;
     end;
end;

procedure bottom_up(input:string;tparsing:table_parsing);
var
  arr: array of char;
  i,len: integer;
  tableparsing: table_parsing;
  bantu: integer;
  bantu2: string;
begin
  // split string to array
  len := length(input);
  setLength(arr,len);

  for i:=len downto 0 do 
      arr[i-1] := input[i];
  //end  split string to array

  // for i:=0 to length(arr) do
  //   write(arr[i], ' ');
  
  tableparsing := set_table_parsing(tparsing);

  top_stack := nil;
  push_stack('0',top_stack);

  for i:=0 to 3 do
  begin
    case arr[i] of
      'c': begin
          bantu:= strToInt(top_stack^.info);
            if tableparsing[bantu+1,c] <> '' then
            begin
              bantu2 := tableparsing[bantu+1,c];
              push_stack('c',top_stack);
              push_stack(bantu2[2],top_stack);
              
            end;
          writeln('TABLE: ',tableparsing[bantu+1,c]);
          writeln('KOOR: ',c,bantu+1);  
          write('action: ',tableparsing[bantu+1,c],' ');
          writeln('stack: ',top_stack^.info);
       end;
      'd': begin
          bantu:= strToInt(top_stack^.info);
          if tableparsing[bantu+1,d] <> '' then
            begin
              bantu2 := tableparsing[bantu+1,d];
              push_stack('d',top_stack);
              push_stack(bantu2[2],top_stack);
            end;
            writeln('TABLE: ',tableparsing[bantu+1,d]);
            writeln('KOOR: ',d,bantu+1);  
            write('action: ',tableparsing[bantu+1,d],' ');
          writeln('stack: ',top_stack^.info);
       end;
      else
        writeln('Sorry i cannot do far');
    end;
  end;

show_stack(top_stack);
writeln('BABI',tableparsing[2,4]);
end;

begin
  // top_stack:= nil;
  tparsing[n,m]:='0';
  // push_stack('a',top_stack);
  // push_stack('n',top_stack);
  // push_stack('j',top_stack);
  // push_stack('i',top_stack);
  // push_stack('n',top_stack);
  // push_stack('g',top_stack);

  // pop_stack(top_stack);

  // set_table_parsing(tparsing);
  // show_table(tparsing);

  // show_stack(top_stack);
  bottom_up('cdd',tparsing);
  readln;
end.
