unit MainList;
interface

uses
 crt;

procedure OpenFromFile;
Procedure SaveToFile;
Procedure DoSQL(var s1:String);
Procedure Go(var s1:string);
Function Go1(var s1:string):string;
function IntToStr(i: Longint): string;

const
 OPL1 = 'AND';
 OPL2 = 'OR';
 OP1 = '=';
 OP2 = '>';
 OP3 = '<';
 ELIM=' ()''';
 Warn='Nacinij klawisz aby kontynuowa†  !!!';

type

 StringPtr = ^String;

 SubjectPtr = ^Subject;
 Subject = record
 Name:StringPtr;
 Note:array[1..40] of integer;
 NumOfNotes:integer;
 Next:SubjectPtr;
 end;

 WorkSubject = record
 Name:String[20];
 Note:array[1..40] of integer;
 NumOfNotes:integer;
 end;

 SubList = object
 Head,Teil:SubjectPtr;
 NumOfSub:integer;
 Constructor Init;
 Destructor Done;
 Procedure Add(Name:StringPtr);
 Procedure AddNoteToSub(x:integer;Name:StringPtr);
 Procedure DelNoteFromSub(x:integer;Name:StringPtr);
 Procedure Del(Name:StringPtr);
 Procedure DisplayNotebySub(Name:StringPtr);
 Procedure DisplaySub;
 Function  GetAverageFromSub(Name:StringPtr):Real;
 Function  GetAllAverage:Real;
 Function  GetSubNameByNum(x:integer):StringPtr;
 end;

 StudentPtr = ^Student;
 Student = record
 Name:StringPtr;
 SurName:StringPtr;
 ID,Age:integer;
 Subject:SubList;
 Next:StudentPtr;
 end;

 WorkStudent = record
 Name:String[25];
 SurName:String[40];
 ID,Age:integer;
 Subject:SubList;
 end;


 TiePtr = ^Tie;
 Tie = record
 StTie:StudentPtr;
 Next:TiePtr;
 end;

 PtrList = object
 Head,Teil:TiePtr;
 Constructor Init;
 Destructor  Done;
 Procedure   Add(Tie:StudentPtr;Criterion:integer);
 Procedure   Del(Tie:StudentPtr);
 end;


 List = object
 Head,Teil:StudentPtr;
 NumOfSt:integer;
 SortList:array[1..3] of PtrList;
 Constructor Init;
 Destructor Done;
 Procedure Add(Name,SurName:StringPtr;ID,Age:integer);
 Procedure AddSubToSt(SubName:StringPtr;ID:integer);
 Procedure AddNoteToSubSt(x:integer;SubName:StringPtr;ID:integer);
 Procedure Del(ID:integer);
 Procedure DelSubToSt(SubName:StringPtr;ID:integer);
 Procedure DelNoteToSubSt(x:integer;SubName:StringPtr;ID:integer);
 Procedure Display;
 Procedure DisplaySub(x:integer);
 Procedure Display2(x:integer);
 end;

 StudentFile = file of WorkStudent;
 SubjectFile = file of WorkSubject;

var
 l,p:byte;
 ID,i,s,Variable:integer;
 Lista:List;
 T1,T2,T3:PtrList;
 T4,T5:TiePtr;
 F:StudentFile;
 F2:SubjectFile;
 s1ptr,s2ptr,s3ptr:StringPtr;
 IDS,TempID : Integer;


implementation

Procedure List.DisplaySub(x:integer);
var
 Tie:StudentPtr;

begin
Tie:=Head;
 While (( Tie <> NIL ) and ( Tie^.ID <> x  )) do
  begin
    Tie:=Tie^.Next;
  end;
If Tie = NIL then
 begin
  Writeln('Student o ID nieznaleziony');
 end
else
 begin
  Tie^.Subject.DisplaySub;
 end;
end;

Procedure   PtrList.Del(Tie:StudentPtr);

var
 Prev,NewTie:TiePtr;

begin
NewTie:=Head;
While (( NewTie <> NIL ) and ( Tie <> NewTie^.StTie ))do
 begin
  Prev:=NewTie;
  NewTie:=NewTie^.Next;
 end;
If NewTie = NIL then
 begin

 end
else
 begin
  if NewTie = Head then
   begin
    if NewTie^.Next  = NIL then
     begin
      Head:=NIL;
      Teil:=NIL;
     end
    else
     begin
      Head:=NewTie^.Next;
     end;
   end
  else
   begin
     Prev^.Next:=NewTie^.Next;
   end;
  Dispose (NewTie);
 end;
