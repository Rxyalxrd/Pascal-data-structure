const MaxN = 5;

type
  
  KeyType = integer;
  ValueType = integer;
  Rec = record
    key: KeyType;
    inf: ValueType;
  end;
  arr = array[0..MaxN] of Rec;
  Table = record
    items: arr;
  end;

  var
    
    num : integer;
 
function create(): Table;
begin
  num := 0;
end;

function isempty(var t: Table): boolean;
begin
  isempty := (num = 0);
end;

procedure move(var t: Table; index: integer);
begin
  for var i := num downto index do
  begin
    t.items[i + 1].key := t.items[i].key;
    t.items[i + 1].inf := t.items[i].inf;
  end;
end;

function findplace(var t: Table; k: KeyType): integer;
begin
  var i : integer := 0;
  while (i < num + 1) and (t.items[i].key < k) do
    i += 1;
  findplace := i;
end;

procedure add(var t: Table; key: KeyType; inf: ValueType);
begin
  if (num < MaxN) then
  begin
    var index := findplace(t, key);
    move(t, index);
    t.items[index].key := key;
    t.items[index].inf := inf;
    num += 1;
  end;
end;

function find(var t: Table; key: KeyType): integer;
begin
  for var i := 0 to num do
    if (t.items[i].key = key) then find := i;
  
end;

procedure delete(var t: Table; key: KeyType);
begin
  var j := Find(t, key);
  for var i := j + 1 to num do
  begin
    t.items[i-1].key := t.items[i].key;
    t.items[i-1].inf := t.items[i].inf; 
  end;
  num -= 1;
end;

procedure display(var t: Table);
begin
  writeln('Ключ':5, 'Значение':10);
  for var i := 1 to num do
  begin
    writeln(t.items[i].key:5, t.items[i].inf:10);
  end;
end;

var
  
  action: integer;
  m: Table;

begin
  writeln('Выберете действие:');
  writeln('1 - Создать');
  writeln('2 - Добавить');
  writeln('3 - Найти');
  writeln('4 - Удалить');
  writeln('5 - Пусто?');
  writeln('6 - Вывести');
  writeln('7 - Выход');

  repeat
    readln(action);
  case action of
    1: m := create();
    2: begin
      write('Введите ключ: ');
      var key: KeyType;
      readln(key);
      write('Введите значение: ');
      var inf: ValueType;
      readln(inf);
      add(m, key, inf);
      end;
    3: begin
      write('Введите ключ: ');
      var key: KeyType;
      readln(key);
      var index := find(m, key);
      writeln('Значение: ', m.items[index].inf);
      end;
    4: begin
      write('Введите ключ: ');
      var key: KeyType;
      readln(key);
      delete(m, key);
      end;
    5: writeln('Пустой: ', isempty(m));
    6: display(m);
    7: 
  else
    writeln('Неизвестное действие');
  end;
    until (action = 7);
end.