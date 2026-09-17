# Upper Comanda (Delphi 13 / FMX)

Aplicativo de comanda/PDV de restaurante feito em Delphi 13 Alexandria, multiplataforma (FMX) com foco em Android e Win32. Consome uma API REST central e usa SQLite local como cache.

## Build / Compilação
- Projeto principal: `upper_comanda.dpr` (projeto é configurado via `upper_comanda.dproj`).
- Platforms: `Android`, `Android64`, `Win32`.
- Não há scripts de lint/test no repo. Verificação é feita compilando no IDE (Delphi 13) ou com `dcc32/dcc64`.
- Deploy configurado em `upper_comanda.deployproj`.

## Arquitetura
- `upper_comanda.dpr` — programa principal: cria `dmLocal` e `FrmLogin`.
- `udmLocal.pas` — `TdmLocal` (DataModule com FireDAC/ACBr) e declara o global `Config: TConfigVo`.
- `configVo.pas` — `TConfigVo`: `ip`, `porta`, `url`, `ident`.
- `controller.comanda.pas` — `TControllerComanda`: acesso à API via RESTRequest4D (`carga`, `verificapath`) usando `config.url`.
- Telas/frames: prefixo `ufr*` (`ufrComanda`, `ufrprodutos`, `ufrDetalhe`, `ufrConfiguracao`, `ufrEncerramento`, `ufrSabor`, `ufrCabecalho`, `ufrdestinoimp`). Login em `UnitLogin.pas`. Impressora em `unConfImpressora.pas` (ACBrPosPrinter). UIs utilitárias: `uFancyDialog`, `uLoading`.

## Funcionamento do Config (importante)
- `config` é preenchido no `UnitLogin.pas` a partir de tabelas do SQLite local (campos `ip`, `porta`, `identificacao`).
- Defaults: IP `187.19.165.178`, porta `9095`; URL montada como `http://<ip>:<porta>`.
- `config.ident` é o "cnpj" enviado como parâmetro da API.

## Banco local (SQLite via FireDAC)
- Path difere por plataforma:
  - Win32: `<cwd>\db\rest.db` (ativo em `udmLocal.pas` via `{$IFDEF MSWINDOWS}`). Se não existir, gera exceção.
  - Android/iOS: `TPath.GetDocumentsPath\rest.db`.
- Cópia local de referência em `banco/rest/rest.db`.

## Convenções de código
- Frames FMX em `ufr*.pas`/`.fmx`, não alterar `.vlb` (LiveBindings) manualmente.
- Comentários e strings em português; alguns arquivos têm acentos corrompidos por codepage (ex.: "n�o") — preserve o encoding ao editar.
- Componentes declarados no `.dfm`/`.fmx`; campos FireDAC declarados como publicado no DataModule.

## Gotchas
- No Win32 o exe deve rodar com CWD onde exista `db\rest.db`, senão `dmLocal` levanta exceção.
- Formas antigas/descartadas: existe `ufrEncerramentoxxx.pas` que parece legado, não usar como referência.
- `controller.api.pas` está vazio (apenas unit), não se trata de um controller em uso.
- Não commitar binários gerados (`.dcu`, `.exe`, etc.) — `.gitignore` já cobre.