unit bluetooth;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, bluetoothclientsocket, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/15/2014 12:37:34]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TOnDeviceFound = procedure(Sender: TObject; deviceName: string; deviceAddress: string) of Object;
TOnDiscoveryFinished = procedure(Sender: TObject; countFoundedDevices: integer; countPairedDevices: integer) of Object;

TOnDeviceBondStateChanged= procedure(Sender: TObject; state: integer; deviceName: string; deviceAddress: string) of Object;

TBondState = ( bsNone {10/Unpaired}, bsBonding {11/Pairing}, bsBonded{12/Paired});


{jControl template}

jBluetooth = class(jControl)
 private

    FOnEnabled: TOnNotify;
    FOnDisabled: TOnNotify;
    FOnDeviceFound: TOnDeviceFound;
    FOnDiscoveryStarted: TOnNotify;
    FOnDiscoveryFinished: TOnDiscoveryFinished;
    FOnDeviceBondStateChanged: TOnDeviceBondStateChanged;

    FSocket: jBluetoothClientSocket;

    procedure SetSocket(Value: jBluetoothClientSocket);

 protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Enabled();
    procedure Discovery();
    procedure CancelDiscovery();
    function GetPairedDevices(): TDynArrayOfString;
    function GetFoundedDevices(): TDynArrayOfString;
    function GetReachablePairedDevices(): TDynArrayOfString;
    procedure Disable();
    function IsEnable(): boolean;
    function GetState(): integer;
    procedure ShareFromSdCardFile(_filename: string);
    procedure ShareFromFile(_filename: string);

    function GetReachablePairedDeviceByName(_deviceName: string): jObject;
    function GetReachablePairedDeviceByAddress(_deviceAddress: string): jObject;

    function IsReachablePairedDevice(_macAddress: string): boolean;
    function GetRemoteDevice(_macAddress: string): jObject;


    procedure GenEvent_OnBluetoothEnabled(Obj: TObject);
    procedure GenEvent_OnBluetoothDisabled(Obj: TObject);
    procedure GenEvent_OnBluetoothDeviceFound(Obj: TObject; _deviceName: string; _deviceAddress: string);
    procedure GenEvent_OnBluetoothDiscoveryStarted(Obj: TObject);
    procedure GenEvent_OnBluetoothDiscoveryFinished(Obj: TObject; countFoundedDevices: integer; countPairedDevices: integer);
    procedure GenEvent_OnBluetoothDeviceBondStateChanged(Obj: TObject; state: integer; _deviceName: string; _deviceAddress: string);

    function GetBondState(state: integer):TBondState;

    procedure SetDeviceByAddress(_deviceAddress: string);
    procedure SetDeviceByName(_deviceName: string);

 published
    property Socket: jBluetoothClientSocket read FSocket write SetSocket;

    property OnEnabled: TOnNotify read FOnEnabled write FOnEnabled;
    property OnDisabled: TOnNotify read FOnDisabled write FOnDisabled;

    property OnDeviceFound: TOnDeviceFound read FOnDeviceFound write FOnDeviceFound;
    property OnDiscoveryStarted: TOnNotify read FOnDiscoveryStarted write FOnDiscoveryStarted;
    property OnDiscoveryFinished: TOnDiscoveryFinished read FOnDiscoveryFinished write FOnDiscoveryFinished;
    property OnDeviceBondStateChanged: TOnDeviceBondStateChanged read FOnDeviceBondStateChanged write FOnDeviceBondStateChanged;

end;

