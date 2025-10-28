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
  ACBrPosPrinter1.ControlePorta := cbControlePorta.IsChecked;
  ACBrPosPrinter1.CortaPapel := cbCortarPapel.IsChecked;

   ACBrPosPrinter1.Ativar ;
  ACBrPosPrinter1.ImprimirLinha('</zera>');
  ACBrPosPrinter1.ImprimirLinha('</linha_dupla>');
  ACBrPosPrinter1.ImprimirLinha('FONTE NORMAL: '+IntToStr(ACBrPosPrinter1.ColunasFonteNormal)+' Colunas');
  ACBrPosPrinter1.ImprimirLinha(LeftStr('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8', ACBrPosPrinter1.ColunasFonteNormal));
  ACBrPosPrinter1.ImprimirLinha('<e>EXPANDIDO: '+IntToStr(ACBrPosPrinter1.ColunasFonteExpandida)+' Colunas');
  ACBrPosPrinter1.ImprimirLinha(LeftStr('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8', ACBrPosPrinter1.ColunasFonteExpandida));
  ACBrPosPrinter1.ImprimirLinha('</e><c>CONDENSADO: '+IntToStr(ACBrPosPrinter1.ColunasFonteCondensada)+' Colunas');
  ACBrPosPrinter1.ImprimirLinha(LeftStr('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8', ACBrPosPrinter1.ColunasFonteCondensada));
  ACBrPosPrinter1.ImprimirLinha('</c><n>FONTE NEGRITO</N>');
  ACBrPosPrinter1.ImprimirLinha('<in>FONTE INVERTIDA</in>');
  ACBrPosPrinter1.ImprimirLinha('<S>FONTE SUBLINHADA</s>');
  ACBrPosPrinter1.ImprimirLinha('<i>FONTE ITALICO</i>');
  ACBrPosPrinter1.ImprimirLinha('FONTE NORMAL');
  ACBrPosPrinter1.ImprimirLinha('</linha_simples>');
  ACBrPosPrinter1.ImprimirLinha('<n>LIGA NEGRITO');
  ACBrPosPrinter1.ImprimirLinha('<i>LIGA ITALICO');
  ACBrPosPrinter1.ImprimirLinha('<S>LIGA SUBLINHADA');
  ACBrPosPrinter1.ImprimirLinha('<c>LIGA CONDENSADA');
  ACBrPosPrinter1.ImprimirLinha('<e>LIGA EXPANDIDA');
  ACBrPosPrinter1.ImprimirLinha('</fn>FONTE NORMAL');
  ACBrPosPrinter1.ImprimirLinha('</linha_simples>');
  ACBrPosPrinter1.ImprimirLinha('<e><n>NEGRITO E EXPANDIDA</n></e>');
  ACBrPosPrinter1.ImprimirLinha('</fn>FONTE NORMAL');
  ACBrPosPrinter1.ImprimirLinha('<in><c>INVERTIDA E CONDENSADA</c></in>');
  ACBrPosPrinter1.ImprimirLinha('</fn>FONTE NORMAL');
  ACBrPosPrinter1.ImprimirLinha('</linha_simples>');
  ACBrPosPrinter1.ImprimirLinha('</FB>FONTE TIPO B');
  ACBrPosPrinter1.ImprimirLinha('<n>FONTE NEGRITO</N>');
  ACBrPosPrinter1.ImprimirLinha('<e>FONTE EXPANDIDA</e>');
  ACBrPosPrinter1.ImprimirLinha('<in>FONTE INVERTIDA</in>');
  ACBrPosPrinter1.ImprimirLinha('<S>FONTE SUBLINHADA</s>');
  ACBrPosPrinter1.ImprimirLinha('<i>FONTE ITALICO</i>');
  ACBrPosPrinter1.ImprimirLinha('</FA>FONTE TIPO A');
  ACBrPosPrinter1.ImprimirLinha('</FN>FONTE NORMAL');
  ACBrPosPrinter1.ImprimirLinha('</corte_total>');
  ACBrPosPrinter1.Desativar;
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
  if (cbxModelo.itemindex<>-1) and (cbxporta.itemindex<>-1) or (edtLocal.text<>emptystr) then
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

