<%@ page import="java.util.*,java.net.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.action.*,ca.usask.gmcte.currimap.model.*"%>
<%
int organizationId = HTMLTools.getInt(request.getParameter("organization_id"));
Boolean sessionValue = (Boolean)session.getAttribute("userIsSysadmin");
boolean sysadmin = sessionValue != null && sessionValue;
if(!sysadmin)
{
	out.println("permission denied. You need to be a system administrator to edit available organization outcomes");
	return;
}

OrganizationManager om = OrganizationManager.instance();

Organization organization = om.getOrganizationById(organizationId);
%>
<h4>Edit Available Organization Outcomes (First for <%=organization.getName()%> followed by the General Organization Outcomes)</h4>
<ul>
<%
List<OrganizationOutcomeGroup> groups = om.getOrganizationOutcomeGroupsForOrg(organization);
for(OrganizationOutcomeGroup group: groups)
{
	%>
	<li><strong><%=group.getName()%></strong>	 
		<a href="javascript:editGenericProgramField(<%=group.getId()%>,'OrganizationOutcomeGroup','name','editDiv','/cat/auth/modifyProgram/editOrganizationOutcomes.jsp?organization_id=<%=organizationId%>');" class="smaller"><img src="/cat/images/edit_16.gif"  title="Edit Name" alt="Edit Name"/></a>
		<a href="javascript:editOutcome('OrganizationOutcomeGroup',<%=group.getId()%>,<%=organizationId%>,'delete');"><img src="/cat/images/deletes.gif" alt="Delete"/></a>
	</li>
	<li>
		<ul style="padding-left:15px;line-height:1.0em;">
		<%
	
		List<OrganizationOutcome> outcomes = om.getOrganizationOutcomeForGroup(group);
		for(OrganizationOutcome outcome: outcomes)
		{
			%>
			<li><%=outcome.getName()%>
			 <a href="javascript:editGenericProgramField(<%=outcome.getId()%>,'OrganizationOutcome','name','editDiv','/cat/auth/modifyProgram/editOrganizationOutcomes.jsp?organization_id=<%=organizationId%>');" class="smaller"><img src="/cat/images/edit_16.gif"  title="Edit Name" alt="Edit Name"/></a>
			 <a href="javascript:editGenericProgramField(<%=outcome.getId()%>,'OrganizationOutcome','description','editDiv','/cat/auth/modifyProgram/editOrganizationOutcomes.jsp?organization_id=<%=organizationId%>');" class="smaller"><img src="/cat/images/edit_16.gif"  title="Edit Description" alt="Edit Description"/></a>
			 <a href="javascript:editOutcome('OrganizationOutcome',<%=outcome.getId()%>,<%=organizationId%>,'delete');"><img src="/cat/images/deletes.gif" alt="Delete"/></a>
			</li>
			
					
			<%
		}
		%>
			<li>
				<a href="javascript:editGenericProgramField(-1,'OrganizationOutcome','name','editDiv','/cat/auth/modifyProgram/editOrganizationOutcomes.jsp?organization_id=<%=organizationId%>','organization_outcome_group_id=<%=group.getId()%>');" class="smaller"><img src="/cat/images/edit_16.gif"  title="Add Outcome" alt="Add Outcome"/>Add Outcome to Group</a>
			</li>
		</ul>
	</li>
	<%
}
%>
	<li>
		<a href="javascript:editGenericProgramField(-1,'OrganizationOutcomeGroup','name','editDiv','/cat/auth/modifyProgram/editOrganizationOutcomes.jsp?organization_id=<%=organizationId%>','organization_id=<%=organizationId%>');" class="smaller">Create new group for <%=organization.getName()%></a>
	</li>
	<li>
		<a href="javascript:editGenericProgramField(-1,'OrganizationOutcomeGroup','name','editDiv','/cat/auth/modifyProgram/editOrganizationOutcomes.jsp?organization_id=<%=organizationId%>','organization_id=-1');" class="smaller">Create new General group</a>
	</li>
	
</ul>

