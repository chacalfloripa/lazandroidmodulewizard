unit uformworkspace;

{$mode objfpc}{$H+}

interface

uses
  inifiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LazIDEIntf,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, FormPathMissing;

type

  { TFormWorkspace }

  TFormWorkspace  = class(TForm)
    bbOK: TBitBtn;
    Bevel1: TBevel;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit8: TEdit;
    edProjectName: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StatusBar1: TStatusBar;

    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);

    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox2SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox3Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);

  private
    { private declarations }
    FFilename: string;
    FPathToWorkspace: string; {C:\adt32\eclipse\workspace}
    FPathToNdkPlataforms: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}

    FInstructionSet: string;      {ArmV6}
    FFPUSet: string;              {Soft}
    FPathToJavaTemplates: string;
    FAndroidProjectName: string;

    FPathToJavaJDK: string;
    FPathToAndroidSDK: string;
    FPathToAndroidNDK: string;
    FPathToAntBin: string;
    FPathToLazbuild: string;

    FProjectModel: string;
    FAntPackageName: string;

    FMinApi: string;
    FTargetApi: string;

    FTouchtestEnabled: string;
    FAntBuildMode: string;
    FMainActivity: string;   //Simon "App"
    FNDK: string;
    FAndroidPlatform: string;

  public
    { public declarations }
    procedure LoadSettings(const pFilename: string);
    procedure SaveSettings(const pFilename: string);
    function GetTextByListIndex(index:integer): string;
    function GetTextByList2Index(index:integer): string;
    function GetNDKPlatform(identName: string): string;

    procedure LoadPathsSettings(const fileName: string);

    property PathToWorkspace: string read FPathToWorkspace write FPathToWorkspace;
    property PathToNdkPlataforms: string
                                                      read FPathToNdkPlataforms
                                                      write FPathToNdkPlataforms;
    property InstructionSet: string read FInstructionSet write FInstructionSet;
    property FPUSet: string  read FFPUSet write FFPUSet;
    property PathToJavaTemplates: string read FPathToJavaTemplates write FPathToJavaTemplates;
    property AndroidProjectName: string read FAndroidProjectName write FAndroidProjectName;

    property PathToJavaJDK: string read FPathToJavaJDK write FPathToJavaJDK;
    property PathToAndroidSDK: string read FPathToAndroidSDK write FPathToAndroidSDK;
    property PathToAndroidNDK: string read FPathToAndroidNDK write FPathToAndroidNDK;
    property PathToAntBin: string read FPathToAntBin write FPathToAntBin;
    property ProjectModel: string read FProjectModel write FProjectModel; {eclipse/ant/jbridge}
    property AntPackageName: string read FAntPackageName write FAntPackageName;
    property MinApi: string read FMinApi write FMinApi;
    property TargetApi: string read FTargetApi write FTargetApi;
    property TouchtestEnabled: string read FTouchtestEnabled write FTouchtestEnabled;
    property AntBuildMode: string read FAntBuildMode write FAntBuildMode;
    property MainActivity: string read FMainActivity write FMainActivity;
    property NDK: string read FNDK write FNDK;
    property AndroidPlatform: string read FAndroidPlatform write FAndroidPlatform;
  end;

  procedure GetSubDirectories(const directory : string; list : TStrings);
  function ReplaceChar(query: string; oldchar, newchar: char):string;
  function TrimChar(query: string; delimiter: char): string;

var
   FormWorkspace: TFormWorkspace;

implementation

{$R *.lfm}

{ TFormWorkspace }

procedure TFormWorkspace.ListBox1Click(Sender: TObject);
begin
    FMinApi:= ListBox1.Items.Strings[ListBox1.ItemIndex]
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByListIndex(index:integer): string;
begin
   Result:= '';
   case index of
     0: Result:= '100% market sharing'; // Api(8)    -Froyo 2.2
     1: Result:= '99.3% market sharing'; // Api(10)  -Gingerbread 2.3
     2: Result:= '87.9% market sharing'; // Api(15)  -Ice Cream 4.0x
     3: Result:= '78.3% market sharing'; // Api(16)  -Jelly Bean 4.1
     4: Result:= '53.2% market sharing'; // Api(17)  -Jelly Bean 4.2
     5: Result:= '32.5% market sharing'; // Api(18)  -Jelly Bean 4.3
     6: Result:= '24.5% market sharing'; // Api(19)  -KitKat 4.4
   end;
end;

