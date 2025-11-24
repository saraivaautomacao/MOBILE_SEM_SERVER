{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			                                         }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit unConfImpressora;

interface

//** Converted with Mida 600     http://www.midaconverter.com - PROJETO.ACBR

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.UIConsts,
  System.Classes,
  System.Variants,
  System.IniFiles,
  Data.DB,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Menus,
  FMX.Grid,
  FMX.ExtCtrls,
  FMX.ListBox,
  FMX.TreeView,
  FMX.Memo,
  FMX.TabControl,
  FMX.Layouts,
  FMX.Edit,
  FMX.Platform,
  FMX.Bind.DBEngExt,
  FMX.Bind.Editors,
  FMX.Bind.DBLinks,
  FMX.Bind.Navigator,
  Data.Bind.EngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.Bind.DBLinks,
  Datasnap.DBClient,
  Soap.EncdDecd,
  Fmx.Bind.Grid,
  System.Rtti,
  System.Bindings.Outputs,
  Data.Bind.Grid,
  Fmx.StdCtrls,
  FMX.Header,
  FMX.Graphics, System.ImageList, FMX.ImgList, FMX.EditBox, FMX.SpinBox,
  FMX.ScrollBox, FMX.Controls.Presentation, FMX.ComboEdit,
  ACBrBase, ACBrDevice, FMX.Memo.Types, ACBrPosPrinter, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type

  { TFrPosPrinterTeste }

  TfrmConfImpressora = class(TForm)
