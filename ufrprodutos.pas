unit ufrprodutos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Edit, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope,data.db, FMX.Ani,FMX.Platform, FMX.VirtualKeyboard,
  FMX.TabControl, FMX.Effects, FMX.ListBox,Data.FiredacJsonReflect,uFancyDialog,  FMX.SearchBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.MultiView, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmProdutos = class(TForm)
    tabPrincipal: TTabControl;
    tabPedido: TTabItem;
    tabFinalizar: TTabItem;
    rectHeader: TRectangle;
    lblComanda: TLabel;
    img_voltar: TImage;
    Image1: TImage;
    lblQuant: TLabel;
    layTabProdutos: TLayout;
    lstVProdutos: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    rectTabelaPreco: TRectangle;
    lstbxTabPrecos: TListBox;
    lstbxDescItem: TListBoxItem;
    lstbxPreco1: TListBoxItem;
    lstbxPreco2: TListBoxItem;
    lstbxPreco3: TListBoxItem;
    lstbxPreco4: TListBoxItem;
    lstbxFinalizar: TListBoxItem;
    rdbPreco1: TRadioButton;
    rdbPreco2: TRadioButton;
    rdbPreco3: TRadioButton;
    rdbPreco4: TRadioButton;
    lstbxObservacao: TListBoxItem;
    edtObservacao: TEdit;
    Button1: TButton;
    SpeedButton1: TSpeedButton;
    BindSourceDB2: TBindSourceDB;
    lstvPedido: TListView;
    Button2: TButton;
    LinkListControlToField2: TLinkListControlToField;
    ToolBar1: TToolBar;
    Label1: TLabel;
    lstvSabor: TListView;
    BindSourceDB3: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    rectObs: TRectangle;
    edtobsitem: TEdit;
    Button3: TButton;
    spbAdicionarItem: TSpeedButton;
    spbDiminuirItem: TSpeedButton;
    lblDescricao: TLabel;
    rectObs1: TRectangle;
    StyleBook1: TStyleBook;
    recPeso: TRectangle;
    lstbxPeso: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    edtPeso: TEdit;
    ListBoxItem7: TListBoxItem;
    btnConfirmaPeso: TSpeedButton;
    MultiView1: TMultiView;
    ListBox1: TListBox;
    MasterButton: TSpeedButton;
    BindSourceDB4: TBindSourceDB;
    LinkListControlToField4: TLinkListControlToField;
    procedure img_voltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstVProdutosButtonClick(const Sender: TObject;
      const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure SpeedButton1Click(Sender: TObject);
    procedure rdbPreco1Click(Sender: TObject);
    procedure rdbPreco2Click(Sender: TObject);
    procedure rdbPreco3Click(Sender: TObject);
    procedure rdbPreco4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstvPedidoButtonClick(const Sender: TObject;
      const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure Button3Click(Sender: TObject);
    procedure spbAdicionarItemClick(Sender: TObject);
    procedure spbDiminuirItemClick(Sender: TObject);
    procedure tabPrincipalChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnConfirmaPesoClick(Sender: TObject);
    procedure MultiView1Hidden(Sender: TObject);
    procedure MultiView1Shown(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
     precoUnit:Extended;
     DescResumida:String;

      fancy : TFancyDialog;
     procedure compoe_TabelaPreco(indice:smallint);
     procedure compoe_pedido(tabela:string;const quant:extended=1);
  public
    { Public declarations }
    numMesa:String;
  end;

var
  frmProdutos: TfrmProdutos;

implementation

{$R *.fmx}

uses udmLocal, ufrSabor,  ufrComanda,acbrposprinter;


procedure TfrmProdutos.btnConfirmaPesoClick(Sender: TObject);
begin
   recPeso.visible:=false;
   if trim(edtPeso.text)=emptyStr then
        edtPeso.text:='1000';
   compoe_pedido('1',StrtoFloatDef(edtpeso.text,1000)/1000);

end;

procedure TfrmProdutos.Button1Click(Sender: TObject);
begin
       //if not Assigned(frSabor) then
        Application.CreateForm(TFrSabor,frSabor);
       frSAbor.show;
end;

procedure TfrmProdutos.Button2Click(Sender: TObject);
 var numcomanda:string;
 var vendedor:string;
begin

     var qry:TFDQuery;
      qry:=TfDquery.Create(nil);
       var Memo:=TStringList.Create;
      try
          qry.Connection:=dmLocal.conLocal;
          qry.sql.text:='insert into vendas (lkprod,qtde,vrunit,lkmesa,produto,observacao,total)  '+
          '                values '+
          '(:lkprod,:qtde,:vrunit,:lkmesa,:produto,:observacao,:total) ' ;
        //  objped.AddPair('nummesa',numMesa);
          //objped.AddPair('codigovendedor',TJSONNumber.create(StrToInt(udmlocal.CodigoVendedor)));

          dmLocal.memPedido.First;
         numcomanda:=dmlocal.memPedidolkmesa.asString;

          while not dmlocal.memPedido.eof do
          begin
              qry.parambyname('lkprod').asstring:=dmlocal.memPedidolkprod.asString;
              qry.parambyname('qtde').asExtended:= dmlocal.memPedidoqtde.Asextended;
              qry.parambyname('vrunit').ascurrency:=dmlocal.memPedidovrunit.asCurrency;
              qry.parambyname('lkmesa').asstring:=dmlocal.memPedidolkmesa.asString;
              qry.parambyname('produto').asString:=dmlocal.memPedidoproduto.asString;
              qry.parambyname('observacao').asString:=dmlocal.memPedidoobservacao.asString;
              qry.parambyname('total').ascurrency:=dmlocal.memPedidoqtde.Asextended*dmlocal.memPedidovrunit.ascurrency;
              qry.ExecSQL;

              dmlocal.memPedido.next;
          end;
          dmLocal.qrVendas.close;
         dmLocal.qrVendas.ParamByName('comanda').asString:=numcomanda;
         dmLocal.qrVendas.open;
         frmComanda.StatusComanda(numcomanda,'O',dmLocal.qrVendasSomaTotal.value) ;
         //bloco de impressao direcionada
          qry.open('select codigo,cognome from funcionarios where codigo='+quotedstr(udmLocal.CodigoVEndedor));
          if not qry.isempty then
             vendedor:=qry.fieldbyname('cognome').AsString
          else
             vendedor:='indefinido';
          qry.close;
         with dmlocal do
         begin
             memPedido.IndexFieldNames:='lkgupo';
             qrcabecalho.open;
             qrGrupos.open;
             qrImpressora.open;
             qrgrupos.first;
             while not qrgrupos.eof do
             begin
                 if (trim(qrGruposlocal.asstring)=emptystr)   or
                (not mempedido.locate('lkgrupo',qrGruposcodigo.asinteger))   then
                 begin
                    qrgrupos.next;
                    continue;
                 end;
                  //configuracao da impressora direcionada
                 qrimpressora.locate('local',qrGruposlocal.asString);

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
                 Memo.Add('');
                 Memo.add('COMANDA:'+numcomanda);
                 Memo.add('HORA PEDIDO:'+FormatDateTime('HH":"MM',TIME));
                 Memo.add('ATENDENTE:'+VENDEDOR);
                 Memo.Add('');
                 while (not memPedido.eof) and (memPedido.FieldByName('lkgrupo').AsInteger=qrgruposcodigo.asinteger) do
                 begin
                    Memo.Add(FloattoStrf( mempedido.FieldByName('qtde').asFloat,ffnumber,7,3)+ ' X ');
                    Memo.Add(Copy(mempedido.FieldByName('produto').asString + ' ' + mempedido.FieldByName('Descresumida').AsString, 1, 24));
                    if Length(mempedido.FieldByName('produto').asString+ ' ' + mempedido.FieldByName('Descresumida').AsString)>24 then
                       Memo.Add(Copy(mempedido.FieldByName('produto').asString + ' ' + mempedido.FieldByName('Descresumida').AsString, 25, 24));
                    if Length(mempedido.FieldByName('produto').asString+ ' ' + mempedido.FieldByName('Descresumida').AsString)>49 then
                       Memo.Add(Copy(mempedido.FieldByName('produto').asString + ' ' + mempedido.FieldByName('Descresumida').AsString, 50, 24));
                    if  mempedido.FieldByName('observacao').AsString<>emptystr then
                          Memo.Add('obs:'+mempedido.FieldByName('observacao').asString);
                   mempedido.next;
                end;
                  Memo.add('</lf>');
                  Memo.add('</pular_linhas>');
                  Memo.Add('</fn>');
                   Memo.Add('</corte_total>');
                  // Memo.Add('</beep>');

               // if qry.FieldByName('corta_papel').AsString='S' Then
                 //  Memo.Add('</corte_parcial>');
                ACBrPosPrinter1.Imprimir(memo.text);
                qrgrupos.next;

             end;
         end;
      finally
          qry.DisposeOf;
          dmLocal.memPedido.IndexFieldNames:='';
          dmLocal.mempedido.close;
          dmLocal.qrVendas.close;
          dmLocal.qrGrupos.close;
          dmLocal.qrImpressora.close;
          dmLocal.qrcabecalho.close;
          memo.DisposeOf;
         close;
      end;

end;


procedure TfrmProdutos.Button3Click(Sender: TObject);
begin
  dmLocal.memPedido.Edit;
  dmLocal.memPedidoobservacao.asString:=edtobsitem.text;
  dmLocal.memPedido.post;
  edtobsitem.text:='';
  rectobs1.Visible:=false;

end;

procedure TfrmProdutos.compoe_pedido(tabela:String;const quant:extended=1);
begin
   with dmLocal do
   begin
      If not dmLocal.memPedido.Active Then
       dmLocal.memPedido.Open;

      if memPedido.locate('lkprod;vrunit',
      vararrayof([qrProdutoscodigo.asString,precounit]),[]) and
      (dmLocal.qrProdutosprecovenda1.AsCurrency=0) Then
      begin
         if memPedidovrunit.asCurrency=precounit then
         begin
             memPedido.edit;
             memPedidoqtde.AsExtended:= memPedidoqtde.AsExtended+1;
             memPedido.post;
             lblQuant.text:= IntToStr(lblQuant.text.ToInteger+1);
             exit;
         end;
      end;

      memPedido.Insert;
      memPedidolkprod.AsString:=dmLocal.qrProdutoscodigo.AsString;
      memPedidoTipoTabela.AsString:=tabela;
      memPedidoqtde.AsExtended:=quant;
      memPedidovrunit.AsCurrency:=precounit;
      memPedidolkmesa.AsString:=numMesa;
      memPedidoproduto.AsString:=copy(dmLocal.qrProdutosproduto.AsString,1,25);
      if dmLocal.qrProdutosdescvenda.AsString<>emptyStr then
      memPedidoproduto.AsString:=dmLocal.qrProdutosproduto.AsString+' '+
      descresumida;
      memPedidocodDest.AsInteger:=dmLocal.qrProdutosCodDest.asInteger;
      memPedidoItem.AsInteger:=memPedido.RecordCount+1;
      lblQuant.text:= IntToStr(lblQuant.text.ToInteger+1);
      memPedidovrunit1.AsCurrency:= dmLocal.qrProdutosprecovenda1.asCurrency;
      memPedidolkgrupo.AsInteger:=dmLocal.qrProdutoslkGrupo.AsInteger;
      memPedidoTotal.AsCurrency:=memPedidovrunit.AsCurrency*memPedidoqtde.AsFloat;
      memPedidoobservacao.asString:=edtObservacao.text;
      mempedido.post;
   end;
end;

procedure TfrmProdutos.compoe_TabelaPreco(indice: smallint);
begin
   case  indice of
   0 : begin
         precoUnit:=dmLocal.qrProdutos.fieldByname('precovenda').asCurrency;
         DescResumida:=dmLocal.qrProdutos.fieldbyname('descvenda').AsString;
       end;
   1 : begin

         precoUnit:=dmLocal.qrProdutos.fieldByname('precovenda'+IntToStr(indice)).asCurrency;
         DescResumida:=dmLocal.qrProdutos.fieldbyname('descvenda'+IntToStr(indice)).AsString;

       end;
  2 : begin

         precoUnit:=dmLocal.qrProdutos.fieldByname('precovenda'+IntToStr(indice)).asCurrency;
         DescResumida:=dmLocal.qrProdutos.fieldbyname('descvenda'+IntToStr(indice)).AsString;

       end;
  3 : begin
         precoUnit:=dmLocal.qrProdutos.fieldByname('precovenda'+IntToStr(indice)).asCurrency;
         DescResumida:=dmLocal.qrProdutos.fieldbyname('descvenda'+IntToStr(indice)).AsString;
       end;
   end;
  

end;

procedure TfrmProdutos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    frmProdutos:=nil;
    fancy.DisposeOf;
    dmLocal.memPedido.close;
    dmLocal.memsabor.close;
    dmLocal.qrProdutos.close;
    lblQuant.text:='0';
end;

procedure TfrmProdutos.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TfrmProdutos.FormShow(Sender: TObject);
begin
  lblQuant.text:='0';
  if dmLocal.memPedido.active then
    lblQuant.text:=dmLocal.memPedido.RecordCount.ToString;
  rectTabelaPreco.Visible:=false;
  recPeso.Visible:=false;
  tabPrincipal.ActiveTab:=tabPedido;
  fancy := TFancyDialog.Create(FrmProdutos);
  for var I := 0 to Lstvprodutos.Controls.Count-1 do
    if Lstvprodutos.Controls[I] is TSearchBox then
    begin
      TSearchBox(Lstvprodutos.Controls[I]).Text := '';
      break;
    end;

end;

procedure TfrmProdutos.Image1Click(Sender: TObject);
begin
  if rectTabelaPreco.Visible then
  begin
     fancy.Show(TIconDialog.Info, 'Aviso','Finalize seleção de item', 'OK');
     exit;
  end;
  if dmLocal.memPedido.isempty then
  begin
     fancy.Show(TIconDialog.Info, 'Aviso','Carrinho vazio', 'OK');
     exit;
  end;



  Tabprincipal.ActiveTab:=tabFinalizar;
end;

procedure TfrmProdutos.img_voltarClick(Sender: TObject);
begin

   rectObs1.Visible:=false;
   edtobsitem.text:='';

   if tabPrincipal.ActiveTab=tabFinalizar then
   begin
      tabPrincipal.ActiveTab:=tabPedido;
   end
   Else
   begin
     frmComanda.lstbxMesas.onItemClick:=nil;
     dmlocal.mempedido.close;
     dmLocal.qrProdutos.close;
     frmProdutos.close;
     frmComanda.tmerro.Enabled:=true;
   end;


end;


procedure TfrmProdutos.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    dmLocal.qrGrupos.Locate('grupo',item.Text);
    dmLocal.qrProdutos.Filter:='lkgrupo='+dmLocal.qrGruposcodigo.AsString;
    MultiView1.HideMaster;
end;

procedure TfrmProdutos.lstvPedidoButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
   rectObs1.visible:=true;
   edtobsitem.text:=dmLocal.memPedidoobservacao.asString;
   lblDescricao.text:=Copy(dmLocal.memPedidoProduto.asString,1,20);
   edtobsitem.setfocus;
end;

procedure TfrmProdutos.lstVProdutosButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);
begin

  if (dmLocal.qrProdutosbalanca.asString='S') then
  begin
      recPeso.Visible:=true;
      lstbxPeso.ListItems[0].text:=dmLocal.qrProdutosproduto.asString;
      precounit:=dmLocal.qrProdutosprecovenda.asCurrency;
      edtpeso.text:='';
      edtPeso.SetFocus;
      Exit;
  end;

   if (dmLocal.qrProdutosprecovenda1.AsCurrency<>0) then
   begin
       rectTabelaPreco.Visible:= true;
       rdbPreco1.isChecked:=true;
       edtObservacao.text:='';
       descresumida:=dmLocal.qrProdutosdescvenda.asString;
       precounit:=dmLocal.qrProdutosprecovenda.asCurrency;

       rdbPreco1.text:=FloatToStrf(dmLocal.qrProdutosprecovenda.asCurrency,ffcurrency,12,2)+
                                  '  '+dmLocal.qrProdutosdescvenda.asString   ;
       rdbPreco2.text:=FloatToStrf(dmLocal.qrProdutosprecovenda1.asCurrency,ffcurrency,12,2)+
                                         '  '+dmLocal.qrProdutosdescvenda1.asString   ;
       rdbPreco3.text:=FloatToStrf(dmLocal.qrProdutosprecovenda2.asCurrency,ffcurrency,12,2)+
                                         '  '+dmLocal.qrProdutosdescvenda2.asString   ;
       rdbPreco4.text:=FloatToStrf(dmLocal.qrProdutosprecovenda3.asCurrency,ffcurrency,12,2)+
                                         '  '+dmLocal.qrProdutosdescvenda3.asString   ;
       lstbxTabPrecos.ListItems[0].text:=dmLocal.qrProdutosproduto.asString;


    end
   else
   begin
   with dmLocal do
     Begin
         precoUnit:=dmLocal.qrProdutosprecovenda.asCurrency;
         edtObservacao.text:='';
         descresumida:=dmLocal.qrProdutosdescvenda.asString;
         compoe_pedido('1');

     End;
   end;
end;

procedure TfrmProdutos.MultiView1Hidden(Sender: TObject);
begin
  dmLocal.qrGrupos.Close;
end;

procedure TfrmProdutos.MultiView1Shown(Sender: TObject);
begin
  dmLocal.qrGrupos.Open();
end;

procedure TfrmProdutos.rdbPreco1Click(Sender: TObject);
begin
  compoe_TabelaPreco(0);
end;

procedure TfrmProdutos.rdbPreco2Click(Sender: TObject);
begin
  compoe_TabelaPreco(1);
end;

procedure TfrmProdutos.rdbPreco3Click(Sender: TObject);
begin
  compoe_TabelaPreco(2);
end;

procedure TfrmProdutos.rdbPreco4Click(Sender: TObject);
begin
  compoe_TabelaPreco(3);
end;

procedure TfrmProdutos.spbAdicionarItemClick(Sender: TObject);
begin
     dmlocal.memPedido.edit;
     dmlocal.memPedidoqtde.ascurrency:=
     dmlocal.memPedidoqtde.ascurrency+1;
     lblQuant.text:= IntToStr(lblQuant.text.ToInteger+1);
     dmlocal.memPedido.post;


end;

procedure TfrmProdutos.spbDiminuirItemClick(Sender: TObject);
begin
//    if dmlocal.memPedidoqtde.asCurrency>1 then
    begin
       dmlocal.memPedido.edit;
       dmlocal.memPedidoqtde.ascurrency:=
       dmlocal.memPedidoqtde.ascurrency-1;
       dmlocal.memPedido.post;
       lblQuant.text:= IntToStr(lblQuant.text.ToInteger-1);
       if dmlocal.memPedidoqtde.ascurrency<=0 Then
       begin
        with dmLocal do
        begin
          if memSAbor.active then
          begin
            memsabor.first;
            while not memsabor.eof do
              memsabor.delete;
          end;
          mempedido.Delete;
        end;

        rectobs1.Visible:=false;
       end;


    end;
end;

procedure TfrmProdutos.SpeedButton1Click(Sender: TObject);
begin
    if precounit<=0 then
    begin
      fancy.Show(TIconDialog.Info, 'Aviso','Sem informação de preço', 'OK');
      exit;
    end;
    rectTabelaPreco.Visible:=false;
    if rdbPreco1.IsChecked then
       compoe_pedido('1')
    else if rdbPreco2.IsChecked then
       compoe_pedido('2')
    else if rdbPreco3.IsChecked then
       compoe_pedido('3')
    else
       compoe_pedido('4');
    //insercao de dados sabor
    if assigned(frSAbor) then
    begin
       with frsabor do
       begin

          var nrec:=dmLocal.mempedido.RecordCount;
          if not dmLocal.memsabor.active then
             dmLocal.memsabor.open;
          for var I:byte in ListView1.Items.CheckedIndexes(True) do
          begin
             dmLocal.memsabor.append;
             dmLocal.memsaborcodigo.asString:= dmLocal.qrProdutoscodigo.AsString;
             dmLocal.memSAborlkmesa.asString:= nummesa;
             dmLocal.memSaborDescricao.asString:= ListView1.Items[i].text;
             dmLocal.memSaboritem.asInteger:=nrec;  //sincronizar com os pedidos
             dmLocal.memSabor.post;

          end;
          ListView1.Items.Clear;

       end;
       frSAbor:=nil;
       frSAbor.DisposeOf;
    end;


end;

procedure TfrmProdutos.tabPrincipalChange(Sender: TObject);
begin
   if tabPrincipal.ActiveTab=tabFinalizar then
     rectObs1.Visible:=false;
end;

end.
