<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.net.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.model.*,ca.usask.gmcte.currimap.action.*, org.apache.log4j.Logger,org.hibernate.validator.Length"%>
<%!private static Logger logger = Logger.getLogger("/auth/courseOffering/index.jsp");%>
<%
Enumeration e = request.getParameterNames();
while(e.hasMoreElements())
{
	String pName = (String)e.nextElement();
	String value = request.getParameter(pName);
	logger.error("("+pName + ") = ("+value+")");
}


String object = request.getParameter("object");
if(object == null)
{
	out.println("ERROR: Unable to determine what to do (Object not found)");	
	return;
}

if(object.equals("TeachingMethod"))
{
	String teachingMethodName = request.getParameter("newTeachingMethodName");
	String newTeachingMethodDescription = request.getParameter("newTeachingMethodDescription");
	CourseManager manager = CourseManager.instance();
	if(manager.saveTeachingMethod(teachingMethodName,newTeachingMethodDescription) )
	{
		out.println("Teaching Method added");
	}
	else
	{
		out.println("There was a problem adding the Teaching Method!");
	}
	
}
else if(object.equals("AssessmentMethod"))
{
	String teachingMethodName = request.getParameter("newAssessmentMethodName");
	String newTeachingMethodDescription = request.getParameter("newAssessmentMethodDescription");
	CourseManager manager = CourseManager.instance();
	if(manager.saveAssessment(teachingMethodName,newTeachingMethodDescription) )
	{
		out.println("Assessment type added");
	}
	else
	{
		out.println("There was a problem adding the Assessment type!");
	}
	
}
else if(object.equals("LinkCourseOfferingAssessmentMethod"))
{
	String courseOfferingId = request.getParameter("course_offering_id");
	String assessmentId = request.getParameter("assessmentMethod");
	
	String weight = request.getParameter("assessmentWeight");
	String additionalInfo = request.getParameter("additional_info");
	
	String criterionExists = request.getParameter("criterion_exists");
	String criterionLevel = request.getParameter("criterion_level");
	String criterionSubmitted = request.getParameter("criterion_submitted");
	String criterionCompleted = request.getParameter("criterion_completed");
	
	
	int id = HTMLTools.getInt(request.getParameter("assessment_link_id"));
	String when = request.getParameter("when");
	CourseManager manager = CourseManager.instance();
	List<AssessmentFeedbackOptionType> questions = manager.getAssessmentFeedbackQuestions();
	String[] additionalQuestionAnswers = request.getParameterValues("additionalQuestionAnswer");
	if(id > -1)
	{
		if(manager.updateLinkCourseOfferingAssessment(id,Integer.parseInt(assessmentId),Double.parseDouble(weight),Integer.parseInt(when),criterionExists,Double.parseDouble(criterionLevel),criterionSubmitted,criterionCompleted,additionalQuestionAnswers,additionalInfo))
		{
			out.println("Assessment info updated");
		}
		else
		{
			out.println("There was a problem updating the assessment info!");
		}
	}
	else if(manager.saveLinkCourseOfferingAssessment(Integer.parseInt(courseOfferingId), Integer.parseInt(assessmentId), Double.parseDouble(weight), Integer.parseInt(when),criterionExists,Double.parseDouble(criterionLevel),criterionSubmitted,criterionCompleted,additionalQuestionAnswers,additionalInfo))
	{
		out.println("Assessment info added");
	}
	else
	{
		out.println("There was a problem adding the assessment info!");
	}
	
}
else if(object.equals("CourseOfferingOutcome"))
{
	int existingOutcomeId = HTMLTools.getInt(request.getParameter("outcome_id"));
	String courseOfferingId = request.getParameter("course_offering_id");
	String mainCharacteristicId = request.getParameter("char_id");
	String mainCharacteristicType = request.getParameter("char_type");
	String characteristicCount = request.getParameter("char_count");
	int charCount = Integer.parseInt(characteristicCount);
	String outcomeName = request.getParameter("outcomeToAdd");
	OutcomeManager manager = OutcomeManager.instance();
	String userid=(String)session.getAttribute("edu.yale.its.tp.cas.client.filter.user");
	int maxFieldSize= (CourseOutcome.class.getMethod("getName")).getAnnotation(Length.class).max();
	if(outcomeName.length() > maxFieldSize)
	{
		out.println("Maximum length of the outcome is "+maxFieldSize+" characters. The one you entered is "+outcomeName.length()+" characters.");
		return;
	}
	
	if(existingOutcomeId < 0 )
	{
		boolean allOkay = true;
		//new outcome link
		
		
		existingOutcomeId = manager.saveCourseOfferingOutcomeLink(Integer.parseInt(courseOfferingId), outcomeName, existingOutcomeId);
		manager.saveCharacteristic(Integer.parseInt(courseOfferingId), existingOutcomeId, mainCharacteristicId,mainCharacteristicType,userid);
		for(int i=1; i < charCount ; i++ )
		{
			String charString = request.getParameter("characteristic_"+i);
			String charType = request.getParameter("characteristic_type_"+i);
			logger.error("charString = ["+charString+"] charType ("+"characteristic_type_"+i+") = ["+charType+"]");
			
			allOkay = allOkay && manager.saveCharacteristic(Integer.parseInt(courseOfferingId), existingOutcomeId, charString,charType,userid);
			
		}
		if(allOkay)
		{
			out.println("Outcome added");
		}
		else
		{
			out.println("ERROR: saving new outcome");
		}
	}
	else
	{
		manager.saveCourseOfferingOutcomeLink(Integer.parseInt(courseOfferingId), outcomeName, existingOutcomeId);
		boolean allOkay = true;
		//saving existing
		for(int i=1; i < charCount ; i++ )
		{
			String charString = request.getParameter("characteristic_"+i);
			String charType = request.getParameter("characteristic_type_"+i);
			logger.error("charString = ["+charString+"] charType ("+"characteristic_type_"+i+") = ["+charType+"]");
			
			allOkay = allOkay && manager.updateCharacteristic(Integer.parseInt(courseOfferingId), existingOutcomeId, charString,charType,userid);
			
		}
		if(allOkay)
		{
			out.println("Outcome updated");
		}
		else
		{
			out.println("ERROR: saving outcome changes");
		}
		
	}
}
else if(object.equals("CharacteristicType"))
{//newOutcomeName','newOutcomeDescription','program_id','newOutcomeProgramSpecific'
	String name = request.getParameter("name");
	String id = request.getParameter("id");
	String questionDisplay = request.getParameter("questionDisplay");
	String valueType = request.getParameter("valueType");
	CharacteristicManager manager = CharacteristicManager.instance();
/*	if(HTMLTools.isValid(id))
	{
		//update
		/if(manager.updateCharacteristicType(id,name, questionDisplay,valueType))
		{
			out.println("Characteristic Type saved");
		}
		else
		{
			out.println("ERROR: Unable to save new outcome");
		}
	}
	else
	{
		if(manager.saveCharacteristicType(name, questionDisplay,valueType))
		{
			out.println("Characteristic Type saved");
		}
		else
		{
			out.println("ERROR: Unable to save new outcome");
		}
	}*/
}
else if(object.equals("CourseOfferingComments"))
{
	String comments = request.getParameter("comments");
	String id = request.getParameter("course_offering_id");
	
	CourseManager manager = CourseManager.instance();
	if(id != null)
	{
		if(manager.setCommentsForCourseOffering(Integer.parseInt(id),comments))
		{
			out.println("comments updated");
		}
		else
		{
			out.println("ERROR: unable to update comments!");
		}
	}
}
else if(object.equals("ExportOfferingData"))
{
	int to = HTMLTools.getInt(request.getParameter("to"));
	int from = HTMLTools.getInt(request.getParameter("course_offering_id"));
	int programId = HTMLTools.getInt(request.getParameter("program_id"));
	
	CourseManager manager = CourseManager.instance();
	if(to >= 0 && from >= 0 && programId >=0)
	{
		if(manager.copyDataFromOfferingToOffering(from, to, programId))
		{
			out.println("Data copied");
		}
		else
		{
			out.println("ERROR: unable to copy data!");
		}
	}
	else
	{
		out.println("ERROR: invalid data");
	}
}
else if (object.equals("EditCourseOutcome"))
{
	int outcomeId = HTMLTools.getInt(request.getParameter("id"));
	CourseOutcome co = DepartmentManager.instance().getCourseOutcomeById(outcomeId);
	String value = request.getParameter("value");
	if(DepartmentManager.instance().saveCourseOutcomeValue(co,value))
	{
		out.println("Value saved");
	}
	else
	{
		out.println("ERROR: Unable to save value");
	}
}
else if (object.equals("CourseOutcomeProgramOutcomeLink"))
{
	int courseOfferingId = HTMLTools.getInt(request.getParameter("course_offering_id"));
	
	int courseOutcomeId = HTMLTools.getInt(request.getParameter("course_outcome_id"));
	int programOutcomeId = HTMLTools.getInt(request.getParameter("program_outcome_id"));
	int existingLinkId = HTMLTools.getInt(request.getParameter("existing_link_id"));

	ProgramManager manager = ProgramManager.instance();
	boolean allOkay = true; 
	
    if( manager.saveCourseOutcomeProgramOutcome(courseOutcomeId, programOutcomeId , courseOfferingId, existingLinkId))
    {
    	out.println("Change saved");
	}
	else
	{
		out.println("ERROR: Unable to save changes");
	}
}

else if (object.equals("TimeItTook"))
{
	int courseOfferingId = HTMLTools.getInt(request.getParameter("course_offering_id"));
	
	int timeItTookId = HTMLTools.getInt(request.getParameter("timeItTookOptionId"));

	CourseManager manager = CourseManager.instance();
	boolean allOkay = true; 
	
    if( manager.saveTimeItTook(courseOfferingId, timeItTookId))
    {
    	out.println("Change saved");
	}
	else
	{
		out.println("ERROR: Unable to save changes");
	}
}
else
{
	out.println("ERROR: Unable to determine what to do (object ["+object+"] not recognized)");	
	return;
}

%>

<%!
public boolean isInt(String s)
{
	try
	{
		Integer.parseInt(s);
		return true;
	}
	catch(Exception e)
	{
	}
	return false;
}
%>