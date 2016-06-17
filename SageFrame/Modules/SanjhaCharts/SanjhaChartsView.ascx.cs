using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SanjhaCharts.Controller;
using SanjhaCharts.Info;

public partial class Modules_SanjhaCharts_SanjhaChartsView : BaseUserControl
{
    public int ModuleID;
    public string ChartData;
    public int ChartTypeID;
    public string IsDataPresent;
    public int ShowIndex;
    public string VerticalValue;
    public string HorizontalValue;
    public string ChartTitle;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeCss("SanjhaCharts", "/Modules/SanjhaCharts/CSS/SanjhaCSS.css");
        //IncludeJs("SanjhaCharts", "/Modules/SanjhaCharts/JS/jquery.fileupload.js");
        IncludeJs("SanjhaCharts", "/Modules/SanjhaCharts/JS/Chart.js");
        //IncludeJs("SanjhaCharts", "/Modules/SanjhaCharts/JS/SanjhaView.js");
        ModuleID = Int32.Parse(SageUserModuleID);
        
        DrawChart();
    }

    /// <summary>
    /// Retrieves data from database based on moduleID and sends the required data to frontend for drawing charts
    /// </summary>
    public void DrawChart()
    {
        SanjhaChartsController objCtl = new SanjhaChartsController();
        SanjhaChartsInfo objInfo = new SanjhaChartsInfo();
        objInfo = objCtl.ChartDataSelect(ModuleID);
        if(objInfo != null)
        {
            IsDataPresent = "true";
            ChartData = objInfo.ChartData;
            ChartTypeID = objInfo.ChartTypeID;
            ChartTitle = objInfo.ChartTitle;
            VerticalValue = objInfo.VerticalValue;
            HorizontalValue = objInfo.HorizontalValue;
            ShowIndex = objInfo.ShowIndex;
        }
        else
        {
            IsDataPresent = "false";
        }
        
    }









}