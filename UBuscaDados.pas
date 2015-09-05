unit UBuscaDados;

interface

uses DB, Classes, StrUtils, TypInfo, Variants, SysUtils, Contnrs, FireDac.Comp.Client;
  type
    BuscaDados = class
    private
      Query: TFDQuery;


    public
      constructor Create(sql: String;Conexao: TFDConnection);
      destructor Destroy;
      public function DataSet: TFDQuery;
      public function AsString(campo: String): string;
      public procedure Propriedades(entidade: TPersistent; ListaString:
         TStrings);
      public function List(Entidade: TPersistentClass): TObjectList;

      public class function ListaEntidade(Entidade: TPersistentClass; Conexao: TFDConnection):
        TObjectList; overload;
      public class function ListaEntidade(Entidade: TPersistentClass;
        Conexao: TFDConnection;
        Restricao: String): TObjectList; overload;

  end;

implementation

function BuscaDados.AsString(campo: String): string;
begin
  result := Query.FieldByName(campo).AsString;
end;

constructor BuscaDados.Create(sql: String; Conexao: TFDConnection);
begin
  if not Assigned(Query) then
    query := TFDQuery.Create(nil);

  Query.Connection := Conexao;

  Query.SQL.Text := sql;
  Query.Open;
end;

function BuscaDados.DataSet: TFDQuery;
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
            //PropValue := VarToStr(GetPropValue(Component, PropInfo^.Name));
            if UpperCase(PropInfo^.Name) = UpperCase(Query.Fields[PosicaoCampoQuery].FieldName)  then
              SetPropValue(NovaEntidade, PropInfo^.Name, Query.Fields[
                 PosicaoCampoQuery].Value)
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

class function BuscaDados.ListaEntidade(Entidade: TPersistentClass;Conexao: TFDConnection): TObjectList;
  var
    Dados : BuscaDados;
    sql : String;
    NomeClasse: string;

begin
  NomeClasse := Entidade.ClassName;
  sql := 'select * from '+ copy(NomeClasse,2, length(NomeClasse));
  Dados := BuscaDados.Create(sql, Conexao);
  Result := Dados.List(entidade);
  Dados.Destroy;
end;

class function BuscaDados.ListaEntidade(Entidade: TPersistentClass;Conexao: TFDConnection; Restricao: String):
TObjectList;
  var
    Dados : BuscaDados;
    sql : String;
    NomeClasse: string;

begin
  NomeClasse := Entidade.ClassName;
  sql := 'select * from '+ copy(NomeClasse,2, length(NomeClasse)) + ' '+
     restricao;
  Dados := BuscaDados.Create(sql, Conexao);
  Result := Dados.List(entidade);
  Dados.Destroy;
end;


procedure BuscaDados.Propriedades(entidade: TPersistent;
  ListaString: TStrings);
begin
  ListComponentProperties(entidade, ListaString);
end;

end.
