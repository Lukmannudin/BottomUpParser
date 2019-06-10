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

  rule1 = '1';
  rule2 = '2';
  rule3 = '3';

  shift_rule = 'S';
  reduce_rule = 'R';

  c_grammar = 'c';
  d_grammar = 'd';
  dS_grammar = '$';
  wS_grammar = '<S>';
  wC_grammar = '<C>';


type
  table_parsing = array[1..n,1..m] of string;
  stack_pointer = ^stack;
  stack = Record
    info: string;
    next: stack_pointer;
  end;
  array_string = array of char;
var
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
   i,j : integer;
   arrInvers : array of string;
   max:integer;
begin
i:=0;
     write('Stack : ');
     if awal=nil then
        writeln('Data kosong')
     else
     begin
          bantu:=awal;
          while bantu<>nil do
          begin
               write(bantu^.info:4,' ');
               bantu:=bantu^.next;
               i := i+1;
          end;
          writeln;
     end;
end;

function rule_1(var top_stack: stack_pointer):boolean;
begin
  rule_1 := false;
  if uppercase(top_stack^.next^.info) = uppercase(wC_grammar) then
    if uppercase(top_stack^.next^.next^.next^.info) = uppercase(wC_grammar) then
      begin
        pop_stack(top_stack);
        pop_stack(top_stack);
        pop_stack(top_stack);
        pop_stack(top_stack);
        push_stack(wS_grammar,top_stack);
        rule_1 := true;
      end;
end;

function rule_2(var top_stack: stack_pointer):boolean;
begin
  rule_2 := false;
  // writeln('REDUCE WITH RULE 2');
  if uppercase(top_stack^.next^.info) = uppercase(wC_grammar) then
    if uppercase(top_stack^.next^.next^.next^.info) = uppercase(c_grammar) then
      begin
        pop_stack(top_stack);
        pop_stack(top_stack);
        pop_stack(top_stack);
        pop_stack(top_stack);
        push_stack(wC_grammar,top_stack);
        rule_2 := true;
      end;
end;

function rule_3(var top_stack: stack_pointer):boolean;
begin
  rule_3 := false;
  // writeln('REDUCE WITH RULE 3');
  // writeln('STACK AVAILABLE: ',top_stack^.next^.info);
  if uppercase(top_stack^.next^.info) = uppercase(d_grammar) then
    begin
      pop_stack(top_stack);
      pop_stack(top_stack);
      push_stack('<C>',top_stack);
      rule_3 := true;
    end  
    else
      begin
        rule_3 := false;
      end;  
end;

function reduce(token:string;var top_stack:stack_pointer):boolean;
begin
  reduce := true;
  case token[2] of
    rule1 : begin
              reduce := rule_1(top_stack);
            end;
    rule2 : begin
              reduce := rule_2(top_stack);
            end;
    rule3 : begin
              reduce := rule_3(top_stack);
            end; 
  end;//endcase        
end;

procedure shift(input:string; token:string; var top_stack:stack_pointer);
begin
  push_stack(input,top_stack);
  push_stack(token[2],top_stack);
end;

function baris_position(info:string):integer;
begin
info := uppercase(info);
      case top_stack^.info of
        '<S>': baris_position := wS;         
        '<C>': baris_position := wC; 
      end;
end;

procedure after_reduce_mechanism(var top_stack:stack_pointer; var tableparsing:table_parsing);
var bantuBaris : integer;
begin
  bantuBaris := baris_position(top_stack^.info);
  push_stack(
    tableparsing[
    strToInt(top_stack^.next^.info)+1,
    bantuBaris],
    top_stack
  );
end;

function reducing_stack(bantu2:string;var top_stack:stack_pointer;var tableparsing:table_parsing):boolean;
begin
  reducing_stack := false;
  if uppercase(bantu2[1]) = reduce_rule then
    begin 
      if reduce(bantu2,top_stack) = false then //reduce
        begin
          // break;
          writeln('Sorry, Something wrong with reduce mechanism');
        end//endreduce
        else
          after_reduce_mechanism(top_stack,tableparsing);
          reducing_stack := true;
    end // end reduce_rule  
