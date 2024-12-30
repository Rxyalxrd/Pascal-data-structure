program from_list_and_tree_to_list;
uses crt;
type


    List=record
    next:^List;
    R:integer;
    level:^List;
    atom:char;
  end;
    
    pTree=^Tree;
    Tree=record
    root:char;
    left:pTree;
    right:pTree;
  end;
  
var p:^List; 
    q:pTree;

procedure Input_to_List(var p:^List);
var c:char;
begin
  if not eoln then
  begin
    read(c);
    case c of
    '(':                      begin
                              new(p); p^.R:=0;
                              Input_to_List(p^.level);
                              Input_to_List(p^.next);
                              end;
    'a'..'z','+','-','*','/': begin
                              new(p); p^.R:=1;
                              p^.atom:=c;
                              Input_to_List(p^.next);
                              end;
    ')':                      p:=nil
    end
  end 
  else p:=nil
end;

procedure Print_of_List(p:^List);
var q:^List;
begin
  if p<>nil then
  begin
    if p^.R=1 then write(p^.atom)
    else
    begin
      write('(');
      q:=p^.level;
      while q<>nil do
      begin
        Print_of_List(q);
        q:=q^.next
      end;
      write(')');
    end
  end
end;


function CutHead(var p:^List):^List;
var q:^List;
begin
  q:=p^.level;
  p^.level:=q^.next;
  q^.next:=nil;
  CutHead:=q
end;

function List_to_Tree(p:^List):pTree;
var q:pTree;
begin
  new(q);
  if p^.R=1 then
  begin
    q^.root:=p^.atom;
    q^.left:=nil;
    q^.right:=nil
  end 
  else
    begin
    q^.left:=List_to_Tree(CutHead(p));
    q^.root:=CutHead(p)^.atom;
    q^.right:=List_to_Tree(CutHead(p));
  end;
  List_to_Tree:=q
end;

procedure Print_of_Tree(p:pTree);
begin
  if p<>nil then
  begin
    if (p^.left<>nil)and(p^.right<>nil)then write('(');
    Print_of_Tree(p^.left);
    write(p^.root);
    Print_of_Tree(p^.right);
    if (p^.left<>nil)and(p^.right<>nil)then write(')');
  end;
end;

Procedure AddHead(var p:^List; q:^List);
begin
  q^.next:=p^.level;
  p^.level:=q
end;

function Tree_to_List(p:pTree):^List;
var ps:^List; 
    pright,pleft,proot:pTree;
begin
  new(ps);
  ps^.next:=nil;
  if (p^.left=nil) and (p^.right=nil) then
  begin
    ps^.R:=1;
    ps^.atom:=p^.root;
    dispose(p)
  end else
  begin
    ps^.R:=0;
    ps^.level:=nil;
    {Расчленение p на pleft, pright, proot}
    pright:=p^.right;
    pleft:=p^.left;
    p^.right:=nil;
    p^.left:=nil;
    proot:=p;
    AddHead(ps,Tree_to_List(pright));
    AddHead(ps,Tree_to_List(proot));
    AddHead(ps,Tree_to_List(pleft));
  end;
  Tree_to_List:=ps
end;

begin
  ClrScr;
  Input_to_List(p);
  Print_of_List(p);
  writeln;
  q:=List_to_Tree(p);
  print_of_Tree(q);
  writeln;
  p:=Tree_to_List(q);
  Print_of_List(p);
  writeln;
  repeat until keypressed
end.

