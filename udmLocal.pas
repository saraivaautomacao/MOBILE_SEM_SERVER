unit udmLocal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI,System.IOUtils,
  FireDAC.Stan.StorageBin, ConfigVo, FireDAC.Phys.SQLiteWrapper.Stat,
  System.ImageList, FMX.ImgList, FMX.Types, FMX.Controls, ACBrBase,
  ACBrPosPrinter;


type
  TdmLocal = class(TDataModule)
    conLocal: TFDConnection;
    Link: TFDPhysSQLiteDriverLink;
    Cursor: TFDGUIxWaitCursor;
    qrProdutos: TFDQuery;
    qrProdutoscodigo: TStringField;
    qrProdutosproduto: TStringField;
    qrProdutoslkGrupo: TSmallintField;
    qrProdutosunidade: TStringField;
    qrProdutosdescvenda: TStringField;
    qrProdutosdescvenda1: TStringField;
    qrProdutosdescvenda2: TStringField;
    qrProdutosdescvenda3: TStringField;
    binLink: TFDStanStorageBinLink;
    qrProdutoscoddest: TIntegerField;
    ImageList1: TImageList;
    memPedido: TFDMemTable;
    memPedidoItem: TSmallintField;
    memPedidolkprod: TStringField;
    memPedidoqtde: TFloatField;
    memPedidovrunit: TCurrencyField;
    memPedidolkmesa: TStringField;
    memPedidoproduto: TStringField;
    memPedidoTotal: TCurrencyField;
    memPedidocodDest: TSmallintField;
    memPedidodescresumida: TStringField;
    memPedidoTipoTabela: TStringField;
    memPedidovrunit1: TCurrencyField;
    memPedidolkgrupo: TSmallintField;
    memPedidoobservacao: TStringField;
    memSAbor: TFDMemTable;
    memSAborlkmesa: TStringField;
    memSAborcodigo: TStringField;
    memSAbordescricao: TStringField;
    dtsLinkPedido: TDataSource;
    memSAboritem: TSmallintField;
    qrProdutosobservacao: TStringField;
    qrProdutosbalanca: TStringField;
    qrProdutosprecovenda: TBCDField;
    qrProdutosprecovenda1: TBCDField;
    qrProdutosprecovenda2: TBCDField;
    qrProdutosprecovenda3: TBCDField;
    qrGrupos: TFDQuery;
    qrGruposcodigo: TSmallintField;
    qrGruposgrupo: TStringField;
    ACBrPosPrinter1: TACBrPosPrinter;
    qrImpressora: TFDQuery;
    qrImpressoraid: TFDAutoIncField;
    qrImpressoramodelo: TIntegerField;
    qrImpressoraporta: TStringField;
    qrImpressoracolunas: TIntegerField;
    qrImpressoralinhaspular: TIntegerField;
    qrImpressoracortarpapel: TBooleanField;
    qrImpressoracontroleporta: TBooleanField;
    qrImpressoramodelo_descricao: TStringField;
    qrImpressoralocal: TStringField;
    qrGruposidimpressora: TIntegerField;
    qrGruposlocal: TStringField;
    qrVendas: TFDQuery;
    qrVendasid: TFDAutoIncField;
    qrVendaslkprod: TStringField;
    qrVendasqtde: TBCDField;
    qrVendasvrunit: TCurrencyField;
    qrVendaslkmesa: TStringField;
    qrVendasproduto: TStringField;
    qrVendasobservacao: TStringField;
    qrVendasSomaTotal: TAggregateField;
    qrEncerra: TFDQuery;
    qrVendastotal: TBCDField;
    qrCabecalho: TFDQuery;
    qrCabecalhocabecalho1: TStringField;
    qrCabecalhocabecalho2: TStringField;
    qrEncerralkmesa: TStringField;
    qrResumo_vendas: TFDQuery;
    qrResumo_vendaslkmesa: TStringField;
    qrResumo_vendastotal: TBCDField;
    qrEncerratotal: TBCDField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  dmLocal: TdmLocal;
  Config:TConfigVo;
  CodigoVEndedor:String='1';
  Atendente:string;
implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TdmLocal.DataModuleCreate(Sender: TObject);

begin
     ACBrPosPrinter1.Device.TimeOut := 3000;
     with ConLocal do
    begin
        {$IFDEF MSWINDOWS}
        if NOT FileExists(System.SysUtils.GetCurrentDir + '\db\rest.db') then
            raise Exception.Create('Banco de dados não encontrado: ' +
                                   System.SysUtils.GetCurrentDir + '\DB\rest.db');

        try
            Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\DB\rest.db';
            Connected := true;
        except on E:Exception do
                raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
        end;

        {$ELSE}

        Params.Values['DriverID'] := 'SQLite';
        try
           //nome do banco deve ser igual a refererida pasta. Case sensitive
            Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'rest.db');
            Connected := true;
        except on E:Exception do
            raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
        end;
        {$ENDIF}
    end;








end;

end.
