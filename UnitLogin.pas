unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Math,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  Rest.Types, data.db, FMX.Ani, FMX.Effects, uFancyDialog,
  System.Actions, FMX.ActnList, idglobal;

type
  TFrmLogin = class(TForm)
    LayoutBrand: TLayout;
    rectLogoBadge: TRectangle;
    ShadowLogo: TShadowEffect;
    ImageLogo: TImage;
    lblAppName: TLabel;
    LayoutFooter: TLayout;
    lblConfig: TLabel;
    lblVersao: TLabel;
    LayoutCardWrap: TLayout;
    Card: TRectangle;
    ShadowCard: TShadowEffect;
    LayoutCardInner: TLayout;
    lblSaudacao: TLabel;
    lblSub: TLabel;
    edt_usuario: TEdit;
    rect_login: TRectangle;
    ShadowButton: TShadowEffect;
    lblAcessar: TLabel;
    FloatAnimationBrand: TFloatAnimation;
    FloatAnimationEntrada: TFloatAnimation;
    procedure rect_loginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lblConfigClick(Sender: TObject);
    procedure edt_usuarioKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure rect_loginMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rect_loginMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    { Private declarations }
    fancy: TFancyDialog;
    procedure AjustarLayoutLogin;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses udmLocal, configvo, NetworkState, ufrComanda, ufrConfiguracao;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(fancy) then
    fancy.DisposeOf;
  FrmLogin := nil;
  Action := TCloseAction.caFree;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
var
  tmpDataset: TDataset;
begin
  AjustarLayoutLogin;
  fancy := TFancyDialog.Create(FrmLogin);
  try
    dmLocal.conLocal.ExecSQL('Select ip,porta,autorizado,identificacao from config', tmpDataset);
    Config := TConfigvo.create;
    config.Ip := '187.19.165.178'; // trim(tmpDataset.FieldByName('ip').AsString);
    config.Porta := iif(tmpDataset.FieldByName('porta').AsString = emptystr, '9095',
      tmpDataset.FieldByName('porta').AsString);
    config.url := 'http://' + config.Ip + ':' + config.porta;
    config.ident := trim(tmpDataset.FieldByName('identificacao').AsString);
  finally
    FreeAndNil(tmpDataset);
  end;
  FloatAnimationBrand.Start;
  FloatAnimationEntrada.Start;
end;

procedure TFrmLogin.FormResize(Sender: TObject);
begin
  AjustarLayoutLogin;
end;

procedure TFrmLogin.AjustarLayoutLogin;
var
  LarguraCard: Single;
  AlturaTop: Single;
begin
  if (ClientWidth <= 0) or (ClientHeight <= 0) then
    Exit;

  lblAppName.Text := 'Upper Automa' + #231 + #227 + 'o';
  lblConfig.Text := 'Configura' + #231 + #245 + 'es';

  rectLogoBadge.Align := TAlignLayout.None;
  lblAppName.Align := TAlignLayout.None;
  Card.Align := TAlignLayout.None;

  LayoutFooter.Height := 94;
  AlturaTop := Max(220, Min(ClientHeight * 0.43, 286));
  LayoutBrand.Height := AlturaTop;

  rectLogoBadge.Width := Min(ClientWidth * 0.32, 122);
  rectLogoBadge.Height := rectLogoBadge.Width;
  rectLogoBadge.XRadius := rectLogoBadge.Width * 0.25;
  rectLogoBadge.YRadius := rectLogoBadge.XRadius;
  rectLogoBadge.Position.X := (ClientWidth - rectLogoBadge.Width) / 2;
  rectLogoBadge.Position.Y := Max(54, AlturaTop - rectLogoBadge.Height - 50);

  ImageLogo.Width := rectLogoBadge.Width * 0.77;
  ImageLogo.Height := ImageLogo.Width;

  lblAppName.Width := Min(ClientWidth - 40, 320);
  lblAppName.Position.X := (ClientWidth - lblAppName.Width) / 2;
  lblAppName.Position.Y := rectLogoBadge.Position.Y + rectLogoBadge.Height + 16;

  LarguraCard := Min(ClientWidth - 52, 328);
  Card.Width := LarguraCard;
  Card.Height := 247;
  Card.Position.X := (ClientWidth - Card.Width) / 2;
  Card.Position.Y := 0;
  LayoutCardInner.Margins.Left := 26;
  LayoutCardInner.Margins.Right := 26;
  LayoutCardWrap.Height := Card.Height;

  edt_usuario.Height := 53;
  rect_login.Height := 56;
  lblAcessar.Height := rect_login.Height;
end;

procedure TFrmLogin.rect_loginMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  rect_login.Fill.Color := $FF4D22B8;
  rect_login.Opacity := 0.93;
end;

procedure TFrmLogin.rect_loginMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  rect_login.Fill.Color := $FF6F3CEC;
  rect_login.Opacity := 1;
end;

procedure TFrmLogin.edt_usuarioKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    rect_loginClick(Sender);
end;

procedure TFrmLogin.lblConfigClick(Sender: TObject);
begin
  if not Assigned(frmConfiguracao) then
    Application.CreateForm(TFrmConfiguracao, frmConfiguracao);
  frmConfiguracao.Show;
end;

procedure TFrmLogin.rect_loginClick(Sender: TObject);
begin
  if trim(edt_usuario.text) = emptystr then
  begin
    fancy.Show(TIconDialog.Warning, 'Aviso', 'Informe usuario', 'OK');
    exit;
  end;
  udmLocal.Atendente := edt_usuario.text;
  if Uppercase(edt_usuario.Text) <> 'MASTER' then
  begin
    var tmpDataset: TDataset;
    dmLocal.conLocal.ExecSQL('select codigo,cognome,senha from funcionarios where cognome=' +
      quotedStr(uppercase(edt_usuario.text)), tmpDataset);
    if tmpDataset.IsEmpty then
    begin
      fancy.Show(TIconDialog.Warning, 'Aviso', 'Usuario Incorreto', 'OK');
      exit;
    end;
    udmLocal.CodigoVEndedor := tmpDAtaset.FieldByName('codigo').AsString;
  end;
  var NS: TNetworkState := TNetworkState.create;
  try
    if not NS.IsWifiConnected then
    begin
      fancy.Show(TIconDialog.Warning, 'Sem WiFi', 'Aviso', 'OK');
      exit;
    end;
  finally
    ns.disposeof;

    if NOT Assigned(FrmComanda) then
      Application.CreateForm(TFrmComanda, FrmComanda);
    Application.MainForm := frmComanda;
    frmComanda.Show;
    rect_login.OnClick:=nil;
    FrmLogin.close;
  end;
end;

end.
