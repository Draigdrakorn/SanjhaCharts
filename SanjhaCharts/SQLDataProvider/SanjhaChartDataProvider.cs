using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SanjhaCharts.Info;
using SageFrame.Web.Utilities;


namespace SanjhaCharts.SQLDataProvider
{
    class SanjhaChartDataProvider
    {
        public void ChartAdd(SanjhaChartsInfo info)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@ChartNo", info.ChartNo));
            param.Add(new KeyValuePair<string, object>("@ChartTypeID",info.ChartTypeID));
            param.Add(new KeyValuePair<string, object>("@Colors", info.Colors));
            param.Add(new KeyValuePair<string, object>("@VerticalValue", info.VerticalValue));
            param.Add(new KeyValuePair<string, object>("@HorizontalValue", info.HorizontalValue));
            param.Add(new KeyValuePair<string, object>("@ChartTitle", info.ChartTitle));
            param.Add(new KeyValuePair<string, object>("@ShowIndex", info.ShowIndex));
            param.Add(new KeyValuePair<string, object>("@ChartData", info.ChartData));

            SQLHandler objSQL = new SQLHandler();
            objSQL.ExecuteNonQuery("sc_Add_Charts", param);
        }

        public void ChartUpdate(SanjhaChartsInfo info)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@ChartNo", info.ChartNo));
            param.Add(new KeyValuePair<string, object>("@ChartTypeID", info.ChartTypeID));
            param.Add(new KeyValuePair<string, object>("@Colors", info.Colors));
            param.Add(new KeyValuePair<string, object>("@VerticalValue", info.VerticalValue));
            param.Add(new KeyValuePair<string, object>("@HorizontalValue", info.HorizontalValue));
            param.Add(new KeyValuePair<string, object>("@ChartTitle", info.ChartTitle));
            param.Add(new KeyValuePair<string, object>("@ShowIndex", info.ShowIndex));
            param.Add(new KeyValuePair<string, object>("@ChartData", info.ChartData));

            SQLHandler objSQL = new SQLHandler();
            objSQL.ExecuteNonQuery("sc_Update_ChartByID", param);
        }

        public void ChartDelete(int ChartNo)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@ChartNo", ChartNo));

            SQLHandler objSQL = new SQLHandler();
            objSQL.ExecuteNonQuery("sc_Delete_ChartByID", param);
        }

        public SanjhaChartsInfo ChartDataSelect(int ChartNo)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@ChartNo", ChartNo));

            SQLHandler objSQL = new SQLHandler();
            return objSQL.ExecuteAsObject<SanjhaChartsInfo>("sc_Select_ChartData", param);
        }

        public List<SanjhaChartsInfo> ChartTypeSelect()
        {
            
            SQLHandler objSQL = new SQLHandler();
            return objSQL.ExecuteAsList<SanjhaChartsInfo>("sc_Select_ChartsType");
        }

        public List<SanjhaChartsInfo> ChartNosSelectAll()
        {

            SQLHandler objSQL = new SQLHandler();
            return objSQL.ExecuteAsList<SanjhaChartsInfo>("sc_SelectAll_ChartNos");
        }

    }
}
