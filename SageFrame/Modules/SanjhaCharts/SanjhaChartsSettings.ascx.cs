using System;
using SageFrame.Web;
using SanjhaCharts.Controller;
using SanjhaCharts.Info;
using System.Collections.Generic;

public partial class Modules_SanjhaCharts_SanjhaChartsSettings : BaseAdministrationUserControl
{
    public int moduleID;
    protected void Page_Load(object sender, EventArgs e)
    {
        
        
            IncludeCss("SanjhaCharts", "/Modules/SanjhaCharts/CSS/SanjhaCSS.css");
            IncludeJs("SanjhaCharts", "/Modules/SanjhaCharts/JS/jquery.fileupload.js");
            IncludeJs("SanjhaCharts", "/Modules/SanjhaCharts/JS/jquery.iframe-transport.js");
            IncludeJs("SanjhaCharts", "/Modules/SanjhaCharts/JS/SanjhaSettings.js");

            SanjhaChartsController objCtl = new SanjhaChartsController();
            List<SanjhaChartsInfo> lstChartsType = objCtl.ChartTypeSelect();
            dListChart.DataTextField = "ChartName";
            dListChart.DataValueField = "ChartTypeID";
            dListChart.DataSource = lstChartsType;
            dListChart.DataBind();
       
            moduleID = GetModuleID;
        
    }

    public int GetModuleID
    {
        get
        {
            if (!string.IsNullOrEmpty(SageUserModuleID))
            {
                moduleID = Int32.Parse(SageUserModuleID);
            }
            return moduleID;
        }
    }


}