unit UBuscaDados;

interface

uses DB, Classes, StrUtils, TypInfo, Variants, SysUtils, Contnrs, FireDac.Comp.Client;

type ArrConst = array of variant;

type IEntidadeFramework = Interface

    function Dset(sql: String): TDataSet;
    function Salvar(Entidade: TPersistent; Tipo: TPersistentClass): integer;

End;

  type TEntidadeFramework = class(TInterfacedObject, IEntidadeFramework)

  private
    _Connection: TFDConnection;
    _Query: TFDQuery;
  public
    constructor Create(Conexao: TFDConnection);
    function Dset(sql: String): TDataSet;
    function Salvar(Entidade: TPersistent; Tipo: TPersistentClass): Integer;
    destructor Destroy; override;
  end;


  type
    BuscaDados = class
    private
      Query: TDataSet;
    public
      constructor Create(sql: String);
      destructor Destroy; override;
      public function DataSet: TDataSet;
      public function AsString(campo: String): string;
      public procedure Propriedades(entidade: TPersistent; ListaString:
         TStrings);
      public function List(Entidade: TPersistentClass): TObjectList;

      public class function ListaEntidade(Entidade: TPersistentClass):
        TObjectList; overload;
      public class function ListaEntidade(Entidade: TPersistentClass;

        Restricao: String): TObjectList; overload;
  end;

  function ParametrosUpdate(Entidade: Tpersistent; Tipo: TPersistentClass; out ID: integer): String;
  function ParametrosInsert(Entidade: Tpersistent; Tipo: TPersistentClass): String;

  var
    FrameWorkEntidade: IEntidadeFramework;

implementation



function ParametrosUpdate(Entidade: Tpersistent; Tipo: TPersistentClass; out ID: integer): String;
  var PosicaoCampoQuery: integer;
    PosicaoPropriedadeEntidade: integer;
    Count, Size, I: Integer;
    List: PPropList;
    PropInfo: PPropInfo;
    NovaEntidade: TPersistent;
    Valores: String;
    NomeID: String;
    StrList: TStringList;
