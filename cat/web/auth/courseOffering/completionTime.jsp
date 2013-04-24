<%@ page import="java.util.*,java.net.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.action.*,ca.usask.gmcte.currimap.model.*"%>



<h2>Some final questions</h2>
<br>
Please complete the following questions and click the "save responses" button to save your answers.
<br/>
<%
int courseOfferingId = HTMLTools.getInt(request.getParameter("course_offering_id"));
CourseManager cm = CourseManager.instance();
CourseOffering courseOffering = cm.getCourseOfferingById(courseOfferingId);
int programId = HTMLTools.getInt((String)session.getAttribute("programId"));
%>
<form>
		<input type="hidden" name="program_id" value="<%=programId%>" id="program_id" />
		<input type="hidden"  name="course_offering_id" value="<%=courseOfferingId%>" id="course_offering_id"/>	

<jsp:include page="programQuestions.jsp" >
<jsp:param name="program_id" value="<%=programId%>"/>
<jsp:param name="course_offering_id" value="<%=courseOfferingId%>"/>
</jsp:include>

</form>