end;
function grammar_check(kolom:integer):string;
begin
  grammar_check := '';
  case kolom of
    c : grammar_check := c_grammar;
    d : grammar_check := d_grammar;
    dS : grammar_check := dS_grammar;
    wS : grammar_check := wS_grammar;
    wC : grammar_check := wC_grammar;
  end;  
end;

function derivation_mechanism(kolom:integer;var tableparsing: table_parsing; 
  var top_stack:stack_pointer):boolean;
var
  bantu: integer;
  bantu2: string;
  grammar : string;
begin
  derivation_mechanism := false;
  bantu:= strToInt(top_stack^.info);  
  bantu2 := tableparsing[bantu+1,kolom];
  grammar := grammar_check(kolom);
  if uppercase(bantu2[1]) = shift_rule then
    begin
      shift(grammar,bantu2,top_stack);
      derivation_mechanism := true;
      // writeln('ACTION shift: ',tableparsing[bantu+1,kolom]);
    end;
  
  if uppercase(bantu2[1]) = reduce_rule then
    begin
      derivation_mechanism := reducing_stack(bantu2,top_stack,tableparsing);
      derivation_mechanism := true;
      //  writeln('ACTION reduce: ',tableparsing[bantu+1,kolom]);
    end 
      
end;

function derivation_terminal_simulation(kolom:integer;
var tableparsing:table_parsing;var top_stack:stack_pointer):boolean;
var 
  bantu:integer;
begin
  derivation_terminal_simulation := false;
  bantu:= strToInt(top_stack^.info);
  
  if tableparsing[bantu+1,kolom] <> '' then
    begin
      derivation_terminal_simulation := derivation_mechanism(kolom,tableparsing,top_stack);
    end
      else
        writeln('Sorry, your input string not acceptable');
  end;

procedure set_string_to_array(input:string; var arr:array_string);
var
  i,len: integer;
begin
  i:=0;
  input := concat(input,'$');
  len := length(input);
  setLength(arr,len);

  for i:=len downto 0 do 
      arr[i-1] := input[i];
  
  writeln('Your Input String : ',input);
  writeln();

end;

procedure init_bottom_up(var top_stack:stack_pointer; var tableparsing:table_parsing);
begin
  tableparsing := set_table_parsing(tableparsing);
  top_stack := nil;
  push_stack('0',top_stack);
end;


procedure bottom_up(input:string);
var
  arr: array of char;
  i,j: integer;
  tableparsing: table_parsing;
  bantu: integer;
  bantu2: string;
  kolomPosition:integer;
  limitIteration,limit: integer;
begin
  limit := 50;
  
  set_string_to_array(input,arr);
  init_bottom_up(top_stack,tableparsing);

  limitIteration := 0;
  i :=0;
  
  while (i < length(arr)) and (i<limit) do
  begin
    show_stack(top_stack);

    case arr[i] of
      c_grammar   : kolomPosition := c;
      d_grammar   : kolomPosition := d;
      dS_grammar  : kolomPosition := dS;
      else 
        writeln('Sorry i cannot do far ');
    end;//end d_grammar

      bantu:= strToInt(top_stack^.info);
      
      writeln('ACTION : ',tableparsing[bantu+1,kolomPosition]);
      // writeln('Current String : ',arr[i], ' position: [',i,']');

      write('STRING :');
      for  j:= i to length(arr) - 1 do
        write(arr[j]);

      writeln;
      // show_stack(top_stack);

      if derivation_terminal_simulation(kolomPosition,tableparsing,top_stack) = false then
        break;

      writeln();

      bantu2 := tableparsing[bantu+1,kolomPosition];
      limitIteration := limitIteration + 1;
      
      // show_stack(top_stack);

      if uppercase(bantu2[1]) = shift_rule then
        i := i+1;

      if (limitIteration = limit) OR (bantu2 = 'ACC') then
        break;
  end;//end case
  // show_stack(top_stack);
end;

begin
  bottom_up('cdd');
  readln;
end.
