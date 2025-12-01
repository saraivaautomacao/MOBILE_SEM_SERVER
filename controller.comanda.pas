unit controller.comanda;

interface
 uses system.JSON,FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,system.SysUtils,configvo,udmlocal;


  type
    TControllerComanda=Class


     public

      class function Carga(Tabela:string;out memcarga:TFDmemTable):integer;
      class function verificapath(path:string):integer;

    End;




implementation
uses RESTRequest4D,DataSet.Serialize.Adapter.RESTRequest4D, DataSet.Serialize;


{ TControllerComanda }



class function TControllerComanda.Carga(Tabela: string;
  out memcarga:TFDmemTable): integer;
var
    Resp : IResponse;
begin

   var memTable:=TFDMemTable.Create(nil);

   Resp := TRequest.New.BaseURL(config.url)
             .Resource('carga')
            // .BasicAuthentication('username', 'password')
             .Accept('application/json')
             .AddParam('cnpj',config.ident)
             .AddParam('tabela',tabela)
             .Adapters(TDataSetSerializeAdapter.New(MemTable))
             .get;
  result:=resp.StatusCode;
  if (result<>400) then
  begin
     memcarga.AppendData(memtable);
  end;
  memtable.DisposeOf;
end;





class function TControllerComanda.verificapath(path:string): integer;
 var
    Resp : IResponse;
begin
   Resp := TRequest.New.BaseURL(config.url)
             .Resource('verificapath')
            // .BasicAuthentication('username', 'password')
             .Accept('application/json')
             .AddParam('cnpj',path)
             .get;
  result:=resp.StatusCode;

end;

end.
