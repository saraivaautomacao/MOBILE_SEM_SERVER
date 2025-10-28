unit ufrDetalhe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.StdCtrls, FMX.Grid, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Objects, FMX.Layouts,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TfrmDetalhe = class(TForm)
    ToolBar2: TToolBar;
    SpeedButton5: TSpeedButton;
    rect_destImpressao: TRectangle;
    spImprime: TSpeedButton;
    lsvdetalhes: TListView;
    Layout1: TLayout;
    lbltotal: TLabel;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    SpeedButton1: TSpeedButton;
    lblConferencia: TLabel;
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    var nummesa:string;
  end;

var
  frmDetalhe: TfrmDetalhe;

implementation

{$R *.fmx}

uses  ufrComanda,controller.comanda, udmLocal;

procedure TfrmDetalhe.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    frmDetalhe := nil;
    frmdetalhe.disposeof;
    dmlocal.qrvendas.close;
end;

procedure TfrmDetalhe.FormKeyUp(Sender: TObject; var Key: Word;
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

procedure TfrmDetalhe.SpeedButton1Click(Sender: TObject);
begin
   with dmlocal do
   begin
       qrvendas.first;
       while not qrvendas.eof do
       begin
         qrvendas.delete;
       end;
       frmComanda.StatusComanda(
      formatFloat('00',Strtointdef(frmComanda.editNumMesa.text,00)),'L',0);

   end;
   frmComanda.lstbxmesas.Enabled:=true;
    close;
end;

procedure TfrmDetalhe.SpeedButton5Click(Sender: TObject);
begin
   frmComanda.lstbxmesas.Enabled:=true;
   close;

end;

end.
