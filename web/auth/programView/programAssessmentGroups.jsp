<%-- 
    Copyright 2012, 2013 University of Saskatchewan

    This file is part of the Curriculum Alignment Tool (CAT).

    CAT is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    CAT is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with CAT.  If not, see <http://www.gnu.org/licenses/>.
--%>


<%@ page import="java.util.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.action.*,ca.usask.gmcte.currimap.model.*,ca.usask.gmcte.currimap.model.to.*,java.text.NumberFormat,java.awt.image.BufferedImage,java.io.*,javax.imageio.*"%>
<%
String[] courseIds = request.getParameterValues("course_id");
List<String> courseIdList = null;
if(courseIds!=null && courseIds.length > 0)
	courseIdList = Arrays.asList(courseIds);
String[] terms = request.getParameterValues("term");
List<String> termList = new ArrayList<String>();
if(terms!=null && terms.length > 0)
	termList = Arrays.asList(terms);

ProgramManager pm = ProgramManager.instance();

int programId = HTMLTools.getInt(request.getParameter("program_id"));
Program program = pm.getProgramById(programId);

CourseManager cm = CourseManager.instance();
CourseOffering courseOffering = null;
StringBuilder optionsString = new StringBuilder();
StringBuilder optionValuesString = new StringBuilder();

List<AssessmentGroup> groupsList = cm.getAssessmentGroups();

int maxValue = groupsList.get(groupsList.size()-1).getDisplayIndex();

boolean debug = request.getParameter("debug")!=null;
		
List<CourseAssessmentOption> assessmentGroupData = pm.getProgramAssessmentGroups(program, termList);
Map<String, Integer> offeringCounts = pm.getCourseOfferingCounts(program ,termList);
HashMap<String, ArrayList<Double>>	organizedAssessmentGroupData = pm.organizeAssessmentGroupData(assessmentGroupData, maxValue, offeringCounts);


//initialize the results list
ArrayList<Double> results = new ArrayList<Double>();

boolean dataFound = false;

for(int i = 0 ; i <= groupsList.size(); i++)
	results.add(new Double(0.0));
if(debug) out.println("<table>");

//go through the data and add the values found to the result array
for(String courseId : organizedAssessmentGroupData.keySet())
{
	if(debug) out.println("<tr><td>CourseId="+courseId);
	if(courseIdList != null && courseIdList.contains(courseId))
	{
		ArrayList<Double> courseData = organizedAssessmentGroupData.get(courseId);
		
		for(int i=1 ; i <= groupsList.size()  ; i++)
		{
			if(courseData.get(i) != null && courseData.get(i) > 0.0 )
				dataFound = true;
			if(debug) out.print("<td>" + results.get(i) + " => ");
			results.set(i, results.get(i)+courseData.get(i));
			if(debug) out.print(results.get(i)+"</td>");
		}
		if(debug) out.print("<td> Sum: " + results.get(0) + " => ");
		results.set(0, results.get(0)+1.0);
		if(debug) out.print(results.get(0)+"</td>");
	}	
	if(debug) out.println("</tr>");
}
if(debug) out.println("</table>");
if(debug)
{
	out.println("<table border=1><tr>");
	for(int i = 0 ; i <= groupsList.size(); i++)
		out.println("<td>"+ i + " "+ results.get(i)+"</td>");
	out.println("</tr></table>");
}

int tableWidth = 800;
double valuePerPercent = tableWidth / 100.0;

List<String> groupNames = new ArrayList<String>();
List<Double> groupValues = new ArrayList<Double>();
double maxSum = -1.0;

for(int i = 0 ; i < groupsList.size(); i++)
{
	AssessmentGroup group = groupsList.get(i);
	groupNames.add(group.getName());
	double value = results.get(group.getDisplayIndex())/results.get(0);
	if(value > maxSum)
		maxSum = value;
	
	groupValues.add(value);
}
String[] colors = {"red", "blue",  "pink", "magenta","purple","grey"}; 
AssessmentCategoriesBarChart barchart = new AssessmentCategoriesBarChart();
barchart.init(groupNames.size(), groupNames,"No data to display, please select (a) course(s) above.", groupValues, maxSum,new ArrayList<Integer>(0));
BufferedImage offImage = barchart.getImage();

response.setContentType("image/png");
OutputStream os = response.getOutputStream();
ImageIO.write(offImage, "png", os);
os.close();
%>