//http://developer.android.com/about/dashboards/index.html
function TFormWorkspace.GetTextByList2Index(index:integer): string;
begin
   Result:= 'KitKat 4.4';
   case index of
     0: Result:= 'Froyo 2.2';        //0.7%  -  Api:8     100-0   =  100.0
     1: Result:= 'Gingerbread 2.3';  //11.4% -  Api:10    100-0.7 =   99.3
     2: Result:= 'Ice Cream 4.0x';   //9.6%  -  Api:15    99.3-11.4 = 87.9
     3: Result:= 'Jelly Bean 4.1';   //25.1% -  Api:16    87.9-9.6  = 78.3
     4: Result:= 'Jelly Bean 4.2';   //20.7% -  Api:17    78.3-25.1 = 53.2
     5: Result:= 'Jelly Bean 4.3';   //8.0%  -  Api:18    53.2-20.7 = 32.5
     6: Result:= 'KitKat 4.4';       //24.5% -  Api:19    32.5-8.0  = 24.5
   end;
end;


procedure TFormWorkspace.ListBox1SelectionChange(Sender: TObject; User: boolean);
begin
    //StatusBar1.SimpleText:= GetTextByListIndex(ListBox1.ItemIndex);
    StatusBar1.Panels.Items[0].Text:= 'MinSdk Api: '+GetTextByListIndex(ListBox1.ItemIndex);
end;

procedure TFormWorkspace.ListBox2Click(Sender: TObject);
begin
  case ListBox2.ItemIndex of
      0: FTargetApi:= '8';
      1: FTargetApi:= '10';
      2: FTargetApi:= '14';
      3: FTargetApi:= '15';
      4: FTargetApi:= '16';
      5: FTargetApi:= '17';
      6: FTargetApi:= '18';
      7: FTargetApi:= '19';
      8: FTargetApi:= '20';
      9: FTargetApi:= '21';
  end
end;

procedure TFormWorkspace.ListBox2SelectionChange(Sender: TObject; User: boolean);
begin
  StatusBar1.Panels.Items[1].Text:='Target Api: '+GetTextByList2Index(ListBox2.ItemIndex);
end;

procedure TFormWorkspace.ListBox3Click(Sender: TObject);
var
   saveIndex: integer;
begin
   saveIndex:=ListBox1.ItemIndex;
   ListBox1.Clear;
   if ListBox3.ItemIndex = 0 then
   begin
     ListBox1.Items.Add('8');
     //ListBox1.Items.Add('10');
     //ListBox1.Items.Add('14');
   end
   else if ListBox3.ItemIndex = 1 then
   begin
     ListBox1.Items.Add('8');
     ListBox1.Items.Add('10');
     //ListBox1.Items.Add('14');
   end
   else
   begin
     ListBox1.Items.Add('8');
     ListBox1.Items.Add('10');
     //ListBox1.Items.Add('14');
     ListBox1.Items.Add('15');
     ListBox1.Items.Add('16');
     ListBox1.Items.Add('17');
     ListBox1.Items.Add('18');
     ListBox1.Items.Add('19');
   end;

   if saveIndex < ListBox1.Count then
      ListBox1.ItemIndex:= saveIndex
   else
      ListBox1.ItemIndex:= ListBox1.Count-1;

   ListBox1Click(nil);
end;

procedure TFormWorkspace.RadioGroup1Click(Sender: TObject);
begin
  FInstructionSet:= RadioGroup1.Items[RadioGroup1.ItemIndex];  //fix 15-december-2013
end;

procedure TFormWorkspace.RadioGroup2Click(Sender: TObject);
begin
  FFPUSet:= RadioGroup2.Items[RadioGroup2.ItemIndex];  //fix 15-december-2013
end;

procedure TFormWorkspace.RadioGroup3Click(Sender: TObject);
begin
  FProjectModel:= RadioGroup3.Items[RadioGroup3.ItemIndex];  //fix 15-december-2013
end;

function TFormWorkspace.GetNDKPlatform(identName: string): string;
begin
    Result:= 'android-14'; //default
         if identName = 'Froyo'          then Result:= 'android-8'
    else if identName = 'Gingerbread'    then Result:= 'android-13'
    else if identName = 'Ice Cream 4.0x' then Result:= 'android-15'
    else if identName = 'Jelly Bean 4.1' then Result:= 'android-16'
    else if identName = 'Jelly Bean 4.2' then Result:= 'android-17'
    else if identName = 'Jelly Bean 4.3' then Result:= 'android-18'
    else if identName = 'KitKat 4.4'     then Result:= 'android-19';
