<cfprocessingdirective pageEncoding="utf-8">

<cfinclude template="qry_get.cfm">

<cfimport 
	taglib =	"../../system/form"  
	prefix =	"fm">

<cfimport 
	taglib =	"../../system/ct"  
	prefix =	"ct">

<ct:quickCheck>
<cfform action="#application.ork.uf('switch=add&id=#url.id#')#" method="post" id="formfield" class="formfield" enctype="multipart/form-data">

<div style="padding-left:10px; padding-bottom:10px">
<cfinput 
	name		= "blogpostname" 
	type		= "text" 
	required	= "yes"
	autocomplete= "off"
	message		= "Please Enter Title"
	class		= "textbig" 
	style		= "width:500px"
	maxlength	= "400"
	value		= "#thisq.blogpostname#" />
	<cfif val(url.id)>
		<cfswitch expression="#val(thisq.valid)#">
			<cfcase value="0">
				(Draft)
			</cfcase>
			<cfdefaultcase>
				 <cfoutput><a style="border-bottom:none" href="#application.root##DateFormat(thisq.created,'yyyy')#/#DateFormat(thisq.created,'mm')#/#thisq.url#.cfm" target="_blank"><img src="images/link.png" align="absmiddle" border="0" title="Open Window" /></a></cfoutput>
			</cfdefaultcase>
		</cfswitch>
	</cfif>
</div>

<!--- *********************************************** --->
<!--- post, rich editor                               --->
<!--- *********************************************** --->
<cfsavecontent variable="js">
<script type='text/javascript' src='js/tiny_mce/jquery.tinymce.js'></script>
<script type="text/javascript">
$(document).ready(function() { 
	$('#blog').tinymce({
		script_url : 'js/tiny_mce/tiny_mce.js',
		mode : "textareas",
		theme : "advanced",
		extended_valid_elements : "cf:execute[id|title|class],cf:code[id|title|class],cf:embad[id|title|class]",
		custom_elements: "~cf:execute,~cf:code",
		convert_urls : false,
		content_css : "<cfoutput>#application.root#styles/#Application.sti.layout#</cfoutput>/post.css",
		plugins : "simplemedia,filemanager,addcode,addexecute,tabfocus,inlinepopups,contextmenu,paste,xhtmlxtras,wordcount,fullscreen",
		theme_advanced_buttons1 : "bold,italic,underline,|,addcode,addexecute,simplemedia,filemanager,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,fontsizeselect,forecolor,|,copy,paste,pastetext,pasteword,bullist,numlist,blockquote,|,link,removeformat,|,fullscreen,code",
		theme_advanced_buttons2 : '',
		theme_advanced_buttons3 : '',
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		convert_urls : false,
		theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : true,
		apply_source_formatting : true,
		file_browser_callback : "imgManager"
	});
});

</script>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfset HTMLFormatBlog = replacenocase(thisq.blog,'&','&amp;','all')>
<div style="padding-left:10px; padding-bottom:10px">
<textarea id="blog" name="blog" style="height:400px; width:90%"><cfoutput>#HTMLFormatBlog#</cfoutput></textarea>
</div>

<!--- *********************************************** --->
<!--- Master Page for Pages (not for blog posts)      --->
<!--- *********************************************** --->
<cfswitch expression="#url.pagetype#">
	<cfcase value="2">
		<cfquery name="mpages" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
			select blogpostid, blogpostname, smalldes from blogpost 
			where pagetype = <cfqueryparam cfsqltype="cf_sql_tinyint" value="2"> 
			and mblogpostID = 0 
			and blogpostid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#">
		</cfquery>

		<cfif mpages.recordCount>
		<fm:label label="Parent Page">
			<cfselect name="mblogpostID" class="input" selected="#thisq.mblogpostID#" value="blogpostid" display="blogpostname" queryPosition="below" query="mpages"><option value="0"></option></cfselect>
		</fm:label>
		</cfif>
	</cfcase>
</cfswitch>

<!--- *********************************************** --->
<!--- keywords                                        --->
<!--- *********************************************** --->
<cfquery name="label" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
	SELECT bloglabel.bloglabelname FROM bloglabel LEFT OUTER JOIN
	blogpost_bloglabel ON bloglabel.bloglabelid = blogpost_bloglabel.bloglabelid
	where blogpost_bloglabel.blogpostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#">
