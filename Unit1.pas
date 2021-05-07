unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Contnrs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.TypInfo, UBuscaDados,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.Dapt,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


type TPessoa = class(Tpersistent)
  private
    FId: Integer;
    FNome: String;
    FDataAniversario: TDateTime;
    procedure SetId(const Value: Integer);
    procedure SetNome(const Value: String);
    procedure SetDataAniversario(const Value: TDateTime);

  published
    property Id: Integer read FId write SetId;
    property Nome:String read FNome write SetNome;
    property DataAniversario: TDateTime read FDataAniversario write SetDataAniversario;

end;

  TFuncionario_Basico = class(TPersistent)

    private
      FId: Integer;
      FNome: String;
      FMatricula: String;
    published
      property Id: Integer read FId write FId;
      property Nome_Funcionario: String read FNome write FNome;
      property Matricula: String read FMatricula write FMatricula;

  end;



type Tpessoas = Class(Tpessoa);

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
  var Lista: TObjectList;
    prop: Pointer;
    pessoa: Tpessoas;
    busca: BuscaDados;
    funcionario : TFuncionario_Basico;
begin
  // TReflexao.ListComponentProperties(self, Memo1.Lines);
  FrameWorkEntidade := TEntidadeFramework.Create(FDConnection1);
//  Lista :=  BuscaDados.ListaEntidade(TPessoas);
//  for prop in lista do
//  begin
//    pessoa := prop;
//    //TReflexao.ListComponentProperties(prop,Memo1.Lines);
//    memo1.Lines.Add(pessoa.Nome);
//
//  end;
//  pessoa.nome := 'teste';
//  FrameWorkEntidade.Salvar(pessoa, tpessoas);


//  lista := BuscaDados.ListaEntidade(TFuncionario_basico);
//  for funcionario in lista do
//  begin
//    memo1.Lines.add(Format('Id: %s Nome:%s', [funcionario.matricula, funcionario.Nome_Funcionario]));
//  end;
//  lista.free;


  busca := BuscaDados.Create('select Id, nome_funcionario as nome from folha.funcionario_basico');
  lista := busca.List(TPessoa);
  for pessoa in lista do
  begin
    memo1.Lines.add(Format('Id: %s Nome:%s', [pessoa.Id.ToString, pessoa.Nome]));
  end;
  busca.Free;
  lista.free;
end;



{ TPessoa }

procedure TPessoa.SetDataAniversario(const Value: TDateTime);
begin
  FDataAniversario := Value;
end;

procedure TPessoa.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TPessoa.SetNome(const Value: String);
begin
  FNome := Value;
end;


initialization
  ReportMemoryLeaksOnShutdown := true;

end.