end;


Procedure   PtrList.Add(Tie:StudentPtr;Criterion:integer);

var
 Prev,HelpPtr,NewTie:TiePtr;

begin
New(NewTie);
NewTie^.StTie:=Tie;
NewTie^.Next:=NIL;
if Criterion = 0 then
begin
if Head = NIL then
 begin
  Head:=NewTie;
 end
else
 begin
  Teil^.Next:=NewTie;
 end;
Teil:=NewTie;
end;
if Criterion = 1 then
 begin
  {
   Nalezy znalesc odpowiednie imie
  }
 HelpPtr:=Head;
  While (( HelpPtr <> NIL ) and ( NewTie^.StTie^.Name^ >= HelpPtr^.StTie^.Name^ )) do
   begin
    Prev:=HelpPtr;
    HelpPtr:=HelpPtr^.Next;
   end;
  if HelpPtr = NIL then
   begin
    Prev^.Next:=NewTie;
    Teil:=NewTie;
   end
  else
   begin
    if HelpPtr = Head then
     begin
      NewTie^.Next:=Head;
      Head:=NewTie;
     end
    else
     begin
      Prev^.Next:=NewTie;
      NewTie^.Next:=HelpPtr;
     end;
   end;
 end;
if Criterion = 2 then
 begin
  {
   Nalezy znalesc odpowiednie Nazwisko
  }
 HelpPtr:=Head;
  While (( HelpPtr <> NIL ) and ( NewTie^.StTie^.SurName^ >= HelpPtr^.StTie^.SurName^ )) do
   begin
    Prev:=HelpPtr;
    HelpPtr:=HelpPtr^.Next;
   end;
  if HelpPtr = NIL then
   begin
    Prev^.Next:=NewTie;
    Teil:=NewTie;
   end
  else
   begin
    if HelpPtr = Head then
     begin
      NewTie^.Next:=Head;
      Head:=NewTie;
     end
    else
     begin
      Prev^.Next:=NewTie;
      NewTie^.Next:=HelpPtr;
     end;
   end;
 end;
end;

Destructor  PtrList.Done;

var
 NewTie:TiePtr;

begin

While Head <> NIL do
 begin
  NewTie:=Head;
  Head:=Head^.Next;
  Dispose(NewTie);
 end;
end;

Constructor PtrList.Init;
 begin
  Head:=NIL;
  Teil:=NIL;
 end;

Procedure List.Display2(x:integer);

var
 Tie:TiePtr;
 i:integer;
 C:Char;

begin
Tie:=SortList[x].Head;
i:=0;
While Tie <> NIL do
 begin
  i:=i+1;
  if i = 9 then begin
   Write(Warn);
   C:=readkey;
   writeln;
   clrscr;
   i:=0
  end;
  Writeln(Tie^.StTie^.Name^:15,'  ',Tie^.StTie^.SurName^:10,'  ',Tie^.StTie^.Age);
  Tie:=Tie^.Next;
 end;
Write(Warn);
C:=readkey;
end;

Procedure List.Display;

var
 Tie:StudentPtr;
 i:integer;
 C:Char;

Begin
Tie:=Head;
i:=0;
while Tie <> NIL do
 begin
  Writeln(Tie^.ID,'   ',Tie^.Name^,'  ',Tie^.SurName^,'  ',Tie^.Age);
  i:=i+1;
  if i = 8 then begin
   Write(Warn);
   C:=readkey;
   Writeln;
   clrscr;
   i:=0
  end;
  Tie:=Tie^.Next;
 end;
   Write(Warn);
   c:=readkey;
end;

Procedure List.DelNoteToSubSt(x:integer;SubName:StringPtr;ID:integer);

var
 Tie:StudentPtr;

begin
Tie:=Head;
 While (( Tie <> NIL ) and ( Tie^.ID <> ID  )) do
  begin
    Tie:=Tie^.Next;
  end;
If Tie = NIL then
 begin
  Writeln('Student o ID nieznaleziony');
 end
else
 begin
  Tie^.Subject.DelNoteFromSub(x,SubName);
 end;
end;

Procedure List.DelSubToSt(SubName:StringPtr;ID:integer);

var
 Tie:StudentPtr;

