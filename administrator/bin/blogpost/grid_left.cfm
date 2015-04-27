<cfimport 
	taglib =	"../../system/ct"  
	prefix =	"ct">

<ct:gridcalc>
<cfquery name="gget" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
	select #request.this.table#name as name, #request.this.table#id as id, valid from #request.this.table#
	where <cfif listlen(grid.searchlist)>#request.this.table#id in (#grid.searchlist#)<cfelse>#request.this.table#id = 0</cfif>
	order by id desc 
</cfquery>

<table cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td id="leftgrid" valign="top">
<ct:gridleft q="#gget#">
<ct:gridnavi q="#grid#">
</td><td valign="top">