</cfquery>
<fm:label label="Topics">
 <ct:FCBKcomplete 
     data = "js/ork.cfc?method=keywords&returnFormat=plain"> 
     <select name="label"><cfoutput query="label"><option value="#bloglabelname#" class="selected">#bloglabelname#</option></cfoutput></select> 
</ct:FCBKcomplete> 
</fm:label>

<!--- *********************************************** --->
<!--- Submit Buttons                                  --->
<!--- *********************************************** --->
<cfif val(url.id)>
	<cfset delete = "<a href=""javascript:conf('Delete Post','Are you sure you want to delete this Post?','#application.ork.uf('switch=delete&id=#url.id#')#')"">Delete</a>">
<cfelse>
	<cfset delete = "">
</cfif>
<fm:label label="#delete#">
<input title="Save as a Draft" class="button" type="submit" value="Draft" id="Draft" name="Draft" />

<cfif not val(thisq.valid) and val(url.id)>
	<input title="Draft & Preview" class="button" type="submit" value="Preview" name="Preview" />
</cfif>

<input title="Publish" class="buttonblu" type="submit" value="Publish"  id="Publish" name="Publish" />
</fm:label>
<br />

<!--- **************************************************** --->
<!--- :: Plugin Include :: Form Treats                     --->
<!--- **************************************************** --->
<cfdirectory action="list" directory="#ExpandPath('./plugins/FormTreats')#" name="plugins" filter="plugin_*.cfm">
<cfloop query="plugins"><cfinclude template="../../plugins/FormTreats/#plugins.name#" /></cfloop>

<!--- *********************************************** --->
<!--- additional  options                             --->
<!--- *********************************************** --->
<div class="formbar">
<div style="cursor:pointer" onclick="$('#addtional').slideToggle()">Additional Options <img src="images/sort1.gif" /></div>
</div>

<div id="addtional" style="display:none; padding-bottom:5px; padding-top:10px">
<fm:label label="Comments">
<cfif not val(url.id) and not YesNoFormat(Application.sti.Default_Comment)>
	<cfset commentchk = '2'>
<cfelse>
	<cfset commentchk = val(thisq.comment)>
</cfif>

<input type="radio" name="comment" id="comment0" value="0" <cfif not val(commentchk)>checked="checked"</cfif> /> <label for="comment0">Enabled</label>
<input type="radio" name="comment" id="comment1" value="1" <cfif commentchk eq 1>checked="checked"</cfif> /> <label for="comment1">Not Enabled, Show Existing</label>
<input type="radio" name="comment" id="comment2" value="2" <cfif commentchk eq 2>checked="checked"</cfif> /> <label for="comment2">Not Enabled, Hide Existing</label>
</fm:label>

<fm:label label="">
	<input type="checkbox" name="sticky" value="1" <cfif val(thisq.sticky)>checked="checked"</cfif> /> <img src="images/pin.png" align="absmiddle" /> Pin<cfif val(thisq.sticky)>ed</cfif> to Wall 
</fm:label>

<!--- *********************************************** --->
<!--- files                                           --->
<!--- *********************************************** --->
<fm:label label="Attachments">
<input type="file" class="text" name="file" />
<cfdirectory
	action 		= "list" 
	type 		= "file"
	directory 	= "#application.wh#posts/#url.id#"   
	name 		= "files" />

