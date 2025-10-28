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

       class function imprimeparcial(mesa: string; out status: integer): String; static;
      // class function SerVerAtivo:String;

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
             .BasicAuthentication('username', 'password')
             .Accept('application/json')
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


class function TControllerComanda.imprimeparcial(mesa:string; out status: integer): String;
var
    Resp : IResponse;
begin
   status:=0;
   var memTable:=TFDMemTable.Create(nil);
   Resp := TRequest.New.BaseURL(config.url)
             .Resource('imprimeparcial/'+mesa)
             .BasicAuthentication('username', 'password')
             .Accept('application/json')
             .get;
   status:=resp.StatusCode;
   result:=resp.Content;

end;


end.
