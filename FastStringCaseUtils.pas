unit FastStringCaseUtils;


// FastStringCaseUtils version 1.2
//
// A fast, unicode compatible string to uppercase and lowercase library
//
// Copyright 2022 - Jouni Flemming / Macecraft Software
// Used in jv16 PowerTools Windows Utility Suite
// https://jv16powertools.com
//
// Latest version available at: https://github.com/jv16x/FastStringCaseUtils
// and
// https://sourceforge.net/p/faststringcaseutils/
//
// Licensed under MIT open source license.


{$R-,T-,X+,H+,B-,O+,Q-}


interface

{.$DEFINE Debug_ReferenceMode_DoubleCheckResults}
{$DEFINE Debug_PerformSelftestOnInit}



uses
 Windows,
 SysUtils,
 System.Character,
 StrUtils;

type
  TCharCaseTable = array [WideChar] of WideChar;
  TCharOrdTable  = array [WideChar] of UInt16;

  procedure Init_FastStringCaseUtils();
  procedure SelfTest_FastStringCaseUtils();


  // A faster version of AnsiLowerCase()
  function FastLowerCase(const Str : String): String;

  // A faster version of AnsiUpperCase()
  function FastUpperCase(const Str : String): String;

  // A faster version of AnsiLowerCase(Trim())
  function FastLowerCase_Trim(const Str : String): String;

  // A faster version of AnsiUpperCase(Trim())
  function FastUpperCase_Trim(const Str : String): String;


 // Note: To quickly get ordval := Ord(Str[x].ToLower),
 // simply write:
 // ordval := GLOB_LowCaseOrdTable[Str[x]];

 // Similarly, you can replace any Str[x].ToLower or Str[x].ToUpper
 // with GLOB_CharLowCaseTable[Str[x]] and GLOB_CharUpCaseTable[Str[x]]

 // Warning: Replacing any Str[x].ToLower with GLOB_CharLowCaseTable[Str[x]]
 // can cause different results on certain unicode characters!


var
 GLOB_CharUpCaseTable      : TCharCaseTable;
 GLOB_CharLowCaseTable     : TCharCaseTable;
 GLOB_LowCaseOrdTable      : TCharOrdTable;



implementation


// A faster version of AnsiLowerCase(Trim())
function FastLowerCase_Trim(const Str : String): String;
var
  i   : Integer;
  j   : Integer;
  len : Integer;
  idx_1 : Integer;
  idx_2 : Integer;
begin

  len := Length(Str);
  if len = 0 then EXIT('');

  if len = 1 then
  begin
    if (Str[1].IsWhiteSpace) or
       (GLOB_LowCaseOrdTable[Str[1]] <= 32) then EXIT('');

    SetLength(Result, 1);
    Result[1] := GLOB_CharLowCaseTable[Str[1]];
  end else
  begin

    idx_1 := 1;
    while (idx_1 <= len) and
          ((Str[idx_1].IsWhiteSpace) or
           (GLOB_LowCaseOrdTable[Str[idx_1]] <= 32)) do Inc(idx_1);

    if idx_1 > len then EXIT('');
    idx_2 := len;

    while (idx_2 > idx_1) and
          ((Str[idx_2].IsWhiteSpace) or
          (GLOB_LowCaseOrdTable[Str[idx_2]] <= 32)) do Dec(idx_2);

    SetLength(Result, len - (len - idx_2) - (idx_1 - 1));

    i := 1;
    for j := idx_1 to idx_2 do
    begin
      Result[i] := GLOB_CharLowCaseTable[Str[j]];
      Inc(i);
    end;
  end;



 {$IFDEF Debug_ReferenceMode_DoubleCheckResults}
  Assert(AnsiLowerCase(Trim(Str)) = Result, 'FastLowerCase_Trim Debug_ReferenceMode_DoubleCheckResults Fail: ' + Result);
 {$ENDIF}

end;

// A faster version of AnsiLowerCase()
function FastLowerCase(const Str : String): String;
var
  i   : Integer;
  len : Integer;
begin

  len := Length(Str);
  if len = 0 then EXIT('');

  SetLength(Result, len);

  for i := 1 to len do
    Result[i] := GLOB_CharLowCaseTable[Str[i]];


 {$IFDEF Debug_ReferenceMode_DoubleCheckResults}
  Assert(AnsiLowerCase(Str) = Result, 'FastLowerCase Debug_ReferenceMode_DoubleCheckResults Fail: ' + Result);
 {$ENDIF}

