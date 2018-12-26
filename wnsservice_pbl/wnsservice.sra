$PBExportHeader$wnsservice.sra
$PBExportComments$Generated Application Object
forward
global type wnsservice from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type wnsservice from application
string appname = "wnsservice"
end type
global wnsservice wnsservice

on wnsservice.create
appname="wnsservice"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on wnsservice.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_main)
end event