StyleBook1: TStyleBook;
    bAtivar: TButton;
    cbCortarPapel: TCheckBox;
    cbxModelo: TComboBox;
    cbxPorta: TComboEdit;
    cbControlePorta: TCheckBox;
    gbConfiguracao: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel2: TPanel;
    btSerial: TSpeedButton;
    seColunas: TSpinBox;
    seEspLinhas: TSpinBox;
    seLinhasBuffer: TSpinBox;
    seLinhasPular: TSpinBox;
    btSearchPorts: TButton;
    Button1: TButton;
    Button2: TButton;
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Rectangle1: TRectangle;
    lbl_titulo: TLabel;
    btnVoltar: TButton;
    Label5: TLabel;
    edtLocal: TEdit;
    procedure bAtivarClick(Sender: TObject);

    procedure bImpLinhaALinhaClick(Sender: TObject);
    procedure cbControlePortaChange(Sender: TObject);
    procedure cbCortarPapelChange(Sender: TObject);
    procedure cbxModeloChange(Sender: TObject);
    procedure cbxPortaChange(Sender: TObject);
    procedure seEspLinhasChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seLinhasBufferChange(Sender: TObject);
    procedure seLinhasPularChange(Sender: TObject);
    procedure btSearchPortsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1ButtonClick(const Sender: TObject;
      const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnVoltarClick(Sender: TObject);
  private
    function CalcularNomeArquivoConfiguracao: String;
    procedure GravarINI;
    procedure LerINI;
    { private declarations }

  public
    { public declarations }
  end;

var
  frmConfImpressora: TfrmConfImpressora;

implementation

Uses
  FMX.Printer,
  udmLocal,
  typinfo, math, System.StrUtils,
  synacode, System.IOUtils,
  ACBrUtil, ACBrImage, ACBrConsts
  {$IfDef MSWINDOWS}
   ,ACBrWinUSBDevice
  {$EndIf};


{$R *.FMX}

{ TFrPosPrinterTeste }

procedure TfrmConfImpressora.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := TCloseAction.caFree;
    frmConfImpressora:=nil;
end;

procedure TfrmConfImpressora.FormCreate(Sender: TObject);
var
  I: TACBrPosPrinterModelo;
  J: TACBrPosPaginaCodigo;
  K: Integer;
begin
  cbxModelo.Items.Clear ;
  For I := Low(TACBrPosPrinterModelo) to High(TACBrPosPrinterModelo) do
     cbxModelo.Items.Add( GetEnumName(TypeInfo(TACBrPosPrinterModelo), integer(I) ) ) ;

 

  btSearchPortsClick(Sender);



end;

procedure TfrmConfImpressora.FormShow(Sender: TObject);
begin
 dmLocal.qrImpressora.open;
 edtLocal.text:='';
 cbxModelo.itemindex:=-1;
 cbxPorta.itemindex:=-1;
 btSearchPortsClick(self);
end;

procedure TfrmConfImpressora.bImpLinhaALinhaClick(Sender: TObject);
begin
   with dmLocal do
   begin
      aCBrPosPrinter1.Modelo := TACBrPosPrinterModelo( cbxModelo.ItemIndex );
      ACBrPosPrinter1.Porta  :=trim( cbxPorta.Text);
      ACBrPosPrinter1.LinhasBuffer := Trunc(seLinhasBuffer.Value);
      ACBrPosPrinter1.LinhasEntreCupons := Trunc(seLinhasPular.Value);
      ACBrPosPrinter1.EspacoEntreLinhas := Trunc(seEspLinhas.Value);
      ACBrPosPrinter1.ColunasFonteNormal := Trunc(seColunas.Value);
      ACBrPosPrinter1.ControlePorta := true;  //cbControlePorta.IsChecked;
      ACBrPosPrinter1.CortaPapel := cbCortarPapel.IsChecked;
      var memo:TStringList:=TStringList.Create;
      try
          Memo.Add('</zera>');
          Memo.Add('<e>');
          Memo.Add('<a>UPPER AUTOMACAO</a>');
          Memo.Add('88-9 97544059');
          Memo.Add('');
          Memo.add('COMANDA: 99x');
          Memo.add('HORA PEDIDO:'+FormatDateTime('HH":"MM',TIME));
          Memo.add('ATENDENTE: teste');
           Memo.Add('</e>');
          Memo.Add('');
         for var cont:integer:= 1 to 3 do
         begin
            Memo.Add(cont.ToString+ ' X ');
            Memo.Add('Produto comanda teste '+cont.tostring)
        end;
        Memo.add('</lf>');
        Memo.add('</pular_linhas>');
        Memo.Add('</fn>');
        Memo.Add('</corte_total>');
        ACBrPosPrinter1.Imprimir(memo.text);
      finally
          memo.DisposeOf;
      end;
   end;
end;


function TfrmConfImpressora.CalcularNomeArquivoConfiguracao: String;
begin
  {$IfDef ANDROID}
   Result :=TPath.Combine(TPath.GetDocumentsPath, 'PosPrinterTeste.ini' );
  {$ElseIf Defined(FMX) and Defined(POSIX) and Defined(DEBUG)}
   // Salva no diretório anterior, pois o PAServer sempre apaga a Pasta antes de executar
   Result := ApplicationPath + '../' + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini');
  {$Else}
   Result := ChangeFileExt(ParamStr(0), '.ini');
  {$IfEnd}
end;

procedure TfrmConfImpressora.cbControlePortaChange(Sender: TObject);
begin
 dmLocal.ACBrPosPrinter1.ControlePorta := cbControlePorta.IsChecked;
end;

procedure TfrmConfImpressora.cbCortarPapelChange(Sender: TObject);
begin
   dmLocal.ACBrPosPrinter1.CortaPapel := cbCortarPapel.IsChecked;
end;

procedure TfrmConfImpressora.cbxModeloChange(Sender: TObject);
begin
  try
      dmLocal.ACBrPosPrinter1.Modelo := TACBrPosPrinterModelo( cbxModelo.ItemIndex ) ;
  except
     cbxModelo.ItemIndex := Integer( dmLocal.ACBrPosPrinter1.Modelo ) ;
     raise ;
  end ;
end;

procedure TfrmConfImpressora.cbxPortaChange(Sender: TObject);
begin
 try
     dmLocal.ACBrPosPrinter1.Porta := cbxPorta.Text ;
  finally
    cbxPorta.Text := dmlocal.ACBrPosPrinter1.Porta ;
  end ;

  btSerial.Visible := dmlocal.ACBrPosPrinter1.Device.IsSerialPort;
end;

procedure TfrmConfImpressora.seEspLinhasChange(Sender: TObject);
begin
   dmLocal.ACBrPosPrinter1.EspacoEntreLinhas := Trunc(seEspLinhas.Value);
end;

procedure TfrmConfImpressora.btnVoltarClick(Sender: TObject);
begin
  Close;
  dmLocal.qrImpressora.close;
end;

procedure TfrmConfImpressora.btSearchPortsClick(Sender: TObject);
begin
  cbxPorta.Items.Clear;
  //ACBrPosPrinter1.Device.AcharPortasSeriais( cbxPorta.Items );
 // {$IfDef MSWINDOWS}
 // ACBrPosPrinter1.Device.AcharPortasUSB( cbxPorta.Items );
 // {$EndIf}
  {
 // ACBrPosPrinter1.Device.AcharPortasRAW( cbxPorta.Items );
  //$IfDef HAS_BLUETOOTH}
/////  try
   //// ACBrPosPrinter1.Device.AcharPortasBlueTooth( cbxPorta.Items, True );
  //except
  ///end;
  //{$EndIf}

  cbxPorta.Items.Add('LPT1') ;
  cbxPorta.Items.Add('\\localhost\Epson') ;
  cbxPorta.Items.Add('c:\temp\ecf.txt') ;
  cbxPorta.Items.Add('TCP:192.168.0.31:9100') ;

  {$IfNDef MSWINDOWS}
   cbxPorta.Items.Add('/dev/ttyS0') ;
   cbxPorta.Items.Add('/dev/ttyUSB0') ;
   cbxPorta.Items.Add('/tmp/ecf.txt') ;
  {$EndIf}
end;

procedure TfrmConfImpressora.Button1Click(Sender: TObject);
begin
  if (cbxModelo.itemindex<>-1) and (cbxporta.text<>emptystr) and (trim(edtLocal.text)<>emptystr) then
 begin
       with dmlocal do
       begin
          qrimpressora.insert;
          qrImpressoramodelo.asinteger:= cbxModelo.ItemIndex;
          qrImpressoraporta.asString:=cbxPorta.Text;
          qrImpressoracolunas.asInteger:= Trunc(seColunas.Value);
          qrImpressoralinhaspular.asInteger:= Trunc(seLinhasPular.Value);
          qrImpressoracortarpapel.AsBoolean:=cbCortarPapel.IsChecked;
          qrImpressoracontroleporta.AsBoolean:=cbControlePorta.IsChecked;
          qrImpressoramodelo_descricao.asString:=cbxModelo.text;
          qrImpressoraLocal.asString:=edtLocal.text;
          qrImpressora.post;

       end;
 end;
end;

procedure TfrmConfImpressora.seLinhasBufferChange(Sender: TObject);
begin
   dmLocal.ACBrPosPrinter1.LinhasBuffer := Trunc(seLinhasBuffer.Value);
end;

procedure TfrmConfImpressora.seLinhasPularChange(Sender: TObject);
begin
   dmLocal.ACBrPosPrinter1.LinhasEntreCupons := Trunc(seLinhasPular.Value);
end;

procedure TfrmConfImpressora.GravarINI;
begin
end;

procedure TfrmConfImpressora.LerINI;
 begin

end;

procedure TfrmConfImpressora.ListView1ButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);
begin
   if not dmLocal.qrimpressora.IsEmpty then
       dmLocal.qrimpressora.delete;
end;

procedure TfrmConfImpressora.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
cbxModelo.ItemIndex:=dmLocal.qrImpressoramodelo.asinteger;
end;

procedure TfrmConfImpressora.bAtivarClick(Sender: TObject);
begin
  if not btSerial.Enabled then
  begin
      dmLocal.ACBrPosPrinter1.Desativar ;
     bAtivar.Text  := 'Ativar' ;
     btSerial.Enabled := True ;
  end
  else
  begin
    Self.BeginUpdate;
    with dmLocal do
    begin
    try
      ACBrPosPrinter1.Modelo := TACBrPosPrinterModelo( cbxModelo.ItemIndex );
      ACBrPosPrinter1.Porta  :=trim( cbxPorta.Text);

      ACBrPosPrinter1.LinhasBuffer := Trunc(seLinhasBuffer.Value);
      ACBrPosPrinter1.LinhasEntreCupons := Trunc(seLinhasPular.Value);
      ACBrPosPrinter1.EspacoEntreLinhas := Trunc(seEspLinhas.Value);
      ACBrPosPrinter1.ColunasFonteNormal := Trunc(seColunas.Value);
      ACBrPosPrinter1.ControlePorta := cbControlePorta.IsChecked;
      ACBrPosPrinter1.CortaPapel := cbCortarPapel.IsChecked;
     

      ACBrPosPrinter1.Ativar ;

      btSerial.Enabled := False ;
      bAtivar.Text  := 'Desativar' ;

      GravarINI ;
    finally
      EndUpdate;
      cbxModelo.ItemIndex := Integer(ACBrPosPrinter1.Modelo) ;
      cbxPorta.Text       := ACBrPosPrinter1.Porta ;
    end ;
  end;
  end;
end;

end.

