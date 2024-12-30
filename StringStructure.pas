program Lab3;
const
  N = 255 - 1;
type
  Str = array[0..N+1] of char;

{ Нулевой символ хранит размер строки }
function Len(var s: Str) := Ord(s[0]);

procedure PrintStr(var s: Str);
begin
  { Выводим первые Len(s) символов строки }
  for var i := 1 to Len(s) do
    write(s[i]);
end;


function CreateEmpty(): Str;
begin
  { Создаем пустую строку - с нулевым размером, заполенную нулями }
  for var i := 1 to N+1 do
    result[i] := Chr(0);
  result[0] := Chr(0);
end;

{ Создание собственной строки из строки Pascal }
function FromString(s: string): Str;
begin
  { Если строки паскаля слишком длинная, то предупредим об этом }
  if Length(s) > N then
    writeln('FromStr: overflow');
  { Просто копируем символы }
  result[0] := Chr(Length(s));
  for var i := 1 to Length(s) do
    result[i] := s[i];
end;


{ Добваление символа в конец }
procedure Append(var s: Str; c: char);
begin
  var l := Len(s);
  { Если добавлять некуда, то напишем об этом }
  if l >= N then
    writeln('Append: overflow')
  else
  begin
    { Вставляем в конец и обновляем размер }
    s[0] := Chr(l+1);
    s[l+1] := c;
  end;
end;

{ Разбить строку s на 2 подстроки начиная с k символа. Результат положить в s1 }
procedure Split(var s, s1: Str; k: integer);
begin
  { Если k слишком большое, то ограничем его размером s, чтобы не было отрицательных размеров }
  var l := Min(Len(s), k);
  { Обновляем размеры }
  s1[0] := Chr(Len(s) - l + 1);
  s[0] := Chr(l - 1);
  { Копируем сиволы в s1 и очищаем s }
  for var i := 1 to Len(s1) do
  begin
    s1[i] := s[k + i - 1];
    s[k + i - 1] := Chr(0);
  end;
end;

{ Соединяем 2 строки }
function StrCat(s1, s2: Str): Str;
begin
  result := s1;
  { Если строки слишкрм длинные, то напишем об этом }
  if Len(s1) + Len(s2) >= N then
    writeln('StrCat: overflow')
  else
  begin
    { Копируем символы s2 в конец s1, не забываем обновить размер }
    result[0] := Chr(Len(s1) + Len(s2));
    for var i := 1 to Len(s2) do
      result[Len(s1) + i] := s2[i];
  end;
end;

function Find(var s, s1: Str): integer;
begin
  result := 0;
  { Будем пытаться искать s1 в s начиная с 1 символа, затем со 2... }
  { Последний поиск будет проводится в самом конце строки, поэтому начинать последний поиск нужно с индекса Len(s) - Len(s1) }
  for var i := 1 to Len(s) - Len(s1) do
  begin
    { Предположим, что мы нашли s1 в s } 
    var match_ := true;
    for var j := 1 to Len(s1) do
      { Если символы отличаются, то наше предположение было не верно }
      if s[i + j - 1] <> s1[j] then
        match_ := false;
    { Ну а если оно было верно, то вернем индекс начала }
    if match_ then
    begin
      result := i;
      exit;
    end;
  end;
end;

function Replace(s: Str; var needle, repl: Str): Str; 
begin
  var p, p1: Str;
  { Найдем первое вхождение needle в s }
  var idx := Find(s, needle);
  while idx <> 0 do
  begin
    { Разделим по этому индексу строки. В s у нас "голова", а в p - "хвост", начало которого мы должны заменить }
    Split(s, p, idx);
    { К голове добавим ту самую замену }
    s := StrCat(s, repl);
    { Из начала хвоста уберем то, что нужно заменить }
    Split(p, p1, Len(needle) + 1);
    { Присоеденим хвост к голове хе-хе }
    s := StrCat(s, p1);
    { и попробуем повторить весь процесс }
    idx := Find(s, needle);
  end;
  result := s;
end;


{ Это прочто циферку от 1 до n считывает. Нужно для меню }
function ReadN(n:integer): integer;
begin
  repeat
    readln(result);
  until (result > 0) and (result <= n);
end;

begin
  var s1, s2, s3: Str;
  var act, m: integer;
  repeat
    writeln('0 - выход');
    writeln('1 - длинна');
    writeln('2 - печать');
    writeln('3 - создать пустую');
    writeln('4 - создать из строки');
    writeln('5 - добавить символ');
    writeln('6 - разделить');
    writeln('7 - соеденить');
    writeln('8 - найти');
    writeln('9 - заменить');
    
    readln(act);
    case act of
    1: begin
      m := ReadN(3);
      if m = 1 then writeln(Len(s1))
      else if m = 2 then writeln(Len(s2))
      else writeln(Len(s3));
    end;
    2: begin
      m := ReadN(3);
      if m = 1 then PrintStr(s1)
      else if m = 2 then PrintStr(s2)
      else PrintStr(s3);
    end;
    3: begin
      m := ReadN(3);
      if m = 1 then s1 := CreateEmpty
      else if m = 2 then s2 := CreateEmpty
      else s3 := CreateEmpty;
    end;
    4: begin
      var s: string;
      readln(s);
      m := ReadN(3);
      if m = 1 then s1 := FromString(s)
      else if m = 2 then s2 := FromString(s)
      else s3 := FromString(s);
    end;
    5: begin
      var c: char;
      readln(c);
      m := ReadN(3);
      if m = 1 then Append(s1, c)
      else if m = 2 then Append(s2, c)
      else Append(s2, c);
    end;
    6: begin
      var k: integer;
      readln(k);
      Split(s1, s2, k);
    end;
    7: s1 := StrCat(s1, s2);
    8: writeln(Find(s1, s2));
    9: s1 := Replace(s1, s2, s3);
   end;
  until act = 0;
end.