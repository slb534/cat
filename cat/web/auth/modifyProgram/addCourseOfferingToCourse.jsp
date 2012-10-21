<%@ page import="java.util.*,java.net.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.action.*,ca.usask.gmcte.currimap.model.*"%>
<%
String courseId = request.getParameter("course_id") ;
String programId = request.getParameter("program_id") ;
CourseManager cm = CourseManager.instance();

Course course = cm.getCourseById(Integer.parseInt(courseId));
CourseOffering offering = null;
String courseOfferingId = request.getParameter("course_offering_id") ;
boolean editing = false;
if(HTMLTools.isValid(courseOfferingId))
{
	offering = cm.getCourseOfferingById(Integer.parseInt(courseOfferingId));
	editing = true;
}

%>
<h3>Add a course offering to course <%=course.getSubject()%> <%=course.getCourseNumber()%></h3>
<br/>
<form name="newCourseOfferingForm" id="newCourseOfferingForm" method="post" action="" >
	<input type="hidden" name="objectClass" id="objectClass" value="CourseOffering"/>
	<input type="hidden" name="course_id" id="course_id" value="<%=courseId%>"/>
	<input type="hidden" name="program_id" id="program_id" value="<%=programId%>"/>
	<%if(editing)
	{
		%><input type="hidden" name="course_offering_id" id="course_offering_id" value="<%=courseOfferingId%>"/><%
	}%>
	<div class="formElement">
		<div class="label">Section Number/Module:</div>
		<div class="field"> <input type="text" size="4" maxLength="4" name="sectionNumber" id="sectionNumber" value="<%=editing?offering.getSectionNumber():"01"%>"/></div>
		<div class="error" id="sectionNumberMessage"></div>
		<div class="spacer"> </div>
	</div>
	<br/>
	<div class="formElement">
		<div class="label">Term:</div>
		<div class="field"> <input type="text" size="6" maxlength="6" name="term" id="term" value="<%=editing?offering.getTerm():"201109"%>"/></div>
		<div class="error" id="termMessage"></div>
		<div class="spacer"> </div>
	</div>
	<br/>
	<div class="formElement">
		<div class="label">Medium:</div>
		<div class="field">
		<%
		List<String> values = new ArrayList<String>();
		values.add("Face to face");
		values.add("Online");
		values.add("Blended");
		out.println(HTMLTools.createSelect("medium", values, values, editing?offering.getMedium():null, null));
		%>
		</div>
		<div class="error" id="mediumMessage"></div>
		<div class="spacer"> </div>
	</div>
	<br/>
	<%if(editing)
	{%>
	<div id="courseOfferingInstructorsDiv">
		<jsp:include page="courseOfferingInstructors.jsp"/>
	</div>
	<%}%>
	<div class="formElement">
		<div class="label"><input type="button" name="saveCourseOfferingButton" id="saveCourseOfferingButton" value="Save Course Offering" onclick="saveProgram(new Array('sectionNumber','term','medium'),new Array('sectionNumber','term','medium','course_id','program_id'));" /></div>
		<div class="field"><div id="messageDiv" class="completeMessage"></div></div>
		<div class="spacer"> </div>
	</div>
</form>

		