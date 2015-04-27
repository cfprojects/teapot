<cfprocessingdirective pageEncoding="utf-8">

<cfimport 
	taglib =	"../../system/ct"  
	prefix =	"ct">
<ct:quickCheck>

<cfparam name="local.preview"	default="No">

<cfquery name="thispost" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
	select blogpostid, created,url,blog,blogpostname,lastupdated from blogpost where 
	blogpostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(local.blogpostid)#">
</cfquery>

<cfif not YesNoFormat(local.preview)>
<!--- **************************************************** --->
<!--- create folders by the publish date                   --->
<!--- **************************************************** --->
	<cfif not DirectoryExists("#application.apath##dateformat(thispost.created,'yyyy')#")>
		<cfdirectory
			action 		= "create" 
			mode		= "#application.chomd#"
			directory 	= "#application.apath##dateformat(thispost.created,'yyyy')#/">
	</cfif>
	<cfif not DirectoryExists("#application.apath##dateformat(thispost.created,'yyyy')#/#dateformat(thispost.created,'mm')#")>
		<cfdirectory
			action 		= "create"
			mode		= "#application.chomd#"
			directory 	= "#application.apath##dateformat(thispost.created,'yyyy')#/#dateformat(thispost.created,'mm')#">
	</cfif>
	
	<cfif FileExists("#application.apath##dateformat(thispost.created,'yyyy')#/#dateformat(thispost.created,'mm')#/#trim(thispost.url)#.cfm")>
		<cffile action="delete" file="#application.apath##dateformat(thispost.created,'yyyy')#/#dateformat(thispost.created,'mm')#/#trim(thispost.url)#.cfm">
	</cfif>

	<!--- **************************************************** --->
	<!--- create index file for this month                     --->
	<!--- **************************************************** --->
	<cfif not FileExists("#application.apath##dateformat(thispost.created,'yyyy')#/#dateformat(thispost.created,'mm')#/index.cfm")>
<cfsavecontent variable="pageContent">
[cfprocessingdirective pageEncoding="utf-8"> 
[cfinclude template	= "../../teapot/library/global.cfm">
[cfset path			= ListDeleteAt(cgi.cf_template_path,listlen(cgi.cf_template_path,'\/'),'\/')>
[cfset thismonth	= listlast(path,'\/')>
[cfset thisyear		= listgetat(path,listlen(path,'\/')-1,'\/')>
[cfinclude template = "../../teapot/library/dsp_header.cfm">
[cfinclude template = "../../teapot/post/qry_fulllist.cfm">
[cfinclude template = "../../teapot/post/index.cfm">
[cfinclude template = "../../teapot/library/dsp_footer.cfm">
</cfsavecontent>
		<cfset pageContent = trim(replace(pageContent,'[cf','<cf','all'))>
		<cfset filePath = "#application.apath##dateformat(thispost.created,'yyyy')#/#dateformat(thispost.created,'mm')#/index.cfm">
		<cffile 
			action			="write"
			mode			="#application.chomd#" 
			nameconflict	="overwrite" 
			charset			="utf-8"
			file			="#filePath#" 
			output			="#pageContent#">
	</cfif>
</cfif>

<cfset stringOrginal 	= thispost.blog>
<cfset stringFixed		= stringOrginal>
<!--- **************************************************** --->
<!--- :: Plugin Include :: Formating                       --->
<!--- **************************************************** --->
<cfparam name="pluginfolder" default="#ExpandPath('./plugins/Formating')#">
<cfdirectory action="list" directory="#pluginfolder#" name="plugins" filter="plugin_*.cfm">
<cfloop query="plugins"><!---<cftry>---><cfinclude template="../../plugins/Formating/#plugins.name#" /><!---<cfcatch></cfcatch></cftry>---></cfloop>


<!--- **************************************************** --->
<!--- Preserve any '[CF' strings in the content            --->
<!--- **************************************************** --->
<cfset stringFixed	= replacenocase(stringFixed,'[cf','#chr(26)#cf','all')>
<!--- **************************************************** --->
<!--- Assemble the file and save                           --->
<!--- **************************************************** --->
<cfdirectory
	action 		= "list"
	directory 	= "#application.wh#posts/#thispost.blogpostid#/igallery/"
	type 		= "file"
	name 		= "ifilesChk" />
<cfoutput>
<cfsavecontent variable="pageContent">
[cfprocessingdirective pageEncoding="utf-8">
[cfset thispostid	= #thispost.blogpostid#>
[cfinclude template	="../../teapot/library/global.cfm">
[cfinclude template	="../../teapot/library/qry_thispost.cfm">
[cfinclude template = "../../teapot/library/dsp_header.cfm">
<div id="posts">
<H1 class="title">#trim(thispost.blogpostname)#</H1><div class="postdate">#dateformat(thispost.lastupdated,'dddd dd mmmm yyyy')# #timeformat(thispost.lastupdated,'hh:mm tt')#</div>
<div class="blog"><cfif ifilesChk.recordCount>[cfinclude template = "../../teapot/library/dsp_imageGallery.cfm"></cfif>#stringFixed#</div>
[cfinclude template="../../teapot/library/postfooter.cfm">
</div>
[cfinclude template="../../#application.warehouse#/widget_list.cfm">
[cfinclude template = "../../teapot/library/dsp_footer.cfm">
</cfsavecontent>
</cfoutput>

<cfset pageContent = replace(pageContent,'[cf','<cf','all')>
<cfset pageContent = replace(pageContent,'#chr(26)#cf','[cf','all')>

<cfif YesNoFormat(local.preview)>
	<cfset filePath = "#application.wh#preview/#trim(thispost.url)#.cfm">
<cfelse>
	<cfset filePath = "#application.apath##dateformat(thispost.created,'yyyy')#/#dateformat(thispost.created,'mm')#/#trim(thispost.url)#.cfm">
</cfif>

<cffile 
	action			="write"  
	mode			="#application.chomd#"
	nameconflict	="overwrite" 
	charset			="utf-8"
	file			="#filePath#" 
	output			="#pageContent#">