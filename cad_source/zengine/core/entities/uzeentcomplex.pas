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

unit uzeentcomplex;
{$INCLUDE def.inc}

interface
uses uzepalette,uzgldrawcontext,uzedrawingdef,uzecamera,gzctnrvectorpobjects,
     uzestyleslayers,uzbtypesbase,sysutils,UGDBSelectedObjArray,UGDBVisibleOpenArray,
     uzeentity,UGDBVisibleTreeArray,uzeentitiestree,uzbtypes,uzeentwithlocalcs,
     gzctnrvectortypes,uzbgeomtypes,uzeconsts,uzegeometry,uzbmemman;
type
{EXPORT+}
PGDBObjComplex=^GDBObjComplex;
GDBObjComplex={$IFNDEF DELPHI}packed{$ENDIF} object(GDBObjWithLocalCS)
                    ConstObjArray:{GDBObjEntityOpenArray;}GDBObjEntityTreeArray;(*oi_readonly*)(*hidden_in_objinsp*)
                    procedure DrawGeometry(lw:GDBInteger;var DC:TDrawContext{infrustumactualy:TActulity;subrender:GDBInteger});virtual;
                    procedure DrawOnlyGeometry(lw:GDBInteger;var DC:TDrawContext{infrustumactualy:TActulity;subrender:GDBInteger});virtual;
                    procedure getoutbound(var DC:TDrawContext);virtual;
                    procedure getonlyoutbound(var DC:TDrawContext);virtual;
                    destructor done;virtual;
                    constructor initnul;
                    constructor init(own:GDBPointer;layeraddres:PGDBLayerProp;LW:GDBSmallint);
                    function CalcInFrustum(frustum:ClipArray;infrustumactualy:TActulity;visibleactualy:TActulity;var totalobj,infrustumobj:GDBInteger; ProjectProc:GDBProjectProc;const zoom,currentdegradationfactor:GDBDouble):GDBBoolean;virtual;
                    function CalcTrueInFrustum(frustum:ClipArray;visibleactualy:TActulity):TInBoundingVolume;virtual;
                    function onmouse(var popa:TZctnrVectorPGDBaseObjects;const MF:ClipArray;InSubEntry:GDBBoolean):GDBBoolean;virtual;
                    procedure renderfeedbac(infrustumactualy:TActulity;pcount:TActulity;var camera:GDBObjCamera; ProjectProc:GDBProjectProc;var DC:TDrawContext);virtual;
                    procedure addcontrolpoints(tdesc:GDBPointer);virtual;
                    procedure remaponecontrolpoint(pdesc:pcontrolpointdesc);virtual;
                    procedure rtedit(refp:GDBPointer;mode:GDBFloat;dist,wc:gdbvertex);virtual;
                    procedure rtmodifyonepoint(const rtmod:TRTModifyData);virtual;
                    procedure FormatEntity(var drawing:TDrawingDef;var DC:TDrawContext);virtual;
                    //procedure feedbackinrect;virtual;
                    //function InRect:TInRect;virtual;
                    //procedure Draw(lw:GDBInteger);virtual;
                    procedure SetInFrustumFromTree(const frustum:ClipArray;infrustumactualy:TActulity;visibleactualy:TActulity;var totalobj,infrustumobj:GDBInteger; ProjectProc:GDBProjectProc;const zoom,currentdegradationfactor:GDBDouble);virtual;
                    function onpoint(var objects:TZctnrVectorPGDBaseObjects;const point:GDBVertex):GDBBoolean;virtual;
                    procedure BuildGeometry(var drawing:TDrawingDef);virtual;
                    procedure FormatAfterDXFLoad(var drawing:TDrawingDef;var DC:TDrawContext);virtual;
              end;
{EXPORT-}
implementation
//uses
//    log{,varmandef};
{procedure GDBObjComplex.Draw;
begin
  if visible then
  begin
       self.DrawWithAttrib; //DrawGeometry(lw);
  end;
end;}
procedure GDBObjComplex.BuildGeometry;
begin
     //ConstObjArray.ObjTree.done;
     ConstObjArray.ObjTree.ClearSub;
     ConstObjArray.ObjTree.maketreefrom(ConstObjArray,vp.BoundingBox,nil);
     //ConstObjArray.ObjTree:=createtree(ConstObjArray,vp.BoundingBox,@ConstObjArray.ObjTree,IninialNodeDepth,nil,TND_Root)^;
