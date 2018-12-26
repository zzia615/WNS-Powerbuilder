$PBExportHeader$nvo_inetresult.sru
forward
global type nvo_inetresult from internetresult
end type
end forward

global type nvo_inetresult from internetresult
end type
global nvo_inetresult nvo_inetresult

type variables
private:
struct_inetdata is_inetData

end variables

forward prototypes
public function integer internetdata (blob data)
public function integer internetstatus (string status)
public function struct_inetdata of_getdata ()
end prototypes

public function integer internetdata (blob data); is_inetData.data = data
 is_inetData.stringdata = string(data)
 return 1
end function

public function integer internetstatus (string status);is_inetData.status = status
return 1
end function

public function struct_inetdata of_getdata ();return is_inetData
end function

on nvo_inetresult.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_inetresult.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

