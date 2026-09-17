unit ufrComanda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.MultiView, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Objects, uFancyDialog, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Ani, FMX.Effects, FMX.Edit;

type
  TfrmComanda = class(TForm)
    Layout1: TLayout;
    lstbxMesas: TListBox;
    Timer1: TTimer;
    pnInfoMesa: TPanel;
    Label2: TLabel;
    editNumMesa: TEdit;
    btnCancelarMesa: TButton;
    btnConfirmarMesa: TButton;
    btnAbrirMesa: TButton;
    btnEncerrar: TButton;
    lblLivCount: TLabel;
    lblOcupCount: TLabel;
    lblParcCount: TLabel;
    StyleBook1: TStyleBook;
    tmErro: TTimer;
    FloatAnimation1: TFloatAnimation;
    MultiView1: TMultiView;
    rect_conf: TRectangle;
    Label1: TLabel;
    ToolBar1: TToolBar;
    headerMesas: TLayout;
    lblTituloMesas: TLabel;
    lblSubtitulo: TLabel;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    MasterButton: TSpeedButton;
    rect_rodape: TRectangle;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label3: TLabel;
    ListBoxItem4: TListBoxItem;
    Image5: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstbxMesasItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnEncerrarClick(Sender: TObject);
    procedure btnAbrirMesaClick(Sender: TObject);
    procedure btnCancelarMesaClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure tmErroTimer(Sender: TObject);
    procedure btnConfirmarMesaClick(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure ListBoxItem4Click(Sender: TObject);
  private
    { Private declarations }
     fancy : TFancyDialog;

     situacaocaixa:char; //A-aberto F-fechado I-Indefinido(sem contato server
     situacaoMesa:char;
     Procedure Venda(numComanda:String);
     procedure AddMapa(comanda: string; status: string; valor_total: String);
     procedure AtualizaContadores;


     procedure ThreadStatusTerminate(Sender: TObject);



  public
    { Public declarations }
    procedure StatusComanda(numComanda,situacao:String;const valor:extended=0);
     procedure carregaMesas;
  end;

var
  frmComanda: TfrmComanda;

implementation

{$R *.fmx}

uses  udmLocal, ufrprodutos,Data.FiredacJsonReflect,
  ufrDetalhe,system.json,controller.comanda, unConfImpressora, ufrdestinoimp,
  ufrConfiguracao, ufrEncerramento, ufrcabecalho;

procedure TfrmComanda.AddMapa(comanda, status, valor_total: String);
begin
// Item da lista...

    var item :TListBoxItem:= TListBoxItem.Create(lstbxMesas);
    item.Text := '';
    item.Height := 114;
    item.TagString := comanda;
    item.Selectable := false;
    item.EnableDragHighlight:=false;

    // Retangulo de fundo...
    var rect :TRectangle:= TRectangle.Create(item);
    rect.Parent := item;
    rect.name:='rect'+comanda;
    rect.Align := TAlignLayout.Client;
    rect.Margins.Top := 8;
    rect.Margins.Bottom := 8;
    rect.Margins.Left := 8;
    rect.Margins.Right := 8;
    rect.Fill.Kind := TBrushKind.Solid;
    rect.HitTest := false;

    if status = 'L' then
        rect.Fill.Color := $FF177543  // verde (livre)
    else if status = 'O' then
        rect.Fill.Color := $FFC0392B // vermelho (ocupada)
    Else
      rect.Fill.Color := $FFA05800; // ambar (parcial);

    rect.XRadius := 12;
    rect.YRadius := 12;
    rect.Stroke.Kind := TBrushKind.None;

    // Label status...
    var lbl :TLabel:= TLabel.Create(item);
    lbl.Parent := rect;
    lbl.Align := TAlignLayout.Top;
    lbl.name:='status'+comanda;
    if status = 'L' then
        lbl.Text := 'Livre'
    else if status = 'O' then
        lbl.Text := 'Ocupada'
    Else
      lbl.Text := 'Parcial';

    lbl.TextAlign := TTextAlign.Center;
    lbl.VertTextAlign := TTextAlign.Center;
    lbl.Margins.Left := 5;
    lbl.Margins.Right := 5;
    lbl.Margins.Top := 10;
    lbl.Height := 20;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor,
                                                TStyledSetting.Size,
                                                TStyledSetting.Style];
    lbl.FontColor := $FFFFFFFF;
    lbl.Font.Size := 13;
    lbl.Font.Style := lbl.Font.Style + [TFontStyle.fsBold];

    // Label valor...
    lbl := TLabel.Create(item);
    lbl.Parent := rect;
    lbl.name:='valor'+comanda;
    lbl.Align := TAlignLayout.Bottom;
    lbl.Text := valor_total; //FormatFloat('#,##0.00', valor_total);

    lbl.Margins.Left := 5;
    lbl.Margins.Right := 5;
    lbl.Margins.Bottom := 8;
    lbl.Height := 20;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor,
                                                TStyledSetting.Size,
                                                TStyledSetting.Style];
    lbl.FontColor := $FFFFFFFF;
    lbl.Font.Size := 13;
    lbl.Font.Style := lbl.Font.Style + [TFontStyle.fsBold];
    lbl.TextAlign := TTextAlign.Trailing;
    lbl.VertTextAlign := TTextAlign.Center;

    // Label comanda...
    lbl := TLabel.Create(rect);
    lbl.Parent := rect;
    lbl.Align := TAlignLayout.Client;
    lbl.Text := comanda;
    lbl.Margins.Bottom := 4;

    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor,
                                                TStyledSetting.Size,
                                                TStyledSetting.Style];
    lbl.FontColor := $FFFFFFFF;
    lbl.Font.Size := 34;
    lbl.Font.Style := lbl.Font.Style + [TFontStyle.fsBold];
    lbl.TextAlign := TTextAlign.Center;
    lbl.VertTextAlign := TTextAlign.Center;
    lstbxMesas.AddObject(item);

    with dmLocal do
    begin
        qrvendas.close;
        qrvendas.paramByname('comanda').asString:=comanda;
        qrvendas.open;
        if not qrvendas.isempty then
        begin
        StatusComanda(comanda,'O',qrVendasSomaTotal.value) ;
        end;
        qrvendas.close;
    end;
