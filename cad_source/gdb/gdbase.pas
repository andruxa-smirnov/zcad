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

unit gdbase;
{$INCLUDE def.inc}
interface
uses gdbasetypes,
     gdbobjectsconstdef;
type
{EXPORT+}
GDBTypedPointer=record
                      Instance:GDBPointer;
                      PTD:GDBPointer;
                end;
PGDBaseObject=^GDBaseObject;
GDBaseObject=object
    function ObjToGDBString(prefix,sufix:GDBString):GDBString; virtual;
    function GetObjType:GDBWord;virtual;
    procedure Format;virtual;
    procedure FormatAfterFielfmod(PField,PTypeDescriptor:GDBPointer);virtual;
    function AfterSerialize(SaveFlag:GDBWord; membuf:GDBPointer):GDBInteger;virtual;
    function AfterDeSerialize(SaveFlag:GDBWord; membuf:GDBPointer):GDBInteger;virtual;
    function GetObjTypeName:GDBString;virtual;
    function GetObjName:GDBString;virtual;
    constructor initnul;
    destructor Done;virtual; abstract;
  end;
devicedesk=record
                 category,variable,name,id,nameall,tu,edizm,mass:GDBString;
           end;
PTZCPOffsetTable=^TZCPOffsetTable;
TZCPOffsetTable=record
                      GDB:GDBLongword;(*saved_to_shd*)
                      GDBRT:GDBLongword;(*saved_to_shd*)
                end;
PZCPHeader=^ZCPHeader;
ZCPHeader=record
                Signature:GDBString;(*saved_to_shd*)
                Copyright:GDBString;(*saved_to_shd*)
                Coment:GDBString;(*saved_to_shd*)
                HiVersion:GDBWord;(*saved_to_shd*)
                LoVersion:GDBWord;(*saved_to_shd*)
                OffsetTable:TZCPOffsetTable;(*saved_to_shd*)
          end;
TObjLinkRecordMode=(OBT(*'ObjBeginToken'*),OFT(*'ObjFieldToken'*),UBR(*'UncnownByReference'*));
PTObjLinkRecord=^TObjLinkRecord;
TObjLinkRecord=record
                     OldAddr:GDBLongword;(*saved_to_shd*)
                     NewAddr:GDBLongword;(*saved_to_shd*)
                     TempAddr:GDBLongword;(*saved_to_shd*)
                     LinkCount:GDBInteger;(*saved_to_shd*)
                     Mode:TObjLinkRecordMode;(*saved_to_shd*)
               end;
PIMatrix4=^IMatrix4;               
IMatrix4=array[0..3]of GDBInteger;
DVector4D=array[0..3]of GDBDouble;
DVector3D=array[0..2]of GDBDouble;
PDMatrix4D=^DMatrix4D;
DMatrix4D=array[0..3]of DVector4D;
DMatrix3D=array[0..2]of DVector3D;
ClipArray=array[0..5]of DVector4D;
PGDBvertex=^GDBvertex;
GDBvertex=record
                x:GDBDouble;(*saved_to_shd*)
                y:GDBDouble;(*saved_to_shd*)
                z:GDBDouble;(*saved_to_shd*)
          end;
PGDBQuaternion=^GDBQuaternion;
GDBQuaternion=record
   ImagPart: GDBvertex;
   RealPart: GDBDouble;
              end;
GDBBasis=record
                ox:GDBvertex;(*'OX Axis'*)(*saved_to_shd*)
                oy:GDBvertex;(*'OY Axis'*)(*saved_to_shd*)
                oz:GDBvertex;(*'OZ Axis'*)(*saved_to_shd*)
          end;
GDBvertex3S=record
                x:GDBFloat;(*saved_to_shd*)
                y:GDBFloat;(*saved_to_shd*)
                z:GDBFloat;(*saved_to_shd*)
          end;
PGDBLineProp=^GDBLineProp;
GDBLineProp=record
                  lBegin:GDBvertex;(*'Begin'*)(*saved_to_shd*)
                  lEnd:GDBvertex;(*'End'*)(*saved_to_shd*)
              end;
PGDBvertex4D=^GDBvertex4D;
GDBvertex4D=record
                x,y,z,w:GDBDouble;
            end;
GDBvertex4F=record
                x,y,z,w:GDBFloat;
            end;
PGDBvertex2D=^GDBvertex2D;
GDBvertex2D=record
                x:GDBDouble;(*saved_to_shd*)
                y:GDBDouble;(*saved_to_shd*)
            end;
PGDBPolyVertex2D=^GDBPolyVertex2D;
GDBPolyVertex2D=record
                      coord:GDBvertex2D;
                      count:GDBInteger;
                end;
PGDBPolyVertex3D=^GDBPolyVertex3D;
GDBPolyVertex3D=record
                      coord:GDBvertex;
                      count:GDBInteger;
                      LineNumber:GDBInteger;
                end;
PGDBvertex2S=^GDBvertex2S;
GDBvertex2S=record
                   x,y:GDBFloat;
             end;
