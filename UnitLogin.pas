unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.TabControl,
  Rest.Types,data.db, FMX.Ani, FMX.Effects,uFancyDialog, System.Actions,
  FMX.ActnList,idTCPClient ,    idglobal,system.JSON,system.IOUtils;

type
  TFrmLogin = class(TForm)
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    Layout1: TLayout;
    edt_usuario: TEdit;
    rect_login: TRectangle;
    Label3: TLabel;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabConfig: TTabItem;
    Layout2: TLayout;
    Label4: TLabel;
    edt_servidor: TEdit;
    rect_save_config: TRectangle;
    Label5: TLabel;
    laBtnConfiguracao: TLayout;
    Image3: TImage;
    ShadowEffect4: TShadowEffect;
    Label32: TLabel;
    FloatAnimation4: TFloatAnimation;
    edt_port: TEdit;
    lblPorta: TLabel;
    rect_testar_print: TRectangle;
    Label1: TLabel;
    edt_autorizacao: TEdit;
    Label2: TLabel;
    btnVoltar: TButton;
    rect_sobre_apk: TRectangle;
    Label6: TLabel;
    AniIndicator1: TAniIndicator;
    rect_Atualizacao_apk: TRectangle;
    Label7: TLabel;
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rect_save_configClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure laBtnConfiguracaoClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure rect_testar_printClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rect_Atualizacao_apkClick(Sender: TObject);
    procedure rect_sobre_apkClick(Sender: TObject);
  private
    { Private declarations }
    fancy : TFancyDialog;
    function Verifica_Server: boolean;
  function BaixarAPK(
    const AURL, AToken, ANomeArquivo: string;
    out ACaminhoArquivo: string;
    out AErro: string
  ): Boolean;
  function ObterVersaoAplicativo(
    out AVersao: string;
    out ABuild: Integer
  ): Boolean;
  procedure InstalarAPK(const ACaminhoAPK: string);
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;
implementation

{$R *.fmx}

uses udmLocal,configvo,NetworkState, ufrComanda,controller.comanda,system.DateUtils,
System.Net.URLClient,
System.Net.HttpClient,
System.Net.HttpClientComponent,
System.NetEncoding,
System.Threading,
Androidapi.Helpers,
Androidapi.JNI.JavaTypes,
Androidapi.JNI.GraphicsContentViewText,
Androidapi.JNI.Net,
Androidapi.JNI.App;


procedure TFrmLogin.btnVoltarClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0, TTabTransition.Slide);
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin

 action:=TCloseAction.cafree;
end;

procedure TFrmLogin.FormDestroy(Sender: TObject);
begin
   frmlogin:=nil;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
var
  tmpDataset:TDataset;
begin
    tmpDataset:=nil;
     btnVoltar.Visible:=false;
    try
      dmLocal.conLocal.ExecSQL('Select ip,porta,autorizado from config',tmpDataset);
      Config:=TConfigvo.create;
      config.Ip:=tmpDataset.FieldByName('ip').AsString;
      config.Porta:=tmpDataset.FieldByName('porta').AsString;
      config.url:='http://'+config.Ip+':'+config.porta+'/comanda';
      config.autorizado:=tmpDataset.FieldByName('autorizado').AsString;
      if (config.ip<>emptyStr) and (config.autorizado='S')  then
      begin
          TabControl.ActiveTab := TabLogin;
          edt_servidor.Text := tmpDataset.FieldByName('ip').AsString;
          edt_port.text:=tmpDataset.FieldByName('porta').AsString;
      end
      else
      begin
          lbl_titulo.Text := 'Configura��es';
          TabControl.ActiveTab := TabConfig;
          edt_port.text:='9000';
      end;
       fancy := TFancyDialog.Create(FrmLogin);
  finally
    FreeAndNil(tmpDataset);
  end;
end;

procedure TFrmLogin.laBtnConfiguracaoClick(Sender: TObject);
begin
 TabControl.GotoVisibleTab(1, TTabTransition.Slide);
    lbl_titulo.Text := 'Configura��es';
end;

function TFrmLogin.Verifica_Server: boolean;
begin
result:=false;
try
//ClientModule1.DSRestConnection1.TestConnection();
result:=true;

except
result:=false;