begin
Tie:=Head;
 While (( Tie <> NIL ) and ( Tie^.ID <> ID  )) do
  begin
    Tie:=Tie^.Next;
  end;
If Tie = NIL then
 begin
  Writeln('Student o ID nieznaleziony');
 end
else
 begin
  Tie^.Subject.Del(SubName);
 end;
end;

Procedure List.Del(ID:integer);

var
 Prev,Tie:StudentPtr;

begin
Tie:=Head;
 While (( Tie <> NIL ) and ( Tie^.ID <> ID  )) do
  begin
   Prev:=Tie;
   Tie:=Tie^.Next;
  end;
If Tie = NIL then
 begin
  Writeln('Nie ma takiego Identyfikatora');
  exit;
 end
else
SortList[1].Del(Tie);
SortList[2].Del(Tie);
SortList[3].Del(Tie);
 begin
  If Tie = Head then
   begin
    If Tie^.Next = NIl then
     begin
      Head:=NIL;
      Teil:=NIL;
     end
    else
     begin
      Head:=Tie^.Next;
     end;
   end
  else
   begin
    If Tie^.Next = NIL then
     begin
      Teil:=Prev;
      Prev^.Next:=NIL
     end
    else
     begin
      Prev^.Next:=Tie^.Next;
     end;
   end;
  Dispose(Tie);
  NumOfSt:=NumOfSt-1;
 end;
end;

Procedure List.AddNoteToSubSt(x:integer;SubName:StringPtr;ID:integer);

var
 Tie:StudentPtr;

begin
Tie:=Head;
 While (( Tie <> NIL ) and ( Tie^.ID <> ID  )) do
  begin
   Tie:=Tie^.Next;
  end;
If Tie = NIL then
 begin
  Writeln('Nie Ma Takiego ID');
 end
else
 begin
  Tie^.Subject.AddNoteToSub(x,SubName);
 end;
end;

Procedure List.AddSubToSt(SubName:StringPtr;ID:integer);

var
 Tie:StudentPtr;

begin
Tie:=Head;
 While (( Tie <> NIL ) and ( Tie^.ID <> ID  )) do
  begin
   Tie:=Tie^.Next;
  end;
If Tie = NIL then
 begin
  Writeln('Nie Ma Takiego ID');
 end
else
 begin
  Tie^.Subject.Add(SubName);
 end;
end;

Procedure List.Add(Name,SurName:StringPtr;ID,Age:integer);

var
 Tie:StudentPtr;

begin
New(Tie);
if Head = NIL then
 begin
  Tie^.Name:=Name;
  Tie^.SurName:=SurName;
  Tie^.ID:=ID;
  Tie^.Age:=Age;
  Tie^.Subject.Init;
  Tie^.Next:=NIL;
  SortList[1].Add(Tie,0);
  SortList[2].Add(Tie,0);
  SortList[3].Add(Tie,0);
  Head:=Tie;
 end
else
 begin
  Tie^.Name:=Name;
  Tie^.SurName:=SurName;
  Tie^.ID:=ID;
  Tie^.Age:=Age;
  Tie^.Subject.Init;
  Tie^.Next:=NIL;
  SortList[1].Add(Tie,0);
  SortList[2].Add(Tie,1);
  SortList[3].Add(Tie,2);
  Teil^.Next:=Tie;
 end;
Teil:=Tie;
NumOfSt:=NumOfSt+1;
end;

Destructor  List.Done;

var
 Tie:StudentPtr;

begin
While Head <> NIL do
 Begin
   Tie:=Head;
   Head:=Head^.Next;
   Dispose(Tie);
 end;
SortList[1].Done;
SortList[2].Done;
SortList[3].Done;
end;

Constructor List.Init;
begin
 Head:=NIL;
 Teil:=NIL;
 SortList[1].Init;
 SortList[2].Init;
 SortList[3].Init;
 NumOfSt:=0;
end;

Function  SubList.GetSubNameByNum(x:integer):StringPtr;

var
 Tie:SubjectPtr;
 i:integer;

begin
Tie:=Head;
i:=1;
if x > NumOfSub then
 begin

 end
else
 begin
  While ( ( Tie <> NIL ) and ( i <> x ) ) do
   begin
    i:=i+1;
    Tie:=Tie^.Next;
   end;
  GetSubNameByNum:=Tie^.Name;
 end;
end;

Function  SubList.GetAllAverage:Real;

