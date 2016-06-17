<%@ WebService Language="C#" Class="SanjhaWebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Excel = Microsoft.Office.Interop.Excel;
using SanjhaCharts.Controller;
using SanjhaCharts.Info;
using SanjhaCharts;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web.Script.Serialization;
using SageFrame.Web;
using System.Web.Script.Services;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SanjhaWebService : System.Web.Services.WebService
{
    private static List<KeyValuePair<string, List<string>>> excelData;
    private int colCount = 0;
    private int rowCount = 0;

    [WebMethod]
    public string HelloWorld()
    {

        return "Hello World";
    }

    /// <summary>
    /// Adds new Chart to the Database or updates existing one based on module ID
    /// </summary>
    /// <param name="chartNo">The no of chart,ie. module ID</param>
    /// <param name="chartTypeID">The ID of chart from table</param>
    /// <param name="verticalValue">The Vertical value for Chart</param>
    /// <param name="horizontalValue">The Horizontal value for Chart</param>
    /// <param name="chartTitle">The title of the Chart</param>
    /// <param name="fileExtension">The extension of chosen file</param>
    /// <param name="showIndex">Show Chart Index or not</param>
    /// <param name="colorValues">The hex values for colors selected</param>
    /// <param name="chartData">The JSON data to create the chart from</param>
    [WebMethod]
    public void AddChart(string chartNo, string chartTypeID, string verticalValue, string horizontalValue, string chartTitle, string fileExtension, int showIndex, string[] colorValues, string chartData)
    {
        bool update = false;
        string result = string.Empty;
        //string result = File.ReadAllText(Server.MapPath("/Modules/SanjhaCharts/Temp/result.txt"));
        SanjhaChartsController objCtl = new SanjhaChartsController();
        SanjhaChartsInfo objInfo = new SanjhaChartsInfo();
        List<SanjhaChartsInfo> lstCharts = objCtl.ChartNosSelectAll();
        int chartNum = int.Parse(chartNo);
        int chartTypeId = int.Parse(chartTypeID);
        if (chartData == null || chartData == "")
        {
            if (File.Exists(Server.MapPath("/Modules/SanjhaCharts/Temp/tempFile") + fileExtension))
            {
                ExcelCheck(fileExtension);
                result = ConvertToJson(colCount, rowCount, excelData, colorValues, chartTypeId);
            }
            else
            {
                SanjhaChartsInfo dataInfo = new SanjhaChartsInfo();
                dataInfo = objCtl.ChartDataSelect(chartNum);
                string value = dataInfo.ChartData;
                result = ChangeColor(value, colorValues);
            }
        }
        else
        {
            result = chartData;
        }
        foreach (var lst in lstCharts)
        {
            if (lst.ChartNo == chartNum)
            {
                update = true;
                break;
            }
            else
            {
                update = false;
            }
        }


        objInfo.ChartNo = chartNum;
        objInfo.ChartTypeID = chartTypeId;
        objInfo.Colors = String.Join(",", colorValues);
        objInfo.VerticalValue = verticalValue;
        objInfo.HorizontalValue = horizontalValue;
        objInfo.ChartTitle = chartTitle;
        objInfo.ChartData = result;
        objInfo.ShowIndex = showIndex;


        if (!update)
        {
            objCtl.ChartAdd(objInfo);
        }
        else
        {
            objCtl.ChartUpdate(objInfo);
        }


    }

    /// <summary>
    /// Analyses the selected file for valid data to draw bar chart
    /// </summary>
    /// <param name="fileExtension">The extension of file chosen</param>
    /// <returns></returns>
    [WebMethod]
    public List<string> AnalyseFile(string fileExtension)
    {
        string err;
        int loopCount = 0;
        SanjhaChartsInfo infoCtl = new SanjhaChartsInfo();
        Excel.Application excelApp = new Excel.Application();
        Excel.Workbook wBook;
        Excel.Worksheet wSheet;
        excelApp.Visible = false;
        List<string> returnValue = new List<string>();
        if (File.Exists(Server.MapPath("/Modules/SanjhaCharts/Temp/tempFile") + fileExtension))
        {
            wBook = excelApp.Workbooks.Open(Server.MapPath("/Modules/SanjhaCharts/Temp/") + "tempFile" + fileExtension);
            wSheet = (Excel.Worksheet)wBook.Sheets[1];
            returnValue.Add("2");
            do
            {
                try
                {
                    Excel.Range range = wSheet.UsedRange;
                    Excel.Range lastCell = range.SpecialCells(Excel.XlCellType.xlCellTypeLastCell, Type.Missing);
                    rowCount = lastCell.Row;
                    colCount = lastCell.Column;
                    loopCount++;
                    if (loopCount > 5)
                    {
                        return returnValue;
                    }
                    err = null;

                }
                catch (Exception ex)
                {
                    err = ex.ToString();
                }
            } while (err != null);

            excelData = GetExcelData(wSheet, colCount, rowCount);

            if (IsExcelDataValid(colCount, rowCount, excelData))
            {
                returnValue[0] = "0";
            }
            else
            {
                returnValue[0] = "1";
            }

            if (returnValue[0] != "1")
            {
                for (int i = 1; i < colCount; i++)
                {
                    returnValue.Add(excelData[i].Key);
                }
            }

            GC.Collect();
            GC.WaitForPendingFinalizers();
            excelApp.Quit();
            Marshal.FinalReleaseComObject(excelApp);
            return returnValue;
        }
        else
        {
            returnValue.Add("3");
            return returnValue;
        }
    }

    ///<summary>
    /// Analyses the selected file for valid data to draw pie chart
    /// </summary>
    /// <param name="fileExtension">The extension of file chosen</param>
    /// <returns></returns>
    [WebMethod]
    public List<string> AnalyseFilePie(string fileExtension)
    {
        string err;
        int loopCount = 0;
        SanjhaChartsInfo infoCtl = new SanjhaChartsInfo();
        Excel.Application excelApp = new Excel.Application();
        Excel.Workbook wBook;
        Excel.Worksheet wSheet;
        excelApp.Visible = false;
        List<string> returnValue = new List<string>();
        if (File.Exists(Server.MapPath("/Modules/SanjhaCharts/Temp/tempFile") + fileExtension))
        {
            wBook = excelApp.Workbooks.Open(Server.MapPath("/Modules/SanjhaCharts/Temp/") + "tempFile" + fileExtension);
            wSheet = (Excel.Worksheet)wBook.Sheets[1];

            returnValue.Add("2");
            do
            {
                try
                {
                    Excel.Range range = wSheet.UsedRange;
                    Excel.Range lastCell = range.SpecialCells(Excel.XlCellType.xlCellTypeLastCell, Type.Missing);
                    rowCount = lastCell.Row;
                    colCount = lastCell.Column;
                    loopCount++;
                    if (loopCount > 5)
                    {
                        return returnValue;
                    }
                    err = null;

                }
                catch (Exception ex)
                {
                    err = ex.ToString();
                }
            } while (err != null);

            excelData = GetExcelData(wSheet, colCount, rowCount);

            if (excelData.Count <= 2)
            {
                returnValue[0] = "0";
            }
            else
            {
                returnValue[0] = "1";
            }


            if (returnValue[0] != "1")
            {
                for (int i = 1; i < rowCount; i++)
                {
                    returnValue.Add(excelData[0].Value[i - 1]);
                }
            }

            GC.Collect();
            GC.WaitForPendingFinalizers();
            excelApp.Quit();
            Marshal.FinalReleaseComObject(excelApp);
            return returnValue;
        }
        else
        {
            returnValue.Add("3");
            return returnValue;
        }
    }

    /// <summary>
    /// Changes the colors for existing charts
    /// </summary>
    /// <param name="value">The chart data from database</param>
    /// <param name="colorValues">The hex codes for new color values</param>
    /// <returns></returns>
    public string ChangeColor(string value, string[] colorValues)
    {
        var stringBuilder = new StringBuilder(value);
        int startValue = 0;
        List<string> previousColors = new List<string>();
        for (int i = 0; i < colorValues.Length; i++)
        {
            int position = value.IndexOf('#', startValue);
            previousColors.Add(value.Substring(position, 7));
            startValue = position + 7;
        }

        for (int i = 0; i < colorValues.Length; i++)
        {
            stringBuilder.Replace(previousColors[i], colorValues[i]);
        }
        string newValue = stringBuilder.ToString();
        return newValue;
    }

    /// <summary>
    /// Checks the Selected file and Analyses the data
    /// </summary>
    /// <param name="fileExtension">The extension of selected file</param>
    public void ExcelCheck(string fileExtension)
    {
        string err;
        int loopCount = 0;
        SanjhaChartsInfo infoCtl = new SanjhaChartsInfo();
        Excel.Application excelApp = new Excel.Application();
        Excel.Workbook wBook;
        Excel.Worksheet wSheet;
        excelApp.Visible = false;
        wBook = excelApp.Workbooks.Open(Server.MapPath("/Modules/SanjhaCharts/Temp/") + "tempFile" + fileExtension);
        wSheet = (Excel.Worksheet)wBook.Sheets[1];
        do
        {
            try
            {
                Excel.Range range = wSheet.UsedRange;
                Excel.Range lastCell = range.SpecialCells(Excel.XlCellType.xlCellTypeLastCell, Type.Missing);
                rowCount = lastCell.Row;
                colCount = lastCell.Column;
                loopCount++;
                if (loopCount > 5)
                {
                    return;
                }
                err = null;

            }
            catch (Exception ex)
            {
                err = ex.ToString();
            }
        } while (err != null);

        excelData = GetExcelData(wSheet, colCount, rowCount);

        GC.Collect();
        GC.WaitForPendingFinalizers();
        excelApp.Quit();
        Marshal.FinalReleaseComObject(excelApp);

        DeleteFile(fileExtension);
    }

    /// <summary>
    /// Gets data from selected excel file
    /// </summary>
    /// <param name="wSheet">Variable representing the excel worksheet</param>
    /// <param name="colCount">No of columns in the file</param>
    /// <param name="rowCount">No of rows in the file</param>
    /// <returns></returns>
    public List<KeyValuePair<string, List<string>>> GetExcelData(Excel.Worksheet wSheet, int colCount, int rowCount)
    {
        string lastCol = AlphabetNumberMap.AlphabetMap(colCount);
        Array fields = ((Array)wSheet.get_Range("A1", lastCol + "1").Cells.Value);
        List<KeyValuePair<string, List<string>>> excelValues = new List<KeyValuePair<string, List<string>>>();
        for (int i = 1; i <= colCount; i++)
        {
            Array values = ((Array)wSheet.get_Range(AlphabetNumberMap.AlphabetMap(i) + "2", AlphabetNumberMap.AlphabetMap(i) + rowCount.ToString()).Cells.Value);
            List<string> tempValue = new List<string>();
            for (int j = 1; j < rowCount; j++)
            {
                tempValue.Add(values.GetValue(j, 1).ToString());
            }

            excelValues.Add(new KeyValuePair<string, List<string>>(fields.GetValue(1, i).ToString(), tempValue));

        }

        return excelValues;
    }

    /// <summary>
    /// Returns if retreived data is valid or not
    /// </summary>
    /// <param name="colCount">No of columns</param>
    /// <param name="rowCount">No of rows</param>
    /// <param name="excelValues">The excel data retreived</param>
    /// <returns></returns>
    public bool IsExcelDataValid(int colCount, int rowCount, List<KeyValuePair<string, List<string>>> excelValues)
    {
        //test the values
        bool isValid = false;
        for (int i = 0; i < colCount; i++)
        {
            for (int j = 0; j < rowCount - 1; j++)
            {
                string tempTest = excelValues[i].Value[j];
                float tempValue;
                if (i != 0)
                {
                    if (float.TryParse(tempTest, out tempValue))
                    {
                        isValid = true;
                    }
                    else
                    {
                        isValid = false;
                        return isValid;
                    }
                }
                else
                {
                    isValid = false;
                }
            }
        }
        return isValid;
    }

    /// <summary>
    /// Converts Excel data to Json
    /// </summary>
    /// <param name="colCount">No of columns</param>
    /// <param name="rowCount">No of rows</param>
    /// <param name="excelData">Excel Data retreived</param>
    /// <param name="colorValues">Hex codes for colors selected</param>
    /// <param name="chartTypeID">Type of chart selected</param>
    /// <returns></returns>
    public string ConvertToJson(int colCount, int rowCount, List<KeyValuePair<string, List<string>>> excelData, string[] colorValues, int chartTypeID)
    {
        var data = "";
        if (chartTypeID == 1)
        {
            data += "{ labels:[";
            for (int j = 0; j < rowCount - 1; j++)
            {
                data += "\"" + excelData[0].Value[j] + "\",";
            }

            data += "], datasets:[  ";

            for (int i = 1; i < colCount; i++)
            {
                data += "{ label: \"" + excelData[i].Key + "\",";
                data += "fillColor: \"" + colorValues[i - 1] + "\",";
                data += "data: [";
                for (int j = 0; j < rowCount - 1; j++)
                {
                    data += excelData[i].Value[j] + ",";
                }
                if (i != colCount - 1)
                {
                    data += "] },";
                }
            }

            data += "] }, ] }";
        }
        else
        {
            data += "[";
            for (int i = 0; i < rowCount - 1; i++)
            {
                data += "{ value:" + excelData[1].Value[i] + "," +
                         "color:\"" + colorValues[i] + "\"," +
                         "label:\"" + excelData[0].Value[i] + "\"},";

            }

            data += "]";

        }


        return data;
    }

    /// <summary>
    /// Deletes the temporary excel file
    /// </summary>
    /// <param name="fileExtension">Extension of file selected</param>
    public void DeleteFile(string fileExtension)
    {

        if (File.Exists(Server.MapPath("/Modules/SanjhaCharts/Temp/tempFile") + fileExtension))
        {
            File.Delete(Server.MapPath("/Modules/SanjhaCharts/Temp/tempFile") + fileExtension);
        }
    }

    /// <summary>
    /// Gets Charts Data from database according to module ID
    /// </summary>
    /// <param name="ChartNo">The Chart No represented by module ID</param>
    /// <returns></returns>
    [WebMethod]
    public SanjhaChartsInfo GetChartData(int ChartNo)
    {
        SanjhaChartsController objCtl = new SanjhaChartsController();
        SanjhaChartsInfo listInfo = new SanjhaChartsInfo();
        listInfo = objCtl.ChartDataSelect(ChartNo);
        return listInfo;

    }
}