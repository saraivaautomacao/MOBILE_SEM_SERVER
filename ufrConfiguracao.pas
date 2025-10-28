unit ufrConfiguracao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.TabControl,uFancyDialog;

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
    procedure rect_save_configClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
     fancy : TFancyDialog;
  public
    { Public declarations }
  end;

var
  frmConfiguracao: TfrmConfiguracao;

implementation

{$R *.fmx}

uses udmLocal,data.db;

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

    config.Ip:=edt_servidor.Text;
    config.porta:=edt_port.text;
    config.url:='http://'+config.Ip+':'+config.porta+'/comanda';
    config.ident:=edt_IdentServer.text; ;
    close;
end;

end.
