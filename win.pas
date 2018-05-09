unit win;
interface
procedure Anim(x,y,z,g,color:byte);
procedure Windows(x,y,z,g,color:byte);
implementation
uses
 crt;

procedure Windows(x,y,z,g,color:byte);

var
 i:byte;

begin
TextBackground(color);
window(x,y,z,g);
clrscr;
write(chr(201));
i:=0;
while i <> z-x-1 do
begin
i:=i+1;
write(chr(205));
end;
write(chr(187));
i:=0;
while i <> g-y-1 do
begin
i:=i+1;
gotoxy(1,i+1);
write(chr(186));
gotoxy(z-x+1,i+1);
write(chr(186));
end;
write(chr(200));
i:=0;
while i <> z-x-1 do
begin
i:=i+1;
write(chr(205));
end;
mem[$b800:((y-1)*80+(g-y)*80+z-1)*2]:=188;
window(x+1,y+1,z-1,g-1);

end;

procedure anim(x,y,z,g,color:byte);

var
 fz:char;
 b,i:byte;

begin
i:=trunc((z-x)/2)-2;
b:=trunc((g-y)/2)-1;
while i <> 0 do
begin
Windows(x+i,y+b,z-i,g-b,color);
delay(5);
i:=i-1;
end;
while b <> 0 do
begin
Windows(x,y+b,z,g-b,color);
delay(5);
b:=b-1;
end;
end;
begin
end.