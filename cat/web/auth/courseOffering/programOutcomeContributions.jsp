<%@ page import="java.util.*,ca.usask.gmcte.currimap.action.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.model.*"%>

<h2>My Course Within this Program</h2>
<p>
This section is used to "map" your course to the overall program outcomes in your academic unit 
(previously identified as part of the curriculum development process). 
The first column lists the program outcome category and the second column describes the program outcome. 
In the column titled "Extent of Exposure", select from the pull down menu the extent to which students in 
your course are exposed to activities, assessments, and materials that address that program outcome.  
In the final "Depth of Mastery" column, select from the pull down menu the level of mastery 
towards a program outcome that your course aims to have students reach by the end of the course. 
For example, an introductory course related to a program outcome may specify a high amount of exposure at an emergent level. 
</p>
<%
String courseOfferingId = request.getParameter("course_offering_id");
CourseManager cm = CourseManager.instance();
DepartmentManager dm = DepartmentManager.instance();
CourseOffering courseOffering = cm.getCourseOfferingById(Integer.parseInt(courseOfferingId));
String programId = (String)session.getAttribute("programId");
int programIdParameter = HTMLTools.getInt(request.getParameter("program_id"));
if(programIdParameter > -1)
{
	session.setAttribute("programId",""+programIdParameter);
	programId = ""+programIdParameter; 
}

out.println("Currently selected Program :");
List<Department> departments = cm.getDepartmentForCourseOffering(courseOffering);
List<Program> programs = new ArrayList<Program>();
Program bogus = new Program();
bogus.setId(-1);
bogus.setName("Please select a Program");
programs.add(bogus);
for(Department dep : departments)
{
	programs.addAll(dm.getProgramOrderedByNameForDepartment(dep));
}
out.println(HTMLTools.createSelect("programToSet", programs, "Id", "Name", programId, "setProgramContributionId("+courseOfferingId+")"));

if(!HTMLTools.isValid(programId))
{
	return;
}




OutcomeManager om = OutcomeManager.instance();
ProgramManager pm = ProgramManager.instance();

Program program = pm.getProgramById(Integer.parseInt(programId));
List<ProgramOutcomeGroup> groups = pm.getProgramOutcomeGroupsProgram(program);
List<ContributionOptionValue> optionValues = pm.getContributionOptions();
List<MasteryOptionValue> masteryOptionValues = pm.getMasteryOptions();

if(groups.isEmpty())
{
	out.println("No Propram Outcomes found");
	return;
}
%>
<hr/>
<strong>The contributions listed below represent the extent of which this course offering contributes to the corresponding Program Outcome.</strong>
<br/>
<%
boolean firstOption = true;
for( ContributionOptionValue optionValue : optionValues)
{
	if(firstOption)
		firstOption = false;
	else
		out.println(", ");
	out.println(optionValue.getCalculationValue() +"="+ optionValue.getName());
}
%>
<strong>The mastery depths listed below represent the depth of mastery this course offering is expected to have of the corresponding Program Outcome.</strong>
<br/>
<%
for( MasteryOptionValue optionValue : masteryOptionValues)
{
	if(firstOption)
		firstOption = false;
	else
		out.println(", ");
	out.println(optionValue.getCalculationValue() +"="+ optionValue.getName());
}

%>
<br/>
<table>
	<tr>
		<th>Category</th>
		<th>Program Outcomes</th>
		<th>Extent of<br/>Exposure</th>
		<th>Depth of<br/>Mastery
	</tr>
	
<%
	String prevGroup = "";
	for(ProgramOutcomeGroup group : groups)
	{
		List<LinkProgramProgramOutcome> programOutcomes = pm.getProgramOutcomeForGroupAndProgram(program,group );
		boolean first = true;
		%>
	<tr>
			<td rowspan="<%=programOutcomes.size()%>"><%=group.getName()%></td>
		<%
		for(LinkProgramProgramOutcome programOutcomeLink: programOutcomes)
		{
			ProgramOutcome programOutcome = programOutcomeLink.getProgramOutcome();
			if(!first)
				out.println("<tr>");
			else
				first = false;
			%>
			<td><span title="<%=HTMLTools.isValid(programOutcome.getDescription())?programOutcome.getDescription():"No description"%>"><%=programOutcome.getName()%></span>
			</td>
			<td id="table_cell_<%=programOutcomeLink.getId()%>">
			
			<%
			LinkCourseOfferingContributionProgramOutcome contributionLink = pm.getCourseOfferingContributionLinksForProgramOutcome(courseOffering, programOutcomeLink);
			if(contributionLink == null)
			{
				pm.saveCourseOfferingContributionLinksForProgramOutcome(courseOffering.getId(), programOutcomeLink.getId(), optionValues.get(0).getId(), masteryOptionValues.get(0).getId());
				contributionLink = pm.getCourseOfferingContributionLinksForProgramOutcome(courseOffering, programOutcomeLink);
			}
			
			out.println(HTMLTools.createSelect("contribution"+programOutcomeLink.getId(), optionValues, "Id", "Name", ""+contributionLink.getContribution().getId(), "saveOfferingContribution("+programOutcomeLink.getId()+","+programId+","+courseOfferingId+");"));
			out.println("</td><td>");
			out.println(HTMLTools.createSelect("mastery"+programOutcomeLink.getId(), masteryOptionValues, "Id", "Name", ""+contributionLink.getMastery().getId(), "saveOfferingContribution("+programOutcomeLink.getId()+","+programId+","+courseOfferingId+");"));
			
			%>
			</td>
			
		</tr>
		<%
		}%>
	
	<%}%>
</table>
<hr/>