begin
  NomeID := 'ID';
  Valores :='';
  NovaEntidade := Entidade.Create;
  strList := TStringList.Create;
  Count := GetPropList(NovaEntidade.ClassInfo, tkAny, nil);
  Size  := Count * SizeOf(Pointer);
  GetMem(List, Size);
  try
    Count := GetPropList(NovaEntidade.ClassInfo, tkAny, List);
    for I := 0 to Count - 1 do
    begin
      PropInfo := List^[I];
      if not (PropInfo^.PropType^.Kind in tkMethods) then
      begin
        if (UpperCase( PropInfo^.Name ) = NomeID) then
        begin
          id := GetPropValue(NovaEntidade, PropInfo^.Name);
          continue;
        end;
        try
          if (PropInfo^.PropType^.Kind = tkUnicodeString) then
            StrList.Add(PropInfo^.Name+'='''+GetPropValue(NovaEntidade, PropInfo^.Name)+'''');
        except

        end;

        result := strlist.DelimitedText;

        //PropValue := VarToStr(GetPropValue(Component, PropInfo^.Name));
//        if UpperCase(PropInfo^.Name) = UpperCase(Query.Fields[PosicaoCampoQuery].FieldName)  then
//          SetPropValue(NovaEntidade, PropInfo^.Name, Query.Fields[
//             PosicaoCampoQuery].Value)
      end;
    end;
  finally
    FreeMem(List);
  end;
end;
function ParametrosInsert(Entidade: Tpersistent; Tipo: TPersistentClass): String;
begin

end;

function BuscaDados.AsString(campo: String): string;
begin
  result := Query.FieldByName(campo).AsString;
end;

constructor BuscaDados.Create(sql: String);
begin

  Query := FrameWorkEntidade.Dset(sql);
end;

function BuscaDados.DataSet: TDataset;
begin
  result := Query;
end;


procedure ListComponentProperties(Component: Tpersistent; Strings: TStrings);
var
  Count, Size, I: Integer;
  List: PPropList;
  PropInfo: PPropInfo;
  PropOrEvent, PropValue: string;
begin
  Count := GetPropList(Component.ClassInfo, tkAny, nil);
  Size  := Count * SizeOf(Pointer);
  GetMem(List, Size);
  try
    Count := GetPropList(Component.ClassInfo, tkAny, List);
    for I := 0 to Count - 1 do
    begin
      PropInfo := List^[I];
      if not (PropInfo^.PropType^.Kind in tkMethods) then
      begin
        PropValue := VarToStr(GetPropValue(Component, PropInfo^.Name));
        Strings.Add(Format('%s = %s', [ PropInfo^.Name, PropValue]));
      end;
    end;
  finally
    FreeMem(List);
  end;
end;


destructor BuscaDados.Destroy;
begin
  if assigned(Query) then
    FreeAndNil(Query);
end;

function BuscaDados.List(Entidade: TPersistentClass): TObjectList;
  var PosicaoCampoQuery: integer;
    PosicaoPropriedadeEntidade: integer;
    Count, Size, I: Integer;
    List: PPropList;
    PropInfo: PPropInfo;
    NovaEntidade: TPersistent;
begin
  result := TObjectList.Create(True);
  while not Query.Eof do
  begin
    NovaEntidade := Entidade.Create;
    for PosicaoCampoQuery := 0 to Query.Fields.Count-1 do
    begin
      Count := GetPropList(NovaEntidade.ClassInfo, tkAny, nil);
      Size  := Count * SizeOf(Pointer);
      GetMem(List, Size);
      try
        Count := GetPropList(NovaEntidade.ClassInfo, tkAny, List);
        for I := 0 to Count - 1 do
        begin
          PropInfo := List^[I];
          if not (PropInfo^.PropType^.Kind in tkMethods) then
          begin
            try
              if UpperCase(PropInfo^.Name) = UpperCase(Query.Fields[PosicaoCampoQuery].FieldName)  then
                SetPropValue(NovaEntidade, PropInfo^.Name, Query.Fields[
                   PosicaoCampoQuery].Value)
            except

            end;
          end;
        end;
      finally
        FreeMem(List);
      end;
    end;
    Query.Next;
    Result.add(NovaEntidade);
  end;

end;

class function BuscaDados.ListaEntidade(Entidade: TPersistentClass): TObjectList;
  var
    Dados : BuscaDados;
    sql : String;
    NomeClasse: string;

begin
  NomeClasse := Entidade.ClassName;
  sql := 'select * from folha.'+ copy(NomeClasse,2, length(NomeClasse));
  Dados := BuscaDados.Create(sql);
  Result := Dados.List(entidade);
  Dados.Destroy;
end;

class function BuscaDados.ListaEntidade(Entidade: TPersistentClass;Restricao: String):
TObjectList;
  var
    Dados : BuscaDados;
    sql : String;
    NomeClasse: string;

begin
  NomeClasse := Entidade.ClassName;
  sql := 'select * from '+ copy(NomeClasse,2, length(NomeClasse)) + ' '+
     restricao;
  Dados := BuscaDados.Create(sql);
  Result := Dados.List(entidade);
  Dados.Destroy;
end;


procedure BuscaDados.Propriedades(entidade: TPersistent;
  ListaString: TStrings);
begin
  ListComponentProperties(entidade, ListaString);
end;


{ TEntidadeFramework }

constructor TEntidadeFramework.Create(Conexao: TFDConnection);
begin
  _Connection := conexao;
  _query := TFDQuery.Create(nil);
  _query.Connection := conexao;

end;

destructor TEntidadeFramework.Destroy;
begin
  _query.Free;
//  _Connection.Free;
  inherited;
end;

function TEntidadeFramework.Dset(sql: String): TDataSet;
  var qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := _Connection;
  qry.Open(sql);
  result := qry;
end;

function TEntidadeFramework.Salvar(Entidade: TPersistent;
  Tipo: TPersistentClass): Integer;
  var sqlExecute: String;
    nomeClasse: String;
    parametros, where: String;
    id: integer;
begin
  nomeClasse := copy(tipo.ClassName,2,100);

  parametros := ParametrosUpdate(Entidade, Tipo, id);
  where := ' id = '+InttoStr(id);
  sqlExecute := Format('update %s set %s where %s', [nomeClasse, parametros, where]);

  _Query.SQL.Text := sqlExecute;
  _Query.ExecSQL;
end;

end.