end;
end;

 function TFrmLogin.BaixarAPK(
  const AURL, AToken, ANomeArquivo: string;
  out ACaminhoArquivo: string;
  out AErro: string
): Boolean;
var
  HTTP: THTTPClient;
  Resp: IHTTPResponse;
  StreamAPK: TFileStream;
begin
  Result := False;
  ACaminhoArquivo := '';
  AErro := '';
  HTTP := nil;

  try
    HTTP := THTTPClient.Create;

    HTTP.CustomHeaders['Authorization'] :=
      'Bearer ' + AToken;

    HTTP.ConnectionTimeout := 10000;
    HTTP.ResponseTimeout := 60000;

    ACaminhoArquivo :=
      TPath.Combine(
        TPath.GetDocumentsPath,
        ANomeArquivo
      );

    StreamAPK :=
      TFileStream.Create(
        ACaminhoArquivo,
        fmCreate
      );

    try
      Resp := HTTP.Get(
        AURL,
        StreamAPK
      );

      if Resp.StatusCode <> 200 then
      begin
        AErro :=
          'Não foi possível baixar o aplicativo.' +
          sLineBreak +
          'HTTP: ' +
          Resp.StatusCode.ToString;

        Exit;
      end;

      if StreamAPK.Size = 0 then
      begin
        AErro :=
          'O servidor retornou um arquivo vazio.';

        Exit;
      end;

      Result := True;

    finally
      StreamAPK.Free;
    end;

  except
    on E: Exception do
      AErro := E.Message;
  end;

  HTTP.Free;

  if (not Result) and
     (ACaminhoArquivo <> '') then
  begin
    DeleteFile(ACaminhoArquivo);
    ACaminhoArquivo := '';
  end;
end;


function TFrmLogin.ObterVersaoAplicativo(
  out AVersao: string;
  out ABuild: Integer
): Boolean;
var
  PackageManager: JPackageManager;
  PackageInfo: JPackageInfo;
begin
  Result := False;
  AVersao := '';
  ABuild := 0;

{$IFDEF ANDROID}
  try
    PackageManager :=
      TAndroidHelper.Context.getPackageManager;

    PackageInfo :=
      PackageManager.getPackageInfo(
        TAndroidHelper.Context.getPackageName,
        0
      );

    AVersao :=
      JStringToString(PackageInfo.versionName);

    ABuild :=
      PackageInfo.versionCode;

    Result := True;

  except
    on E: Exception do
    begin
      AVersao := '';
      ABuild := 0;
      Result := False;
    end;
  end;
{$ENDIF}
end;

procedure TFrmLogin.InstalarAPK(const ACaminhoAPK: string);
var
  Intent: JIntent;
  ArquivoAPK: JFile;
  UriAPK: JNet_Uri;
begin
{$IFDEF ANDROID}
  try
    if not TFile.Exists(ACaminhoAPK) then
    begin
      fancy.Show(
        TIconDialog.Error,
        'Atualização',
        'O arquivo APK não foi encontrado.',
        'OK'
      );
      Exit;
    end;

    ArquivoAPK :=
      TJFile.JavaClass.init(
        StringToJString(ACaminhoAPK)
      );

    UriAPK :=
      TAndroidHelper.JFileToJURI(ArquivoAPK);

    Intent :=
      TJIntent.JavaClass.init(
        TJIntent.JavaClass.ACTION_VIEW
      );

    Intent.setDataAndType(
      UriAPK,
      StringToJString(
        'application/vnd.android.package-archive'
      )
    );

    Intent.addFlags(
      TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION
    );

    Intent.addFlags(
      TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK
    );

    TAndroidHelper.Activity.startActivity(Intent);

  except
    on E: Exception do
    begin
      fancy.Show(
        TIconDialog.Error,
        'Atualização',
        'Não foi possível iniciar a instalação.' +
        sLineBreak + sLineBreak +
        E.Message,
        'OK'
      );
    end;
  end;
{$ENDIF}
end;

procedure TFrmLogin.rect_Atualizacao_apkClick(Sender: TObject);
const
  URL_ATUALIZACAO = 'http://187.19.165.178:9001';
  TOKEN = '123';
var
  URLDownload: string;