end;

procedure TfrmComanda.btnCancelarMesaClick(Sender: TObject);
begin
   lstbxmesas.Enabled:=true;
   rect_rodape.Enabled:=true;
   pnInfoMesa.Visible:=false;
   editNumMesa.Text:='';
end;



procedure TfrmComanda.btnConfirmarMesaClick(Sender: TObject);
var
  n: Integer;
begin
  n := StrToIntDef(Trim(editNumMesa.Text), 0);
  if (n < 1) or (n > 50) then
  begin
    fancy.Show(TIconDialog.Warning, 'Aviso', 'Informe uma mesa entre 01 e 50.', 'OK');
    editNumMesa.SetFocus;
    exit;
  end;
  with dmlocal do
  begin
    try
      qrvendas.close;
      qrvendas.params[0].asstring:=formatFloat('00',n);
      qrvendas.open;
      if qrvendas.isempty then
      begin
        fancy.Show(TIconDialog.info,'Aviso','Sem movimento', 'OK');
        qrvendas.close;
        lstbxmesas.Enabled:=true;
        editNumMesa.Text:='';
        exit;
      end;
      if not assigned(frmDetalhe) then
        Application.createForm(TFrmDetalhe,frmDetalhe);
    finally
      pnInfoMesa.Visible:=false;
    end;
    frmDetalhe.lblConferencia.text:='Comanda '+formatFloat('00',n);
    frmDetalhe.nummesa:=formatFloat('00',n);
    frmDetalhe.show;
  end;
end;



procedure TfrmComanda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   fancy.DisposeOf;

   dmLocal.DisposeOf;
   Action := TCloseAction.caFree;
   frmcomanda := nil;
   frmComanda.DisposeOf;

end;

procedure TfrmComanda.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TfrmComanda.FormShow(Sender: TObject);
begin

  lstbxMesas.TagString:= ''   ;
  FloatAnimation1.Start;
  carregaMesas;
  fancy := TFancyDialog.Create(FrmComanda);
  pnInfoMesa.visible:=false;
  timer1.enabled:=false;
  tmerro.enabled:=false;
end;

procedure TfrmComanda.btnAbrirMesaClick(Sender: TObject);
begin
if not lstbxMesas.enabled then
   begin
     fancy.Show(TIconDialog.Warning, 'Aviso','Verifique Conexoes', 'OK');
       exit;
   end;
   lstbxmesas.Enabled:=false;
   //tbRodape.Enabled:=false;
   pnInfoMesa.Visible:=true;
   editNumMesa.Text:='';
   editNumMesa.SetFocus;
end;

procedure TfrmComanda.btnEncerrarClick(Sender: TObject);
begin
   if not Assigned(frmEncerramento) then
      Application.createform(tfrmEncerramento,frmEncerramento);
   dmLocal.qrVendas.open;
  If   not  dmLocal.qrVendas.isempty Then
  begin
    fancy.Show(TIconDialog.Warning, 'Aviso','Vendas Pendentes', 'OK');
    dmLocal.qrVendas.close;
    exit;
  end;
  dmLocal.qrVendas.close;
  dmLocal.qrEncerra.open;
  frmEncerramento.show;
end;

procedure TfrmComanda.ListBoxItem1Click(Sender: TObject);
begin
  if not Assigned(frmconfiguracao) then
      Application.createform(tFrmConfiguracao,frmConfiguracao);
  with frmconfiguracao do
  begin
    edt_port.text:='9000';
    edt_servidor.text:='';
    edt_identserver.text:='';

  end;
  frmconfiguracao.show;
  MultiView1.HideMaster;