end;


// A faster version of AnsiUpperCase()
function FastUpperCase(const Str : String): String;
var
  i   : Integer;
  len : Integer;
begin

  len := Length(Str);
  if len = 0 then EXIT('');

  SetLength(Result, len);

  for i := 1 to Len do
    Result[i] := GLOB_CharUpCaseTable[Str[i]];


 {$IFDEF Debug_ReferenceMode_DoubleCheckResults}
  Assert(AnsiUpperCase(Str) = Result, 'FastUpperCase Debug_ReferenceMode_DoubleCheckResults Fail: ' + Result);
 {$ENDIF}

end;


// A faster version of AnsiUpperCase(Trim())
// If TrimAllUnderOrd32, all characters with Ord() code <= 32 will be trimmed
function FastUpperCase_Trim(const Str : String): String;
var
  i   : Integer;
  j   : Integer;
  len : Integer;
  idx_1 : Integer;
  idx_2 : Integer;
begin

  len := Length(Str);
  if len = 0 then EXIT('');

  if len = 1 then
  begin
    if (Str[1].IsWhiteSpace) or
       (GLOB_LowCaseOrdTable[Str[1]] <= 32) then EXIT('');

    SetLength(Result, 1);
    Result[1] := GLOB_CharUpCaseTable[Str[1]];
  end else
  begin

    idx_1 := 1;
    while (idx_1 <= len) and
          ((Str[idx_1].IsWhiteSpace) or
           (GLOB_LowCaseOrdTable[Str[idx_1]] <= 32)) do Inc(idx_1);

    if idx_1 > len then EXIT('');
    idx_2 := len;

    while (idx_2 > idx_1) and
          ((Str[idx_2].IsWhiteSpace) or
          (GLOB_LowCaseOrdTable[Str[idx_2]] <= 32)) do Dec(idx_2);

    SetLength(Result, len - (len - idx_2) - (idx_1 - 1));

    i := 1;
    for j := idx_1 to idx_2 do
    begin
      Result[i] := GLOB_CharUpCaseTable[Str[j]];
      Inc(i);
    end;
  end;




 {$IFDEF Debug_ReferenceMode_DoubleCheckResults}
 Assert(AnsiUpperCase(Trim(Str)) = Result, 'FastUpperCase_Trim Debug_ReferenceMode_DoubleCheckResults Fail: ' + Result);
 {$ENDIF}

end;