end;

function GDBObjComplex.onpoint(var objects:TZctnrVectorPGDBaseObjects;const point:GDBVertex):GDBBoolean;
begin
     result:=ConstObjArray.onpoint(objects,point);
end;
procedure GDBObjComplex.SetInFrustumFromTree;
begin
     inherited;
     ConstObjArray.SetInFrustumFromTree(frustum,infrustumactualy,visibleactualy,totalobj,infrustumobj, ProjectProc,zoom,currentdegradationfactor);
     ConstObjArray.ObjTree.BoundingBox:=vp.BoundingBox;
     ProcessTree(frustum,infrustumactualy,visibleactualy,ConstObjArray.ObjTree,IRFully,TDTFulDraw,totalobj,infrustumobj,ProjectProc,zoom,currentdegradationfactor);
end;
{function GDBObjComplex.InRect:TInRect;
begin
     result:=ConstObjArray.InRect;
end;}
procedure GDBObjComplex.rtmodifyonepoint;
var m:DMatrix4D;
begin
     //m:=bp.ListPos.owner.getmatrix^;
     //m:=objmatrix;
     //PGDBVertex(@m[3])^:=nulvertex;
     //MatrixInvert(m);
     m:=onematrix;

     case rtmod.point.pointtype of
               os_point:begin
                             if rtmod.point.pobject=nil then
                             Local.p_insert:=vectortransform3d(VertexAdd(rtmod.point.worldcoord, rtmod.dist{VectorTransform3D(rtmod.dist,m)}),m)
                             else
                               Local.p_insert:=vectortransform3d(VertexSub(VertexAdd(rtmod.point.worldcoord, rtmod.dist),rtmod.point.dcoord),m);
                         end;
     end;
end;
procedure GDBObjComplex.rtedit;
var
   m:DMatrix4D;
begin
  if mode = os_blockinsert then
  begin
    m:=objmatrix;
    matrixinvert(m);
    Local.p_insert :={vectortransform3d( }VertexAdd(PGDBObjComplex(refp)^.Local.p_insert, dist){,m)};
  end;
  //format;
end;
procedure GDBObjComplex.remaponecontrolpoint(pdesc:pcontrolpointdesc);
begin
                    case pdesc^.pointtype of
                    os_point:begin
                                  if pdesc.pobject=nil then
                                  begin
                                  pdesc.worldcoord:=self.P_insert_in_WCS;// Local.P_insert;
                                  pdesc.dispcoord.x:=round(ProjP_insert.x);
                                  pdesc.dispcoord.y:=round(ProjP_insert.y);
                                  end
                                  else
                                  begin
                                  pdesc.worldcoord:=PGDBObjComplex(pdesc.pobject).P_insert_in_WCS;// Local.P_insert;
                                  pdesc.dispcoord.x:=round(PGDBObjComplex(pdesc.pobject).ProjP_insert.x);
                                  pdesc.dispcoord.y:=round(PGDBObjComplex(pdesc.pobject).ProjP_insert.y);
                                  pdesc.dcoord:=vertexsub(PGDBObjComplex(pdesc.pobject).P_insert_in_WCS,P_insert_in_WCS);
                                  end

                             end;
                    end;
end;
procedure GDBObjComplex.addcontrolpoints(tdesc:GDBPointer);
var pdesc:controlpointdesc;
begin
          PSelectedObjDesc(tdesc)^.pcontrolpoint^.init({$IFDEF DEBUGBUILD}'{E8AC77BE-9C28-4A6E-BB1A-D5F8729BDDAD}',{$ENDIF}1);
          pdesc.selected:=false;
          pdesc.pobject:=nil;
          pdesc.pointtype:=os_point;
          pdesc.pobject:=nil;
          pdesc.worldcoord:=self.P_insert_in_WCS;// Local.P_insert;
          {pdesc.dispcoord.x:=round(ProjP_insert.x);
          pdesc.dispcoord.y:=round(ProjP_insert.y);}
          PSelectedObjDesc(tdesc)^.pcontrolpoint^.PushBackData(pdesc);