end;

procedure TfrmComanda.ListBoxItem2Click(Sender: TObject);
begin
      if NOT Assigned(FrmConfImpressora) then
        Application.CreateForm(TFrmConfImpressora, FrmConfImpressora);

    FrmConfImpressora.Show;
      MultiView1.HideMaster;
end;

procedure TfrmComanda.ListBoxItem3Click(Sender: TObject);
begin
if NOT Assigned(FrmDestinoImp) then
        Application.CreateForm(TFrmDestinoImp,FrmDestinoImp);

    FrmDestinoImp.Show;
      MultiView1.HideMaster;
end;

procedure TfrmComanda.ListBoxItem4Click(Sender: TObject);
begin
  if NOT Assigned(FrmCabecalho) then
        Application.CreateForm(TFrmCabecalho,FrmCabecalho);

    FrmCabecalho.Show;
      MultiView1.HideMaster;
end;

procedure TfrmComanda.lstbxMesasItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  venda(item.TagString);
end;





procedure TfrmComanda.StatusComanda(numComanda, situacao: String;Const VAlor:Extended=0);
begin

   var item:TListBoxItem;
   item:=lstbxMesas.ListItems[numcomanda.tointeger-1];
    var LabelTexto := TLabel(item.FindComponent('status'+NumComanda));
     if not Assigned(LabelTexto) then
      LabelTexto.Text := 'indefinido';
   var rect:TRectangle:= TRectangle(item.FindComponent('rect'+NumComanda)) ;
   if Assigned(rect) then
   begin
if situacao = 'L' then
      begin
         rect.Fill.Color := $FF177543;  // verde escuro (livre)
         LabelTexto.Text :='Livre';
      end
     else if situacao = 'O' then
     BEGIN
         rect.Fill.Color := $FFC0392B; // vermelho (ocupada)
         LabelTexto.Text :='Ocupada';
     END
     Else
     BEGIN
       rect.Fill.Color := $FFA05800; // ambar escuro (parcial)
        LabelTexto.Text :='Parcial';
     end;

   end;
   LabelTexto:= TLabel(item.FindComponent('valor'+NumComanda));
     if Assigned(LabelTexto) then
       LabelTexto.Text := FloattoStrf(valor,ffnumber,10,2);
   AtualizaContadores;
end;

procedure TfrmComanda.carregaMesas;
begin
 //situacao das mesas
  for var  I:integer:= 1 to 50  do

       AddMapa(formatfloat('00',i),'L',FormatFloat('#,##0.00',0));

  AtualizaContadores;
end;

procedure TfrmComanda.AtualizaContadores;
var
  i: Integer;
  lbl: TLabel;
  Livre, Ocupada, Parcial: Integer;
begin
  Livre := 0;
  Ocupada := 0;
  Parcial := 0;
  for i := 0 to lstbxMesas.Count - 1 do
  begin
    lbl := TLabel(lstbxMesas.ItemByIndex(i).FindComponent('status' +
      lstbxMesas.ItemByIndex(i).TagString));
    if Assigned(lbl) then
    begin
      if lbl.Text = 'Livre' then
        Inc(Livre)
      else if lbl.Text = 'Ocupada' then
        Inc(Ocupada)
      else
        Inc(Parcial);
    end;
  end;
  lblLivCount.Text := Livre.ToString;
  lblOcupCount.Text := Ocupada.ToString;
  lblParcCount.Text := Parcial.ToString;
end;


procedure TfrmComanda.ThreadStatusTerminate(Sender: TObject);
begin
   lstbxMesas.TagString:='';
end;

procedure TfrmComanda.tmErroTimer(Sender: TObject);
begin
   lstbxMesas.onItemClick:=lstbxMesasItemClick;
   tmerro.Enabled:=false;
end;

procedure TfrmComanda.Venda(numComanda: String);
begin
 
   if not lstbxMesas.enabled then
   begin
      ShowMessage('Verifique Conexões');
       exit;
   end;
   if numcomanda=emptystr then
   begin
      fancy.Show(TIconDialog.info,'Aviso','Nenhuma mesa selecionada', 'OK');
      abort;
   end;
 
   dmLocal.qrProdutos.filter:='';
   dmLocal.qrProdutos.Open();
   if dmLocal.qrProdutos.isEmpty Then
   begin
       fancy.Show(TIconDialog.Info,'Aviso','Sem movimentacao de produtos', 'OK');
       exit;
   end;
   dmlocal.memPedido.Close;

   If not assigned(frmProdutos) then
       Application.CreateForm(TfrmProdutos,frmProdutos);

   frmProdutos.nummesa:=numcomanda;
   frmProdutos.lblComanda.text:='comanda '+numcomanda;
   frmProdutos.show;


end;

end.
