program DynamicStack;

type
  containeres = integer;
  StackNode = record
    data: containeres;
    next: ^StackNode;
  end;

function CreateStack(): ^StackNode;
begin
  CreateStack := nil;
end;

function IsEmpty(s: ^StackNode): Boolean;
begin
  IsEmpty := (s = nil);
end;

procedure Push(var s: ^StackNode; data: containeres);
var
  node: ^StackNode;
begin
  New(node);
  node^.data := data;
  node^.next := s;
  s := node;
end;

function Pop(var s: ^StackNode): containeres;
var
  tmp: ^StackNode;
begin
  tmp := s;
  s := tmp^.next;
  Pop := tmp^.data;
  Dispose(tmp);
end;

function Top(s: ^StackNode): containeres;
begin
  Top := s^.data;
end;

procedure DisplayStack(s: ^StackNode);
var
  node: ^StackNode;
begin
  write('Стэк: ');
  while s <> nil do
  begin
    write(s^.data, ' ');
    s := s^.next;
  end;
  writeln;
end;

var
  stak: ^StackNode;
  choice: Integer;
begin
  stak := CreateStack();
    repeat
      writeln('Выберите действие: ');
      writeln('1. Добавить элемент');
      writeln('2. Убрать верхнее значения');
      writeln('3. Узнать верхнее значение');
      writeln('4. Вывести стек');
      writeln('5. Выход');
      readLn(choice);
      print;
    case choice of
      1:
        begin
          var data := readinteger('Введите элемент: ');
          Push(stak, data);
          print;
        end;
      2:
        if not IsEmpty(stak) then
          Pop(stak)
        else
          begin
            writeLn('Стэк пустой');
            print;
          end;
      3:
        if not IsEmpty(stak) then
          writeLn('Верхний элемент: ', Top(stak))
        else
          begin
            writeLn('Стэк пустой');
            print;
          end;
      4:
        begin
          DisplayStack(stak);
          print;
          print;
        end;
    end;
  until choice = 5;
end.