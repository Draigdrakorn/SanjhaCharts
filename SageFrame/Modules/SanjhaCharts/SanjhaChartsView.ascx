<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SanjhaChartsView.ascx.cs" Inherits="Modules_SanjhaCharts_SanjhaChartsView" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<script type="text/javascript">
    $(document).ready(function () {
        var isDataPresent = '<%=IsDataPresent%>';
        var data = '';
        if (isDataPresent == "true") {
            var moduleID = '<%=ModuleID%>';
            var chartData = '<%=ChartData%>';
            var chartTypeID = '<%=ChartTypeID%>';
            var chartTitle = '<%=ChartTitle%>';
            var verticalValue = '<%=VerticalValue%>';
            var horizontalValue = '<%=HorizontalValue%>';
            var showIndex = '<%=ShowIndex%>';

            data = eval('(' + chartData + ')');
            if (chartTypeID == 1) {
                var ctx = $('#<%=chartCanvas.ClientID%>').get(0).getContext("2d");
            var newChart = new Chart(ctx).Bar(data);
            if (verticalValue != "" && verticalValue != null) {
                $('#<%=verticalValue.ClientID%>').show();
                    $('#<%=verticalValue.ClientID%> p').text(verticalValue);
                }
                if (horizontalValue != "" && horizontalValue != null) {
                    $('#<%=horizontalValue.ClientID%>').show();
                    $('#<%=horizontalValue.ClientID%> p').html(horizontalValue + "<img src=\"/Modules/SanjhaCharts/img/Arrow-horizontal.png\" width=\"40\" />");
                }
            }
            else if (chartTypeID == 2) {
                $('#<%=verticalValue.ClientID%>').hide();
                $('#<%=horizontalValue.ClientID%>').hide();
                var ctx = $('#<%=chartCanvas.ClientID%>').get(0).getContext("2d");
                var newChart = new Chart(ctx).Pie(data);
            }
        $('#<%=legend.ClientID%>').html(newChart.generateLegend());
            if (showIndex == 0) {
                $('#<%=legend.ClientID%>').hide();
        }

        $('#<%=chartTitle.ClientID%>').text(chartTitle);
        }
    });
</script>

<div id="sanjhaViewContainer" runat="server" class="sanjhaViewContainer">
    <div class="sfCol" id="chartTitle" runat="server">Charts</div>
    <table id="chartTable" runat="server" class="chartTable">
        <tr>
            <td style="vertical-align:middle">
                <div id="verticalValue" runat="server" class="verticalValue"><img src="/Modules/SanjhaCharts/img/Arrow-vertical.png" width="20" id="imgUpArrow"/><p></p></div>
            </td>
            <td>
                <canvas id="chartCanvas" width="300" height="300" runat="server"></canvas>
            </td>
            <td>
                <div id="legend" runat="server" class="legend"></div>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <div id="horizontalValue" runat="server" class="horizontalValue"><p></p></div>
            </td>
        </tr>

    </table>
</div>