begin
  // Impede dois downloads simultâneos
  rect_atualizacao_apk.Enabled := False;

  // Mostra o indicador e inicia a animação
  AniIndicator1.Visible := True;
  AniIndicator1.Enabled := True;

  // Monta a URL do download
  URLDownload :=
    URL_ATUALIZACAO +
    '/download?path=atualizacao&nome=' +
    TNetEncoding.URL.Encode('comanda.apk');

  // Toda a comunicação com o servidor é executada em background.
  TTask.Run(
    procedure
    var
      HTTP: THTTPClient;
      Resp: IHTTPResponse;
      JSON: TJSONObject;
      VersaoServidor: string;
      BuildServidor: Integer;
      Obrigatoria: Boolean;
      VersaoAtual: string;
      BuildAtual: Integer;
      CaminhoAPK: string;
      ErroDownload: string;
      Sucesso: Boolean;
    begin
      HTTP := nil;
      JSON := nil;
      CaminhoAPK := '';
      ErroDownload := '';
      Sucesso := False;

      try
        // ---------------------------------------------------------
        // 1. Consulta a versão disponível no servidor
        // ---------------------------------------------------------
        HTTP := THTTPClient.Create;

        HTTP.CustomHeaders['Authorization'] :=
          'Bearer ' + TOKEN;

        HTTP.ConnectionTimeout := 5000;
        HTTP.ResponseTimeout := 10000;

        Resp := HTTP.Get(
          URL_ATUALIZACAO + '/versao-app'
        );

        if Resp.StatusCode <> 200 then
        begin
          ErroDownload :=
            'Não foi possível consultar a versão do aplicativo.' +
            sLineBreak +
            'HTTP: ' +
            Resp.StatusCode.ToString;

          TThread.Queue(nil,
            procedure
            begin
              AniIndicator1.Enabled := False;
              AniIndicator1.Visible := False;
              rect_atualizacao_apk.Enabled := True;

              fancy.Show(
                TIconDialog.Error,
                'Atualização',
                ErroDownload,
                'OK'
              );
            end
          );

          Exit;
        end;

        JSON :=
          TJSONObject.ParseJSONValue(
            Resp.ContentAsString
          ) as TJSONObject;

        if not Assigned(JSON) then
        begin
          ErroDownload :=
            'Resposta inválida do servidor.';

          TThread.Queue(nil,
            procedure
            begin
              AniIndicator1.Enabled := False;
              AniIndicator1.Visible := False;
              rect_atualizacao_apk.Enabled := True;

              fancy.Show(
                TIconDialog.Error,
                'Atualização',
                ErroDownload,
                'OK'
              );
            end
          );

          Exit;
        end;

        try
          VersaoServidor :=
            JSON.GetValue<string>('versao');

          BuildServidor :=
            JSON.GetValue<Integer>('build');

          Obrigatoria :=
            JSON.GetValue<Boolean>('obrigatoria');

        finally
          JSON.Free;
          JSON := nil;
        end;

        // ---------------------------------------------------------
        // 2. Obtém a versão real instalada no Android
        // ---------------------------------------------------------
        if not ObterVersaoAplicativo(VersaoAtual, BuildAtual) then
        begin
          ErroDownload :=
            'Não foi possível identificar a versão atual do aplicativo.';

          TThread.Queue(nil,
            procedure
            begin
              AniIndicator1.Enabled := False;
              AniIndicator1.Visible := False;
              rect_atualizacao_apk.Enabled := True;

              fancy.Show(
                TIconDialog.Error,
                'Atualização',
                ErroDownload,
                'OK'
              );
            end
          );

          Exit;
        end;

        // ---------------------------------------------------------
        // 3. Verifica se existe uma versão nova
        // ---------------------------------------------------------
        if BuildServidor <= BuildAtual then
        begin
          TThread.Queue(nil,
            procedure
            begin
              AniIndicator1.Enabled := False;
              AniIndicator1.Visible := False;
              rect_atualizacao_apk.Enabled := True;

              fancy.Show(
                TIconDialog.Error,
                'Atualização',
                'O aplicativo já está atualizado.' +
                sLineBreak + sLineBreak +
                'Versão: ' + VersaoAtual +
                sLineBreak +
                'Build: ' + BuildAtual.ToString,
                'OK'
              );
            end
          );

          Exit;
        end;

        // ---------------------------------------------------------
        // 3. Baixa o APK
        // ---------------------------------------------------------
        Sucesso :=
          BaixarAPK(
            URLDownload,
            TOKEN,
            'comanda.apk',
            CaminhoAPK,
            ErroDownload
          );

        // ---------------------------------------------------------
        // 4. Volta para a thread da interface
        // ---------------------------------------------------------
        TThread.Queue(nil,
          procedure
          begin
            AniIndicator1.Enabled := False;
            AniIndicator1.Visible := False;
            rect_atualizacao_apk.Enabled := True;

            if Sucesso then
            begin
              // O APK já foi baixado. Abre diretamente o instalador Android.
              InstalarAPK(CaminhoAPK);
            end
            else
            begin
              fancy.Show(
                TIconDialog.Error,
                'Atualização',
                'Erro ao baixar o aplicativo:' +
                sLineBreak + sLineBreak +
                ErroDownload,
                'OK'
              );
            end;
          end
        );

      except
        on E: Exception do
        begin
          ErroDownload :=
            'Erro ao verificar atualização:' +
            sLineBreak + sLineBreak +
            E.Message;

          TThread.Queue(nil,
            procedure
            begin
              AniIndicator1.Enabled := False;
              AniIndicator1.Visible := False;
              rect_atualizacao_apk.Enabled := True;

              fancy.Show(
                TIconDialog.Error,
                'Atualização',
                ErroDownload,
                'OK'
              );
            end
          );
        end;
      end;

      HTTP.Free;
    end
  );
