unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  OverbyteIcsWndControl, OverbyteIcsHttpProt, OverbyteIcsWSocket;

type
  TFormMain = class(TForm)
    grpEndereco: TGroupBox;
    edtEndereco: TEdit;
    lblEndereco: TLabel;
    grpParametros: TGroupBox;
    grpResultado: TGroupBox;
    pnlBt: TPanel;
    btDownloadSuperior: TButton;
    mmoParametros: TMemo;
    mmoResultado: TMemo;
    SslContext: TSslContext;
    Http: TSslHttpCli;
    procedure btDownloadSuperiorClick(Sender: TObject);
  private
    FConteudo: string;
    procedure SetConteudo(const Value: string);
    procedure HTTPOnData(Sender: TObject; Buffer: Pointer; Size: Integer);
    property Conteudo : string read FConteudo write SetConteudo;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.btDownloadSuperiorClick(Sender: TObject);
var
   Data : AnsiString;
begin
  mmoResultado.Clear;
  Data := AnsiString(StringReplace(mmoParametros.Lines.Text,#$D#$A,'',[rfReplaceAll]));

  With Http do
  begin
    ContentTypePost := 'application/json';
    SendStream := TMemoryStream.Create;
    SendStream.Write(Data[1],length(Data));
    SendStream.Seek(0,0);
    OnDocData := HTTPOnData;
    URL := edtEndereco.Text;
    try
      Post;
      Close;
    except
      ShowMessage('A requisição falhou!');
      SendStream.Free;
      Exit;
    end;
    mmoResultado.Lines.Text := Conteudo;
    SendStream.Free;
  end;
end;

procedure TFormMain.HTTPOnData(Sender: TObject; Buffer: Pointer; Size: Integer);
var Response : AnsiString;
begin
  try
    SetLength(response, Size);
    Move(Buffer^, Response[1], Size);
    Conteudo := Conteudo + Response;
  except
  end;

end;

procedure TFormMain.SetConteudo(const Value: string);
begin
  FConteudo := Value;
end;

end.