var
 Tie:SubjectPtr;
 x,y:real;
 z:integer;

begin
 z:=NumOfSub;
 Tie:=Head;
 x:=0;
 While Tie <> NIL do
  begin
   y:=GetAverageFromSub(Tie^.Name);
   if y = 0 then
   begin
    z:=z-1;
   end
   else
   begin
   x:=x+y
   end;
   Tie:=Tie^.Next;
  end;
 if z = 0 then
  z:=1;
GetAllAverage:=x/z;
end;


Function  SubList.GetAverageFromSub(Name:StringPtr):Real;

var
 Tie:SubjectPtr;
 i,x:integer;

begin
 Tie:=Head;
  while ( ( Tie <> NIL ) and ( Tie^.Name^ <> Name^ )) do
   begin
    Tie:=Tie^.Next;
   end;
i:=0;
x:=0;
while i <> Tie^.NumOfNotes do
 begin
  i:=i+1;
  x:=x+Tie^.Note[i];
 end;
if Tie^.NumOfNotes = 0 then
begin
GetAverageFromSub:=0;
end
else
begin
GetAverageFromSub:=x/Tie^.NumOfNotes;
end;
end;

Procedure SubList.DelNoteFromSub(x:integer;Name:StringPtr);

var
 Tie:SubjectPtr;
 i:integer;

begin
 Tie:=Head;
  while ( ( Tie <> NIL ) and ( Tie^.Name^ <> Name^ ) ) do begin
    Tie:=Tie^.Next;
   end;
i:=1;
while (( i <> Tie^.NumOfNotes+1 ) and ( Tie^.Note[i] <> x )) do begin
  i:=i+1;
 end;

if i = Tie^.NumOfNotes+1 then begin
  Writeln('Nie ma takiej oceny');
 end
else begin
  while i <> Tie^.NumOfNotes do begin
    Tie^.Note[i]:=Tie^.Note[i+1];
    i:=i+1;
   end;
  Tie^.NumOfNotes:=Tie^.NumOfNotes-1;
 end;
end;


Procedure SubList.Del(Name:StringPtr);

var
 Prev,Tie:SubjectPtr;

begin
 Tie:=Head;
  while ( ( Tie <> NIL ) and ( Tie^.Name^ <> Name^ ) ) do begin
    Prev:=Tie;
    Tie:=Tie^.Next;
   end;
if Tie = NIL then begin
  Writeln('Nie ma takiego przedmiotu !!!');
 end
else begin
  if Tie = Head then begin
    if Tie^.Next = NIL then begin
      Dispose(Tie);
      Head:=NIL;
      Teil:=NIL;
     end
    else begin
      Head:=Head^.Next;
      Dispose(Tie);
     end;
   end
   else begin
     if Tie = Teil then begin
       Teil:=Prev;
       Teil^.Next:=NIL;
      end
     else begin
       Prev^.Next:=Tie^.Next;
      end;
    Dispose(Tie);
  end;
 NumOfSub:=NumOfSub-1;
end;
end;

Procedure SubList.DisplayNotebySub(Name:StringPtr);

var
 Tie:SubjectPtr;
 y,i:integer;

begin
 Tie:=Head;
  while ( ( Tie <> NIL ) and ( Tie^.Name^ <> Name^ ) ) do begin
    Tie:=Tie^.Next;
   end;
For i:=1 to Tie^.NumOfNotes do begin
  Write(Tie^.Note[i],'  ');
 end;
Writeln;
end;

Procedure SubList.AddNoteToSub(x:integer;Name:StringPtr);

var
 Tie:SubjectPtr;

begin
 Tie:=Head;
  while ( ( Tie <> NIL ) and ( Tie^.Name^ <> Name^ ) ) do begin
    Tie:=Tie^.Next;
   end;
 Tie^.NumOfNotes:=Tie^.NumOfNotes+1;
 Tie^.Note[Tie^.NumOfNotes]:=x;
end;



Procedure SubList.DisplaySub;

var
 Tie:SubjectPtr;
 i:integer;
 C:Char;

begin
Tie:=Head;
 i:=0;
 While Tie <> NIL do begin
   i:=i+1;
   if i = 5 then begin
   i:=0;
   Write(Warn);
   C:=readkey;
   Writeln;
   clrscr;
   end;
   Writeln(Tie^.Name^);
   DisplayNoteBySub(Tie^.Name);
   Tie:=Tie^.Next;
  end;
   Write(Warn);
   C:=readkey;
   Writeln;
