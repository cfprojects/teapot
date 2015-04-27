<br />
<table class="tabbox" border="0" cellpadding="0" cellspacing="0"><tr>
<td width="11" valign="top"><img src="images/bxleft.gif" width="11" height="260" /></td>
<td style="border:1px solid #CCCCCC" valign="top">
<table style="width: 100%; font-family:Verdana; font-size:11px; border-bottom:1px solid #4B4B4B" border="0" cellpadding="0" cellspacing="0" background="images/tabbg2.gif">
<tr>
<td width="55"><img src="images/tbbxstart.gif" width="55" height="44" /></td>
<td id="tab1" class="tabselect" align="center"><a href="javascript:">My Images</a></td><td width="13"><img id="tab_i1" src="images/stabrite.gif" width="13" height="44" /></td>
<td id="tab2" class="tab" align="center"><a href="javascript:">Add Image</a></td><td width="13"><img  id="tab_i2" src="images/tabrite.gif" width="13"></td>
<td background="images/tabbg.gif" align="right"><img src="images/tabxend.gif" /></td></tr>
</table><div id="tabedbox">

<!--- *********************************************************** --->
<!--- List Images                                                 --->
<!--- *********************************************************** --->
<div id="imagelist">
<cfinclude template="dsp_imagelist.cfm">
</div>

<!--- *********************************************************** --->
<!--- upload form                                                 --->
<!--- *********************************************************** --->
<div id="uploadimage" style="display:none">
	<cfinclude template="form_upload.cfm">
</div>

</div></td>
<td width="13" valign="top"><img src="images/bxrite.gif" width="13" height="227" /></td>
</tr>
</table>
<!--- *********************************************************** --->
<!--- image Preview and info                                      --->
<!--- *********************************************************** --->
<div id="film"></div>
<div id="bigimg"><div class="imgholder"><div title="Close" onclick="closeimg()"></div></div>
<div id="imgmenu">
<table cellpadding="0" cellspacing="0" border="0" width="100%"><tr>
<td align="left" width="100">
<div class="submenusel"><img align="absmiddle" src="images/tbsellft.png" height="18" /> <a href="javascript:insertimg()"><img align="absmiddle" border="0" src="images/add.png" /> Insert</a><img align="absmiddle" src="images/tbselrite.png" height="18" /></div>
</td>
<td valign="top" id="imginfo"></td>
<td align="right">
<div class="submenusel"><img align="absmiddle" src="images/tbsellft.png" height="18" /> <a href="javascript:deleteimg()">Delete</a><img align="absmiddle" src="images/tbselrite.png" height="18" /></div>
<div class="submenusel"><img align="absmiddle" src="images/tbsellft.png" height="18" /> <a href="javascript:closeimg()">Close</a><img align="absmiddle" src="images/tbselrite.png" height="18" /></div></td>
</tr></table>
</div></div>


<script type="text/javascript">
$("document").ready(function() {
	window.focus()
	$('#tab1').click(function() {
		$('#tab1').removeClass("tab")
		$('#tab1').addClass("tabselect")
		$('#tab2').removeClass("tabselect")
		$('#tab2').addClass("tab")
		$('#tab_i1').attr("src",'images/stabrite.gif')
		$('#tab_i2').attr("src",'images/tabrite.gif')
		$('#imagelist').css('display','block')
		$('#uploadimage').css('display','none')
	} )
	
	$('#tab2').click(function() {
		$('#tab1').removeClass("tabselect")
		$('#tab1').addClass("tab")
		$('#tab2').removeClass("tab")
		$('#tab2').addClass("tabselect")
		$('#tab_i1').attr("src",'images/tabrite.gif')
		$('#tab_i2').attr("src",'images/stabrite.gif')
		$('#imagelist').css('display','none')
		$('#uploadimage').css('display','block')
	} )

<!--- form validation --->
	$("#imguploadform").submit(function() {
		var ext = $('#imguploadform input[type=file]').val().split('.')	
		ext		= ext[ext.length-1].toLowerCase()
		var f	= $('#filetypes').val().toLowerCase()
		if (f.indexOf(ext) < 0 || ext == '' ){
			alert('Please Select '+f.toUpperCase()+' File')
			return false
		} else {
			$('#imguploadform input[type=submit]').css('visibility','hidden').after(' <img src="images/loading.gif" align="absmiddle" />')
		}
	})
	
<!--- cheap height hack --->
	heighthack()
	$(window).resize(function() {heighthack()})
	function heighthack() {
		$('#imgbox').height( $(window).height() - 85 )
		imgsize()
	}
})

function closeimg() {
	$('#film').fadeOut('slow')
	$('#bigimg').fadeOut('slow')
	$('.imgholder div:first').html('')
}

function imgsize() {
	var w = $('#bigimg').innerWidth() 
	var h = $('#bigimg').innerHeight() 
	$('#bigimgpre').css({'max-height':h-65,'max-width':w-25})
	$('.imgholder div:first').height(h- $('#bigimg #imgmenu').height() )
}

function addimg(i,n,z) {
	$('.imgholder div:first').html('<img id="bigimgpre" src="'+i+'" title="'+n+'" />').css('cursor','pointer')
	imgsize()
	$('#bigimg img').load(function() {imgsize(); imageinfo(i)});
}

function imageinfo(i) {
	var newImg = new Image()
	newImg.src = i
	var h = newImg.height
	var w = newImg.width
	$('#imginfo').append(' ('+h+' x '+w+' pixels)')
}

function bigimgload(i,n,z) {
	$('#imginfo').html('<a href="'+i+'" target="_blank">'+n+'</a><br />' + z)
	$('#film').fadeTo('slow', 0.9)
	$('#bigimg').fadeIn("slow", function(){addimg(i,n,z)})	
}

function deleteimg() {
	var answer = confirm("Are You sure You want to Delete this image?")
	if (answer){
		window.location = "<cfoutput>#application.ork.uf('switch=imageDelete&header=0')#</cfoutput>&img="+$('#bigimgpre').attr('title')
	}
}

function insertimg() {
	window.opener.mainwindow.document.getElementById('src').value = $('#bigimgpre').attr('src')
	window.close()
}
</script>