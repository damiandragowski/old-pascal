{$M 16384,0,655360}
uses

 Dos,Menu,Win,MainList,crt;

label
 l1,l3;

{$F+,S-,W-}
procedure TimerHandler; interrupt;
var
 i:byte;
 s1:string[2];
 h, m, s, hund : Word;
  begin
   i:=i+1;
   if i=18 then begin
    GetTime(h,m,s,hund);
    s1:=inttostr(h);
    if length(s1) = 1 then begin
    s1:=s1+' ';
    s1[2]:=s1[1];
    s1[1]:=' ';
    end;
    mem[$b800:3984]:=ord(s1[1]);
    mem[$b800:3985]:=$70;
    mem[$b800:3986]:=ord(s1[2]);
    mem[$b800:3987]:=$70;
    mem[$b800:3988]:=58;
    mem[$b800:3989]:=$70;
    s1:='  ';
    s1:=inttostr(m);
    if length(s1) = 1 then begin
    s1:=s1+' ';
    s1[2]:=s1[1];
    s1[1]:='0';
    end;
    mem[$b800:3990]:=ord(s1[1]);
    mem[$b800:3991]:=$70;
    mem[$b800:3992]:=ord(s1[2]);
    mem[$b800:3993]:=$70;
    mem[$b800:3994]:=44;
    mem[$b800:3995]:=$70;
    s1:='  ';
    s1:=inttostr(s);
    if length(s1) = 1 then begin
    s1:=s1+' ';
    s1[2]:=s1[1];
    s1[1]:='0';
    end;
    mem[$b800:3996]:=ord(s1[1]);
    mem[$b800:3997]:=$70;
    mem[$b800:3998]:=ord(s1[2]);
    mem[$b800:3999]:=$70;
    i:=0;
   end;
end;
{$F-,S+}

var
 Int1CSave : Pointer;
 s1ptr,s2ptr:StringPtr;
 C : Char;

begin
textbackground(0);
textcolor(15);
clrscr;
Lista.Init;
OpenFromFile;
window(1,25,80,25);
textbackground(15);
textcolor(0);
clrscr;
Write(' Program Pokazujacy Prace na liscie','                           Godzina:');
GetIntVec($1C,Int1CSave);
SetIntVec($1C,Addr(TimerHandler));
textcolor(15);
manu;
repeat
l1:
clrscr;
manu1;
case C of
'1' :
begin
anim(1,12,80,24,4);
new(s1ptr);
new(s2ptr);
Write('Podaj Imie Studenta: ');
window(23,14,46,14);
textbackground(11);
clrscr;
window(2,16,28,16);
textbackground(4);
clrscr;
Write('Podaj Nazwisko Studenta:');
window(29,16,59,16);
textbackground(11);
clrscr;
window(2,18,34,18);
textbackground(4);
clrscr;
Write('Podaj Rok Urodzenia Studenta:');
window(35,18,40,18);
textbackground(11);
clrscr;
window(23,14,46,14);
textbackground(11);
clrscr;
readln(s1ptr^);
if length(s1ptr^) = 0 then goto l3;
Write(s1ptr^);
window(29,16,59,16);
textbackground(11);
clrscr;
readln(s2ptr^);
if length(s2ptr^) = 0 then goto l3;
Write(s2ptr^);
window(35,18,40,18);
textbackground(11);
clrscr;
Readln(Variable);
Write(Variable);
IDS:=IDS+1;
ID:=IDS;
Lista.Add(s1ptr,s2ptr,ID,Variable);
TextBackGround(0);
window(1,12,80,24);
clrscr;
l3:
end;
'2' :
begin
Anim(1,12,80,24,4);
Write('Podaj ID: ');
window(11,14,16,14);
textbackground(11);
clrscr;
Readln(ID);
Write(ID);
Lista.Del(ID);
TextBackGround(0);
window(1,12,80,24);
clrscr;
end;
'3' :
begin
menuedit;
c:='0';
goto l1;
end;
'4' :
begin
MenuRap;
c:='0';
goto l1;
end;
'5' :
begin
Anim(1,12,80,24,5);
Lista.Display;
TextBackGround(0);
window(1,12,80,24);
clrscr;
end;
end;
C:=readkey;
until C = #27;
SaveToFile;
Lista.Done;
window(1,1,80,25);
TextBackGround(0);
TextColor(7);
Clrscr;
  SetIntVec($01C,Int1CSave);
end.