<cfif files.recordCount>
	<cfsavecontent variable="js">
	<script type="text/javascript">
	$(document).ready(function(){
		$('.deletefile').click(function(){
			$.ajax({url: cfc + "?method=fileremove&returnformat=plain&files="+$(this).attr('file')+"&id="+$(this).parent().attr('id'), dataType: "text", cache:false, success: function(data){ 
				if ($('#'+$.trim(data)).length == 1) {$('#'+$.trim(data)).hide("slow").remove(); }
			}})
		})
	})
	</script>
	</cfsavecontent>
	<cfhtmlhead text="#js#">
	<cfoutput query="files">
		<!---- check download count --->
		<cfquery name="dcount" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
			select downloads from downloadcount where blogpostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#"> 
			and filename = '#files.name#'
		</cfquery>
		<div id="list#currentRow#" class="list"><img style="cursor:pointer" class="deletefile" file="#Encrypt('posts/#url.id#/#files.name#', session.key, 'AES', 'hex')#" src="images/delsml.gif" align="absmiddle" /> <a href="../#application.warehouse#/posts/#url.id#/#files.name#">#files.name#</a>
		<cfif dcount.recordCount>(#val(dcount.downloads)# Downloads)</cfif>
		<img src="images/hlink.png" align="absmiddle" original-title="Direct Download Link" style="cursor:pointer" class="alert" onclick="$(this).next().show('slow')" />
		<span style="display:none">#application.root#index.cfm?action=download&path=#url.id#/#files.name#</span>
		</div>
	</cfoutput>
</cfif>
</fm:label>

<fm:label label="Demo URL">
<cfinput 
	name		= "demourl" 
	type		= "text"
	class		= "text" 
	style		= "width:500px"
	maxlength	= "500"
	value		= "#thisq.demourl#" />
</fm:label>
<fm:label label="Description">
<cfinput 
	name		= "smalldes" 
	type		= "text"
	class		= "text" 
	style		= "width:500px"
	maxlength	= "500"
	value		= "#HTMLEditFormat(trim(thisq.smalldes))#" />
</fm:label>

<cfif IsDate(thisq.publisheddate)>
<!--- *********************************************** --->
<!--- Edit Permalink                                  --->
<!--- *********************************************** --->
<cfsavecontent variable="js">
<script type="text/javascript">
	function editplink() {
		if( $('#plink input').length == 0 ) {
			$('#plink').attr('title',$("#plink").html()).html('<input name="permalink" class="text" type="text" value="'+$("#plink").html()+'" />')
			$('.permalink').toggle()
		}
	}
	function canplink() {
		$('#plink').html( $('#plink').attr('title') )
		$('.permalink').toggle()
	}
</script>
</cfsavecontent>
<cfhtmlhead text="#js#">

<fm:label label="Permalink">
	<cfoutput>#application.root##DateFormat(thisq.publisheddate,'yyyy')#/#DateFormat(thisq.publisheddate,'mm')#/<span style="background-color:##FFC" onclick="editplink()" id="plink">#thisq.url#</span>.cfm 
	&nbsp; <a href="javascript:editplink()" class="permalink">Edit</a>
	&nbsp; <a href="javascript:canplink()" class="permalink" style="display:none">Cancel</a></cfoutput>
</fm:label>
</cfif>

<!--- *********************************************** --->
<!--- External Links                                  --->
<!--- *********************************************** --->
<fm:label label="External Links">
<cfquery name="ext" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
	select externallinkName, externallinkURL from externallink where blogpostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#"> 
	and valid = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>

<cfloop from="1" to="#val(ext.recordCount+1)#" index="i">
<cfoutput>
<div id="ext_#i#" class="exlinks">
<input 
	name		= "exttitle#i#"
	type		= "text"
	class		= "text" 
	style		= "width:500px"
	maxlength	= "500" 
	onchange	= "getTitle(this)"
	value		= "#ext.externallinkName[i]#" />
	<input type="hidden" name="exturl#i#" value="#ext.externallinkURL[i]#" />
	<span><cfif len(ext.externallinkURL[i])><a style="border-bottom:none" href="#ext.externallinkURL[i]#" target="_blank"><img src="images/link.png" border="0" align="middle" /></a></cfif></span>
</div>
</cfoutput>
</cfloop>
</fm:label>

<cfsavecontent variable="js">
<script type="text/javascript">
	function getTitle(a) {
		var d = '#ext_'+ $(a).parent().attr('id').split('_')[1]
		var v = $(d+' :text').val()
		if (v !== '') {
			$(d+' span').html('<img src="images/loading.gif" align="absmiddle" /> Fetching Title')
			$.ajax({url : cfc + "?method=getTitle&returnformat=plain&u=" + v, dataType: 'html',cache:false, success: function(data) { 
				$(d+' :text').attr('title',v); 
				if ($.trim(data) !=='') {
					$(d+' :text').val($.trim(data))
					$(d+' span').html('<a style="border-bottom:none" href="'+v+'" target="_blank"><img src="images/link.png" border="0" align="middle" /></a>')
				} else {
					$(d+' span').html('')
				}
				$(d+' input[type=hidden]').val(v); makenewexlink()} 
			})
		} else {
			$(d+' span').html('')
			$(d+' input[type=hidden]').val('')
		}
	}
	function makenewexlink() {
		var html = $('#ext_1').html()
		var now	 = $('.exlinks').length
		var next = now + 1
		if (now < 10 && $('#ext_'+now+' :text').val() ) {
			$('#ext_'+now).after('<div id="ext_'+next+'" class="exlinks">'+html+'</div>')
			$('#ext_'+next+' span').html('')
			$('#ext_'+next+' :text').attr('name','exttitle'+next).val('')
			$('#ext_'+next+' input[type=hidden]').attr('name','exturl'+next).val('')
		}
	}
</script>
</cfsavecontent>
<cfhtmlhead text="#js#">
</div>

<!--- *********************************************** --->
<!--- Footer button set                               --->
<!--- *********************************************** --->
<div class="formbar" style="text-align:right;">
	<cfif val(thisq.pageviews)><cfoutput>#thisq.pageviews# Request<cfif thisq.pageviews gt 1>s</cfif> </cfoutput></cfif>
	
	<cfquery name="pcount" datasource="#application.ds#" username="#application.un#" password="#application.pw#">		
		<cfswitch expression="#application.dbtype#">
			<cfcase value="mssql">
				select top 1 blogpostID from blogpost where blogpostid > <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#"> 
				and pagetype = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#val(url.pagetype)#"> order by blogpostID desc
			</cfcase>
			<cfdefaultcase>
				select blogpostID from blogpost where blogpostid > <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#"> 
				and pagetype = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#val(url.pagetype)#"> order by blogpostID desc
				limit 1		
			</cfdefaultcase>
		</cfswitch>
	</cfquery>
	<cfif pcount.recordCount>
		<img src="images/div.gif" align="absmiddle" />
		<cfoutput><a href="#application.ork.uf('switch=edit&id=#pcount.blogpostID#')#">Previous Post</a></cfoutput>
	</cfif>
	
	<cfquery name="pcount" datasource="#application.ds#" username="#application.un#" password="#application.pw#">		
		<cfswitch expression="#application.dbtype#">
			<cfcase value="mssql">
				select top 1 blogpostID from blogpost where blogpostid < <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#"> 
				and pagetype = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#val(url.pagetype)#"> order by blogpostID desc
			</cfcase>
			<cfdefaultcase>
				select blogpostID from blogpost where blogpostid < <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.id)#"> 
				and pagetype = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#val(url.pagetype)#"> order by blogpostID desc
				limit 1
			</cfdefaultcase>
		</cfswitch>
	</cfquery>
	<cfif pcount.recordCount>
		<img src="images/div.gif" align="absmiddle" />
		<cfoutput><a href="#application.ork.uf('switch=edit&id=#pcount.blogpostID#')#">Next Post</a></cfoutput>
	</cfif>