end;

Procedure SubList.Add(Name:StringPtr);

var
 Tie:SubjectPtr;

begin
 New(Tie);
 if Head = NIL then  begin
   Head:=Tie;
   Head^.Name:=Name;
   Head^.NumOfNotes:=0;
   Teil:=Head;
  end
 else begin
   Teil^.Next:=Tie;
   Teil:=Tie;
   Teil^.Name:=Name;
   Teil^.NumOfNotes:=0;
  end;
NumOfSub:=NumOfSub+1;
Teil^.Next:=NIL;
end;

Constructor SubList.Init;
begin
 Head:=NIL;
 Teil:=NIL;
 NumOfSub:=0;
end;

Destructor SubList.Done;

var
 Tie:SubjectPtr;

begin
 while Head <> NIL do begin
   Tie:=Head;
   Head:=Head^.Next;
   Dispose(Tie);
  end;
end;

var
 Temp:WorkStudent;
 Ti:StudentPtr;
 Temp2:WorkSubject;
 Temp3:SubjectPtr;



Procedure SaveToFile;

var
 TempString:string;

begin
Assign(F,'Students.db');
Rewrite(F);
Assign(F2,'Notes.db');
Rewrite(F2);
Ti:=Lista.Head;
While Ti <> NIL do begin
  Temp.Name:=Ti^.Name^;
  Temp.SurName:=Ti^.SurName^;
  Temp.Age:=Ti^.Age;
  Temp.ID:=Ti^.ID;
  Temp.Subject.NumOfSub:=Ti^.Subject.NumOfSub;
  Temp.Subject:=Ti^.Subject;
  Write(F,Temp);
if Ti^.Subject.NumOfSub <> 0 then begin
  Temp3:=Ti^.Subject.Head;
  While Temp3 <> NIL do begin
    Temp2.Name:=Temp3^.Name^;
    Temp2.NumOfNotes:=Temp3^.NumOfNotes;
    i:=0;
    while i <> Temp2.NumOfNotes do begin
     i:=i+1;
     Temp2.Note[i]:=Temp3^.Note[i];
    end;
    Write(F2,Temp2);
    Temp3:=Temp3^.Next;
   end;
end;
Ti:=Ti^.Next;
end;
Close(F);
Close(F2);
end;


Procedure OpenFromFile;

begin
{$I-}
Assign(F,'Students.db');
Assign(F2,'Notes.db');
Reset(F);
Reset(F2);
if IOResult<>0 then begin
  Write('BRAK PLIKOW : Tworze Nowe Pliki');
  Rewrite(F);
  Close(F);
  Rewrite(F2);
  Close(F2);
  Exit;
end;
{$I+}
While NOT Eof(F) do begin
      i:=0;
      Read(F,Temp);
      new(s1ptr);
      new(s2ptr);
      s1ptr^:=Temp.Name;
      s2ptr^:=Temp.SurName;
      TempID:=Temp.ID;
      if IDS < TempID then
         IDS:=TempID+1;
      Lista.Add(s1ptr,s2ptr,Temp.ID,Temp.Age);
      While i <> Temp.Subject.NumOfSub do begin
         i:=i+1;
         Read(F2,Temp2);
         new(s3ptr);
         s3ptr^:=Temp2.Name;
         Lista.AddSubToSt(s3ptr,Temp.ID);
         s:=0;
            while s <> Temp2.NumOfNotes do  begin
                 s:=s+1;
                 Lista.AddNoteToSubSt(Temp2.Note[s],s3ptr,Temp.ID);
            end;
      end;
end;
Close(F2);
Close(F);
end;

Procedure DoSQL(var s1:String);

var
 s,i,slen:byte;
 C: String[5];

begin
 C:=Elim;
 slen:=Length(s1);
 i:=1;
  while i <= 4 do  begin
   s:=1;
    while s <> slen+1 do begin
     if  C[i] = s1[s] then
      s1[s]:='"';
      s:=s+1;
    end;
   i:=i+1;
  end;
end;

function upercase(str:string):string;
var
   i:byte;
   slen:byte;
   s:string;
begin
   slen:=length(str);
   s:='';
   for i:=1 to slen do
      s := s + upcase(str[i]);
   upercase:=s;
end;

Procedure Equal(var L1,L2:PtrList); { L2 Mamy dane }

