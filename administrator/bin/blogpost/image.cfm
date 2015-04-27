<cfparam name="attributes.field" 			default="file">
<cfparam name="attributes.save" 			default="">
<cfparam name="attributes.path" 			default="#ExpandPath('.')#">
<cfparam name="attributes.thumb" 			default="_thumb">
<cfparam name="attributes.width" 			default="78">
<cfparam name="attributes.hight" 			default="78">
<cfparam name="attributes.createFolder" 	default="Yes">

<cfif not StructKeyExists(session,'id')>
	<cflocation addtoken="no" url="login.cfm">
</cfif>

<cfif listfirst(server.coldfusion.productversion) gte 8>
	<cfparam name="attributes.types"	default="JPG,GIF,PNG,BMP">
<cfelse>
	<cfparam name="attributes.types"	default="jpg">
</cfif>

<cfif len(form[attributes.field])>
<!--- ******************************************************************** --->
<!--- all images goes in a folder, create it first                         --->
<!--- ******************************************************************** --->
<cfif YesNoFormat(attributes.createFolder) and not DirectoryExists(attributes.path)>
	<cfdirectory 
		action		="create"
		mode		= "#application.chomd#"
		directory	="#attributes.path#" >
</cfif>

<cffile
    action 			= "upload"
    fileField 		= "form.#attributes.field#" 
    nameconflict	= "makeunique"
	mode			= "#application.chomd#"
    destination 	= "#attributes.path#">

<cfif not len(attributes.save)>
	<cfset attributes.save = Replace(cffile.serverFile,' ','_','all')>
</cfif>
<cfif not DirectoryExists("#attributes.path#/#attributes.thumb#")>
	<cfdirectory action="create" directory="#attributes.path#/#attributes.thumb#" mode="#application.chomd#">
</cfif>

<cfif not ListFindNoCase(attributes.types,file.clientFileExt)>
	<cfset session.error	= "Error Uploading file. The File You Upload is #ucase(clientFileExt)#. Please upload #ucase(attributes.types)# Files Only.">
	<cffile
		action 	= "delete"
		file 	= "#attributes.path#/#cffile.serverFile#">
<cfelse>
	<!--- ******************************************************************** --->
	<!--- Create Thumb Image - Version dependent processing                    --->
	<!--- ******************************************************************** --->
	<cfif len(attributes.width) and (attributes.hight) and len(attributes.thumb)>
		<cfset this.thumbname = "thumb_#listdeleteat(attributes.save,listlen(attributes.save,'.'),'.')#.jpg">
		<cfif listfirst(server.coldfusion.productversion) gte 8>
			<cfset myImage	= ImageRead('#attributes.path#/#cffile.serverFile#')>
			<cfset imginfo	= ImageInfo(myImage)>
			<cfif imginfo.width gt attributes.width OR imginfo.height gt attributes.hight>
				<cfset ImageScaleToFit(myImage,attributes.width,attributes.hight)>
				<cfset ImageWrite(myImage,'#attributes.path#/#attributes.thumb#/#this.thumbname#')>
			<cfelse>
				<cffile action="copy" destination="#attributes.path#/#attributes.thumb#/#this.thumbname#" source="#attributes.path#/#cffile.serverFile#">
			</cfif>
		<cfelse>
			<cfset myImage = CreateObject("Component", "iedit")>
			<cfset myImage.SelectImage("#attributes.path#/#cffile.serverFile#")>
			<cfif myImage.getWidth() gt attributes.width OR myImage.getHeight() gt attributes.hight>
				<cfset myImage.ScaletoFit(attributes.width,attributes.hight)>
				<cfset myImage.output("#attributes.path#/#attributes.thumb#/#this.thumbname#", "jpg",100)>
			<cfelse>
				<cffile action="copy" destination="#attributes.path#/#attributes.thumb#/#this.thumbname#" source="#attributes.path#/#cffile.serverFile#">
			</cfif>
		</cfif>
	<cftry>	<cfcatch>
			<cfset session.error ="Thumbnail creation Failed. [#cfcatch.Message#]">
		</cfcatch>
		</cftry>
	</cfif>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(1000)>

	<cfif Compare(cffile.serverFile,attributes.save)>
		<cffile
			action 		= "rename"
			source 		= "#attributes.path#/#cffile.serverFile#"
			destination = "#attributes.path#/#attributes.save#">
	</cfif>
	<cfset caller.fileName  = attributes.save>
	<cfset session.msg ="Image Uploaded">
</cfif>
</cfif>