</div>

</cfform>
</div>
<!--- *********************************************** --->
<!--- Open Preview window                             --->
<!--- *********************************************** --->
<cfsavecontent variable="js">
<cfif StructKeyExists(session,'openPreview')>
<script type="text/javascript">
$(document).ready( function() {
	<cfoutput>window.open('#application.root##application.warehouse#/preview/#thisq.url#.cfm',"previewwindow");</cfoutput>
})
</script>
	<cfset StructDelete(session,'openPreview')>
</cfif>

<script type="text/javascript">
$(document).ready( function() {
	$('#smalldes').bind('keyup', function() { textSize(this.id) })
	$("#smalldes").trigger('keyup');
	$('#formfield').submit(function() { 
		$('#Publish').val('Saving..')
		$('#Draft').val('Saving..')
	} )
})

function textSize(i) {
	var l = $('#'+i).val().length
	if (l < 100) {
		if ( $('#'+i).attr('type') !== 'text' ) {
			$('#'+i).parent().html('<input type="text" class="text" style="width:500px;" onKeyUp="textSize(this.id)" value="'+$('#'+i).val()+'" name="'+i+'" id="'+i+'" />')
			$('#'+i).parent().focus()
		}
	} else {
		if ( $('#'+i).attr('type') == 'text' ) {
			$('#'+i).parent().html('<textarea class="text" style="width:500px; height:70px" name="'+i+'" id="'+i+'" onKeyUp="textSize(this.id)">'+$('#'+i).val()+'</textarea>')
			$('#'+i).parent().focus()
		}
	}
}
</script>
</cfsavecontent>
<cfhtmlhead text="#js#">