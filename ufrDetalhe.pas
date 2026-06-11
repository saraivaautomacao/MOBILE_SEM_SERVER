unit ufrDetalhe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.StdCtrls, FMX.Grid, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Objects, FMX.Layouts,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,FMX.DialogService;

type
  // Enum para forma de pagamento
  TFormaPagamento = (fpNenhuma, fpDinheiro, fpCredito, fpDebito, fpPix);

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
    edt_Cancela_comanda: TSpeedButton;
    lblConferencia: TLabel;
    // Novos componentes de pagamento
    layPagamento: TLayout;
    lblPagamentoTitulo: TLabel;
    layBotoesPagamento: TLayout;
    rectDinheiro: TRectangle;
    btnDinheiro: TSpeedButton;
    rectCredito: TRectangle;
    btnCredito: TSpeedButton;
    rectDebito: TRectangle;
    btnDebito: TSpeedButton;
    rectPix: TRectangle;
    btnPix: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure spImprimeClick(Sender: TObject);
    // Novo evento unificado para os botões de pagamento
    procedure btnPagamentoClick(Sender: TObject);
    procedure edt_Cancela_comandaClick(Sender: TObject);
  private
    { Private declarations }
    FFormaPagamento: TFormaPagamento;
    procedure impressao_parcial;
    procedure AtualizarSelecaoPagamento;
    procedure DesmarcarTodosBotoes;

  public
    { Public declarations }
    var nummesa: string;
    property FormaPagamento: TFormaPagamento read FFormaPagamento;
    // Retorna a descrição textual da forma de pagamento selecionada
    function FormaPagamentoDescricao: string;
  end;

var
  frmDetalhe: TfrmDetalhe;

implementation

{$R *.fmx}

uses  ufrComanda, controller.comanda, udmLocal, acbrposprinter;

// ---------------------------------------------------------------------------
// Cor de destaque ao selecionar forma de pagamento
// ---------------------------------------------------------------------------
const
  COR_SELECIONADO       = $FF4CAF50;  // Verde
  COR_NAO_SELECIONADO   = $FFFFFFFF;  // Branco (claWhite)
  COR_BORDA_SELECIONADA = $FF2E7D32;  // Verde escuro
  COR_BORDA_NORMAL      = $FFDCDCDC;  // Gainsboro (claGainsboro)

procedure TfrmDetalhe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    //Action := TCloseAction.caFree;
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

// ---------------------------------------------------------------------------
// Desmarca todos os botões de pagamento (visual neutro)
// ---------------------------------------------------------------------------
procedure TfrmDetalhe.DesmarcarTodosBotoes;
begin
  rectDinheiro.Fill.Color := COR_NAO_SELECIONADO;
  rectDinheiro.Stroke.Color := COR_BORDA_NORMAL;
  rectCredito.Fill.Color  := COR_NAO_SELECIONADO;
  rectCredito.Stroke.Color  := COR_BORDA_NORMAL;
  rectDebito.Fill.Color   := COR_NAO_SELECIONADO;
  rectDebito.Stroke.Color   := COR_BORDA_NORMAL;
  rectPix.Fill.Color      := COR_NAO_SELECIONADO;
  rectPix.Stroke.Color      := COR_BORDA_NORMAL;

  btnDinheiro.TextSettings.FontColor := $FF000000;  // claBlack
  btnCredito.TextSettings.FontColor  := $FF000000;
  btnDebito.TextSettings.FontColor   := $FF000000;
  btnPix.TextSettings.FontColor      := $FF000000;
end;

procedure TfrmDetalhe.edt_Cancela_comandaClick(Sender: TObject);

begin
  TDialogService.InputQuery(
    'Cancelar Comanda',          // título
    ['Digite a senha:'],         // array de prompts
    [''],                        // array de valores iniciais
    procedure(const AResult: TModalResult; const AValues: array of string)
    begin
      if AResult <> mrOk then
        Exit;

      if AValues[0] <> 'sa123*' then
      begin
        TDialogService.ShowMessage('Senha incorreta. Cancelamento não autorizado.');
        Exit;
      end;

      // --- Senha correta: insira aqui a lógica de cancelamento ---
      // dmlocal.CancelarComanda(nummesa);
     with dmlocal do
     begin
          qrvendas.first;
          while not qrvendas.eof do
             qrvendas.delete;
         qrvendas.close;
     end;

       frmComanda.StatusComanda(nummesa, 'L', 0);
       frmComanda.lstbxmesas.Enabled := True;
       Close;
    end
  );



end;


// ---------------------------------------------------------------------------
// Destaca visualmente o botão correspondente à forma selecionada
// ---------------------------------------------------------------------------
procedure TfrmDetalhe.AtualizarSelecaoPagamento;
var
  rectSel: TRectangle;
  btnSel: TSpeedButton;