end;

procedure TFrmLogin.rect_sobre_apkClick(Sender: TObject);
var
  VersaoAtual: string;
  BuildAtual: Integer;
begin
  if ObterVersaoAplicativo(VersaoAtual, BuildAtual) then
  begin
    fancy.Show(
      TIconDialog.Error,
      'Sobre o aplicativo',
      'Versão: ' + VersaoAtual +
      sLineBreak +
      'Build: ' + BuildAtual.ToString,
      'OK'
    );
  end
  else
  begin
    fancy.Show(
      TIconDialog.Error,
      'Sobre o aplicativo',
      'Não foi possível identificar a versão do aplicativo.',
      'OK'
    );
  end;
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);

begin
    if config.autorizado<>'S' then
    begin
      fancy.Show(TIconDialog.Warning, 'Aviso','Informe Chave Autoriza��o', 'OK');
       lbl_titulo.Text := 'Configura��es';
       TabControl.ActiveTab := TabConfig;
       edt_port.text:='9000';
       exit;
    end;
    if  trim(edt_usuario.text)=emptystr then
    begin
        fancy.Show(TIconDialog.Warning, 'Aviso','Informe usuario', 'OK');
        exit;
    end;
    if Uppercase(edt_usuario.Text)<>'MASTER' then
    begin
        Var  tmpDataset:TDataset;
        try
        dmLocal.conLocal.ExecSQL('select codigo,cognome,senha from funcionarios where cognome='+
        quotedStr(uppercase(edt_usuario.text)),tmpDataset);
        if tmpDataset.IsEmpty  then
         begin
             fancy.Show(TIconDialog.Warning, 'Aviso','Usuario Incorreto', 'OK');
             exit;
         end;
         udmLocal.CodigoVEndedor:=tmpDAtaset.FieldByName('codigo').AsString;
        finally
          tmpdataset.free;
        end;
    end;
    var  NS: TNetworkState:=TNetworkState.create;
    try
      if not  NS.IsWifiConnected then
      begin
          fancy.Show(TIconDialog.Warning, 'Sem WiFi','Aviso', 'OK');
          exit;
      end;
    finally
      ns.free;
    end;

    //verifica conexao com o endpoint
     var  idTCPClient:TIdtcpclient:= TIdtcpclient.Create(nil);
     try
      idTCPClient.ReadTimeout:=2000;
      idTCPClient.IPVersion:=Id_IPv4;
      idTCPClient.ConnectTimeout:=2000;
      idTCPClient.Port:=config.porta.tointeger;
      idTCPClient.Host:=config.Ip;
      try
         idTCPClient.Connect;
         idTCPClient.Disconnect;
      except
         fancy.Show(TIconDialog.Warning, 'server OFF','Aviso', 'OK');
         exit;
      end;
     finally
       idTCPClient.Free;
     end;
     Application.MainForm := frmComanda;
     Application.CreateForm(TFrmComanda, FrmComanda);
     frmComanda.Show;
     fancy.free;
     rect_login.onclick:=nil;
     frmLogin.close;
   end;