Procedure SelfTest_FastStringCaseUtils();
begin

  Assert( FastLowerCase('Foobar!') = 'foobar!', 'SelfTest_FastStringCaseUtils Fail-1');
  Assert( FastUpperCase('Qwerty!') = 'QWERTY!', 'SelfTest_FastStringCaseUtils Fail-2');

  Assert( FastLowerCase('Fööbär') = 'fööbär', 'SelfTest_FastStringCaseUtils Fail-3');
  Assert( FastUpperCase('Fööbär') = 'FÖÖBÄR', 'SelfTest_FastStringCaseUtils Fail-4');

  Assert( FastLowerCase('Ligação') = 'ligação', 'SelfTest_FastStringCaseUtils Fail-5');
  Assert( FastUpperCase('Ligação') = 'LIGAÇÃO', 'SelfTest_FastStringCaseUtils Fail-6');

  Assert( FastLowerCase('På Hver Handletur Du Gjør') = 'på hver handletur du gjør', 'SelfTest_FastStringCaseUtils Fail-7');
  Assert( FastUpperCase('på hver handletur du gjør') = 'PÅ HVER HANDLETUR DU GJØR', 'SelfTest_FastStringCaseUtils Fail-8');

  Assert( FastLowerCase('Serpiştirmek1') = 'serpiştirmek1', 'SelfTest_FastStringCaseUtils Fail-9');
  Assert( FastUpperCase('Serpiştirmek1') = 'SERPIŞTIRMEK1', 'SelfTest_FastStringCaseUtils Fail-10');

  Assert( FastLowerCase('üç nokta') = 'üç nokta', 'SelfTest_FastStringCaseUtils Fail-11');
  Assert( FastUpperCase('üç nokta') = 'ÜÇ NOKTA', 'SelfTest_FastStringCaseUtils Fail-12');

  Assert( FastLowerCase('ελληνική γλώσσα') = 'ελληνική γλώσσα', 'SelfTest_FastStringCaseUtils Fail-13');
  Assert( FastUpperCase('ελληνική γλώσσα') = 'ΕΛΛΗΝΙΚΉ ΓΛΏΣΣΑ', 'SelfTest_FastStringCaseUtils Fail-14');

  Assert( FastLowerCase_Trim('Fööbär') = 'fööbär', 'SelfTest_FastStringCaseUtils Fail-15');
  Assert( FastUpperCase_Trim('Fööbär') = 'FÖÖBÄR', 'SelfTest_FastStringCaseUtils Fail-16');

  Assert( FastLowerCase_Trim('Fööbär ') = 'fööbär', 'SelfTest_FastStringCaseUtils Fail-17');
  Assert( FastUpperCase_Trim('Fööbär ') = 'FÖÖBÄR', 'SelfTest_FastStringCaseUtils Fail-18');

  Assert( FastLowerCase_Trim(' Fööbär') = 'fööbär', 'SelfTest_FastStringCaseUtils Fail-19');
  Assert( FastUpperCase_Trim(' Fööbär') = 'FÖÖBÄR', 'SelfTest_FastStringCaseUtils Fail-20');

  Assert( FastLowerCase_Trim('   Fööbär   ') = 'fööbär', 'SelfTest_FastStringCaseUtils Fail-21');
  Assert( FastUpperCase_Trim('   Fööbär   ') = 'FÖÖBÄR', 'SelfTest_FastStringCaseUtils Fail-22');

  Assert( FastLowerCase_Trim(#9 + ' Fööbär ' + #9 + #0) = 'fööbär', 'SelfTest_FastStringCaseUtils Fail-23');
  Assert( FastUpperCase_Trim(#9 + ' Fööbär ' + #9 + #0) = 'FÖÖBÄR', 'SelfTest_FastStringCaseUtils Fail-24');

  Assert( FastLowerCase_Trim('  ' + #9 + #0) = '', 'SelfTest_FastStringCaseUtils Fail-25');
  Assert( FastUpperCase_Trim('  ' + #9 + #0) = '', 'SelfTest_FastStringCaseUtils Fail-26');

  Assert( FastLowerCase('') = '', 'SelfTest_FastStringCaseUtils Fail-27');
  Assert( FastUpperCase('') = '', 'SelfTest_FastStringCaseUtils Fail-28');

  Assert( FastLowerCase_Trim('') = '', 'SelfTest_FastStringCaseUtils Fail-29');
  Assert( FastUpperCase_Trim('') = '', 'SelfTest_FastStringCaseUtils Fail-30');

  Assert( FastLowerCase_Trim(#3 + ' Fööbär ' + #2) = 'fööbär', 'SelfTest_FastStringCaseUtils Fail-31');
  Assert( FastUpperCase_Trim(#3 + ' Fööbär ' + #2) = 'FÖÖBÄR', 'SelfTest_FastStringCaseUtils Fail-32');

  Assert( FastLowerCase('c') = 'c', 'SelfTest_FastStringCaseUtils Fail-33');
  Assert( FastUpperCase('c') = 'C', 'SelfTest_FastStringCaseUtils Fail-34');
  Assert( FastLowerCase('C') = 'c', 'SelfTest_FastStringCaseUtils Fail-35');
  Assert( FastUpperCase('C') = 'C', 'SelfTest_FastStringCaseUtils Fail-36');

  Assert( FastLowerCase_Trim('c') = 'c', 'SelfTest_FastStringCaseUtils Fail-37');
  Assert( FastUpperCase_Trim('c') = 'C', 'SelfTest_FastStringCaseUtils Fail-38');
  Assert( FastLowerCase_Trim('C') = 'c', 'SelfTest_FastStringCaseUtils Fail-39');
  Assert( FastUpperCase_Trim('C') = 'C', 'SelfTest_FastStringCaseUtils Fail-40');

  Assert( FastLowerCase('cÖ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-41');
  Assert( FastUpperCase('cÖ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-42');
  Assert( FastLowerCase('CÖ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-43');
  Assert( FastUpperCase('CÖ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-44');

  Assert( FastLowerCase_Trim('cÖ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-45');
  Assert( FastUpperCase_Trim('cÖ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-46');
  Assert( FastLowerCase_Trim('CÖ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-47');
  Assert( FastUpperCase_Trim('CÖ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-48');

  Assert( FastLowerCase_Trim('cÖ ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-49');
  Assert( FastUpperCase_Trim('cÖ ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-50');
  Assert( FastLowerCase_Trim('CÖ ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-51');
  Assert( FastUpperCase_Trim('CÖ ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-52');

  Assert( FastLowerCase_Trim(' cÖ ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-53');
  Assert( FastUpperCase_Trim(' cÖ ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-54');
  Assert( FastLowerCase_Trim(' CÖ ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-55');
  Assert( FastUpperCase_Trim(' CÖ ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-56');

  Assert( FastLowerCase_Trim(' cÖ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-57');
  Assert( FastUpperCase_Trim(' cÖ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-58');
  Assert( FastLowerCase_Trim(' CÖ') = 'cö', 'SelfTest_FastStringCaseUtils Fail-59');
  Assert( FastUpperCase_Trim(' CÖ') = 'CÖ', 'SelfTest_FastStringCaseUtils Fail-60');

  Assert( FastLowerCase_Trim('Ö ') = 'ö', 'SelfTest_FastStringCaseUtils Fail-61');
  Assert( FastUpperCase_Trim('Ö ') = 'Ö', 'SelfTest_FastStringCaseUtils Fail-62');
  Assert( FastLowerCase_Trim('Ö ') = 'ö', 'SelfTest_FastStringCaseUtils Fail-63');
  Assert( FastUpperCase_Trim('Ö ') = 'Ö', 'SelfTest_FastStringCaseUtils Fail-64');

  Assert( FastLowerCase_Trim(' Ö ') = 'ö', 'SelfTest_FastStringCaseUtils Fail-65');
  Assert( FastUpperCase_Trim(' Ö ') = 'Ö', 'SelfTest_FastStringCaseUtils Fail-66');
  Assert( FastLowerCase_Trim(' Ö ') = 'ö', 'SelfTest_FastStringCaseUtils Fail-67');
  Assert( FastUpperCase_Trim(' Ö ') = 'Ö', 'SelfTest_FastStringCaseUtils Fail-68');

  Assert( FastLowerCase_Trim(' Ö') = 'ö', 'SelfTest_FastStringCaseUtils Fail-69');
  Assert( FastUpperCase_Trim(' Ö') = 'Ö', 'SelfTest_FastStringCaseUtils Fail-70');
  Assert( FastLowerCase_Trim(' Ö') = 'ö', 'SelfTest_FastStringCaseUtils Fail-71');
  Assert( FastUpperCase_Trim(' Ö') = 'Ö', 'SelfTest_FastStringCaseUtils Fail-72');

  Assert( FastLowerCase_Trim(#9) = '', 'SelfTest_FastStringCaseUtils Fail-73');
  Assert( FastUpperCase_Trim(#9) = '', 'SelfTest_FastStringCaseUtils Fail-74');

  Assert( FastLowerCase_Trim(#9 + #9) = '', 'SelfTest_FastStringCaseUtils Fail-75');
  Assert( FastUpperCase_Trim(#9 + #9) = '', 'SelfTest_FastStringCaseUtils Fail-76');

  Assert( FastLowerCase_Trim(#9 + #9 + #9) = '', 'SelfTest_FastStringCaseUtils Fail-77');
  Assert( FastUpperCase_Trim(#9 + #9 + #9) = '', 'SelfTest_FastStringCaseUtils Fail-78');

end;



procedure Init_FastStringCaseUtils();
var
  i : Cardinal;
begin


  for i := 0 to Length(GLOB_CharUpCaseTable) - 1 do
  begin
    GLOB_CharUpCaseTable[Char(i)]  := Char(i);
    GLOB_CharLowCaseTable[Char(i)] := Char(i);
  end;

  CharUpperBuff(@GLOB_CharUpCaseTable, Length(GLOB_CharUpCaseTable));
  CharLowerBuff(@GLOB_CharLowCaseTable, Length(GLOB_CharLowCaseTable));

  for i := 0 to Length(GLOB_LowCaseOrdTable) - 1 do
    GLOB_LowCaseOrdTable[Char(i)] := Ord(GLOB_CharLowCaseTable[Char(i)]);

end;



initialization

 Init_FastStringCaseUtils();


 {$IFDEF Debug_PerformSelftestOnInit}
  SelfTest_FastStringCaseUtils();
 {$ENDIF}


end.