end;
procedure GDBObjComplex.DrawOnlyGeometry;
begin
  inc(dc.subrender);
  ConstObjArray.{DrawWithattrib}DrawOnlyGeometry(CalculateLineWeight(dc),dc{infrustumactualy,subrender});
  dec(dc.subrender);
  //inherited;
end;
procedure GDBObjComplex.DrawGeometry;
var
   oldlw:gdbsmallint;
   oldColor:TGDBPaletteColor;
begin
  oldlw:=dc.OwnerLineWeight;
  oldColor:=dc.ownercolor;
  dc.OwnerLineWeight:=self.GetLineWeight;
  case vp.Color of
                  ClByBlock:;
                  ClByLayer:
                            dc.ownercolor:=vp.Layer^.color;
                else
                      dc.ownercolor:=vp.Color;
  end;
  inc(dc.subrender);
  //ConstObjArray.DrawWithattrib(dc{infrustumactualy,subrender)}{DrawGeometry(CalculateLineWeight});
  TZEntsManipulator.treerender(ConstObjArray.ObjTree,dc);
  //ConstObjArray.ObjTree.treerender(dc);
      if DC.SystmGeometryDraw then
                                  ConstObjArray.ObjTree.DrawVolume(dc);
  dec(dc.subrender);
  dc.OwnerLineWeight:=oldlw;
  dc.ownercolor:=oldColor;
  inherited;
end;
procedure GDBObjComplex.getoutbound;
begin
     vp.BoundingBox:=ConstObjArray.{calcbb}getoutbound(dc);
end;
procedure GDBObjComplex.getonlyoutbound;
begin
     vp.BoundingBox:=ConstObjArray.{calcbb}getonlyoutbound(dc);
end;
constructor GDBObjComplex.initnul;
begin
  inherited initnul(nil);
  ConstObjArray.init({$IFDEF DEBUGBUILD}'{9DC0AF69-6DBD-479E-91FE-A61F4AC3BE56}',{$ENDIF}100);
end;
constructor GDBObjComplex.init;
begin
  inherited init(own,layeraddres,LW);
  ConstObjArray.init({$IFDEF DEBUGBUILD}'{9DC0AF69-6DBD-479E-91FE-A61F4AC3BE56}',{$ENDIF}100);
end;
destructor GDBObjComplex.done;
begin
     ConstObjArray.free;
     ConstObjArray.done;
     inherited done;
end;
function GDBObjComplex.CalcInFrustum(frustum:ClipArray;infrustumactualy:TActulity;visibleactualy:TActulity;var totalobj,infrustumobj:GDBInteger; ProjectProc:GDBProjectProc;const zoom,currentdegradationfactor:GDBDouble):GDBBoolean;
begin
     result:=ConstObjArray.calcvisible(frustum,infrustumactualy,visibleactualy,totalobj,infrustumobj, ProjectProc,zoom,currentdegradationfactor);
     ProcessTree(frustum,infrustumactualy,visibleactualy,ConstObjArray.ObjTree,IRPartially,TDTFulDraw,totalobj,infrustumobj,ProjectProc,zoom,currentdegradationfactor);
end;
function GDBObjComplex.CalcTrueInFrustum;
begin
      result:=ConstObjArray.CalcTrueInFrustum(frustum,visibleactualy);
end;
procedure GDBObjComplex.FormatAfterDXFLoad;
var
    p:pgdbobjEntity;
    ir:itrec;
begin
     //BuildGeometry;
  p:=ConstObjArray.beginiterate(ir);
  if p<>nil then
  repeat
       p^.FormatAfterDXFLoad(drawing,dc);
       p:=ConstObjArray.iterate(ir);
  until p=nil;
  inherited;
end;

function GDBObjComplex.onmouse;
var //t,xx,yy:GDBDouble;
    //i:GDBInteger;
    p:pgdbobjEntity;
    ot:GDBBoolean;
        ir:itrec;
begin
  result:=false;

  p:=ConstObjArray.beginiterate(ir);
  if p<>nil then
  repeat
       ot:=p^.isonmouse(popa,mf,InSubEntry);
       if ot then
                 begin
                      {PGDBObjOpenArrayOfPV}(popa).PushBackData(p);
                 end;
       result:=result or ot;
       p:=ConstObjArray.iterate(ir);
  until p=nil;
