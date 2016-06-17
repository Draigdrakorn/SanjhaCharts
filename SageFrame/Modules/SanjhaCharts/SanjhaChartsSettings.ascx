<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SanjhaChartsSettings.ascx.cs" Inherits="Modules_SanjhaCharts_SanjhaChartsSettings" %>

<script type="text/javascript">
    var moduleID = '<%=moduleID%>';
</script>


<div>
    <h1>Chart Settings</h1>
    <table id="tblSettingsContainer">
        <tr>
            <td>
                <label id="lblDataSource" class="sfFormlabel scLabel" for="fileDataSource">Data Source</label></td>
            <td>
                <input type="file" id="fileDataSource" accept=".xls,.xlsx"/></td>
            <td><div id ="lblFileStatus"></div></td>
        </tr>
        <tr>
            <td>
                <label id="lblChartType" class="sfFormlabel scLabel" for="selChartType">Chart Type</label></td>
            <td>
                <asp:DropDownList ID="dListChart" runat="server" ClientIDMode="Static"></asp:DropDownList>
            </td>
            <td><div id ="lblChartStatus"></div></td>
        </tr>
        <tr>
            <td>
                <label id="lblChartColors" class="sfFormlabel scLabel" for="selChartType">Chart Colors</label></td>
            <td>
                <div id="divColors"></div>
            </td>
        </tr>
        <tr>
            <td>
                <label id="lblChartTitle" class="sfFormlabel scLabel" for="txtChartTitle">Chart Title</label></td>
            <td>
                <input type="text" id="txtChartTitle" class="sfInputbox scInput" /></td>
        </tr>
        <tr>
            <td>
                <label id="lblVerticalValue" class="sfFormlabel scLabel" for="txtVerticalValue">Vertical Value</label></td>
            <td>
                <input type="text" id="txtVerticalValue" class="sfInputbox scInput" /></td>
        </tr>
        <tr>
            <td>
                <label id="lblHorizontalValue" class="sfFormlabel scLabel" for="txtHorizontalValue">Horizontal Value</label></td>
            <td>
                <input type="text" id="txtHorizontalValue" class="sfInputbox scInput" /></td>
        </tr>
        <tr>
            <td>
                <label id="lblShowIndex" class="sfFormlabel scLabel" for="chkShowIndex">Show Index</label></td>
            <td>
                <input type="checkbox" id="chkShowIndex" class="sfCheckbox scInput" /></td>
        </tr>
    </table>
    <div class="divSanjhaCharts">
        <label id="btnSave" class="icon-save sfBtn">Save</label>
        <label id="btnCancel" class="icon-close sfBtn">Cancel</label>
    </div>
</div>
