unit menu;
interface
procedure manu;
procedure manu1;
procedure menuedit;
procedure menuRap;

implementation
uses
 Mainlist,win,crt;

var
 S1: String;

procedure ManuRap;
begin
window(1,1,80,12);
textbackground(0);
clrscr;
anim(1,1,80,12,1);
Writeln('                     ########     Menu Raporty      ####### ');
Writeln;
Writeln('1. Wyswietl Wedlug Imion');
Writeln('2. Wyswietl Wedlug Nazwisk');
Writeln('3. Buduj Zapytanie');
Writeln;
Writeln('ESC = Poprzednie Menu');
end;

procedure ManuRap1;
begin
window(1,1,80,12);
textbackground(0);
clrscr;
Windows(1,1,80,10,1);
Writeln('                     ########     Menu Raporty      ####### ');
WriteLn;
Writeln('1. Wyswietl Wedlug Imion');
Writeln('2. Wyswietl Wedlug Nazwisk');
Writeln('3. Buduj Zapytanie');
Writeln;
Writeln('ESC = Poprzednie Menu');
end;


procedure manuedit;
begin
window(1,1,80,12);
textbackground(0);
clrscr;
anim(1,1,80,12,1);
Writeln('                     ########     Menu Edycja      ####### ');
Writeln('1. Dodaj Przedmiot');
Writeln('2. Odejmowanie Przedmiotu');
Writeln('3. Dodaj ocene');
Writeln('4. Odejmowanie oceny');
Writeln('5. Wyswietl oceny Studenta');
Writeln('ESC = Poprzednie Menu');
end;


procedure manuedit1;
begin
window(1,1,80,12);
textbackground(0);
clrscr;
Windows(1,1,80,10,1);
Writeln('                     ########     Menu Edycja      ####### ');
Writeln('1. Dodaj Przedmiot');
Writeln('2. Odejmowanie Przedmiotu');
Writeln('3. Dodaj ocene');
Writeln('4. Odejmowanie oceny');
Writeln('5. Wyswietl oceny Studenta');
Writeln('ESC = Poprzednie Menu');
end;



procedure menuedit;

var
 C:char;

begin
textbackground(0);
textcolor(15);
clrscr;
manuedit;
repeat
clrscr;
manuedit1;
case C of
'1' :
begin
anim(1,12,80,24,2);
new(s1ptr);
Writeln('Podaj identyfikator studenta:');
Readln(ID);
Writeln('Podaj nazwe przedmiotu:');
Readln(s1ptr^);
Lista.AddSubToSt(s1ptr,ID);
TextBackGround(0);
window(1,12,80,24);
clrscr;
end;
'2' :
begin
Anim(1,12,80,24,4);
new(s1ptr);
Writeln('Podaj ID Studenta:');
Readln(ID);
Writeln('Podaj nazwe przedmiotu:');
Readln(s1ptr^);
Lista.DelSubToSt(s1ptr,ID);
TextBackGround(0);
window(1,12,80,24);
dispose(s1ptr);
clrscr;
end;
'3' :
begin
Anim(1,12,80,24,2);
new(s1ptr);
Writeln('Podaj ID Studenta:');
Readln(ID);
Writeln('Podaj nazwe przedmiotu:');
Readln(s1ptr^);
WriteLn('Podaj Ocene:');
ReadLn(Variable);
Lista.AddNoteToSubSt(Variable,s1ptr,ID);
TextBackGround(0);
window(1,12,80,24);
dispose(s1ptr);
clrscr;
end;
'4' :
begin
Anim(1,12,80,24,4);
new(s1ptr);
Writeln('Podaj ID Studenta:');
Readln(ID);
Writeln('Podaj nazwe przedmiotu:');
Readln(s1ptr^);
WriteLn('Podaj Ocene:');
ReadLn(Variable);
Lista.DelNoteToSubSt(Variable,s1ptr,ID);
TextBackGround(0);
window(1,12,80,24);
dispose(s1ptr);
clrscr;
end;
'5' :
begin
Anim(1,12,80,24,5);
Writeln('Podaj ID Studenta:');
Readln(ID);
Lista.DisplaySub(ID);
TextBackGround(0);
window(1,12,80,24);
clrscr;
end;
end;
C:=readkey;
until C = #27;
end;

procedure MenuRap;

var
 C:char;

begin
textbackground(0);
textcolor(15);
clrscr;
manurap;
repeat
clrscr;
manurap1;
case C of
'1' :
begin
Anim(1,12,80,24,5);
Lista.Display2(2);
TextBackGround(0);
window(1,12,80,24);
clrscr;
end;
'2' :
begin
Anim(1,12,80,24,5);
Lista.Display2(3);
TextBackGround(0);
window(1,12,80,24);
clrscr;
end;
'3' :
begin
Anim(1,12,80,24,2);
Writeln('Napisz zapytanie i nacisnij Enter');
Writeln('Pamietaj ze Duze litery w parametrach maja znaczenie:');
Readln(s1);
DoSQL(s1);
go(s1);
TextBackGround(0);
window(1,12,80,24);
clrscr;
end;
end;
C:=readkey;
until C = #27;
end;


procedure manu;
begin
window(1,1,80,12);
textbackground(0);
clrscr;
anim(1,1,80,12,1);
Writeln('                     ########     Baza Danych      ####### ');
Writeln('1. Dodaj Studenta');
Writeln('2. Odejmowanie Studenta');
Writeln('3. Edycja');
Writeln('4. Raporty');
Writeln('5. Wyswietl');
Writeln('ESC = Wyjdz');
end;

procedure manu1;
begin
window(1,1,80,12);
textbackground(0);
clrscr;
Windows(1,1,80,10,1);
Writeln('                     ########     Baza Danych      ####### ');
Writeln('1. Dodaj Studenta');
Writeln('2. Odejmowanie Studenta');
Writeln('3. Edycja');
Writeln('4. Raporty');
Writeln('5. Wyswietl');
Writeln('ESC = Wyjdz');
end;

begin end.