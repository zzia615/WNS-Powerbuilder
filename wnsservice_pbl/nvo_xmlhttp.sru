$PBExportHeader$nvo_xmlhttp.sru
forward
global type nvo_xmlhttp from nonvisualobject
end type
end forward

global type nvo_xmlhttp from nonvisualobject
end type
global nvo_xmlhttp nvo_xmlhttp

type variables
oleObject XMLHttp
private:
struct_xmlhttp httlResult
boolean ib_connected=false
end variables

forward prototypes
public subroutine of_open (string method, string url)
public subroutine of_setheader (string contenttype, string content)
public subroutine of_send (any data)
public function struct_xmlhttp of_get_response ()
end prototypes

public subroutine of_open (string method, string url);if not ib_connected then return 
XMLHttp.Open(method,url,true)
end subroutine

public subroutine of_setheader (string contenttype, string content);if not ib_connected then return 
XMLHttp.setRequestHeader(contenttype,content)
end subroutine

public subroutine of_send (any data);if not ib_connected then return 
try
	XMLHttp.Send(data)
	do while XMLHttp.readyState <> 4 
		yield()
	loop
	httlResult.Data = xmlHttp.responseText
	httlResult.Status = long(xmlHttp.Status)
catch(Exception e)
	httlResult.data = "请求发送异常"+e.Text
	Messagebox("提示",httlResult.data)
end try
end subroutine

public function struct_xmlhttp of_get_response ();return httlResult
end function

on nvo_xmlhttp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_xmlhttp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;XMLHttp = create oleObject
if XMLHttp.ConnectToNewObject("MSXML2.XMLHTTP")<>0 then 
	ib_connected = false
else
	ib_connected = true
end if 
end event

event destructor;if isvalid(XMLHttp) then 
	XMLHttp.DisconnectObject()
	destroy XMLHttp
end if 
end event

