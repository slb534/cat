<%@ page import="java.util.*,java.net.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.action.*,ca.usask.gmcte.currimap.model.*"%>

<%
String programId = (String)session.getAttribute("programId");
int programIdParameter = HTMLTools.getInt(request.getParameter("program_id"));
if(programIdParameter > -1)
{
	session.setAttribute("programId",""+programIdParameter);
	programId = ""+programIdParameter; 
}
CourseManager cm = CourseManager.instance();
DepartmentManager dm = DepartmentManager.instance();
String courseId = request.getParameter("course_id") ;
Course course = cm.getCourseById(Integer.parseInt(courseId));
String courseNumber = ""+course.getCourseNumber();
String subject = course.getSubject();
Boolean sessionValue = (Boolean)session.getAttribute("userIsSysadmin");
boolean sysadmin = sessionValue != null && sessionValue;
boolean access = sysadmin;

List<Department> homeDepartments = cm.getDepartmentForCourse(course);
boolean homeDepartment = false;
List<Department> accessToDepartments = new ArrayList<Department>();

if(HTMLTools.isValid(programId))
{
	Program program = ProgramManager.instance().getProgramById(Integer.parseInt(programId));
	
	Organization organization = OrganizationManager.instance().getOrganizationByProgram(program);
	HashMap<String,Organization>  userHasAccessToOrganizations = (HashMap<String,Organization>)session.getAttribute("userHasAccessToOrganizations");
	if(userHasAccessToOrganizations == null)
		userHasAccessToOrganizations = new HashMap<String,Organization>();
	if(sysadmin)
	{
		List<Organization> allOrgs = OrganizationManager.instance().getAllOrganizations();
		for(Organization org : allOrgs)
		{
			userHasAccessToOrganizations.put(""+org.getId(), org);
		}
	}

	for(Organization org:userHasAccessToOrganizations.values())
	{
		accessToDepartments.add(org.getDepartment());
	}
	
	access = sysadmin || userHasAccessToOrganizations!=null && userHasAccessToOrganizations.containsKey(""+organization.getId());
	for(Department dept: homeDepartments)
	{
		if(dept.getId() == organization.getDepartment().getId())
		{
			homeDepartment = true;
		}
	}

}
List<Program> programs = new ArrayList<Program>();
Program bogus = new Program();
bogus.setId(-1);
bogus.setName("Please select a Program");
programs.add(bogus);
for(Department dep : accessToDepartments)
{	
	for(Program p : dm.getProgramOrderedByNameForDepartmentLinkedToCourse(dep,course))
	{
		boolean notInYet = true;
		for(Program toCheck : programs)
		{
			if(toCheck.getId() == p.getId())
			{
				notInYet = false;
			}
		}
		if(notInYet)
		{
			programs.add(p);
		}
	}
}

out.println("Currently selected Program :");
out.println(HTMLTools.createSelect("programToSet", programs, "Id", "Name", programId, "setProgramCourseContributionId("+courseId+")"));

String courseTitle = null;
LinkCourseProgram temp = cm.getLinkCourseProgramByCourseAndProgram(Integer.parseInt(programId),course.getId());
boolean linkExists = false;
String hideOfferings = "style=\"display:none;\" ";
if(temp != null)
{
	hideOfferings = "";
}
%>

<h2>Course Information for <%=subject%> <%=courseNumber%> <%=course.getTitle()%><%if(access){%> <img src="/cat/images/edit_16.gif" alt="Edit" onclick="loadModify('/cat/auth/modifyProgram/course.jsp?course_id=<%=course.getId()%>&program_id=<%=programId%>');"><%}%></h2>

<jsp:include page="linkProgramCourse.jsp"> 
	<jsp:param value="<%=courseId%>" name="course_id"/>	
	<jsp:param value="<%=programId%>" name="program_id"/>	
</jsp:include>

<%
if(homeDepartment)
{%>

<div id="courseOfferingsDiv" <%=hideOfferings%> >
	<jsp:include page="courseOfferings.jsp"> 
	 	<jsp:param name="course_id" value="<%=course.getId()%>"/>
	 	<jsp:param value="<%=programId%>" name="program_id"/>	
	 </jsp:include>
</div>

<div id="summaryCourseOutcomes">
	<jsp:include page="summaryCourseOutcomes.jsp"> 
	 	<jsp:param name="course_id" value="<%=course.getId()%>"/>
	 	<jsp:param value="<%=programId%>" name="program_id"/>	
	 </jsp:include>
</div>

<%
}
else
{
	

%>
	<div id="programOutcomeContributionsDiv">
	<jsp:include page="programOutcomeContributions.jsp"> 
	 	<jsp:param name="course_id" value="<%=course.getId()%>"/>
	 	<jsp:param value="<%=programId%>" name="program_id"/>	
	 </jsp:include>
</div>
<%}
%>

