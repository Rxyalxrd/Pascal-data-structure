type
  
  PStackStr = ^StackStr;
  IType = string;
  StackStr = record
    inf: IType;
    next: PStackStr
  end;
  
  PStackStrNum = ^StackStrNum;
  LType = real;
  StackStrNum = record
    inf: LType;
    next: PStackStrNum
  end;

procedure Push_real(var p: PStackStrNum; i: LType);
var p1: PStackStrNum;
begin
  new(p1);
  p1^.inf := i;
  p1^.next := p;
  p := p1;
end;

procedure Pop_real(var p: PStackStrNum);
var 
  p1: PStackStrNum;
begin
  if p <> nil then
    begin
      p1 := p^.next;
      dispose(p);
      p := p1;
    end;
end;

function Top(p: PStackStrNum): real;
begin
  Top := p^.inf;
end;

procedure Add_str(var p: PStackStr; i: IType);
var p1: PStackStr;
begin
  new(p1);
  p1^.inf := i;
  p1^.next := p;
  p := p1;
end;

procedure Pop_str(var p: PStackStr);
var p1: PStackStr;
begin
  if p <> nil then
    begin
      p1 := p^.next;
      dispose(p);
      p := p1;
    end;
end;

  
function CreateStack(): PStackStr; 
begin 
  CreateStack := nil 
end;

function Top_str(p: PStackStr): string;
begin
  Top_str := p^.inf;
end;

function last(p: PStackStr): PStackStr;
var q: PStackStr;
begin
  if (p = nil) then last := nil
  else
  begin
    q := p;
    while q^.next <> nil do q := q^.next;
    last := q;
  end;
end;

procedure AddEnd(var p: PStackStr; c: string);
var q, y: PStackStr;
begin
  new(q);
  q^.inf := c;
  q^.next := nil;
  if p = nil then p := q
  else 
    begin
      y := last(p);
      y^.next := q;
    end;
end;

function CreateStrStack(s: string): PStackStr;
var p: PStackStr;
begin
  p := CreateStack(); 
  for i: integer := 1 to length(s) do AddEnd(p, s[i]);
  CreateStrStack := p
end;



function transform(var p: PStackStr): string;
var s: string;
    k: PStackStr;
begin
  while p <> nil do
    begin
      if (p^.inf <> '+') and (p^.inf <> '-') and (p^.inf <> '*') and (p^.inf <> '/') and (p^.inf <> '(') and (p^.inf <> ')') then s := s + p^.inf;
      if (p^.inf = '+') or (p^.inf = '-') or (p^.inf = '*') or (p^.inf = '/') then  
        begin 
          Add_str(k, p^.inf) 
        end;
      if (p^.inf = ')') then 
        begin 
         s := s + Top_str(k);
         Pop_str(k); 
        end;
      p := p^.next;
    end;
  transform := s;
end;

function calc(var p: PStackStr): real;
var 
  k, n1, n2: real;
  l: PStackStrNum;
begin
  while p <> nil do 
    begin
      if (p^.inf <> '+') and (p^.inf <> '-') and (p^.inf <> '*') and (p^.inf <> '/') then 
        begin 
          write('Введите значение для: ', p^.inf, ' ');
          readln(k);
          Push_real(l, k) 
        end
      else 
        begin
          n1 := Top(l);
          Pop_real(l); 
          n2 := Top(l);
          Pop_real(l);
          if (p^.inf = '+') then 
            begin 
              n1 := n2 + n1;
              Push_real(l, n1);
            end;
          if (p^.inf = '-') then 
            begin 
              n1 := n2 - n1;
              Push_real(l, n1);
            end;
          if (p^.inf = '*') then 
            begin 
              n1 := n2 * n1;
              Push_real(l, n1);
            end;
          if (p^.inf = '/') then 
            begin 
              if n1 <> 0 then 
                begin 
                  n1 := n2 / n1;
                  Push_real(l, n1);
                end
              else writeln('Нельзя делить на 0');
            end;     
       end;
      p := p^.next;
  end;
  calc := n1;
end;

var 
    sb, ss: string;
    n: real;
    k, l: PStackStr;
    t: PStackStrNum;

begin

  writeln('Введите выражение: ');
  readln(sb);
  k := CreateStrStack(sb);
  ss := transform(k); 
  writeln(ss);
  l := CreateStrStack(ss);
  n := calc(l);
  write('Результат: ', n);   
   
end.