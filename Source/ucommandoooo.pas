unit ucommandoooo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  StdCtrls, process, usettingsform;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonFire: TButton;
    ListBoxFiles: TListBox;
    MainMenu: TMainMenu;
    MenuItemRemove: TMenuItem;
    MenuItemSettings: TMenuItem;
    PopupMenuRemove: TPopupMenu;
    procedure ButtonFireClick(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure ListBoxFilesKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure MenuItemRemoveClick(Sender: TObject);
    procedure MenuItemSettingsClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

{ TFormMain }

procedure TFormMain.MenuItemSettingsClick(Sender: TObject);
begin
  FormSettings.ShowModal;
end;

procedure TFormMain.FormDropFiles(Sender: TObject; const FileNames: array of string);
var
  HFileIndex: integer = 0;
begin
  for HFileIndex := 0 to High(FileNames) do
  begin
    if not (DirectoryExists(FileNames[HFileIndex])) then
      ListBoxFiles.Items.Add(FileNames[HFileIndex]);
  end;
end;

procedure TFormMain.ListBoxFilesKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
var
  HIndex: integer;
begin
  if key = $2E then
  begin
    ListBoxFiles.Items.BeginUpdate;
    for HIndex := ListBoxFiles.Items.Count - 1 downto 0 do
    begin
      if ListBoxFiles.Selected[HIndex] then
        ListBoxFiles.Items.Delete(HIndex);
    end;
    ListBoxFiles.Items.EndUpdate;
  end;
end;

procedure TFormMain.MenuItemRemoveClick(Sender: TObject);
var
  HIndex: integer;
begin
  ListBoxFiles.Items.BeginUpdate;
  for HIndex := ListBoxFiles.Items.Count - 1 downto 0 do
  begin
    if ListBoxFiles.Selected[HIndex] then
      ListBoxFiles.Items.Delete(HIndex);
  end;
  ListBoxFiles.Items.EndUpdate;
end;

procedure TFormMain.ButtonFireClick(Sender: TObject);
var
  HConfigFile: TextFile;
  HConfigFileContent: string;
  HFile: string;
  HPath: string;
  HCommand: string;
  HOutputTemp: string;
  HOutput: TStringList;
begin
  if not FileExists(GetAppConfigFile(False)) then
  begin
    ShowMessage('Please update Settings');
  end
  else
  begin
    HOutput := TStringList.Create;
    AssignFile(HConfigFile, GetAppConfigFile(False));
    try
      Reset(HConfigFile);
      ReadLn(HConfigFile, HConfigFileContent);
    finally
      CloseFile(HConfigFile);
    end;
    try
      for HFile in ListBoxFiles.Items do
      begin
        HPath := ExtractFileDir(HFile);
        HCommand := StringReplace(HConfigFileContent, '$commandoooo$',
          HFile, [rfReplaceAll]);
{$IFDEF Windows}
        RunCommandIndir(HPath, 'C:\Windows\System32\cmd.exe',
          ['/c "' + HCommand + '"'], HOutputTemp);
{$ENDIF Windows}
{$IFDEF Unix}
        RunCommandIndir(HPath, HCommand, HOutput);
{$ENDIF Unix}
        HOutput.Add('commandoooo: ' + HCommand);
        HOutput.Add(HOutputTemp);
        HOutput.SaveToFile(IncludeTrailingPathDelimiter(HPath) + 'commandoooo.log');
      end;
    except
      on E: Exception do
        ShowMessage('Error occurred: ' + E.Message);
    end;
    FreeAndNil(HOutput);
  end;
  ShowMessage('Done!');
end;

end.