begin
  DesmarcarTodosBotoes;

  case FFormaPagamento of
    fpDinheiro: begin rectSel := rectDinheiro; btnSel := btnDinheiro; end;
    fpCredito:  begin rectSel := rectCredito;  btnSel := btnCredito;  end;
    fpDebito:   begin rectSel := rectDebito;   btnSel := btnDebito;   end;
    fpPix:      begin rectSel := rectPix;      btnSel := btnPix;      end;
  else
    Exit;
  end;

  rectSel.Fill.Color   := COR_SELECIONADO;
  rectSel.Stroke.Color := COR_BORDA_SELECIONADA;
  btnSel.TextSettings.FontColor := $FFFFFFFF;  // claWhite
end;

// ---------------------------------------------------------------------------
// Evento único disparado por todos os botões de pagamento (via Tag)
//   Tag 1 = Dinheiro | 2 = Crédito | 3 = Débito | 4 = Pix
// ---------------------------------------------------------------------------
procedure TfrmDetalhe.btnPagamentoClick(Sender: TObject);
var
  tag: Integer;
begin
  tag := (Sender as TSpeedButton).Tag;

  // Toggle: clicando novamente no mesmo botão desmarca
  if (tag = 1) and (FFormaPagamento = fpDinheiro) then
    FFormaPagamento := fpNenhuma
  else if (tag = 2) and (FFormaPagamento = fpCredito) then
    FFormaPagamento := fpNenhuma
  else if (tag = 3) and (FFormaPagamento = fpDebito) then
    FFormaPagamento := fpNenhuma
  else if (tag = 4) and (FFormaPagamento = fpPix) then
    FFormaPagamento := fpNenhuma
  else
  begin
    case tag of
      1: FFormaPagamento := fpDinheiro;
      2: FFormaPagamento := fpCredito;
      3: FFormaPagamento := fpDebito;
      4: FFormaPagamento := fpPix;
    end;
  end;

  AtualizarSelecaoPagamento;
end;

// ---------------------------------------------------------------------------
// Retorna a descrição da forma de pagamento selecionada
// ---------------------------------------------------------------------------
function TfrmDetalhe.FormaPagamentoDescricao: string;
begin
  case FFormaPagamento of
    fpDinheiro: Result := 'Dinheiro';
    fpCredito:  Result := 'Cartão de Crédito';
    fpDebito:   Result := 'Cartão de Débito';
    fpPix:      Result := 'Pix';
  else
    Result := '';
  end;
end;

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
             ACBrPosPrinter1.ControlePorta :=true;
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
             if FormaPagamentoDescricao<>'' Then
                Memo.Add('Forma Pagamento:'+FormaPagamentoDescricao);
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
  // Valida se uma forma de pagamento foi selecionada antes de finalizar
  if FFormaPagamento = fpNenhuma then
  begin
    ShowMessage('Selecione uma forma de pagamento antes de finalizar.');
    Exit;
  end;

  with dmlocal do
  begin
      qrvendas.first;
      var lkmesa := qrVendaslkmesa.asstring;
      // soma de valores
      var total: currency := 0;
      while not qrvendas.eof do
      begin
        total := total + qrVendastotal.asCurrency;
        qrvendas.delete;
      end;
      qrResumo_vendas.close;
      qrResumo_vendas.Params[0].asString := lkmesa;
      qrResumo_vendas.open;
      if qrResumo_vendas.isempty then
      begin
         qrResumo_vendas.append;
         qrResumo_vendaslkmesa.asString := lkmesa;
      end
      Else
        qrResumo_vendas.edit;
      qrResumo_vendastotal.asCurrency := qrResumo_vendastotal.asCurrency + total;

      // -----------------------------------------------------------------------
      // Grava a forma de pagamento no dataset de resumo.
      // Adapte o nome do campo conforme sua estrutura de banco de dados.
      // -----------------------------------------------------------------------
      // qrResumo_vendasformapgto.asString := FormaPagamentoDescricao;

      qrResumo_vendas.post;
      qrResumo_vendas.Close;
      qrvendas.close;
      qrForma_pgto.open;
      case FFormaPagamento of
        fpDinheiro: qrForma_pgto.locate('id',1);
        fpCredito:  qrForma_pgto.locate('id',3);
        fpDebito:   qrForma_pgto.locate('id',4);
        fpPix:     qrForma_pgto.locate('id',17);
      end;
       qrForma_pgto.edit;
       qrForma_pgtovalor.asCurrency:=qrForma_pgtovalor.asCurrency+total;
       qrForma_pgto.post;
       qrForma_pgto.close;
      frmComanda.StatusComanda(lkmesa, 'L', 0);
  end;

    frmComanda.lstbxmesas.Enabled := true;
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
