$PBExportHeader$nvo_config.sru
forward
global type nvo_config from nonvisualobject
end type
end forward

global type nvo_config from nonvisualobject autoinstantiate
end type

type variables
string is_config = "wnsconfig.ini"
end variables

forward prototypes
public function string of_getconfig (string section, string item, string default)
public subroutine of_setconfig (string section, string item, string value)
end prototypes

public function string of_getconfig (string section, string item, string default);string ls_data
ls_data = profilestring(is_config,section,item,"")
if isnull(ls_data) or ls_data = "" then 
	SetProfilestring(is_config,section,item,default)
end if 
return profilestring(is_config,section,item,default)
end function

public subroutine of_setconfig (string section, string item, string value);SetProfilestring(is_config,section,item,value)

end subroutine

on nvo_config.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_config.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;long ll_fileNum
//校验文件是否存在
if not FileExists(is_config) then 
	ll_fileNum = FileOpen(is_config,StreamMode!,Write!,LockWrite!,Append!)
	if ll_fileNum<=0 then return
	FileClose(ll_fileNum)
end if 
end event

