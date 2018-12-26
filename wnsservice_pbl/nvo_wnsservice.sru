$PBExportHeader$nvo_wnsservice.sru
forward
global type nvo_wnsservice from nonvisualobject
end type
end forward

global type nvo_wnsservice from nonvisualobject
end type
global nvo_wnsservice nvo_wnsservice

type variables
struct_credential istr_credential
nvo_config config
string is_wns_url

string tile="wns/tile"
string toast="wns/toast"
string badge="wns/badge"
string raw="wns/raw"

end variables
forward prototypes
public function integer of_post (string ars_data, ref struct_inetdata astr_result)
private function integer of_get_accesstoken (ref struct_accesstoken astr_token)
public function integer of_get_token (ref struct_accesstoken astr_token)
public function integer of_post_wns (string token, string notifytype, string xml)
end prototypes

public function integer of_post (string ars_data, ref struct_inetdata astr_result);inet liNet
nvo_inetresult ln_result
string ls_header
long ll_length
int li_ret
blob lb_data
lb_data = blob(ars_data)
ll_length = len(lb_data)
ls_header = "Content-Type: " + &
		"application/x-www-form-urlencoded~n" + &
		"Content-Length: " + String( ll_length ) + "~n~n"
try
	li_ret = GetContextService("Internet",liNet)
	if li_ret<>1 then 
		Messagebox("提示","实例化Inet对象失败，错误代号"+string(li_ret))
		return -1
	end if 
	ln_result = create nvo_inetresult
	li_ret = liNet.postUrl(istr_credential.url,lb_data,ls_header,ln_result)
	if li_ret<>1 then 
		Messagebox("提示","POST请求失败")
		return -1
	end if 
	//获取返回值
	astr_result = ln_result.of_getData()
catch (Exception e)
	Messagebox("提示","程序发生异常"+e.Text)
	return -2
finally
	if isvalid(liNet) then destroy liNet
	if isvalid(ln_result) then destroy ln_result
end try

return 1
end function

private function integer of_get_accesstoken (ref struct_accesstoken astr_token);string ls_parms
string ls_result
blob lb_data
nvo_xmlHttp XmlHttp
struct_xmlHttp lstr_result
try
	XmlHttp = create nvo_xmlHttp
	//拼接参数
	ls_parms+="grant_type="+istr_credential.grant_type
	ls_parms+="&client_id="+istr_credential.client_id
	ls_parms+="&client_secret="+istr_credential.client_secret
	ls_parms+="&scope="+istr_credential.scope
	//Http请求
	lb_data = blob(ls_parms)
	XmlHttp.of_open("POST",istr_credential.Url)
	XmlHttp.of_setHeader("Content-Type","application/x-www-form-urlencoded")
	XmlHttp.of_setHeader("Content-Length",string(len(lb_data)))
	XmlHttp.of_Send(lb_data)

	lstr_result = XmlHttp.of_get_response()
catch(Exception e)
	return -1
finally
	if isvalid(XmlHttp) then destroy XmlHttp
end try

if lstr_result.Status<>200 then 
	Messagebox("提示","获取AccessToken失败~r~n错误代码:"+string(lstr_result.Status)+"~r~n错误原因:"+lstr_result.Data,StopSign!,OK!)
	return -1
end if 
debugbreak()
//返回200表示正常
//解析Json
SailJson json
json = create SailJson
json.parse(lstr_result.Data)
astr_token.token_type = json.getAttribute("token_type")
astr_token.access_token = json.getAttribute("access_token")
astr_token.expires_in = long(json.getAttribute("expires_in"))
//返回1
return 1
end function

public function integer of_get_token (ref struct_accesstoken astr_token);string ls_data
string ls_now
datetime ldt_end_dt
datetime ldt_now
int ts=0
ldt_now = datetime(today(),now())
ls_now = string(ldt_now,"yyyy-mm-dd hh:mm:ss")

astr_token.token_type = config.of_getconfig("accesstoken","token_type","")
astr_token.access_token = config.of_getconfig("accesstoken","access_token","")
astr_token.expires_in = long(config.of_getconfig("accesstoken","expires_in","86400"))
//取天数，默认1天
ts = astr_token.expires_in/(60*60*24)
ls_data = config.of_getconfig("accesstoken","start_sj","1900-01-01 00:00:00")
ldt_end_dt = DateTime(RelativeDate(date(left(ls_data,10)),ts),time(right(ls_data,8)))
//校验
if ldt_now>=ldt_end_dt then 
	if of_get_accesstoken(ref astr_token)<>1 then return -1
	//重新获取
	ldt_now = datetime(today(),now())
	ls_now = string(ldt_now,"yyyy-mm-dd hh:mm:ss")
	//写入配置
	config.of_setconfig("accesstoken","token_type",astr_token.token_type)
	config.of_setconfig("accesstoken","access_token",astr_token.access_token)
	config.of_setconfig("accesstoken","expires_in",string(astr_token.expires_in))
	config.of_setconfig("accesstoken","start_sj",ls_now)
end if 
return 1
end function

public function integer of_post_wns (string token, string notifytype, string xml);string ls_auth 
blob lb_data
string ls_contentType
string ls_url
struct_xmlhttp lstr_result
nvo_xmlhttp XmlHttp
lb_data = blob(xml)
ls_auth = "Bearer "+token
ls_url = istr_credential.url
if notifytype = raw then 
	ls_contentType = "application/octet-stream"
else
	ls_contentType = "text/xml"
end if 

try
	XmlHttp = create nvo_xmlhttp
	XmlHttp.of_open("POST",is_wns_url)
	XmlHttp.of_setHeader("Authorization",ls_auth)
	XmlHttp.of_setHeader("Content-Type",ls_contentType)
	XmlHttp.of_setHeader("Content-Length",string(len(lb_data)))
	XmlHttp.of_setHeader("X-WNS-Type",notifytype)
	XmlHttp.of_setHeader("X-WNS-RequestForStatus","true")
	XmlHttp.of_send(lb_data)
	lstr_result = XmlHttp.of_get_Response()
catch(Exception e)
	return -1
finally
	if isvalid(XmlHttp) then destroy XmlHttp
end try
if lstr_result.status<>200 then 
	Messagebox("提示","发送消息失败~r~n错误信息:"+lstr_result.Data)
	return -1
end if 
Messagebox("提示","发送WNS推送成功~r~n"+lstr_result.Data)
return 1
end function

on nvo_wnsservice.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_wnsservice.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;string ls_config
//配置文件
istr_credential.url = config.of_getconfig("wnsservice","auth_url","https://login.live.com/accesstoken.srf")
istr_credential.grant_type = config.of_getconfig("wnsservice","grant_type","client_credentials")
istr_credential.client_id = config.of_getconfig("wnsservice","client_id","ms-app://s-1-15-2-1635968878-2709273150-4062749316-203191074-2711108347-2051327805-3653975296")
istr_credential.client_secret = config.of_getconfig("wnsservice","client_secret","wRjnj5PwN4FfXJn+OHlmh0rivYFHxjMC")
istr_credential.scope = config.of_getconfig("wnsservice","scope","notify.windows.com")
is_wns_url = config.of_getconfig("wnsservice","wns_url","https://login.microsoftonline.com/common/oauth2/nativeclient")

end event

