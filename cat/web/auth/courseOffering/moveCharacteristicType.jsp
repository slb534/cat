<%@ page import="java.util.*,java.net.*,ca.usask.gmcte.currimap.action.*,ca.usask.gmcte.currimap.model.*"%>
<%
String charTypeId = request.getParameter("charTypeId");
String departmentId = request.getParameter("department_id");
String direction = request.getParameter("direction");

if(!DepartmentManager.instance().moveCharacteristicType(Integer.parseInt(departmentId), Integer.parseInt(charTypeId),direction))
{
	out.println("ERROR: Unable to move Characteristic Type "+direction);
}

%>
		