program upper_comanda;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrComanda in 'ufrComanda.pas' {frmComanda},
  udmLocal in 'udmLocal.pas' {dmLocal: TDataModule},
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  configVo in 'configVo.pas',
  NetworkState in 'NetworkState.pas',
  ufrprodutos in 'ufrprodutos.pas' {frmProdutos},
  ufrSabor in 'ufrSabor.pas' {frSAbor},
  uFancyDialog in 'uFancyDialog.pas',
  ufrDetalhe in 'ufrDetalhe.pas' {frmDetalhe},
  controller.comanda in 'controller.comanda.pas',
  unConfImpressora in 'unConfImpressora.pas' {frmConfImpressora},
  ufrdestinoimp in 'ufrdestinoimp.pas' {frmDestinoImp},
  ufrConfiguracao in 'ufrConfiguracao.pas' {frmConfiguracao},
  ufrEncerramento in 'ufrEncerramento.pas' {frmEncerramento},
  ufrcabecalho in 'ufrcabecalho.pas' {frmCabecalho};

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown:= true;
  Application.Initialize;
  Application.CreateForm(TdmLocal, dmLocal);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.Run;
end.