GDBvertex2DI=record
                   x,y:GDBInteger;
             end;
GDBBoundingBbox=record
                      LBN:GDBvertex;(*'Near'*)
                      RTF:GDBvertex;(*'Far'*)
                end;
TInRect=(IRFully,IRPartially,IREmpty);                
PGDBvertex2DI=^GDBvertex2DI;
GDBvertex2DIArray=array [0..0] of GDBvertex2DI;
PGDBvertex2DIArray=^GDBvertex2DIArray;
OutBound4V=array [0..3]of GDBvertex;
Proj4V2DI=array [0..3]of GDBvertex2DI;
PGDBQuad3d=^GDBQuad3d;
GDBQuad2d=array[0..3] of GDBvertex2D;
GDBQuad3d={array[0..3] of GDBvertex}OutBound4V;
PGDBLineProj=^GDBLineProj;
GDBLineProj=array[0..6] of GDBvertex2D;
GDBplane=record
               normal:GDBvertex;
               d:GDBDouble;
         end;
GDBray=record
             start,dir:GDBvertex;
       end;
GDBPiece=record
             lbegin,dir,lend:GDBvertex;
       end;
ptarcrtmodify=^tarcrtmodify;
tarcrtmodify=record
                      p1,p2,p3:GDBVertex2d;
                end;
TArcData=record
               r,startangle,endangle:gdbdouble;
               p:GDBvertex2D;
end;
GDBCameraBaseProp=record
                        point:GDBvertex;
                        look:GDBvertex;
                        ydir:GDBvertex;
                        xdir:GDBvertex;
                        zoom: GDBDouble;
                  end;
TActulity=GDBInteger;
TObjID=GDBWord;
TDrawContext=record
                   VisibleActualy:TActulity;
                   InfrustumActualy:TActulity;
                   DRAWCOUNT:TActulity;
                   Subrender:GDBInteger;
                   Selected:GDBBoolean;
                   SysLayer:GDBPointer;
                   MaxDetail:GDBBoolean;
                   DrawMode:GDBInteger;
                   OwnerLineWeight:GDBSmallInt;
                   OwnerColor:GDBInteger;
                   MaxWidth:GDBInteger;
                   ScrollMode:GDBBoolean;
                   Zoom:GDBDouble;
             end;

PGDBBaseCamera=^GDBBaseCamera;
GDBBaseCamera=object(GDBaseObject)
                modelMatrix:DMatrix4D;
                fovy:GDBDouble;
                totalobj:GDBInteger;
                prop:GDBCameraBaseProp;
                anglx,angly,zmin,zmax:GDBDouble;
                projMatrix:DMatrix4D;
                viewport:IMatrix4;
                clip:DMatrix4D;
                frustum:ClipArray;
                infrustum:GDBInteger;
                obj_zmax,obj_zmin:GDBDouble;
                DRAWNOTEND:GDBBoolean;
                DRAWCOUNT:TActulity;
                POSCOUNT:TActulity;
                VISCOUNT:TActulity;
                CamCSOffset:GDBvertex;
                procedure NextPosition;virtual; abstract;
          end;
PRGB=^RGB;
RGB=record
          r:GDBByte;(*'Red'*)
          g:GDBByte;(*'Green'*)
          b:GDBByte;(*'Blue'*)
          a:GDBByte;(*'Alpha'*)
          name:GDBString;
    end;
GDBPalette=array[0..255] of RGB;
PGDBNamedObject=^GDBNamedObject;
GDBNamedObject=object(GDBaseObject)
                     Name:GDBAnsiString;(*saved_to_shd*)(*'Name'*)
                     constructor initnul;
                     constructor init(n:GDBString);
                     destructor Done;virtual;
                     procedure SetName(n:GDBString);
                     function GetName:GDBString;
                     function GetFullName:GDBString;virtual;
               end;
ODBDevicepassport=record
                        category,name,id,nameall,tu,edizm:GDBString;
                        mass:GDBDouble;
                  end;
PGLLWWidth=^GLLWWidth;
GLLWWidth=record
                startw:GDBDouble;(*saved_to_shd*)
                endw:GDBDouble;(*saved_to_shd*)
                hw:GDBBoolean;(*saved_to_shd*)
                quad:GDBQuad2d;
          end;
PGDBOpenArrayGLlwwidth_GDBWord=^GDBOpenArrayGLlwwidth_GDBWord;
PGDBStrWithPoint=^GDBStrWithPoint;
GDBStrWithPoint=record
                      str:GDBString;
                      x,y,z,w:GDBDouble;
                end;
GDBAttrib=record
                tag,prompt,value:GDBString;
          end;
GDBArrayVertex2D=array[0..300] of GDBVertex2D;
PGDBArrayVertex2D=^GDBArrayVertex2D;
GDBArrayGDBDouble=array[0..300] of GDBDouble;
GDBArrayAttrib=array[0..300] of GDBAttrib;
PGDBArrayGLlwwidth=^GDBArrayGLlwwidth;
GDBArrayGLlwwidth=array[0..300] of GLLWWidth;
GDBOpenArrayGLlwwidth_GDBWord=record
    count: GDBWord;
    widtharray: GDBArrayGLlwwidth;
  end;
