unit ufrEncerramento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Layouts, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope;

type
  TfrmEncerramento = class(TForm)
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    btnVoltar: TButton;
    ToolBar1: TToolBar;
    Button2: TButton;
    Layout1: TLayout;
    lsvResumo: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    spImprime: TSpeedButton;
    LinkFillControlToField1: TLinkFillControlToField;
    Label1: TLabel;
    Label2: TLabel;
    lsvPagamentos: TListView;
    BindSourceDB2: TBindSourceDB;
    LinkFillControlToField2: TLinkFillControlToField;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spImprimeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEncerramento: TfrmEncerramento;

implementation

{$R *.fmx}

uses udmLocal, ufrComanda,acbrposprinter;
Function TamStr(Texto:String;N:SmallInt;Direcao:Char):String;
Var
  Cont:Integer;
  Str:String;
Begin
   Result:=trim(Texto);
   Texto:=trim(texto);
   Str:='';
   If Length(Texto)<N Then
   Begin
       For Cont:=1 To Abs(Length(Texto)-n) Do
          Str:=Str+' ';
       If UpperCase(Direcao)='E' Then
          Texto:=str+Texto
       Else If UpperCase(Direcao)='D' Then
          Texto:=Texto+Str;
       Result:=Texto;
   End;
End;

procedure TfrmEncerramento.btnVoltarClick(Sender: TObject);
begin
   close;

end;

procedure TfrmEncerramento.Button2Click(Sender: TObject);
begin

     dmLocal.conLocal.ExecSQL('delete from vendas_resumo');
     with dmlocal do
     begin
       qrForma_pgto.first;
       while not qrForma_pgto.eof do
       begin
          qrForma_pgto.edit;
         qrForma_pgtoVALOR.asCurrency:=0;
         qrForma_pgto.post;
         qrForma_pgto.next;
       end;
     end;
     frmcomanda.lstbxMesas.Clear;
     frmcomanda.carregamesas;
     close;
end;

procedure TfrmEncerramento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := TCloseAction.caFree;
    frmEncerramento := nil;
    frmEncerramento.disposeof;
    dmlocal.qrEncerra.close;
    dmlocal.qrForma_pgto.close;
end;

procedure TfrmEncerramento.FormShow(Sender: TObject);
begin
  with dmlocal do
  begin
      var soma:currency:=0;
      qrEncerra.first;
      while not qrencerra.eof do
      begin
         soma:=soma+qrEncerratotal.ascurrency;
         qrencerra.next;
      end;
      qrForma_pgto.open;
      label2.text:='Total Geral:'+floattostrf(soma,ffcurrency,12,2);
  end;
end;

procedure TfrmEncerramento.spImprimeClick(Sender: TObject);
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
             Memo.add('***************FECHAMENTO*************');
             Memo.add('</linha_simples>');

             memo.Add('Atendente: '+Atendente);
             Memo.add('Data/hora: '+DateToStr(now));
             memo.Add('</linha_simples>');
              memo.Add('      Comanda             Total ') ;
             memo.Add('</linha_simples>');
             Var Soma:Currency:=0;
             qrencerra.first;
             while not qrencerra.eof do
             begin
                memo.Add('        '+qrEncerralkmesa.asString +'          '+
                tamstr(floattostrf(qrencerratotal.ascurrency,ffcurrency,12,2),12,'e'));
                qrencerra.Next;
             end;
             memo.Add('</linha_simples>');
             qrForma_pgto.first;
             while not qrForma_pgto.eof do
             begin
                 memo.Add(tamstr(qrForma_pgtoDescricao.asString,20,'d') +
                tamstr(floattostrf(qrForma_pgtovalor.ascurrency,ffcurrency,12,2),12,'e'));
                qrForma_pgto.Next;
             end;
             memo.Add('</linha_simples>');
             Memo.Add('<e>'+label2.text+'</e>');
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

end.
