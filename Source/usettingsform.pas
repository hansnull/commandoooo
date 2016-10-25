unit usettingsform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormSettings }

  TFormSettings = class(TForm)
    ButtonSave: TButton;
    EditCommand: TEdit;
    LabelCommand: TLabel;
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormSettings: TFormSettings;

implementation

{$R *.lfm}

{ TFormSettings }

procedure TFormSettings.ButtonSaveClick(Sender: TObject);
var
  HConfigFileContent: TStringlist;
begin
  HConfigFileContent:= TStringlist.Create;
  try
    ForceDirectories(ExtractFilePath(GetAppConfigFile(False)));
    HConfigFileContent.Add(EditCommand.Text);
    HConfigFileContent.SaveToFile(GetAppConfigFile(False));
  except
    on E: Exception do
      ShowMessage('Error occurred: ' + E.Message);
  end;
  FreeAndNil(HConfigFileContent);
  Self.Close;
end;

procedure TFormSettings.FormCreate(Sender: TObject);
var
  HConfigFile: TextFile;
  HConfigFileContent: string;
begin
  if not FileExists(GetAppConfigFile(False)) then
  begin
    EditCommand.Text := 'C:\temp\mycommand -R $commandoooo$';
  end
  else
  begin
    AssignFile(HConfigFile, GetAppConfigFile(False));
    try
      Reset(HConfigFile);
      ReadLn(HConfigFile, HConfigFileContent);
      EditCommand.Text := HConfigFileContent;
    finally
      CloseFile(HConfigFile);
    end;
  end;
end;

end.
