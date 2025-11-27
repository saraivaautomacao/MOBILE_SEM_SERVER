unit ufrDetalhe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.StdCtrls, FMX.Grid, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Objects, FMX.Layouts,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TfrmDetalhe = class(TForm)
    ToolBar2: TToolBar;
    SpeedButton5: TSpeedButton;
    rect_destImpressao: TRectangle;
    spImprime: TSpeedButton;
    lsvdetalhes: TListView;
    Layout1: TLayout;
    lbltotal: TLabel;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    SpeedButton1: TSpeedButton;
    lblConferencia: TLabel;
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure spImprimeClick(Sender: TObject);
  private
    { Private declarations }
    procedure impressao_parcial;

  public
    { Public declarations }
    var nummesa:string;
  end;

var
  frmDetalhe: TfrmDetalhe;

implementation

{$R *.fmx}

uses  ufrComanda,controller.comanda, udmLocal,acbrposprinter;

procedure TfrmDetalhe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    frmDetalhe := nil;
    frmdetalhe.disposeof;
    dmlocal.qrvendas.close;
end;

procedure TfrmDetalhe.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
 {$IFDEF ANDROID}
  if Key = vkReturn then
  begin
    Key := vkTab;
    KeyDown(Key, KeyChar, Shift);
  end;
 {$ENDIF}
  if Key = vkHardwareBack then
    key := 0;
end;

Function TamStr(Texto:String;N:SmallInt;Direcao:Char):String;

Begin
   Result:=trim(Texto);
   Texto:=trim(texto);
   var Str:String:='';
   If Length(Texto)<N Then
   Begin
       For var Cont:Integer:=1 To Abs(Length(Texto)-n) Do
          Str:=Str+' ';
       If UpperCase(Direcao)='E' Then
          Texto:=str+Texto
       Else If UpperCase(Direcao)='D' Then
          Texto:=Texto+Str;
       Result:=Texto;
   End;
End;


procedure TfrmDetalhe.impressao_parcial;
begin
  with dmlocal do
   begin
       qrImpressora.open;
       qrCabecalho.open;
       //impressao parcial existe
       if qrImpressora.locate('local','PARCIAL') then
       Begin
         var   Memo:TStringList:=TStringList.Create;
         try
            aCBrPosPrinter1.Modelo := TACBrPosPrinterModelo(qrImpressoramodelo.asinteger);
            ACBrPosPrinter1.Porta  :=qrImpressoraporta.asString;
             ACBrPosPrinter1.LinhasEntreCupons := qrImpressoralinhaspular.asInteger;
             ACBrPosPrinter1.ControlePorta :=true;// qrImpressoracontroleporta.asBoolean;
             ACBrPosPrinter1.CortaPapel := qrImpressoracortarpapel.asBoolean;
             memo.clear;
             Memo.Add('</zera>');
             Memo.Add('<e>');
             Memo.Add(qrCabecalhocabecalho1.asstring);
             Memo.Add(qrCabecalhocabecalho2.asstring);
             Memo.Add('</fn>');
             Memo.add('</linha_simples>');
             Memo.add('***************** PARCIAL***************');
             Memo.add('</linha_simples>');
             memo.Add('<e>'+'MESA:'+nummesa+'</e>');
             memo.Add('Atendente: '+Atendente);
             Memo.add('Data/hora: '+DateToStr(now));
             memo.Add('</linha_simples>');
              memo.Add(' Descricao    Quant x P.Unit.  Total ') ;
             memo.Add('</linha_simples>');
             Var Soma:Currency:=0;
             qrvendas.first;
             while not qrVendas.eof do
             begin
                memo.Add(copy(qrVendas.FieldByName('produto').AsString,1,40));
                Memo.Add(FloattoStrf( qrVendas.FieldByName('qtde').asFloat,ffnumber,7,3)+
                 '   X         ' +
                tamstr( floatToStrf(qrVendas.FieldByName('vrunit').asCurrency,ffnumber,7,2),7,'e')+
                '      '+
                tamstr(FloatToStrf(qrVendas.FieldByName('vrunit').asCurrency*
                qrVendas.FieldByName('qtde').asFloat,ffnumber,7,2),7,'e'));
                Soma:=Soma+qrVendastotal.ascurrency;
                qrVendas.Next;
             end;
             memo.Add('</linha_simples>');
             Memo.Add('<e>TOTAL:'+ FloatToStrf(soma,ffCurrency,12,2)+'</e>');
             Memo.add('</lf>');
             Memo.add('</pular_linhas>');
             Memo.Add('</fn>');
             Memo.Add('</corte_total>');
             ACBrPosPrinter1.Imprimir(memo.text);
         finally
             memo.DisposeOf;
         end;
       End;
      qrCabecalho.close;
      qrImpressora.close;
   end;



end;

procedure TfrmDetalhe.SpeedButton1Click(Sender: TObject);
begin
//   impressao_parcial;
   with dmlocal do
   begin
       qrvendas.first;
       var lkmesa:=qrVendaslkmesa.asstring;
       //soma de valores
       var total:currency:=0;
       while not qrvendas.eof do
       begin
         total:=total+qrVendastotal.asCurrency;
         qrvendas.delete;
       end;
       qrResumo_vendas.close;
       qrResumo_vendas.Params[0].asString:=lkmesa;
       qrResumo_vendas.open;
       if qrResumo_vendas.isempty then
       begin
          qrResumo_vendas.append ;
          qrResumo_vendaslkmesa.asString:=lkmesa;
       end
       Else
         qrResumo_vendas.edit;
       qrResumo_vendastotal.asCurrency:=  qrResumo_vendastotal.asCurrency+total;
       qrResumo_vendas.post;
       qrResumo_vendas.Close;
       frmComanda.StatusComanda(lkmesa,'L',0);
      qrvendas.close;
   end;
     frmComanda.lstbxmesas.Enabled:=true;
     close;
end;

procedure TfrmDetalhe.SpeedButton5Click(Sender: TObject);
begin
   frmComanda.lstbxmesas.Enabled:=true;
   close;

end;

procedure TfrmDetalhe.spImprimeClick(Sender: TObject);
begin
  impressao_parcial;
end;

end.