var
 sw:TiePtr;

begin
sw:=L2.Head;
 While sw <> NIL do begin
  L1.Add(sw^.StTie,0);
  sw:=sw^.Next;
 end;
end;

procedure DisplayList(var L1:PtrList);

var
sw:TiePtr;
i:integer;
c:char;

begin
sw:=L1.Head;
i:=0;
While sw <> NIL do begin
i:=i+1;
if i = 9 then begin
i:=0;
Write(Warn);
C:=ReadKey;
Writeln;
ClrScr;
end;
WriteLn('    ',sw^.StTie^.ID,'    ',sw^.StTie^.Name^,'     ',sw^.StTie^.SurName^);
sw:=sw^.Next;
end;
Write(Warn);
C:=ReadKey;
Writeln;
ClrScr;
end;

Procedure MakeSQL(var T3,T2,T1:PtrList;var s2:string);

label
 l1;

var
sw1,sw2:TiePtr;
i:integer;

begin
 if s2 = 'AND' then begin
  sw1:=T2.Head;
   While sw1 <> NIL do begin
    sw2:=T1.Head;
     While sw2 <> NIL do begin
      if sw1^.StTie = sw2^.StTie then
       T3.Add(sw2^.StTie,0);
     sw2:=sw2^.Next;
     end;
    sw1:=sw1^.Next;
   end;
 end;
 if s2 = 'OR' then begin
  Equal(T3,T1);
  Equal(T3,T2);
  {
   Nie potrzebne Kasowanie tych samych elementow
  }

  l1:
  sw1:=T3.Head;
  While sw1 <> NIL do begin
   sw2:=T3.Head;
   i:=1;
    While sw2 <> NIL do begin
     if sw2^.StTie = sw1^.StTie then
      i:=i+1;
     if (i > 2) and (sw2^.StTie = sw1^.StTie) then begin
      T3.Del(sw2^.StTie);
      goto l1;
      end;
     sw2:=sw2^.next;
    end;
   sw1:=sw1^.Next;
  end;
 end;
end;

procedure Go(var s1:string);

label
 l1,l2,l3;

var
 s0,s2,s3:string;
 op:char;
 Status:byte;
 Value,Code:integer;

begin
Status:=0;
T3.Init;
p:=1;
{
 Wyciagamy Parametr i zmienna
}

T1.Init;
s2:=go1(s1);
s2:=upercase(s2);
op:=s1[p];
p:=p+1;
s3:=go1(s1);

{
 Tworzymy Liste Wskaznikow na T1
}

Ti:=Lista.Head;
i:=0;
if s2 = 'NAME' then begin
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if s3 = Ti^.Name^ then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if s3 > Ti^.Name^ then begin
     T1.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if s3 < Ti^.Name^ then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;
end;

if s2 = 'SURNAME' then begin
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if s3 = Ti^.SurName^ then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if s3 > Ti^.SurName^ then begin
     T1.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if s3 < Ti^.SurName^ then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;
end;

if s2 = 'YEAR' then begin
val(s3,value,code);
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if  value = Ti^.Age then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if value > Ti^.Age then begin
     T1.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if value < Ti^.Age then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;

end;
if s2 = 'AVERAGE' then begin
val(s3,value,code);
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if  value = Ti^.Subject.GetAllAverage then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if value > Ti^.Subject.GetAllAverage then begin
     T1.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if value < Ti^.Subject.GetAllAverage then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;

end;
if s2 = 'ID' then begin
val(s3,value,code);
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if  value = Ti^.ID then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if value > Ti^.ID then begin
     T1.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if value < Ti^.ID then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;


end;
if s2 = 'SUBNAME' then begin
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   code:=1;
   while code <> Ti^.Subject.NumOfSub+1 do begin
   if s3 = Ti^.Subject.Getsubnamebynum(code)^ then begin
     T1.add(Ti,0);
    end;
    code:=code+1;
   end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   code:=1;
   while code <> Ti^.Subject.NumOfSub+1 do begin
   if s3 > Ti^.Subject.Getsubnamebynum(code)^ then begin
     T1.add(Ti,0);
    end;
    code:=code+1;
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   code:=1;
   while code <> Ti^.Subject.NumOfSub+1 do begin
   if s3 < Ti^.Subject.Getsubnamebynum(code)^ then begin
     T1.add(Ti,0);
    end;
    code:=code+1;
   end;
   Ti:=Ti^.Next;
   end;
  end;
 end;
