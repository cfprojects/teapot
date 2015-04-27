<cfprocessingdirective pageEncoding="utf-8">
<cfparam name="url.pagetype" default="1">

<cfswitch expression="#url.switch#">
	<cfcase value="addimage">
		<cf_image path="#application.wh#UserImages" thumb="_thumb">
		<cflocation addtoken="no" url="#application.ork.uf('switch=imgmanger&header=0')#">
	</cfcase>
	<cfcase value="imageDelete">
		<cfinclude template="imgmanger/act_delete.cfm">
		<cflocation addtoken="no" url="#application.ork.uf('switch=imgmanger&header=0')#">
	</cfcase>
	<cfcase value="imgmanger">
		<cfinclude template="imgmanger/tab_images.cfm">
	</cfcase>
	<cfcase value="delete">
		<cfinclude template="qry_delete.cfm">
	</cfcase>
	<cfcase value="add">
		<cfinclude template="qry_add.cfm">
		<cflocation addtoken="no" url="#application.ork.uf('switch=edit&id=#url.id#')#">
	</cfcase>
	<cfcase value="edit">
		<cfinclude template="tab_edit.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="tab_post.cfm">
	</cfdefaultcase>
</cfswitch>
