unit ufrdestinoimp;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, FMX.ListView;

type
  TfrmDestinoImp = class(TForm)
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    btnVoltar: TButton;
    Layout1: TLayout;
    Label1: TLabel;
    cbxGrupos: TComboBox;
    Label2: TLabel;
    cbxDestino: TComboBox;
    rect_imp: TRectangle;
    Label3: TLabel;
    lsvDestino: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    procedure FormShow(Sender: TObject);
    procedure rect_impClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDestinoImp: TfrmDestinoImp;

implementation

{$R *.fmx}

uses udmLocal;

procedure TfrmDestinoImp.btnVoltarClick(Sender: TObject);
begin
   close;
   dmLocal.qrImpressora.close;
    dmlocal.qrGrupos.Close;
end;

procedure TfrmDestinoImp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := TCloseAction.caFree;
    frmDestinoImp := nil;
    frmDestinoImp.DisposeOf;
    dmLocal.qrgrupos.close;
     dmLocal.qrImpressora.close;
end;

procedure TfrmDestinoImp.FormShow(Sender: TObject);
begin
   dmLocal.qrgrupos.open;
   dmLocal.qrgrupos.first;
   cbxGrupos.items.Clear;
   while not dmLocal.qrgrupos.eof do
   begin
     cbxgrupos.items.add( dmLocal.qrGruposgrupo.asstring);
      dmLocal.qrgrupos.next;
   end;
   dmLocal.qrImpressora.open;
   cbxDestino.items.clear;
   while not dmLocal.qrImpressora.eof do
   begin
       cbxDestino.items.add(dmLocal.qrImpressoralocal.asString);
       dmLocal.qrImpressora.next;
   end;

end;

procedure TfrmDestinoImp.rect_impClick(Sender: TObject);
begin
    if (cbxGrupos.ItemIndex<>-1) and (cbxDestino.itemIndex<>-1) then
    begin

        dmLocal.qrImpressora.locate('local',cbxDestino.text);
        dmLocal.qrGrupos.locate('grupo',cbxGrupos.text);
        dmLocal.qrGrupos.edit;
        dmLocal.qrGruposidimpressora.asinteger:= dmLocal.qrImpressoraid.asinteger;
         dmLocal.qrGruposlocal.asString:= cbxdestino.text;
        dmlocal.qrGrupos.post;
          dmlocal.qrGrupos.ApplyUpdates(-1);

    end;

end;

end.