procedure TFrmLogin.rect_save_configClick(Sender: TObject);
begin
    if edt_servidor.Text = '' then
    begin

        fancy.Show(TIconDialog.Warning, 'Aviso','Informe o servidor', 'OK');
        exit;
    end;
    if config.autorizado<>'S' then
    begin
       //verificar autorizacao
       if FloatToStr(hourof(time)+24)+ FloatToStr(yearof(date)+73)+FloatToStr(Dayof(date)+29)+FloatToStr(Monthof(date)+10)<>
       trim(edt_autorizacao.text) Then
       begin
        fancy.Show(TIconDialog.Warning, 'Chave n�o Confere','Aviso', 'OK');
        exit;
       end;
    end;
    dmLocal.conLocal.ExecSQL('delete from config');

    dmLocal.conLocal.ExecSQL('insert into config (ip,porta,autorizado) '+
    ' values '+
    '(:ip,:porta,:autorizado)',
    [
     edt_servidor.Text,
     edt_port.text,
     'S'
    ]
    );
    TabControl.GotoVisibleTab(0, TTabTransition.Slide);
    lbl_titulo.Text := 'Acesso';
    config.Ip:=edt_servidor.Text;
    config.porta:=edt_port.text;
    config.url:='http://'+config.Ip+':'+config.porta+'/comanda';
    config.autorizado:='S';
end;

procedure TFrmLogin.rect_testar_printClick(Sender: TObject);
begin
    var  NS: TNetworkState:=TNetworkState.create;
    try
      if not  NS.IsWifiConnected then
      begin
          fancy.Show(TIconDialog.Warning, 'Sem WiFi','Aviso', 'OK');
          exit;
      end;
    finally
      ns.free;
    end;
   //verifica conexao com o endpoint
     var  idTCPClient:TIdtcpclient:= TIdtcpclient.Create(nil);
     try
      idTCPClient.ReadTimeout:=2000;
      idTCPClient.IPVersion:=Id_IPv4;
      idTCPClient.ConnectTimeout:=2000;
      idTCPClient.Port:=config.porta.tointeger;
      idTCPClient.Host:=config.Ip;
      try
         idTCPClient.Connect;
         idTCPClient.Disconnect;
      except
         fancy.Show(TIconDialog.Warning, 'server OFF','Aviso', 'OK');
         exit;
      end;
     finally
       idTCPClient.Free;
     end;
         var tmpDataset: TDataset := nil;
    var objPed: TJSONObject := TJSONObject.Create;
    try
      dmLocal.conLocal.ExecSQL('select distinct coddest from produtos', tmpDataset);

      if tmpDataset.IsEmpty then
      begin
        fancy.Show(TIconDialog.Warning, 'Banco Vazio. Faca Carga', 'Aviso', 'OK');
        Exit;
      end;

      objPed.AddPair('nummesa', '9999');
      objPed.AddPair('codigovendedor', TJSONNumber.Create(1));

      var arrayitems := TJSONArray.Create;

      while not tmpDataset.Eof do
      begin
        var objItemPed := TJSONObject.Create;

        objItemPed.AddPair('lkprod', '10010');
        objItemPed.AddPair('qtde', TJSONNumber.Create(1));
        objItemPed.AddPair('vrunit', TJSONNumber.Create(1));
        objItemPed.AddPair('lkmesa', '99');
        objItemPed.AddPair('produto', 'produto teste comanda');
        objItemPed.AddPair('descresumida', '');
        objItemPed.AddPair('tipotabela', '1');
        objItemPed.AddPair('coddest', TJSONNumber.Create(tmpDataset.FieldByName('coddest').AsInteger));
        objItemPed.AddPair('item', TJSONNumber.Create(1));
        objItemPed.AddPair('observacao', '');

        arrayitems.AddElement(objItemPed);
        tmpDataset.Next;
      end;

      objPed.AddPair('itenspedido', arrayitems);

      var status: Integer;
      var jsonPedido := objPed.ToJSON;
      var retorno := TControllerComanda.TesteImpComandaJson(jsonPedido, status);

      if status <> 200 then
      begin
        fancy.Show(TIconDialog.Error, 'Error', retorno, 'OK');
        Exit;
      end;

    finally
      objPed.Free;

      if Assigned(tmpDataset) then
      begin
        tmpDataset.Close;
        FreeAndNil(tmpDataset);
      end;
end;






end;

procedure TFrmLogin.TabControlChange(Sender: TObject);
begin
   btnVoltar.Visible:= TabControl.ActiveTab=TabConfig;

end;

end.
