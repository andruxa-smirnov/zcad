{
*****************************************************************************
*                                                                           *
*  This file is part of the ZCAD                                            *
*                                                                           *
*  See the file COPYING.modifiedLGPL.txt, included in this distribution,    *
*  for details about the copyright.                                         *
*                                                                           *
*  This program is distributed in the hope that it will be useful,          *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
*                                                                           *
*****************************************************************************
}
{
@author(Andrey Zubarev <zamtmn@yandex.ru>) 
}

unit uzccommand_prevdrawing;
{$INCLUDE def.inc}

interface
uses
  LCLProc,
  uzccommandsabstract,uzccommandsimpl,
  uzcmainwindow;

implementation

function PrevDrawing_com(operands:TCommandOperands):TCommandResult;
var
   i:integer;
begin
  if assigned(ZCADMainWindow.PageControl)then
    if ZCADMainWindow.PageControl.PageCount>1 then begin
      i:=ZCADMainWindow.PageControl.ActivePageIndex-1;
      if i<0 then
        i:=ZCADMainWindow.PageControl.PageCount-1;
      ZCADMainWindow.PageControl.ActivePageIndex:=i;
      ZCADMainWindow.ChangedDWGTab(ZCADMainWindow.PageControl);
    end;
  result:=cmd_ok;
end;

procedure startup;
begin
  CreateCommandFastObjectPlugin(@PrevDrawing_com,'PrevDrawing',0,0);
end;
procedure finalize;
begin
end;
initialization
  debugln('{I}[UnitsInitialization] Unit "',{$INCLUDE %FILE%},'" initialization');
  startup;
finalization
  debugln('{I}[UnitsFinalization] Unit "',{$INCLUDE %FILE%},'" finalization');
  finalize;
end.
