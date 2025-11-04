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
    imgCarga: TImage;
    FloatAnimation3: TFloatAnimation;
    imgStatusMesa: TImage;
    Image1: TImage;
    Timer1: TTimer;
    pnInfoMesa: TPanel;
    Label2: TLabel;
    editNumMesa: TEdit;
    btnInfoMesa: TButton;
    Button3: TButton;
    GlowEffect1: TGlowEffect;
    Button6: TButton;
    StyleBook1: TStyleBook;
    tmErro: TTimer;
    FloatAnimation1: TFloatAnimation;
    MultiView1: TMultiView;
    rect_conf: TRectangle;
    Label1: TLabel;
    ToolBar1: TToolBar;
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
    procedure imgCargaClick(Sender: TObject);
    procedure imgStatusMesaClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);

    procedure Button3Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure tmErroTimer(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure ListBoxItem4Click(Sender: TObject);
  private
    { Private declarations }
     fancy : TFancyDialog;
     controleCarga:boolean;
     situacaocaixa:char; //A-aberto F-fechado I-Indefinido(sem contato server
     situacaoMesa:char;
     Procedure Venda(numComanda:String);
     procedure AddMapa(comanda: string; status: string; valor_total: String);
     procedure Carga;
     procedure ThreadCargaTerminate(Sender: TObject);
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
    item.Height := 110;
    item.TagString := comanda;
    item.Selectable := false;
    item.EnableDragHighlight:=false;

    // Retangulo de fundo...
    var rect :TRectangle:= TRectangle.Create(item);
    rect.Parent := item;
    rect.name:='rect'+comanda;
    rect.Align := TAlignLayout.Client;
    rect.Margins.Top := 10;
    rect.Margins.Bottom := 10;
    rect.Margins.Left := 10;
    rect.Margins.Right := 10;
    rect.Fill.Kind := TBrushKind.Solid;
    rect.HitTest := false;

    if status = 'L' then
        rect.Fill.Color := $FF4A70F7  // azul...
    else if status = 'O' then
        rect.Fill.Color := $FFEC6E73 // vermelho...
    Else
      rect.Fill.Color := TAlphaColors.Orange; // amarelo;


    rect.XRadius := 10;
    rect.YRadius := 10;
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
    lbl.Margins.Left := 5;
    lbl.Margins.Top := 5;
    lbl.Height := 15;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor];
    lbl.FontColor := $FFFFFFFF;

    // Label valor...
    lbl := TLabel.Create(item);
    lbl.Parent := rect;
    lbl.name:='valor'+comanda;
    lbl.Align := TAlignLayout.Bottom;
    lbl.Text := valor_total; //FormatFloat('#,##0.00', valor_total);


    lbl.Margins.Right := 5;
    lbl.Margins.Bottom := 5;
    lbl.Height := 15;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor];
    lbl.FontColor := $FFFFFFFF;
    lbl.TextAlign := TTextAlign.Trailing;

    // Label comanda...
    lbl := TLabel.Create(rect);
    lbl.Parent := rect;
    lbl.Align := TAlignLayout.Client;
    lbl.Text := comanda;

    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.FontColor,
                                                TStyledSetting.Size];
    lbl.FontColor := $FFFFFFFF;
    lbl.Font.Size := 30;
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

procedure TfrmComanda.Button3Click(Sender: TObject);
begin
   lstbxmesas.Enabled:=true;
   rect_rodape.Enabled:=true;
   pnInfoMesa.Visible:=false;
end;



procedure TfrmComanda.Button6Click(Sender: TObject);
begin
 with dmlocal do
 begin
    try
    qrvendas.close;
    qrvendas.params[0].asstring:=formatFloat('00',Strtointdef(editNumMesa.text,00));
    qrvendas.open;
    if qrvendas.isempty then
    begin
       fancy.Show(TIconDialog.info,'Aviso','sem moviemento', 'OK');
       qrvendas.close;
        lstbxmesas.Enabled:=true;
       exit;
    end;
     if not assigned(frmDetalhe) then
       Application.createForm(TFrmDetalhe,frmDetalhe);
    finally
        pnInfoMesa.Visible:=false;
    end;
    frmDetalhe.lblConferencia.text:='Comanda '+formatFloat('00',Strtointdef(editNumMesa.text,00));
     frmDetalhe.show;


 end;

end;

