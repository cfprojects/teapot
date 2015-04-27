<cfimport 
	taglib =	"../../../system/ct"  
	prefix =	"ct">
<ct:quickCheck>
<cfif FileExists("#application.wh#UserImages/#url.img#")>
	<cffile action="delete" file="#application.wh#UserImages/#url.img#">
	<cfset session.msg ="Image Removed">
</cfif>

<cfset thumbname = "thumb_#listdeleteat(url.img,listlen(url.img,'.'),'.')#.jpg">
<cfif FileExists("#application.wh#UserImages/_thumb/#thumbname#")>
	<cffile action="delete" file="#application.wh#UserImages/_thumb/#thumbname#">
</cfif>
