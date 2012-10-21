<%@ page import="java.util.*,java.net.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.action.*,ca.usask.gmcte.currimap.model.*"%>
<%
int programId = HTMLTools.getInt(request.getParameter("program_id"));
ProgramManager om = ProgramManager.instance();

Program program = om.getProgramById(programId);
%>
<h4>Edit Available Program Outcomes (First for <%=program.getName()%>, followed by the General Program outcomes)</h4>
<input type="hidden" id="program_id" value="<%=programId%>" />
<ul>
<%
List<ProgramOutcomeGroup> groups = om.getProgramOutcomeGroupsForProgram(program);
for(ProgramOutcomeGroup group: groups)
{
	%>
	<li><strong><%=group.getName()%></strong>	 
		<a href="javascript:editGenericProgramField(<%=group.getId()%>,'ProgramOutcomeGroup','name','editDiv','/cat/auth/modifyProgram/editProgramOutcomes.jsp?program_id=<%=programId%>');" class="smaller"><img src="/cat/images/edit_16.gif"  title="Edit Name" alt="Edit Name"/></a>
		<a href="javascript:editOutcome('ProgramOutcomeGroup',<%=group.getId()%>,<%=programId%>,'delete');"><img src="/cat/images/deletes.gif" alt="Delete"/></a>
	</li>
	<li>
		<ul style="padding-left:15px;line-height:1.0em;">
		<%
	
		List<ProgramOutcome> outcomes = om.getProgramOutcomesForGroup(group);
		for(ProgramOutcome outcome: outcomes)
		{
			%>
			<li><%=outcome.getName()%>
			 <a href="javascript:editGenericProgramField(<%=outcome.getId()%>,'ProgramOutcome','name','editDiv','/cat/auth/modifyProgram/editProgramOutcomes.jsp?program_id=<%=programId%>');" class="smaller"><img src="/cat/images/edit_16.gif"  title="Edit Name" alt="Edit Name"/></a>
			 <a href="javascript:editGenericProgramField(<%=outcome.getId()%>,'ProgramOutcome','description','editDiv','/cat/auth/modifyProgram/editProgramOutcomes.jsp?program_id=<%=programId%>');" class="smaller"><img src="/cat/images/edit_16.gif"  title="Edit Description" alt="Edit Description"/></a>
			 <a href="javascript:editOutcome('ProgramOutcome',<%=outcome.getId()%>,<%=programId%>,'delete');"><img src="/cat/images/deletes.gif" alt="Delete"/></a>
			</li>
			
					
			<%
		}
		%>
			<li>
				<a href="javascript:editGenericProgramField(-1,'ProgramOutcome','name','editDiv','/cat/auth/modifyProgram/editProgramOutcomes.jsp?program_id=<%=programId%>','program_outcome_group_id=<%=group.getId()%>');" class="smaller"><img src="/cat/images/edit_16.gif"  title="Add Outcome" alt="Add Outcome"/>Add Outcome to Group</a>
			</li>
		</ul>
	</li>
	<%
}
%>
	<li>
		<a href="javascript:editGenericProgramField(-1,'ProgramOutcomeGroup','name','editDiv','/cat/auth/modifyProgram/editProgramOutcomes.jsp?program_id=<%=programId%>','program_id=<%=programId%>');" class="smaller">Create new Program Outcome group for <%=program.getName()%> (eg: Biology Program Outcomes, Math: Geometry)</a>
	</li>
	<li>
		<a href="javascript:editGenericProgramField(-1,'ProgramOutcomeGroup','name','editDiv','/cat/auth/modifyProgram/editProgramOutcomes.jsp?program_id=<%=programId%>','program_id=-1');" class="smaller">Create new General group (eg: Research)</a>
	</li>
	
</ul>