end;
if s2 = 'NUMOFSUB' then begin
val(s3,value,code);
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if  value = Ti^.Subject.NumOfSub then begin
     T1.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if value > Ti^.Subject.NumOfSub then begin
     T1.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if value < Ti^.Subject.NumOfSub then begin
     T1.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;
end;

{
 Operator Logiczny
}

s0:=go1(s1);
s0:=upercase(s0);
if length(s0) = 0 then
goto l3;
l2:

s2:=go1(s1);
s2:=upercase(s2);
T2.Init;
op:=s1[p];
p:=p+1;
s3:=go1(s1);

{
 Tworzymy Liste Wskaznikow na T2
}

Ti:=Lista.Head;
i:=0;
if s2 = 'NAME' then begin
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if s3 = Ti^.Name^ then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if s3 > Ti^.Name^ then begin
     T2.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if s3 < Ti^.Name^ then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;
end;

if s2 = 'SURNAME' then begin
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if s3 = Ti^.SurName^ then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if s3 > Ti^.SurName^ then begin
     T2.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if s3 < Ti^.SurName^ then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;
end;

if s2 = 'YEAR' then begin
val(s3,value,code);
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if  value = Ti^.Age then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if value > Ti^.Age then begin
     T2.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if value < Ti^.Age then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;

end;
if s2 = 'AVERAGE' then begin
val(s3,value,code);
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if  value = Ti^.Subject.GetAllAverage then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if value > Ti^.Subject.GetAllAverage then begin
     T2.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if value < Ti^.Subject.GetAllAverage then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;

end;
if s2 = 'ID' then begin
val(s3,value,code);
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if  value = Ti^.ID then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if value > Ti^.ID then begin
     T2.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if value < Ti^.ID then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;


end;
if s2 = 'SUBNAME' then begin
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   code:=1;
   while code <> Ti^.Subject.NumOfSub+1 do begin
   if s3 = Ti^.Subject.Getsubnamebynum(code)^ then begin
     T2.add(Ti,0);
    end;
    code:=code+1;
   end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   code:=1;
   while code <> Ti^.Subject.NumOfSub+1 do begin
   if s3 > Ti^.Subject.Getsubnamebynum(code)^ then begin
     T2.add(Ti,0);
    end;
    code:=code+1;
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   code:=1;
   while code <> Ti^.Subject.NumOfSub+1 do begin
   if s3 < Ti^.Subject.Getsubnamebynum(code)^ then begin
     T2.add(Ti,0);
    end;
    code:=code+1;
   end;
   Ti:=Ti^.Next;
   end;
  end;
 end;
end;
if s2 = 'NUMOFSUB' then begin
val(s3,value,code);
 While i <> Lista.NumOfSt do begin
   i:=i+1;
   case op of
   '=':
   begin
   if  value = Ti^.Subject.NumOfSub then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
   '<':begin
   if value > Ti^.Subject.NumOfSub then begin
     T2.add(Ti,0);
   end;
   Ti:=Ti^.Next;
   end;
   '>':begin
   if value < Ti^.Subject.NumOfSub then begin
     T2.add(Ti,0);
    end;
   Ti:=Ti^.Next;
   end;
  end;
 end;
end;

MakeSQL(T3,T2,T1,s0);

T1.Done;
T1.Init;
Equal(T1,T3);
s0:=go1(s1);
s0:=upercase(s0);
if length(s0) > 0 then begin
T3.Done;
T3.Init;
goto l2;
l3:
Equal(T3,T1);
end;
DisplayList(T3);
T1.Done;
T2.Done;
T3.Done;
end;


function IntToStr(i: Longint): string;

var
  s: string[11];
begin
  Str(i, s);
  IntToStr := s;
end;

Function Go1(var s1:string):string;

var
 s2:string;

begin
 l:=1;
 while s1[p] = '"' do begin
   p:=p+1; end;
    while NOT (( chr(60) <= s1[p] ) and ( s1[p]  <= chr(62) )) and ( p <> Length(s1)+1) and ( s1[p] <> '"' ) do begin
      s2[l]:=s1[p];
      l:=l+1;
      p:=p+1;
    end;
 while s1[p] = '"' do begin
  p:=p+1; end;
 s2[0]:=chr(l-1);
 Go1:=s2;
end;

begin end.