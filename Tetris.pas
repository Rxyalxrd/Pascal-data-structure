uses GraphWPF;

const
  
  ColorN: array[0..12] of Color = (Colors.ForestGreen, Colors.Gold, Colors.Aqua,
                                   Colors.BlueViolet, Colors.Crimson, Colors.OliveDrab,
                                   Colors.MediumVioletRed, Colors.DarkOrange, Colors.RosyBrown, 
                                   Colors.Lime, Colors.Olive, Colors.Purple, Colors.DarkOrange);        
var
  
  Status, NumberFigure, Pause, Line, x, y, ColorNF, PressedKey, Score : integer;
  place: boolean;
  Field:array[1..12, 1..22] of integer;

procedure DrawBlock(i, j: integer);
var
  xx, yy: integer;
  shouldExit: Boolean;
begin
  shouldExit := False;

  if j > 22 then
  begin
    if (i < 2) or (i > 11) then place := True;
    shouldExit := True;
  end;

  if not shouldExit then
  begin
    xx := 220 + i * 26;
    yy := 573 - j * 26;
    case Status of
      0: FillRectangle(xx, yy, 26, 26, Colors.Black);
      1: FillRectangle(xx+1, yy+1, 24, 24, ColorN[Field[i,j]>0 ? Field[i,j] : ColorNF]);
      2: FillRectangle(xx, yy, 26, 26, Colors.Pink);
      3: if (i > 11) or (Field[i, j] > 0) then place := True;
      4: Field[i, j] := ColorNF;
      5: FillRectangle(xx - 155, yy - 420, 24, 24, ColorN[ColorNF]);
    end;
  end;
end;

procedure DrawFigures(x,y,n,s:integer); 
begin
 if s = 3 then place:= false; 
 Redraw(() -> begin
 Status := s; DrawBlock(x,y); 
 case n of 
   1: begin DrawBlock(x+1,y); DrawBlock(x,y-1); DrawBlock(x+1,y-1) end;
   2: begin DrawBlock(x-1,y); DrawBlock(x+1,y); DrawBlock(x+2,y) end;
   3: begin DrawBlock(x,y+1); DrawBlock(x,y-1); DrawBlock(x,y-2) end;
   4: begin DrawBlock(x+1,y); DrawBlock(x-1,y); DrawBlock(x-1,y+1) end;
   5: begin DrawBlock(x,y+1); DrawBlock(x+1,y+1); DrawBlock(x,y-1) end;
   6: begin DrawBlock(x-1,y); DrawBlock(x+1,y); DrawBlock(x+1,y-1) end;
   7: begin DrawBlock(x,y+1); DrawBlock(x,y-1); DrawBlock(x-1,y-1) end;
   8: begin DrawBlock(x-1,y); DrawBlock(x+1,y); DrawBlock(x+1,y+1) end;
   9: begin DrawBlock(x,y+1); DrawBlock(x,y-1); DrawBlock(x+1,y-1) end;
   10: begin DrawBlock(x+1,y); DrawBlock(x-1,y); DrawBlock(x-1,y-1) end;
   11: begin DrawBlock(x,y+1); DrawBlock(x,y-1); DrawBlock(x-1,y+1) end;
   12: begin DrawBlock(x-1,y); DrawBlock(x,y-1); DrawBlock(x+1,y-1) end;
   13: begin DrawBlock(x,y+1); DrawBlock(x-1,y); DrawBlock(x-1,y-1) end;
   14: begin DrawBlock(x+1,y); DrawBlock(x-1,y-1); DrawBlock(x,y-1) end;
   15: begin DrawBlock(x-1,y); DrawBlock(x,y-1); DrawBlock(x-1,y+1) end;
   16: begin DrawBlock(x+1,y); DrawBlock(x-1,y); DrawBlock(x,y+1) end;
   17: begin DrawBlock(x+1,y); DrawBlock(x,y+1); DrawBlock(x,y-1) end;
   18: begin DrawBlock(x,y-1); DrawBlock(x-1,y); DrawBlock(x+1,y) end;
   19: begin DrawBlock(x-1,y); DrawBlock(x,y+1); DrawBlock(x,y-1) end
 end
end)
end;
 
procedure MoveFigure;
begin
 sleep(Pause); 
 case PressedKey of  
  1: begin
        DrawFigures(x-1,y,NumberFigure,3);
        if not place then begin DrawFigures(x,y,NumberFigure,0); x -= 1; DrawFigures(x,y,NumberFigure,1); end;
       end;
  3: begin
         DrawFigures(x+1,y,NumberFigure,3);
         if not place then begin DrawFigures(x,y,NumberFigure,0); x += 1; DrawFigures(x,y,NumberFigure,1); end;
       end;
  5: begin
          var turn := Procedure -> 
           begin
            NumberFigure -= 1;
            case NumberFigure of 
             15: NumberFigure:=19;
             13: NumberFigure:=15;
             11: NumberFigure:=13;
              7: NumberFigure:=11;
              3: NumberFigure:=7;
              1: NumberFigure:=3;
              0: NumberFigure:=1;
            end;
         end;
        
         turn; DrawFigures(x,y,NumberFigure,3); turn; turn; turn;
        
         if not place then begin DrawFigures(x,y,NumberFigure,0); turn; DrawFigures(x,y,NumberFigure,1); end;
      end;
  2: Pause := 2; 
  22: Pause := 50 - Line * 2;
