$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_3 from commandbutton within w_main
end type
type cb_close from commandbutton within w_main
end type
type cb_send from commandbutton within w_main
end type
type st_2 from statictext within w_main
end type
type st_1 from statictext within w_main
end type
type ddlb_1 from dropdownlistbox within w_main
end type
type mle_1 from multilineedit within w_main
end type
end forward

global type w_main from window
integer width = 3374
integer height = 1408
boolean titlebar = true
string title = "消息发送"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_3 cb_3
cb_close cb_close
cb_send cb_send
st_2 st_2
st_1 st_1
ddlb_1 ddlb_1
mle_1 mle_1
end type
global w_main w_main

forward prototypes
public subroutine of_example_toast ()
end prototypes

public subroutine of_example_toast ();string ls_xml
ls_xml+='<toast launch="">~r~n'
ls_xml+='  <visual lang="en-US">~r~n'
ls_xml+='    <binding template="ToastImageAndText01">~r~n'
ls_xml+='      <image id="1" src="World" />~r~n'
ls_xml+='      <text id="1">Hello</text>~r~n'
ls_xml+='    </binding>~r~n'
ls_xml+='  </visual>~r~n'
ls_xml+='</toast>'

mle_1.Text = ls_xml
end subroutine

on w_main.create
this.cb_3=create cb_3
this.cb_close=create cb_close
this.cb_send=create cb_send
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.mle_1=create mle_1
this.Control[]={this.cb_3,&
this.cb_close,&
this.cb_send,&
this.st_2,&
this.st_1,&
this.ddlb_1,&
this.mle_1}
end on

on w_main.destroy
destroy(this.cb_3)
destroy(this.cb_close)
destroy(this.cb_send)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.mle_1)
end on

event resize;cb_send.Y = newHeight - cb_send.Height - 10
cb_close.Y = cb_send.Y

mle_1.Width = newWidth - mle_1.X - 100
mle_1.Height = cb_close.Y - mle_1.Y - 10


end event

event open;ddlb_1.text = "wns/toast"
end event

type cb_3 from commandbutton within w_main
integer x = 1024
integer y = 16
integer width = 457
integer height = 128
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "样例"
end type

event clicked;if ddlb_1.text="wns/toast" then 
	of_example_toast()
end if 
end event

type cb_close from commandbutton within w_main
integer x = 914
integer y = 1120
integer width = 457
integer height = 128
integer taborder = 40
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "关闭"
end type

event clicked;close(parent)
end event

type cb_send from commandbutton within w_main
integer x = 366
integer y = 1120
integer width = 457
integer height = 128
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "发送"
end type

event clicked;nvo_wnsservice ln_service
struct_accesstoken lstr_token
string ls_xml,ls_wnsType
//获取XML
ls_xml = trim(mle_1.text)
ls_wnsType = ddlb_1.text

if isnull(ls_xml) or ls_xml="" then
	Messagebox("提示","发送内容不能为空，请输入！")
	mle_1.setfocus()
	return
end if 

try
	ln_service = create nvo_wnsservice
	//获取Token
	if ln_service.of_get_token(ref lstr_token)<>1 then return
	ln_service.of_post_wns(lstr_token.access_token,ls_wnsType,ls_xml)
catch(Exception e)
	MessageBox("异常",e.Text)
	return
finally
	destroy ln_service
end try
end event

type st_2 from statictext within w_main
integer x = 146
integer y = 160
integer width = 183
integer height = 80
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "内容"
boolean focusrectangle = false
end type

type st_1 from statictext within w_main
integer x = 146
integer y = 40
integer width = 183
integer height = 80
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "文本"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_main
integer x = 366
integer y = 32
integer width = 549
integer height = 452
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"wns/tile","wns/toast","wns/badge","wns/raw"}
borderstyle borderstyle = stylelowered!
end type

type mle_1 from multilineedit within w_main
integer x = 366
integer y = 160
integer width = 2816
integer height = 928
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

