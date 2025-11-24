unit ufrcabecalho;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,data.db;

type
  TfrmCabecalho = class(TForm)
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    btnVoltar: TButton;
    Layout2: TLayout;
    Label4: TLabel;
    edt_Linha1: TEdit;
    lblPorta: TLabel;
    rect_save_config: TRectangle;
    Label5: TLabel;
    edtLinha2: TEdit;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    procedure FormShow(Sender: TObject);
    procedure rect_save_configClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCabecalho: TfrmCabecalho;

implementation

{$R *.fmx}

uses udmLocal;

procedure TfrmCabecalho.btnVoltarClick(Sender: TObject);
begin
  close;
end;

procedure TfrmCabecalho.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := TCloseAction.caFree;
    frmCabecalho := nil;
    frmCabecalho.DisposeOf;
   dmLocal.qrcabecalho.close;
end;

procedure TfrmCabecalho.FormShow(Sender: TObject);
begin
   with dmlocal do
   begin
      qrcabecalho.open;
      if qrcabecalho.isempty then
         qrcabecalho.append
      else
         qrcabecalho.edit;


   end;
end;

procedure TfrmCabecalho.rect_save_configClick(Sender: TObject);
begin
  if dmlocal.qrcabecalho.State in [dsedit,dsinsert] then
   dmlocal.qrcabecalho.post;
   close;
end;

end.
