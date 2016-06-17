
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SanjhaCharts.SQLDataProvider;
using SanjhaCharts.Info;

namespace SanjhaCharts.Controller
{
    public class SanjhaChartsController
    {
        public void ChartAdd(SanjhaChartsInfo info)
        {
            SanjhaChartDataProvider scDP = new SanjhaChartDataProvider();
            scDP.ChartAdd(info);
        }

        public void ChartUpdate(SanjhaChartsInfo info)
        {
            SanjhaChartDataProvider scDP = new SanjhaChartDataProvider();
            scDP.ChartUpdate(info);
        }

        public void ChartDelete(int ChartNo)
        {
            SanjhaChartDataProvider scDP = new SanjhaChartDataProvider();
            scDP.ChartDelete(ChartNo);
        }

        public SanjhaChartsInfo ChartDataSelect(int ChartNo)
        {
            SanjhaChartDataProvider scDP = new SanjhaChartDataProvider();
            return scDP.ChartDataSelect(ChartNo);
        }

        public List<SanjhaChartsInfo> ChartTypeSelect()
        {
            SanjhaChartDataProvider scDP = new SanjhaChartDataProvider();
            return scDP.ChartTypeSelect();
        }

        public List<SanjhaChartsInfo> ChartNosSelectAll()
        {
            SanjhaChartDataProvider scDP = new SanjhaChartDataProvider();
            return scDP.ChartNosSelectAll();
        }
    }
}
