unit ufrEncerramento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Layouts, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope;

type
  TfrmEncerramento = class(TForm)
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    btnVoltar: TButton;
    ToolBar1: TToolBar;
    Button2: TButton;
    Layout1: TLayout;
    lsvResumo: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    spImprime: TSpeedButton;
    LinkFillControlToField1: TLinkFillControlToField;
    Label1: TLabel;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEncerramento: TfrmEncerramento;

implementation

{$R *.fmx}

uses udmLocal, ufrComanda;

procedure TfrmEncerramento.btnVoltarClick(Sender: TObject);
begin
   close;

end;

procedure TfrmEncerramento.Button2Click(Sender: TObject);
begin
     dmLocal.conLocal.ExecSQL('delete from vendas');
     frmcomanda.lstbxMesas.Clear;
     frmcomanda.carregamesas;
     close;
end;

procedure TfrmEncerramento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := TCloseAction.caFree;
    frmEncerramento := nil;
    frmEncerramento.disposeof;
    dmlocal.qrEncerra.close;
end;

end.
