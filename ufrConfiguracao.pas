unit ufrConfiguracao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.TabControl,uFancyDialog,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmConfiguracao = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    Layout1: TLayout;
    rect_login: TRectangle;
    Label3: TLabel;
    laBtnConfiguracao: TLayout;
    Image3: TImage;
    rect_conf: TRectangle;
    Label1: TLabel;
    rect_imp: TRectangle;
    Label2: TLabel;
    rect_destImpressao: TRectangle;
    Label6: TLabel;
    edt_usuario: TEdit;
    TabConfig: TTabItem;
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    btnVoltar: TButton;
    Layout2: TLayout;
    Label4: TLabel;
    edt_servidor: TEdit;
    lblPorta: TLabel;
    rect_save_config: TRectangle;
    Label5: TLabel;
    edt_port: TEdit;
    lblIdentServer: TLabel;
    edt_IdentServer: TEdit;
    rect_carga: TRectangle;
    Label7: TLabel;
    procedure rect_save_configClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rect_cargaClick(Sender: TObject);
  private
    { Private declarations }
     fancy : TFancyDialog;
     controleCarga:boolean;
    procedure ThreadCargaTerminate(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmConfiguracao: TfrmConfiguracao;

implementation

{$R *.fmx}

uses udmLocal,controller.comanda,uloading;

procedure TfrmConfiguracao.btnVoltarClick(Sender: TObject);
begin
   close;
end;

procedure TfrmConfiguracao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := TCloseAction.caFree;
    frmConfiguracao := nil;
    frmConfiguracao.DisposeOf;
    fancy.DisposeOf;
end;

procedure TfrmConfiguracao.FormCreate(Sender: TObject);
begin
   fancy := TFancyDialog.Create(FrmConfiguracao);
end;

procedure TfrmConfiguracao.FormShow(Sender: TObject);
var
  tmpDataset:TDataset;
begin
  try
      dmLocal.conLocal.ExecSQL('Select ip,porta,autorizado,identificacao from config',tmpDataset);

      edt_servidor.text:=trim(tmpDataset.FieldByName('ip').AsString);
      edt_port.text:=tmpDataset.FieldByName('porta').AsString;
      edt_IdentServer.text:=tmpDataset.FieldByName('identificacao').AsString;

  finally
    FreeAndNil(tmpDataset);
  end;
end;


procedure TfrmConfiguracao.ThreadCargaTerminate(Sender: TObject);
begin
   controleCarga:=false;
    TLoading.Hide;
   if Sender is TThread then
    begin
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
    end;

end;

procedure TfrmConfiguracao.rect_cargaClick(Sender: TObject);
  var
    t: TThread;
    status:integer;

begin
    config.Ip:='187.19.165.178';
    config.porta:=edt_port.text;
    config.url:='http://'+config.Ip+':'+edt_port.text;
    config.ident:=edt_IdentServer.text; ;
  if  TControllerComanda.verificapath(trim(edt_IdentServer.text))<>200 then
  begin
      fancy.Show(TIconDialog.Warning, 'Aviso','identificação server invalida', 'OK');
        exit;
  end;

    if controlecarga Then
       exit;
    controlecarga:=true;
    Var query:=TFDQuery.Create(nil);
    query.Connection:=dmLocal.conLocal;
    Var memCarga:=   TFDMemTable.Create(nil);
     TLoading.Show(FrmConfiguracao, 'Atualizando...');
    t := TThread.CreateAnonymousThread(procedure
    begin
        try
          // TThread.Synchronize(TThread.CurrentThread, procedure

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

procedure TfrmConfiguracao.rect_save_configClick(Sender: TObject);
begin
   if edt_servidor.Text = '' then
    begin

        fancy.Show(TIconDialog.Warning, 'Aviso','Informe o servidor', 'OK');
        exit;
    end;

    dmLocal.conLocal.ExecSQL('delete from config');

    dmLocal.conLocal.ExecSQL('insert into config (ip,porta,identificacao) '+
    ' values '+
    '(:ip,:porta,:identificacao)',
    [
     edt_servidor.Text,
     edt_port.text,
     edt_IdentServer.text
    ]
    );

    config.Ip:='187.19.165.178';
    config.porta:=edt_port.text;
    config.url:='http://'+config.Ip+':'+config.porta;
    config.ident:=edt_IdentServer.text; ;
    //fancy.Show(TIconDialog.Warning, 'Aviso','Salvo com Sucesso', 'OK');
    close;
end;

end.