procedure TfrmComanda.Carga;
var
    t: TThread;
    status:integer;

begin
    if controlecarga Then
       exit;
    controlecarga:=true;
    Var query:=TFDQuery.Create(nil);
    query.Connection:=dmLocal.conLocal;
    Var memCarga:=   TFDMemTable.Create(nil);
    t := TThread.CreateAnonymousThread(procedure
    begin
        try
           FloatAnimation3.Start;
            With dmLocal do
            begin
              //sabores
              memcarga.close;
              query.SQL.Text:='delete from sabores';
              query.ExecSQL;
             if TControllerComanda.Carga('sabor',memcarga)<>400 Then
             begin
                  query.SQL.Text:='Insert into sabores (id,descricao,lksetor)'+
                  ' values '+
                  '(:id,:descricao,:lksetor)';
                  memCarga.First;
                  while not memCarga.Eof do
                  begin
                    query.ParamByName('id').AsInteger:=memCarga.FieldByName('id').AsInteger;
                    query.ParamByName('descricao').AsString:=memCarga.FieldByName('descricao').AsString;
                    query.ParamByName('lksetor').AsInteger:=strtointdef( memCarga.FieldByName('lksetor').AsString,0);
                    query.ExecSQL;
                    memCarga.Next;
                  end;
                  memcarga.close;
              end;
               //produtos
              query.SQL.Text:='delete from produtos';
              query.ExecSQL;
              if TControllerComanda.Carga('produto',memcarga)<>400 then
              begin
                //memCarga.AppendData(memcarga);
                memCarga.First;

                query.SQL.Text:='Insert into produtos (codigo,produto,unidade,lkgrupo,precovenda,'+
                'precovenda1,precovenda2,precovenda3,Descvenda,Descvenda1,Descvenda2,Descvenda3,coddest,'+
                'balanca)'+
                ' values  '+
                '(:codigo,:produto,:unidade,:lkgrupo,:precovenda,'+
                ':precovenda1,:precovenda2,:precovenda3,:Descvenda,:Descvenda1,:Descvenda2,:Descvenda3,'+
                ':coddest,:balanca)';

                 while not memCarga.Eof do
                 begin
                    query.ParamByName('codigo').AsString:=memCarga.FieldByName('codigo').AsString;
                    query.ParamByName('produto').AsString:=memCarga.FieldByName('produto').AsString;
                    query.ParamByName('unidade').AsString:=memCarga.FieldByName('unidade').AsString;
                    query.ParamByName('lkgrupo').AsInteger:=memCarga.FieldByName('lksetor').AsInteger;
                    query.ParamByName('precovenda').AsCurrency:=StrtocurrDef(memCarga.FieldByName('precovenda').AsString,0);
                    query.ParamByName('precovenda1').AsCurrency:=StrtocurrDef(memCarga.FieldByName('precovenda1').AsString,0);
                    query.ParamByName('precovenda2').AsCurrency:=StrtocurrDef(memCarga.FieldByName('precovenda2').AsString,0);
                    query.ParamByName('precovenda3').AsCurrency:=StrtocurrDef(memCarga.FieldByName('precovenda3').AsString,0);
                    query.ParamByName('DescVenda').AsString:=memCarga.FieldByName('DescVenda').AsString;
                    query.ParamByName('DescVenda1').AsString:=memCarga.FieldByName('DescVenda1').AsString;
                    query.ParamByName('DescVenda2').AsString:=memCarga.FieldByName('DescVenda2').AsString;
                    query.ParamByName('DescVenda3').AsString:=memCarga.FieldByName('DescVenda3').AsString;
                    query.ParamByName('coddest').AsInteger:=strtointdef(memCarga.FieldByName('lkdest').AsString,0);
                    query.ParamByName('balanca').AsString:=memCarga.FieldByName('balanca').AsString;
                    query.ExecSQL;
                    memCarga.Next;
                  end;
                  memCarga.Close;
              End;
              //grupos
              query.SQL.Text:='delete from grupos';
              query.ExecSQL;
              If TControllerComanda.Carga('grupo',memcarga)<>400 Then
              begin
                memCarga.First;
                query.SQL.Text:='Insert into grupos (codigo,grupo) values (:codigo,:grupo)';
                while not memCarga.Eof do
                begin
                   query.ParamByName('codigo').AsInteger:=memCarga.FieldByName('controle').AsInteger;
                   query.ParamByName('grupo').AsString:=memCarga.FieldByName('setor').AsString;
                   query.ExecSQL;
                   memCarga.Next;
                end;
                memCarga.Close;
              end;
              //vendedores
              query.SQL.Text:='delete from funcionarios';
              query.ExecSQL;
              If TControllerComanda.Carga('vendedor',memcarga)<>400 Then
              begin
                  query.SQL.Text:='Insert into funcionarios (codigo,cognome,senha)'+
                  ' values '+
                  '(:codigo,:cognome,:senha)';
                  memCarga.First;
                  while not memCarga.Eof do
                  begin
                    query.ParamByName('codigo').AsInteger:=memCarga.FieldByName('codvend').AsInteger;
                    query.ParamByName('cognome').AsString:=memCarga.FieldByName('cognome').AsString;
                    query.ParamByName('senha').AsString:=memCarga.FieldByName('senha').AsString;
                    query.ExecSQL;
                    memCarga.Next;
                  end;
                  memCarga.Close;
              end;
              //grade
              query.SQL.Text:='delete from grade';
              query.ExecSQL;
              if TControllerComanda.Carga('grade',memcarga)<>400 then
              begin
                  query.SQL.Text:='Insert into grade (id,descricao)'+
                  ' values '+
                  '(:id,:descricao)';
                   memCarga.First;
                  while not memCarga.Eof do
                  begin
                    query.ParamByName('id').AsInteger:=memCarga.FieldByName('id').AsInteger;
                    query.ParamByName('descricao').AsString:=memCarga.FieldByName('descricao').AsString;
                    query.ExecSQL;
                    memCarga.Next;
                  end;
                  memcarga.close;
              end;
              qrProdutos.Close;
              qrProdutos.open;
             end;
       finally
        memCarga.Close;
        query.close;
        query.disposeof;
        memcarga.disposeof;
       end;
     end);
   t.OnTerminate := ThreadCargaTerminate;
   t.Start;


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
  controlecarga:=false;
  lstbxMesas.TagString:= ''   ;
  FloatAnimation1.Start;
  carregaMesas;
  fancy := TFancyDialog.Create(FrmComanda);
  pnInfoMesa.visible:=false;
  timer1.enabled:=false;
  tmerro.enabled:=false;
