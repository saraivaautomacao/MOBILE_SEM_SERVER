unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.TabControl,
  Rest.Types,data.db, FMX.Ani, FMX.Effects,uFancyDialog, System.Actions,
  FMX.ActnList,   idglobal;

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
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure rect_confClick(Sender: TObject);
  private
    { Private declarations }
    fancy : TFancyDialog;
    function Verifica_Server: boolean;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses udmLocal,configvo,NetworkState, ufrComanda, ufrConfiguracao;
procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   // Action := TCloseAction.caFree;
    FrmLogin := nil;
    frmLogin.DisposeOf;
    fancy.DisposeOf;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
var
  tmpDataset:TDataset;
begin
     fancy := TFancyDialog.Create(FrmLogin);
     try
      dmLocal.conLocal.ExecSQL('Select ip,porta,autorizado,identificacao from config',tmpDataset);
      Config:=TConfigvo.create;
      config.Ip:='187.19.165.178';//trim(tmpDataset.FieldByName('ip').AsString);
      config.Porta:=iif(tmpDataset.FieldByName('porta').AsString=emptystr,'9095',
      tmpDataset.FieldByName('porta').AsString);
      config.url:='http://'+config.Ip+':'+config.porta;
      config.ident:=trim(tmpDataset.FieldByName('identificacao').AsString);

  finally
    FreeAndNil(tmpDataset);
  end;
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


procedure TFrmLogin.rect_confClick(Sender: TObject);
begin
  //TabControl.GotoVisibleTab(1, TTabTransition.Slide);
   // lbl_titulo.Text := 'Configurações'
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);

begin

    if  trim(edt_usuario.text)=emptystr then
    begin
        fancy.Show(TIconDialog.Warning, 'Aviso','Informe usuario', 'OK');
        exit;
    end;
     udmLocal.Atendente:=edt_usuario.text;
    if Uppercase(edt_usuario.Text)<>'MASTER' then
    begin
        Var  tmpDataset:TDataset;
        dmLocal.conLocal.ExecSQL('select codigo,cognome,senha from funcionarios where cognome='+
        quotedStr(uppercase(edt_usuario.text)),tmpDataset);
        if tmpDataset.IsEmpty  then
         begin
             fancy.Show(TIconDialog.Warning, 'Aviso','Usuario Incorreto', 'OK');
             exit;
         end;
         udmLocal.CodigoVEndedor:=tmpDAtaset.FieldByName('codigo').AsString;

    end;
    var  NS: TNetworkState:=TNetworkState.create;
    try
      if not  NS.IsWifiConnected then
      begin
          fancy.Show(TIconDialog.Warning, 'Sem WiFi','Aviso', 'OK');
          exit;
      end;
    finally
      ns.disposeof;



    if NOT Assigned(FrmComanda) then
        Application.CreateForm(TFrmComanda, FrmComanda);
    Application.MainForm := frmComanda;
    frmComanda.Show;
    FrmLogin.close;
   end;
end;

end.