end;
{procedure GDBObjComplex.feedbackinrect;
begin
     if pprojpoint=nil then
                           exit;
     if POGLWnd^.seldesc.MouseFrameInverse
     then
     begin
          if pointinquad2d(POGLWND^.seldesc.Frame1.x, POGLWND^.seldesc.Frame1.y, POGLWND^.seldesc.Frame2.x, POGLWND^.seldesc.Frame2.y, pprojpoint[0].x,pprojpoint[0].y)
          or pointinquad2d(POGLWND^.seldesc.Frame1.x, POGLWND^.seldesc.Frame1.y, POGLWND^.seldesc.Frame2.x, POGLWND^.seldesc.Frame2.y, pprojpoint[1].x,pprojpoint[1].y)
          then
              begin
                   select;
                   exit;
              end;
          if
          intercept2d2(POGLWND^.seldesc.Frame1.x, POGLWND^.seldesc.Frame1.y, POGLWND^.seldesc.Frame2.x, POGLWND^.seldesc.Frame1.y, pprojpoint[0].x,pprojpoint[0].y,pprojpoint[1].x,pprojpoint[1].y)
       or intercept2d2(POGLWND^.seldesc.Frame2.x, POGLWND^.seldesc.Frame1.y, POGLWND^.seldesc.Frame2.x, POGLWND^.seldesc.Frame2.y, pprojpoint[0].x,pprojpoint[0].y,pprojpoint[1].x,pprojpoint[1].y)
       or intercept2d2(POGLWND^.seldesc.Frame2.x, POGLWND^.seldesc.Frame2.y, POGLWND^.seldesc.Frame1.x, POGLWND^.seldesc.Frame2.y, pprojpoint[0].x,pprojpoint[0].y,pprojpoint[1].x,pprojpoint[1].y)
       or intercept2d2(POGLWND^.seldesc.Frame1.x, POGLWND^.seldesc.Frame2.y, POGLWND^.seldesc.Frame1.x, POGLWND^.seldesc.Frame1.y, pprojpoint[0].x,pprojpoint[0].y,pprojpoint[1].x,pprojpoint[1].y)
          then
          begin
               select;
          end;

     end
     else
     begin
          if pointinquad2d(POGLWND^.seldesc.Frame1.x, POGLWND^.seldesc.Frame1.y, POGLWND^.seldesc.Frame2.x, POGLWND^.seldesc.Frame2.y, pprojpoint[0].x,pprojpoint[0].y)
         and pointinquad2d(POGLWND^.seldesc.Frame1.x, POGLWND^.seldesc.Frame1.y, POGLWND^.seldesc.Frame2.x, POGLWND^.seldesc.Frame2.y, pprojpoint[1].x,pprojpoint[1].y)
          then
              begin
                   select;
              end;
     end;
end;}
procedure GDBObjComplex.renderfeedbac(infrustumactualy:TActulity;pcount:TActulity;var camera:GDBObjCamera; ProjectProc:GDBProjectProc;var DC:TDrawContext);
//var pblockdef:PGDBObjBlockdef;
    //pvisible:PGDBObjEntity;
    //i:GDBInteger;
begin
  //if POGLWnd=nil then exit;
  {gdb.GetCurrentDWG^.myGluProject2}ProjectProc(P_insert_in_WCS,ProjP_insert);
  //pdx:=PProjPoint[1].x-PProjPoint[0].x;
  //pdy:=PProjPoint[1].y-PProjPoint[0].y;
     ConstObjArray.RenderFeedbac(infrustumactualy,pcount,camera,ProjectProc,dc);
end;
procedure GDBObjComplex.FormatEntity(var drawing:TDrawingDef;var DC:TDrawContext);
{var pblockdef:PGDBObjBlockdef;
    pvisible,pvisible2:PGDBObjEntity;
    i:GDBInteger;
    m4:DMatrix4D;
    TempNet:PGDBObjElWire;
    TempDevice:PGDBObjDevice;
    po:pgdbobjgenericsubentry;}
begin
     calcobjmatrix;
     ConstObjArray.FormatEntity(drawing,dc);
     calcbb(dc);
     self.BuildGeometry(drawing);
end;
begin
end.
