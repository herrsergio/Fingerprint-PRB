<%--
##########################################################################################################
# Nombre Archivo  : AssistanceReportYum.jsp     
# Compania        : PRB
# Autor           : Sergio Cuellar
# Objetivo        : Reporte de Asistencia biometrico
# Fecha Creacion  : 08/Febrero/12
# Inc/requires    : ../Include/CommonLibyum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos
##########################################################################################################
--%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/AssistanceLibYum.jsp" %>


<%! AbcUtils moAbcUtils = new AbcUtils();

    String msPreviousYear;
    String msYear;
    String msPeriod;
    String msWeek;
    String msWeekId;
    String msDay;
    String msReport;
    String msMessage;
    String msDataset;
    boolean reportOk;
%>

<%
    try
    {
        msYear            = request.getParameter("hidSelectedYear");
        msPeriod          = request.getParameter("hidSelectedPeriod");
        msWeek            = request.getParameter("hidSelectedWeek");
        msDay             = request.getParameter("hidSelectedDay");
        msReport          = request.getParameter("hidReportType");
        msMessage = "";
        msDataset = "new Array()";
        reportOk  = false;
        System.out.println("msWeek:"+msWeek);
        if(!msWeek.equals("0"))
        {
            msWeekId = getWeekId(msYear, msPeriod, msWeek);
        }

        if(msReport.equals("3"))//Se tiene que escoger una semana o un dia
        {
            reportOk  = true;
            msDataset = getDataset(msYear, msPeriod, msWeek, msDay);
	}
	else
	{
               msMessage = "Seleccione alg&uacute;n d&iacute;a del calendario Yum.";
	}
	
        //reportOk  = true;//reportOk(msPreviousYear, msYear, msPeriod, msWeekId);
        //updateConm(msYear, msPeriod, msWeekId, msDay); 

    }
    catch(Exception e)
    {
        System.out.println("Exception  de AssistanceReportYum ... " + e);
    }

	//System.out.println(msDataset);
%>

<html>
    <head>
        <%@ include file="/Include/CalendarLibYum.jsp" %>
        <script language="javascript" src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="../Scripts/AssistanceReportYum.js"></script>
        <script>
            var reportOk = <%= reportOk %>;

            function submitFrame(frameName)
            {
                document.mainform.target = frameName;

                if(frameName=='preview')
                    document.mainform.hidTarget.value = "Preview";

                if(frameName=='printer')
                    document.mainform.hidTarget.value = "Printer";

                document.mainform.submit();
            }
            function submitFrames()
            {
                setTimeout("submitFrame('printer')", 1000);
                //Despues de 2 seg se carga el segundo frame
                setTimeout("submitFrame('preview')", 3000);
            }

            function doAction()
            {

                if(reportOk == true)
                {
                    submitFrames();
                }
                else
                {    
                    document.mainform.action = '/MessageYum.jsp';
                    addHidden(document.mainform, 'hidTitle', 'Reporte de asistencia en biom&eacute;trico');
                    addHidden(document.mainform, 'hidSplit', 'true');
                    submitFrame('preview');
                }
            }
        
            var gaDataset = <%= msDataset %>;


            customDataset(gaDataset);

        </script>
    </head>
    <body onLoad=" doAction()" style="margin-left: 0px; margin-right: 0px">
        <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="530" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>                      
        <form name="mainform" action="AssistanceReportFrm.jsp">
            <input type="hidden" name="year" value="<%= msYear %>">
            <input type="hidden" name="period" value="<%= msPeriod %>">
            <input type="hidden" name="week" value="<%= msWeekId %>">
            <input type="hidden" name="day" value="<%= msDay %>">
            <input type="hidden" name="hidTarget">
            <input type="hidden" name="hidMessage" value="<%= msMessage %>">
            <input type="hidden" name="hidPreviousYear" value="<%= msPreviousYear %>">
        </form>
    </body>
</html>

