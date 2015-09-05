unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Contnrs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.TypInfo, UBuscaDados,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.Dapt;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TReflexao = class
  public
    class procedure ListComponentProperties(Component: Tpersistent;
      Strings: TStrings); static;
  end;

type
  TPropF = class(TPersistent)
  private
    FCodigo: Integer;
    FProprietario: String;
    procedure SetCodigo(const Value: Integer);
    procedure SetProprietario(const Value: String);

  published
    property Proprietario: String read FProprietario write SetProprietario;
    property Codigo: Integer read FCodigo write SetCodigo;

  end;
var
  Form1: TForm1;

implementation

{$R *.dfm}
class procedure TReflexao.ListComponentProperties(Component: Tpersistent; Strings: TStrings);
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

procedure TForm1.Button1Click(Sender: TObject);
  var Lista: TObjectList;
    prop: Pointer;
begin
  // TReflexao.ListComponentProperties(self, Memo1.Lines);
  Lista :=  BuscaDados.ListaEntidade(TPropF, FDConnection1);
  for prop in lista do
  begin
    TReflexao.ListComponentProperties(prop,Memo1.Lines);
  end;


end;

{ TPropF }

procedure TPropF.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TPropF.SetProprietario(const Value: String);
begin
  FProprietario := Value;
end;

end.
