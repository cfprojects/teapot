<cfcomponent displayname="Application" output="no">
	<cfset this.name 				= "teapot_blog">
	<cfset this.clientmanagement	= "no">
	<cfset this.sessionmanagement	= "yes">
	<cfcontent type="text/html; charset=utf-8">
	<cfset SetEncoding("form","utf-8")>
	<cfset SetEncoding("url","utf-8")>
	
	<cffunction name="OnApplicationStart" output="no">
		<!--- DSN Name                                              --->
		<cfset application.ds		= "">
		<!--- DSN User Name                                         --->
		<cfset application.un		= "">
		<!--- DSN Password                                          --->
		<cfset application.pw		= "">
		<!--- Database Type (mssql,PostgreSQL,mysql)                --->
		<cfset application.dbtype	= "">
		<!--- URL to the root of the site.                          --->
		<cfset application.root		= "">
		<!--- Encription Key, Change only Once                      --->
		<cfset application.key 		= "">
		<!--- Application SALT Key !!!DO NOT CHANGE IF NOT EMPTY!!! --->
		<cfset application.salt 	= "">
		<!--- Absolute path of the root                             --->
		<cfset application.apath 	= GetDirectoryFromPath(GetCurrentTemplatePath())>
		<!--- Warehouse Directory Name                              --->
		<cfset application.warehouse = 'warehouse'>
		<!--- Warehouse Directory Absolute path                     --->
		<cfset application.wh 		= '#application.apath##application.warehouse#/'>
		<!--- Permision for created files and folders on Linux      --->
		<cfset application.chomd	= "777">
		<!--- load settings file                                    --->
		<cfinclude template="#application.warehouse#/settings.cfm">
	</cffunction>

	<cffunction name="OnRequestStart" output="no">
		<cfif StructKeyExists(session,'ApplicationReset')>
			<cfset OnApplicationStart()>
			<cfset StructDelete(session,'ApplicationReset')>
		</cfif>
	</cffunction>
	
	<cffunction name="OnSessionStart" output="no">
		<!--- Session base Encription Key                           --->
		<cfset session.key 		= GenerateSecretKey('AES')>
	</cffunction>
</cfcomponent>