end;
end;
 
procedure Main;
begin
  while true do 
    begin
      Window.Clear(Colors.Black);
      TextOut(65,10, 'Next figure:', Font.withSize(24).withColor(Colors.White));
      TextOut(50,395,'Wasd - control', Font.withSize(22).withColor(Colors.White));
      TextOut(75,435,'W - turn', Font.withSize(16).withColor(Colors.White));
      TextOut(75,460,'A - move left', Font.withSize(16).withColor(Colors.White));
      TextOut(75,485,'D - move right', Font.withSize(16).withColor(Colors.White));
      TextOut(75,510,'S - speeding up', Font.withSize(16).withColor(Colors.White));

      for var xx:=1 to 12 do 
        for var yy:=1 to 22 do 
          if (xx = 1) or (xx = 12) or (yy = 1) then 
          begin 
            Field[xx,yy]:=1; 
            Status := 2; 
            DrawBlock(xx,yy) 
          end
          else 
            Field[xx,yy]:= 0; 
            place := false; 
            Status := 0;
            PressedKey := 0;
            Line := 0;
            var nextF := (1+random(18), Random(1,8));
            FillRectangle(30,220,200,140,Colors.Black);
            DrawText(30,220,200,140,'Score: 0', Colors.White);
            repeat
              Pause := 30 - Line * 2; 
              FillRectangle(70,60,160,140,Colors.Black);
              var Now := NextF;
              nextF := (1+random(18), Random(1,8));
              Status := 5; 
              (NumberFigure, ColorNF):= nextF;
              DrawFigures(2,2,NumberFigure,5);
              Status := 0; 
              (NumberFigure, ColorNF):= Now;
              (x,y) := (7, 22); 
              DrawFigures(x,y,NumberFigure,3); 
                                                    
              if not place then 
              begin
                repeat 
                 DrawFigures(x,y,NumberFigure,1); 
                 loop 15 do 
                   begin 
                    MoveFigure; 
                    if PressedKey = 10 then 
                      break; 
                      PressedKey := 0; 
                   end;
                 DrawFigures(x,y-1,NumberFigure,3); 
                 if not place then 
                   begin 
                     DrawFigures(x,y,NumberFigure,0); 
                     y -= 1 
                   end;
                until place;  
                DrawFigures(x,y,NumberFigure,4); 
                
                Redraw(() ->begin
                for var yy := 22 downto 2 do 
                 begin
                   var a := 0; 
                   for var xx:=2 to 11 do 
                     a += Field[xx,yy]>0 ? 1 : 0;
                     if a = 10 then 
                     begin  
                       for var yyy:= yy to 21 do 
                         for var xx:= 2 to 11 do 
                           Field[xx,yyy] := Field[xx,yyy+1]; 
                           Score += 10;
                           Line += 1;
                           FillRectangle(30,220,200,140,Colors.Black);
                           DrawText(30,220,200,140,'Score: '+Score.ToString, Colors.White);
                     end 
                 end;
             
                 
                 for var xx:=2 to 11 do 
                   for var yy:=2 to 22 do 
                     begin 
                       Status := Field[xx,yy]>0 ? 1 : 0; 
                       DrawBlock(xx,yy) 
                     end;
                 place := false; 
                 end);     
               end;   
             until place; 
               DrawFigures(x,y,NumberFigure,1);
               FillRectangle(0,237,999,100,Colors.MistyRose);  
               DrawText(152,237,260,50,'Game over',Colors.LightSalmon);
               DrawText(152,287,260,50,'Press ENTER for the new game',Colors.LightSalmon);
               repeat
                sleep(Pause); 
                if PressedKey = 10 then break;
               until false;
       
      end;    
 end;
 
begin
 Window.Title := 'Tetris';
 window.SetSize(550, 574);
 Window.CenterOnScreen; 
 Window.IsFixedSize := True; 
 Font.Style := Bold; 
 Font.Size := 32;
 OnkeyDown := K ->
  case K of
    Key.Left, Key.A: PressedKey := 1;
    Key.Down, Key.Space, Key.S: PressedKey := 2; 
    Key.Right, Key.D: PressedKey := 3;
    Key.Up, Key.W: PressedKey := 5; 
    Key.Enter: PressedKey := 10; 
    Key.Escape: halt(1); 
   else PressedKey := 0; 
 end; 
 OnkeyUp := K ->
    case K of
      Key.Down, Key.Space, Key.S: PressedKey := 22; 
    end;
 Main;
end.
