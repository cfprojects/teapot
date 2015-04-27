<cfprocessingdirective pageEncoding="utf-8">
<cfquery name="master" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
	SELECT distinct blogpost.blogpostid  <cfif len(url.order)>, #Decrypt(url.order, application.key, 'AES', 'hex')#</cfif>
	FROM blogpost INNER JOIN
	bloguser ON blogpost.bloguser = bloguser.bloguserid LEFT OUTER JOIN
	comments ON blogpost.blogpostid = comments.blogpostid
	where bloguser.valid = <cfqueryparam cfsqltype="cf_sql_bit" value="1">  and bloguser = #val(session.id)#
	and blogpost.pagetype = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#val(url.pagetype)#">
	<cfswitch expression="#url.tab#">
    	<cfcase value="2">
			and blogpost.valid = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        </cfcase>
    </cfswitch>
	<cfif len(url.srch)>
		and blogpost.blogpostname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(url.srch)#%">
	</cfif>
	<cfif len(url.order)>
		order by #Decrypt(url.order, application.key, 'AES', 'hex')# 
		<cfswitch expression="#url.dir#"><cfcase value="1">desc</cfcase><cfdefaultcase>asc</cfdefaultcase></cfswitch>
	<cfelse>
		ORDER BY blogpost.blogpostid desc
	</cfif>
</cfquery>

<cfset searchlist	= "#valuelist(master.blogpostid)#">
<cfinclude template="../../system/library/grid_calc.cfm">

<cfquery name="get" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
	SELECT blogpost.blogpostid, blogpost.blogpostname, blogpost.mblogpostID, blogpost.smalldes, blogpost.publisheddate, blogpost.lastupdated, bloguser.blogusername,  blogpost.valid,
	COUNT(comments.commentid) AS comments
	FROM blogpost INNER JOIN
	bloguser ON blogpost.bloguser = bloguser.bloguserid LEFT OUTER JOIN
	comments ON blogpost.blogpostid = comments.blogpostid
	where <cfif listlen(searchlist)>blogpost.blogpostid in (#searchlist#)<cfelse>blogpost.blogpostid = 0</cfif>
	GROUP BY blogpost.blogpostid, blogpost.blogpostname, blogpost.smalldes, blogpost.publisheddate, blogpost.lastupdated, blogpost.valid, bloguser.blogusername,
	blogpost.mblogpostID
	<cfif len(url.order)>
		order by #Decrypt(url.order, application.key, 'AES', 'hex')# 
		<cfswitch expression="#url.dir#"><cfcase value="1">desc</cfcase><cfdefaultcase>asc</cfdefaultcase></cfswitch>
	<cfelse>
		ORDER BY blogpost.blogpostid desc
	</cfif>
</cfquery>

<cfset titlelist = "Post|blogpostname,Author|blogusername,Comments,Published|publisheddate">
<cfinclude template="../../system/library/grid_header.cfm">

<cfoutput query="get">
<tr <cfif not currentrow mod 2>class="zibrablk"<cfelse>class="zibrawhite"</cfif>>
	<td><a href="#application.ork.uf('switch=edit&id=#blogpostid#')#"><img border="0" src="images/file#valid#.gif" align="absmiddle" /> #blogpostname#</a></td>
	<td>#blogusername#</td>
	<td align="center">
		<cfif val(comments)>
			<cfquery name="cmtact" datasource="#application.ds#" username="#application.un#" password="#application.pw#">
				<cfswitch expression="#application.dbtype#">
					<cfcase value="mssql">
						select top 1 commentid,valid from comments where blogpostid = #blogpostid# and 
						(valid = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> or publish = <cfqueryparam cfsqltype="cf_sql_tinyint" value="0"> )
					</cfcase>
					<cfcase value="mysql,PostgreSQL">
						select commentid,valid from comments where blogpostid = #blogpostid# and 
						(valid = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> or publish = <cfqueryparam cfsqltype="cf_sql_tinyint" value="0"> )
						limit 1
					</cfcase>
				</cfswitch>
			</cfquery>
			<cfif cmtact.recordCount>
				<cfif val(cmtact.valid)>
					<div class="cmticonred" title="Action Required" ><a class="wite" href="#application.ork.uf('path=2,1&id2=#blogpostid#&tab=2')#">#comments#</a> </div>
				<cfelse>
					<div class="cmticonred" title="Action Required" ><a class="wite" href="#application.ork.uf('path=2,1&id2=#blogpostid#&tab=3')#">#comments#</a> </div>
				</cfif>
			<cfelse>
				<div class="cmticon"><a class="wite" href="#application.ork.uf('path=2,1&id2=#blogpostid#')#">#comments#</a> </div>
			</cfif>
			
		</cfif></td>
	<td><cfif val(valid)>#dateformat(publisheddate,'mmm dd yyyy')#<cfelse><span title="Last Updated : #dateformat(lastupdated,'mmm dd yyyy')#" class="alert"><strong>(Draft)</strong></span></cfif></td>
</tr>
</cfoutput>
</table>
<cfinclude template="../../system/library/grid_navi.cfm">
</div>