end;

procedure TfrmComanda.Image1Click(Sender: TObject);
begin
if not lstbxMesas.enabled then
   begin
      ShowMessage('Verifique Conexões');
       exit;
   end;
   lstbxmesas.Enabled:=false;
   //tbRodape.Enabled:=false;
   pnInfoMesa.Visible:=true;
   editNumMesa.Text:='';
   editNumMesa.SetFocus;
end;

procedure TfrmComanda.imgCargaClick(Sender: TObject);
begin

   carga;

end;

procedure TfrmComanda.imgStatusMesaClick(Sender: TObject);
begin
   if not Assigned(frmEncerramento) then
      Application.createform(tfrmEncerramento,frmEncerramento);
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
        rect.Fill.Color := $FF4A70F7;   // azul...
        LabelTexto.Text :='Livre';
     end
    else if situacao = 'O' then
    BEGIN
        rect.Fill.Color := $FFEC6E73; // vermelho...
        LabelTexto.Text :='Ocupada';
    END
    Else
    BEGIN
      rect.Fill.Color := TAlphaColors.Orange; // amarelo;
       LabelTexto.Text :='Parcial';
    end;

   end;
   LabelTexto:= TLabel(item.FindComponent('valor'+NumComanda));
    if Assigned(LabelTexto) then
      LabelTexto.Text := FloattoStrf(valor,ffnumber,10,2);
   {  for var i := 0 to lstbxMesas.Count-1  do
    begin
      var LabelTexto := TLabel(lstbxMesas.ItemByIndex(i).FindComponent('text'+i.ToString));
      if Assigned(LabelTexto) then
        LabelTexto.Text := 'Atualizado '
      else
         showmessage('ok');
    end;}
end;

procedure TfrmComanda.carregaMesas;
begin
 //situacao das mesas
  for var  I:integer:= 1 to 50  do

       AddMapa(formatfloat('00',i),'L',FormatFloat('#,##0.00',0));


end;



procedure TfrmComanda.ThreadCargaTerminate(Sender: TObject);
begin
   controleCarga:=false;
   FloatAnimation3.stop;
   if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

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
