<%@ page import="java.util.*,java.net.*,ca.usask.gmcte.util.*,ca.usask.gmcte.currimap.model.*"%>
<jsp:include page="header.jsp"/>
		<div id="content-and-context" style="overflow:auto;">
			<div class="wrapper" style="overflow:auto;"> 
				<div id="content" style="overflow:auto;"> 
					<div id="breadcrumbs"><p><a href="http://www.usask.ca/gmcte/">The Gwenna Moss Centre for Teaching Effectiveness</a> &gt; Curriculum Alignment Tool</p></div>  
					<div id="allOrganizations" class="module" style="overflow:auto;">
						<jsp:include page="organizationOfferings.jsp"/>
					</div>
					<a name="modifyLocation"></a>
					<div id="modifyDiv"  class="fake-input" style="display:none;"></div>
				</div>
			</div>
		</div>


<jsp:include page="footer.jsp"/>		