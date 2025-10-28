unit ufrSabor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, FMX.StdCtrls, FMX.Controls.Presentation, Data.Bind.Components, Data.Bind.DBScope, FMX.ListView;

type
  TfrSAbor = class(TForm)
    ListView1: TListView;
    ToolBar1: TToolBar;
    Button1: TButton;
    ToolBar2: TToolBar;
    lblDescricao: TLabel;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ToolBar1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   // codigomesa:string;
  end;

var
  frSAbor: TfrSAbor;

implementation

{$R *.fmx}

uses udmLocal, fireDAC.Comp.DataSet, FireDAC.Comp.Client, ufrprodutos;

procedure TfrSAbor.FormShow(Sender: TObject);
var
  itemAdd:TListViewItem;
  qrList:TFDquery;
begin
  try
    qrList:=TFDQuery.create(nil);
    qrList.connection:=dmLocal.conLocal;
   

    qrList.SQL.Text:='select * from sabores where lksetor=:setor order by descricao';
    qrlist.parambyname('setor').AsInteger:=dmlocal.qrProdutoslkGrupo.AsInteger;
    qrlist.Open();
    qrList.first;
    ListView1.BeginUpdate;
    listView1.Items.Clear;
   while not qrList.eof do
   begin
      ItemAdd:=listView1.items.add;
      ItemAdd.text:=qrList.fieldbyname('descricao').asString;
      qrList.next;
   end;
   ListView1.EndUpdate;
   lblDescricao.text:=dmlocal.qrProdutosProduto.asString;
  finally
    qrList.close;
    FreeAndNil(qrList);
  end;
end;

procedure TfrSAbor.ToolBar1Click(Sender: TObject);
begin
   close;
   frmProdutos.SpeedButton1Click(self);
end;

end.
