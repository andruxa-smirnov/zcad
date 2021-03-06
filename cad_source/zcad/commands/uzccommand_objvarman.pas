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
{$mode delphi}
unit uzccommand_objvarman;

{$INCLUDE def.inc}

interface
uses
  LazLogger,
  Controls,
  sysutils,
  uzbpaths,
  uzccmdinfoform,
  uzccommandsabstract,uzccommandsimpl,
  UGDBOpenArrayOfByte,
  uzeentity,
  uzcenitiesvariablesextender,
  uzcinterface,
  uzcstrconsts,
  uzcdrawings,
  UUnitManager,
  uzccmdeditunit,
  uzctranslations;

implementation

function ObjVarMan_com(operands:TCommandOperands):TCommandResult;
var
  pobj:PGDBObjEntity;
  pentvarext:PTVariablesExtender;
begin
  if drawings.GetCurrentDWG.wa.param.SelDesc.Selectedobjcount=1 then
    pobj:=PGDBObjEntity(drawings.GetCurrentDWG.GetLastSelected)
  else
    pobj:=nil;
  if pobj<>nil then begin
    pentvarext:=pobj^.GetExtension(typeof(TVariablesExtender));
    if pentvarext<>nil then begin
      if EditUnit(pentvarext^.entityunit) then
        ZCMsgCallBackInterface.Do_GUIaction(nil,ZMsgID_GUIRePrepareObject);
    end;
   end else
     ZCMsgCallBackInterface.TextMessage(rscmSelEntBeforeComm,TMWOHistoryOut);
  result:=cmd_ok;
end;

initialization
  debugln('{I}[UnitsInitialization] Unit "',{$INCLUDE %FILE%},'" initialization');
  CreateCommandFastObjectPlugin(@ObjVarMan_com,'ObjVarMan',CADWG or CASelEnt,0);
finalization
  debugln('{I}[UnitsFinalization] Unit "',{$INCLUDE %FILE%},'" finalization');
end.