PGDBArrayVertex=^GDBArrayVertex;
GDBArrayVertex=array[0..0] of GDBvertex;
  pcontrolpointdesc=^controlpointdesc;
  controlpointdesc=record
                         pointtype:GDBInteger;
                         pobject:GDBPointer;
                         worldcoord:GDBvertex;
                         dcoord:GDBvertex;
                         dispcoord:GDBvertex2DI;
                         selected:GDBBoolean;
                   end;
  TRTModifyData=record
                     point:controlpointdesc;
                     dist,wc:gdbvertex;
               end;
  tcontrolpointdist=record
    pcontrolpoint:pcontrolpointdesc;
    disttomouse:GDBInteger;
  end;
  TmyFileVersionInfo=record
                         major,minor,release,build,revision:GDBInteger;
                         versionstring:GDBstring;
                     end;
  TArrayIndex=GDBInteger;

  fontfloat=GDBFloat;
  pfontfloat=^fontfloat;

  TPolyData=record
                  nearestvertex:gdbinteger;
                  nearestline:gdbinteger;
                  dir:gdbinteger;
                  wc:GDBVertex;
            end;
  TLoadOpt=(TLOLoad,TLOMerge);
  PTLayerControl=^TLayerControl;
  TLayerControl=record
                      Enabled:GDBBoolean;(*'Enabled'*)
                      LayerName:GDBString;(*'Layer name'*)
                end;
  TShapeBorder=(SB_Owner,SB_Self,SB_Empty);
  TShapeClass=(SC_Connector,SC_Terminal,SC_Graphix,SC_Unknown);
  TShapeGroup=(SG_El_Sch,SG_Cable_Sch,SG_Plan,SG_Unknown);

  TBlockType=(BT_Connector,BT_Unknown);
  TBlockBorder=(BB_Owner,BB_Self,BB_Empty);
  TBlockGroup=(BG_El_Device,BG_Unknown);
  TBlockDesc=record
                   BType:TBlockType;(*'Block type'*)
                   BBorder:TBlockBorder;(*'Border'*)
                   BGroup:TBlockGroup;(*'Block group'*)
             end;
FreeElProc=procedure (p:GDBPointer);
{EXPORT-}
TDWGHandle=ptruint;
const
  empty_GDBString='Empty GDBString';
  arccount: GDBWord=16;
  ZCPSignature='ZCAD project file'#13#10;
  ZCPCopyright='Copyright (C) 2005-2007 Zubarev Andrey'#13#10;
  ZCPComent='Формат файла будет меняться в ходе разработки программы';

  ZCPHead:ZCPHeader=
                    (
                     Signature:ZCPSignature;
                     Copyright:ZCPCopyright;
                     Coment:ZCPComent;
                     HiVersion:0;
                     LoVersion:2;
                     OffsetTable:(
                                  GDB:1;
                                  GDBRT:2;
                                 )
                     );
   ZCPHeadOffsetTableOffset=3*sizeof(word)+length(ZCPSignature)+length(ZCPCopyright)+length(ZCPComent)
                             +sizeof(ZCPHead.HiVersion)+sizeof(ZCPHead.LoVersion);
var
  palette: gdbpalette;
implementation
uses
     log;
function GDBaseObject.GetObjType;
begin
     result:=GDBBaseObjectID;
end;
function GDBaseObject.ObjToGDBString(prefix,sufix:GDBString):GDBString;
begin
     result:=prefix+GetObjTypeName+sufix;
end;
constructor GDBaseObject.initnul;
begin
end;
procedure GDBaseObject.format;
begin
end;
procedure GDBaseObject.FormatAfterFielfmod;
begin
     format;
end;
function GDBaseObject.AfterSerialize;
begin
     result:=0;
end;
function GDBaseObject.AfterDeSerialize;
begin
     result:=0;
end;
function GDBaseObject.GetObjTypeName;
begin
     //pointer(result):=typeof(testobj);
     result:='GDBaseObject';

end;
function GDBaseObject.GetObjName;
begin
     //pointer(result):=typeof(testobj);
     result:=GetObjTypeName;

end;
constructor GDBNamedObject.initnul;
begin
     pointer(name):=nil;
end;
constructor GDBNamedObject.Init;
begin
    initnul;
    SetName(n);
end;
destructor GDBNamedObject.done;
begin
     SetName('');
end;
procedure GDBNamedObject.SetName;
begin
     name:=n;
end;
function GDBNamedObject.GetName;
begin
     result:=name;
end;
function GDBNamedObject.GetFullName;
begin
     result:=name;
end;
begin
{$IFDEF DEBUGINITSECTION}log.LogOut('gdbase.initialization');{$ENDIF}
end.