end;

procedure TFormWorkspace.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
   strList: TStringList;
   count, i, j: integer;
   path: string;
begin
  if ModalResult = mrCancel  then Exit;

  if Edit1.Text = '' then
  begin
    ShowMessage('Error! Workplace Path was missing....[Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if ComboBox1.Text = '' then
  begin
    ShowMessage('Error! Projec Name was missing.... [Cancel]');
    ModalResult:= mrCancel;
    Exit;
  end;

  if Edit8.Text = '' then Edit8.Text:= 'org.lazarus';

  Self.LoadPathsSettings(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');

  FMainActivity:= 'App'; {dummy for Simon template} //TODO: need name flexibility here...

  FAntPackageName:= LowerCase(Trim(Edit8.Text));

  FPathToWorkspace:= Edit1.Text;
  FAndroidProjectName:= Trim(ComboBox1.Text);
  FAndroidPlatform:= GetNDKPlatform(ListBox3.Items.Strings[ListBox3.ItemIndex]);

  if FProjectModel <> 'Ant' then
  begin
      strList:= TStringList.Create;
      path:= FAndroidProjectName+DirectorySeparator+'src';
      GetSubDirectories(path, strList);
      count:= strList.Count;
      while count > 0 do
      begin
         path:= strList.Strings[0];
         strList.Clear;
         GetSubDirectories(path, strList);
         count:= strList.Count;
      end;
      strList.Clear;
      strList.Delimiter:= DirectorySeparator;
      strList.DelimitedText:= path;
      i:= 0;
      path:=strList.Strings[i];
      while path <> 'src' do
      begin
         i:= i+1;
         path:= strList.Strings[i];
      end;
      path:='';
      for j:= (i+1) to strList.Count-2 do
      begin
         path:= path + '.' + strList.Strings[j];
      end;
      FAntPackageName:= TrimChar(path, '.');
      strList.Free;
  end;

  if RadioGroup3.ItemIndex = 1 then  //Ant Project
  begin
     FProjectModel:= 'Ant';
     if (Pos(DirectorySeparator, ComboBox1.Text) = 0) then  //i.e just "name", not path+name
     begin
         FAndroidProjectName:= FPathToWorkspace + DirectorySeparator + ComboBox1.Text; //get full name: path+name
         {$I-}
         ChDir(FPathToWorkspace+DirectorySeparator+ComboBox1.Text);
         if IOResult <> 0 then MkDir(FPathToWorkspace+DirectorySeparator+ComboBox1.Text);
     end;
  end;

  SaveSettings(FFileName);

end;

procedure TFormWorkspace.LoadPathsSettings(const fileName: string);
var
   indexNdk: integer;
   frm: TFormPathMissing;
   testPath: string;
begin
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    begin

      FPathToJavaJDK:= ReadString('NewProject','PathToJavaJDK', '');

      if  FPathToJavaJDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Java JDK: [ex. C:\Program Files (x86)\Java\jdk1.7.0_21]';
          if frm.ShowModal = mrOK then  FPathToJavaJDK:= frm.PathMissing;
          frm.Free;
      end;

      FPathToAntBin:= ReadString('NewProject','PathToAntBin', '');

      if  FPathToAntBin = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Ant bin: [ex. C:\adt32\ant\bin]';
          if frm.ShowModal = mrOK then  FPathToAntBin:= frm.PathMissing;
          frm.Free;
      end;

      FPathToAndroidSDK:= ReadString('NewProject','PathToAndroidSDK', '');

      if  FPathToAndroidSDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Android SDK: [ex. C:\adt32\sdk]';
          if frm.ShowModal = mrOK then  FPathToAndroidSDK:= frm.PathMissing;
          frm.Free;
      end;

      FPathToAndroidNDK:= ReadString('NewProject','PathToAndroidNDK', '');

      if  FPathToAndroidNDK = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Android NDK:  [ex. C:\adt32\ndk10]';
          if frm.ShowModal = mrOK then  FPathToAndroidNDK:= frm.PathMissing;
          frm.Free;
      end;

      if ReadString('NewProject','NDK', '') <> '' then
          indexNdk:= StrToInt(ReadString('NewProject','NDK', ''))
      else
          indexNdk:= 2;  //ndk 10   ... default

      case indexNdk of
         0: FNDK:= '7';
         1: FNDK:= '9';
         2: FNDK:= '10';
      end;

      FPathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      if  FPathToJavaTemplates = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Java templates: [ex. ..\LazAndroidWizard\java]';
          if frm.ShowModal = mrOK then  FPathToJavaTemplates:= frm.PathMissing;
          frm.Free;
      end;

      FPathToLazbuild:= ReadString('NewProject','PathToLazbuild', '');

      if  FPathToLazbuild = '' then
      begin
          frm:= TFormPathMissing.Create(nil);
          frm.LabelPathTo.Caption:= 'WARNING! Path to Lazbuild: [ex. C:\Laz4Android]';
          if frm.ShowModal = mrOK then  FPathToLazbuild:= frm.PathMissing;
          frm.Free;
      end;

      Free;
    end;
  end;
end;

procedure TFormWorkspace.FormActivate(Sender: TObject);
begin
  ComboBox1.SetFocus;
  StatusBar1.Panels.Items[0].Text:= 'MinSdk Api: '+GetTextByListIndex(ListBox1.ItemIndex);
  StatusBar1.Panels.Items[1].Text:= 'Target Api: '+GetTextByList2Index(ListBox2.ItemIndex);
end;

procedure TFormWorkspace.SpeedButton1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    Edit1.Text := SelectDirectoryDialog1.FileName;
    FPathToWorkspace:= SelectDirectoryDialog1.FileName;
    ComboBox1.Items.Clear;
    GetSubDirectories(FPathToWorkspace, ComboBox1.Items);

    //try some guesswork:
    if Pos('eclipse', LowerCase(FPathToWorkspace) ) > 0 then
    begin
      RadioGroup3.ItemIndex:= 0;
      Edit8.Text:='';
    end;

    if Pos('ant', LowerCase(FPathToWorkspace) ) > 0 then
       RadioGroup3.ItemIndex:= 1;

  end;
end;

procedure TFormWorkspace.SpeedButton2Click(Sender: TObject);
begin
  FPathToWorkspace:= Edit1.Text;
  ComboBox1.Items.Clear;
  GetSubDirectories(FPathToWorkspace, ComboBox1.Items);

  //try some guesswork:
  if Pos('eclipse', LowerCase(FPathToWorkspace) ) > 0 then
  begin
    RadioGroup3.ItemIndex:= 0;
    Edit8.Text:='';
  end;

  if Pos('ant', LowerCase(FPathToWorkspace) ) > 0 then
     RadioGroup3.ItemIndex:= 1;
end;

procedure TFormWorkspace.LoadSettings(const pFilename: string);
var
  i1, i2, i3, i5, j1, j2, j3: integer;
begin
  FFileName:= pFilename;
  with TIniFile.Create(pFilename) do
  begin
    FPathToWorkspace:= ReadString('NewProject','PathToWorkspace', '');
    FAntPackageName:= ReadString('NewProject','AntPackageName', '');

    FAntBuildMode:= 'debug'; //default...
    FTouchtestEnabled:= 'True'; //default

    FMainActivity:= ReadString('NewProject','MainActivity', '');  //dummy
    if FMainActivity = '' then FMainActivity:= 'App';

    if ReadString('NewProject','NDK', '') <> '' then
      i5:= strToInt(ReadString('NewProject','NDK', ''))
    else i5:= 2;  //ndk 10

    ListBox3.Clear;
    if i5 > 0 then //not ndk7
    begin
      ListBox3.Items.Add('Froyo');
      ListBox3.Items.Add('Gingerbread');
      ListBox3.Items.Add('Ice Cream 4.0x');
      ListBox3.Items.Add('Jelly Bean 4.1');
      ListBox3.Items.Add('Jelly Bean 4.2');
      ListBox3.Items.Add('Jelly Bean 4.3');
      ListBox3.Items.Add('KitKat 4.4');
    end
    else
    begin  //just ndk7
      ListBox3.Items.Add('Froyo');
      ListBox3.Items.Add('Gingerbread');
      ListBox3.Items.Add('Ice Cream 4.0');  //Android-14
    end;

    if ReadString('NewProject','InstructionSet', '') <> '' then
       i1:= strToInt(ReadString('NewProject','InstructionSet', ''))
    else i1:= 0;

    if ReadString('NewProject','FPUSet', '') <> '' then
       i2:= strToInt(ReadString('NewProject','FPUSet', ''))
    else i2:= 0;

    if ReadString('NewProject','ProjectModel', '') <> '' then
       i3:= strToInt(ReadString('NewProject','ProjectModel', ''))
    else i3:= 0;

    if ReadString('NewProject','MinApi', '') <> '' then
       j1:= strToInt(ReadString('NewProject','MinApi', ''))
    else j1:= 2; // Api 14

    if  j1 < ListBox1.Items.Count then
        ListBox1.ItemIndex:= j1
    else
       ListBox1.ItemIndex:= ListBox1.Items.Count-1;

    if ReadString('NewProject','AndroidPlatform', '') <> '' then
       j2:= strToInt(ReadString('NewProject','AndroidPlatform', ''))
    else j2:= 2; // Android-14

    ListBox3.ItemIndex:= j2;
    ListBox3Click(nil); //update ListBox1


    FAndroidPlatform:=  GetNDKPlatform(ListBox3.Items.Strings[ListBox3.ItemIndex]);

    if ReadString('NewProject','TargetApi', '') <> '' then
       j3:= strToInt(ReadString('NewProject','TargetApi', ''))
    else j3:= 2; // Api 14

    if  j3 < ListBox2.Items.Count then
        ListBox2.ItemIndex:= j3
    else
       ListBox2.ItemIndex:= ListBox2.Items.Count-1;

    ComboBox1.Items.Clear;
    GetSubDirectories(FPathToWorkspace, ComboBox1.Items);

    Free;
  end;

  RadioGroup1.ItemIndex:= i1;
  RadioGroup2.ItemIndex:= i2;

  if i3 > 1 then i3:= 0;
  RadioGroup3.ItemIndex:= i3;

  FInstructionSet:= RadioGroup1.Items[RadioGroup1.ItemIndex];
  FFPUSet:= RadioGroup2.Items[RadioGroup2.ItemIndex];
  FProjectModel:= RadioGroup3.Items[RadioGroup3.ItemIndex]; //Eclipse Project or Ant Project

  FMinApi:= ListBox1.Items[ListBox1.ItemIndex];
  FTargetApi:= ListBox2.Items[ListBox2.ItemIndex];

  Edit1.Text := FPathToWorkspace;

  Edit8.Text := FAntPackageName;
end;

procedure TFormWorkspace.SaveSettings(const pFilename: string);
begin
   with TInifile.Create(pFilename) do
   begin
      WriteString('NewProject', 'PathToWorkspace', Edit1.Text);

      WriteString('NewProject', 'FullProjectName', FAndroidProjectName);
      WriteString('NewProject', 'InstructionSet', IntToStr(RadioGroup1.ItemIndex));
      WriteString('NewProject', 'FPUSet', IntToStr(RadioGroup2.ItemIndex));

      WriteString('NewProject', 'ProjectModel',IntToStr(RadioGroup3.ItemIndex));  //Eclipse or Ant
      WriteString('NewProject', 'AntPackageName', LowerCase(Trim(Edit8.Text)));

      WriteString('NewProject', 'AndroidPlataform', IntToStr(ListBox3.ItemIndex));
      WriteString('NewProject', 'MinApi', IntToStr(ListBox1.ItemIndex));
      WriteString('NewProject', 'TargetApi', IntToStr(ListBox2.ItemIndex));

      WriteString('NewProject', 'AntBuildMode', 'debug'); //default...
      WriteString('NewProject', 'MainActivity', FMainActivity); //dummy

      Free;
   end;
end;

//helper...
function ReplaceChar(query: string; oldchar, newchar: char):string;
begin
  if query <> '' then
  begin
     while Pos(oldchar,query) > 0 do query[pos(oldchar,query)]:= newchar;
     Result:= query;
  end;
end;

function TrimChar(query: string; delimiter: char): string;
var
  auxStr: string;
  count: integer;
  newchar: char;
begin
  newchar:=' ';
  if query <> '' then
  begin
      auxStr:= Trim(query);
      count:= Length(auxStr);
      if count >= 2 then
      begin
         if auxStr[1] = delimiter then  auxStr[1] := newchar;
         if auxStr[count] = delimiter then  auxStr[count] := newchar;
      end;
      Result:= Trim(auxStr);
  end;
end;

//http://delphi.about.com/od/delphitips2008/qt/subdirectories.htm
//fils the "list" TStrings with the subdirectories of the "directory" directory
//Warning: if not  subdirectories was found return empty list [list.count = 0]!
procedure GetSubDirectories(const directory : string; list : TStrings);
var
   sr : TSearchRec;
begin
   try
     if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then Exit
     else
     repeat
       if ((sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..')) then
       begin
           List.Add(IncludeTrailingPathDelimiter(directory) + sr.Name);
       end;
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
end;

end.

