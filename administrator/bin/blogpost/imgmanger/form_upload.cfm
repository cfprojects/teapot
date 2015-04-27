<cfif listfirst(server.coldfusion.productversion) gte 8>
	<cfset allowedTypes = "JPG,GIF,PNG,BMP">
<cfelse>
	<cfset allowedTypes = "JPG">
</cfif>

<cfform action="#application.ork.uf('switch=addimage&header=0')#" id="imguploadform" method="post" class="formfield" enctype="multipart/form-data">
<div class="label">Image File</div><div class="field">
<input 
	type		= "file" 
    label		= "Image File"
	style		= "width:250px"
	class		= "text" 
	name		= "file"><br />
	
	<cfoutput><div class="hint">(#ucase(allowedTypes)# image file only)</div>
	<input type="hidden" id="filetypes" value="#lcase(allowedTypes)#" />
	</cfoutput>
</div>
<div style="clear:both; padding:3px"></div>

<div class="label"> &nbsp; </div><div class="field">
<input 
	type 		= "submit" 
    class		= "button"
    name		= "UpdateProfile" 
    width		= "100" 
    value 		= "Add Image">
</div>
<div style="clear:both; padding:3px"></div>

</cfform>