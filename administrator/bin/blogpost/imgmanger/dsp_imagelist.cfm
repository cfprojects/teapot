<cfscript>
// http://www.cflib.org/udf/fncFileSize
function fncFileSize(size) {
	if ((size gte 1024) and (size lt 1048576)) {
		return round(size / 1024) & "Kb";
	} else if (size gte 1048576) {
		return decimalFormat(size/1048576) & "Mb";
	} else {
		return "#size# b";
	}
}
</cfscript>

<cfdirectory 
    directory	= "#application.wh#UserImages/"
    action		= "list"
    listInfo	= "all"
    name		= "get"
    type		= "file">

<div id="imgbox">

<cfset raws 	= 1>
<cfoutput query="get">

<cfset this.ext = listlast(get.name,'.')>
<cfif listfindnocase("JPG,GIF,PNG,BMP",this.ext)>

<div class="imgitem" title="#name#" align="center" onclick="bigimgload('#JSStringFormat("#application.root##application.warehouse#/UserImages/#get.name#")#','#JSStringFormat("#get.name#")#','#JSStringFormat(fncFileSize(get.size))#')">
<div class="imgwrap">
<!--- if thumb file exsists, display the thumb image --->
<cfset thumbname = "thumb_#listdeleteat(name,listlen(name,'.'),'.')#.jpg">
<cfif FileExists("#application.wh#UserImages/_thumb/#thumbname#")>
    <img title="#name#" src="../#application.warehouse#/UserImages/_thumb/#thumbname#"/>
<cfelse>
<!--- if no thumb, display file icon --->
	<cfswitch expression="#this.ext#">
		<cfcase value="gif"><img src="images/gifico.gif" /></cfcase>
		<cfcase value="jpg"><img src="images/jpgico.gif" /></cfcase>
		<cfcase value="bmp"><img src="images/bmpico.gif" /></cfcase>
		<cfdefaultcase><img src="images/fileico.gif" /></cfdefaultcase>
	</cfswitch>
</cfif>
</div>
<div class="filename">#lcase(name)#</div>
</div>
</cfif>
</cfoutput>

</div>