function jBluetooth_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jBluetooth_jFree(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
procedure jBluetooth_Enabled(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
procedure jBluetooth_Discovery(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
procedure jBluetooth_CancelDiscovery(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
function jBluetooth_GetPairedDevices(env: PJNIEnv; this: JObject; _jbluetooth: JObject): TDynArrayOfString;
function jBluetooth_GetFoundedDevices(env: PJNIEnv; this: JObject; _jbluetooth: JObject): TDynArrayOfString;
function jBluetooth_GetReachablePairedDevices(env: PJNIEnv; this: JObject; _jbluetooth: JObject): TDynArrayOfString;
procedure jBluetooth_Disable(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
function jBluetooth_IsEnable(env: PJNIEnv; this: JObject; _jbluetooth: JObject): boolean;
function jBluetooth_GetState(env: PJNIEnv; this: JObject; _jbluetooth: JObject): integer;
procedure jBluetooth_ShareFromSdCardFile(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _filename: string);
procedure jBluetooth_ShareFromFile(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _filename: string);
function jBluetooth_GetReachablePairedDeviceByName(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _deviceName: string): jObject;
function jBluetooth_GetReachablePairedDeviceByAddress(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _deviceAddress: string): jObject;
function jBluetooth_IsReachablePairedDevice(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _macAddress: string): boolean;
function jBluetooth_GetRemoteDevice(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _macAddress: string): jObject;


implementation

{---------  jBluetooth  --------------}

constructor jBluetooth.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jBluetooth.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
      end;
    end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jBluetooth.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
end;


function jBluetooth.jCreate(): jObject;
begin
   Result:= jBluetooth_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jBluetooth.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetooth.Enabled();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_Enabled(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetooth.Discovery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_Discovery(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetooth.CancelDiscovery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_CancelDiscovery(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jBluetooth.GetPairedDevices(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetPairedDevices(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jBluetooth.GetFoundedDevices(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetFoundedDevices(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jBluetooth.GetReachablePairedDevices(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetReachablePairedDevices(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetooth.Disable();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_Disable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jBluetooth.IsEnable(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_IsEnable(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

function jBluetooth.GetState(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetState(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetooth.ShareFromSdCardFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_ShareFromSdCardFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _filename);
end;

procedure jBluetooth.ShareFromFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_ShareFromFile(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _filename);
end;

function jBluetooth.GetReachablePairedDeviceByName(_deviceName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result:= jBluetooth_GetReachablePairedDeviceByName(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _deviceName);
end;

function jBluetooth.GetReachablePairedDeviceByAddress(_deviceAddress: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetReachablePairedDeviceByAddress(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _deviceAddress);
end;


function jBluetooth.IsReachablePairedDevice(_macAddress: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_IsReachablePairedDevice(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _macAddress);
end;

function jBluetooth.GetRemoteDevice(_macAddress: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetRemoteDevice(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _macAddress);
end;

procedure jBluetooth.SetDeviceByName(_deviceName: string);
begin
   if FSocket <> nil then
   begin
     FSocket.SetDevice(Self.GetReachablePairedDeviceByName(_deviceName));
   end;
end;

procedure jBluetooth.SetDeviceByAddress(_deviceAddress: string);
begin
   if FSocket <> nil then FSocket.SetDevice(Self.GetReachablePairedDeviceByAddress(_deviceAddress));
end;

procedure jBluetooth.GenEvent_OnBluetoothEnabled(Obj: TObject);
begin
   if Assigned(FOnEnabled) then FOnEnabled(Obj);
end;

procedure jBluetooth.GenEvent_OnBluetoothDisabled(Obj: TObject);
begin
   if Assigned(FOnDisabled) then FOnDisabled(Obj);
end;

procedure jBluetooth.GenEvent_OnBluetoothDeviceFound(Obj: TObject; _deviceName: string; _deviceAddress: string);
begin
   if Assigned(FOnDeviceFound) then FOnDeviceFound(Obj,_deviceName, _deviceAddress);
end;

procedure jBluetooth.GenEvent_OnBluetoothDiscoveryStarted(Obj: TObject);
begin
   if Assigned(FOnDiscoveryStarted) then FOnDiscoveryStarted(Obj);
end;

procedure jBluetooth.GenEvent_OnBluetoothDiscoveryFinished(Obj: TObject; countFoundedDevices: integer; countPairedDevices: integer);
begin
   if Assigned(FOnDiscoveryFinished) then FOnDiscoveryFinished(Obj, countFoundedDevices, countPairedDevices);
end;

procedure jBluetooth.GenEvent_OnBluetoothDeviceBondStateChanged(Obj: TObject; state: integer; _deviceName: string; _deviceAddress: string);
begin
   if Assigned(FOnDeviceBondStateChanged) then FOnDeviceBondStateChanged(Obj, state, _deviceName, _deviceAddress);
end;

//TBondState = ( bsNone {10/Unpaired}, bsBonding {11/Pairing}, bsBonded{12/Paired});
function jBluetooth.GetBondState(state: integer):TBondState;
begin
  Result:= bsNone; //10
  case state of
     11: Result:= bsBonding;
     12: Result:= bsBonded;
  end;
end;

procedure jBluetooth.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FSocket then
      begin
        FSocket:= nil;
      end
  end;
end;

procedure jBluetooth.SetSocket(Value: jBluetoothClientSocket);
begin
  if Value <> FSocket then
  begin
    if Assigned(FSocket) then
    begin
       FSocket.RemoveFreeNotification(Self); //remove free notification...
    end;
    FSocket:= Value;
    if Value <> nil then  //re- add free notification...
    begin
       Value.FreeNotification(self);
    end;
  end;
end;

{-------- jBluetooth_JNI_Bridge ----------}

function jBluetooth_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jBluetooth_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jBluetooth_jCreate(long _Self) {
      return (java.lang.Object)(new jBluetooth(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jBluetooth_jFree(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
end;

procedure jBluetooth_Enabled(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'Enabled', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
end;

procedure jBluetooth_Discovery(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'Discovery', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
end;

procedure jBluetooth_CancelDiscovery(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'CancelDiscovery', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
end;

function jBluetooth_GetPairedDevices(env: PJNIEnv; this: JObject; _jbluetooth: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPairedDevices', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jbluetooth, jMethod);
  resultsize:= env^.GetArrayLength(env, jresultArray);
  SetLength(Result, resultsize);
  for i:= 0 to resultsize - 1 do
  begin
    jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
    case jStr = nil of
       True : Result[i]:= '';
       False: begin
               jBoo:= JNI_False;
               Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
              end;
    end;
  end;
end;

function jBluetooth_GetFoundedDevices(env: PJNIEnv; this: JObject; _jbluetooth: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFoundedDevices', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jbluetooth, jMethod);
  resultsize:= env^.GetArrayLength(env, jresultArray);
  SetLength(Result, resultsize);
  for i:= 0 to resultsize - 1 do
  begin
    jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
    case jStr = nil of
       True : Result[i]:= '';
       False: begin
               jBoo:= JNI_False;
               Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
              end;
    end;
  end;
end;

function jBluetooth_GetReachablePairedDevices(env: PJNIEnv; this: JObject; _jbluetooth: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReachablePairedDevices', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jbluetooth, jMethod);
  resultsize:= env^.GetArrayLength(env, jresultArray);
  SetLength(Result, resultsize);
  for i:= 0 to resultsize - 1 do
  begin
    jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
    case jStr = nil of
       True : Result[i]:= '';
       False: begin
               jBoo:= JNI_False;
               Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
              end;
    end;
  end;
end;

procedure jBluetooth_Disable(env: PJNIEnv; this: JObject; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'Disable', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
end;

function jBluetooth_IsEnable(env: PJNIEnv; this: JObject; _jbluetooth: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'IsEnable', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetooth, jMethod);
  Result:= boolean(jBoo);
end;

function jBluetooth_GetState(env: PJNIEnv; this: JObject; _jbluetooth: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetState', '()I');
  Result:= env^.CallIntMethod(env, _jbluetooth, jMethod);
end;

procedure jBluetooth_ShareFromSdCardFile(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'ShareFromSdCardFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jBluetooth_ShareFromFile(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'ShareFromFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

function jBluetooth_GetReachablePairedDeviceByName(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _deviceName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_deviceName));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReachablePairedDeviceByName', '(Ljava/lang/String;)Landroid/bluetooth/BluetoothDevice;');
  Result:= env^.CallObjectMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

function jBluetooth_GetReachablePairedDeviceByAddress(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _deviceAddress: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_deviceAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReachablePairedDeviceByAddress', '(Ljava/lang/String;)Landroid/bluetooth/BluetoothDevice;');
  Result:= env^.CallObjectMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

function jBluetooth_IsReachablePairedDevice(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _macAddress: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_macAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'IsReachablePairedDevice', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jbluetooth, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
end;


function jBluetooth_GetRemoteDevice(env: PJNIEnv; this: JObject; _jbluetooth: JObject; _macAddress: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_macAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetRemoteDevice', '(Ljava/lang/String;)Landroid/bluetooth/BluetoothDevice;');
  Result:= env^.CallObjectMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

end.