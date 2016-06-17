var SanjhaSettings = {
    config: {
        moduleId: 0,
        type: "POST",
        contentType: "application/json;charset=uf=8",
        async: false,
        serviceUrl: "/Modules/SanjhaCharts/WebService/SanjhaWebService.asmx/",
        handlerURL: "/Modules/SanjhaCharts/FileHandler/SanjhaFileHandler.ashx/",
        dataType: "json",
        extension: "",
        fieldLength: 0,
        chartData: ""
    },
    AnalyseFile: function(){
        var myData = JSON2.stringify({
            fileExtension: SanjhaSettings.config.extension
        });
        $.ajax({
            type: SanjhaSettings.config.type,
            contentType: SanjhaSettings.config.contentType,
            data: myData,
            url: SanjhaSettings.config.serviceUrl + "AnalyseFile",
            dataType: SanjhaSettings.config.dataType,
            success: function (data) {
                $('.err').text("");
                $('#dListChart').val("1");
                $('#txtVerticalValue').show();
                $('#txtHorizontalValue').show();
                $('#lblVerticalValue').show();
                $('#lblHorizontalValue').show();
                SanjhaSettings.config.fieldLength = data.d.length;
                var obj = data.d;
                if (obj[0] != "3") {
                    $('#txtVerticalValue').val(obj[1]);
                    if (obj[0] == "0") {
                        $("#lblFileStatus").html("<p>The Selected File has valid Data</p>");
                    }
                    else if (obj[0] == "1") {
                        $("#lblFileStatus").html("<p class='err'>The Selected File has invalid Data</p>");
                    }
                    else {
                        $("#lblFileStatus").html("<p class='err'>Timeout! please select the file again</p>");
                    }
                    var colorHtml = "<table>";
                    for (var i = 1; i < obj.length; i++) {
                        colorHtml += "<tr><td><p id='pColor'>" + obj[i] + "</p></td><td><input type='color' id='color"+i+"' value='#"+(Math.random()*0xFFFFFF<<0).toString(16)+"'></td></tr>";
                    }
                    $("#divColors").html(colorHtml);
                }
                else {
                    var dataConvert = true;
                    SanjhaSettings.GetChartData(dataConvert);
                }
            },
            error: function (e) {
                console.log(e);
            }
        });
    },
    AnalyseFilePie: function () {
        var myData = JSON2.stringify({
            fileExtension: SanjhaSettings.config.extension
        });
        $.ajax({
            type: SanjhaSettings.config.type,
            contentType: SanjhaSettings.config.contentType,
            data: myData,
            url: SanjhaSettings.config.serviceUrl + "AnalyseFilePie",
            dataType: SanjhaSettings.config.dataType,
            success: function (data) {
                SanjhaSettings.config.fieldLength = data.d.length;
                var obj = data.d;
                if (obj[0] != "3") {
                    if (obj[0] == "1") {
                        $("#lblChartStatus").html("<p class='err'>The Selected File does not have valid data for Pie</p>");
                    }
                    else if (obj[0] == "2") {
                        $("#lblFileStatus").html("<p class='err'>Timeout! please select the file again</p>");
                    }
                    var colorHtml = "<table>";
                    for (var i = 1; i < obj.length; i++) {
                        colorHtml += "<tr><td><p id='pColor'>" + obj[i] + "</p></td><td><input type='color' id='color" + i + "' value='#" + (Math.random() * 0xFFFFFF << 0).toString(16) + "'></td></tr>";
                    }
                    $("#divColors").html(colorHtml);
                }
                else {
                    var dataConvert = true;
                    SanjhaSettings.GetChartData(dataConvert);
                }
            },
            error: function (e) {
                console.log(e);
            }
        });
    },
    GetColors: function(){
        var obj = SanjhaSettings.config.fieldLength;
        var colorValues = [];
        for (var i = 1; i < obj; i++) {
            var value = $('#color' + i).val();
            colorValues.push(value);
        }
        return colorValues;
    },
    IsShowIndexChecked: function(){
        if ($('#chkShowIndex').prop("checked") == true)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    },
    AddChart: function () {
        var chartTypeID = $('#dListChart :selected').val();
        var verticalValue = $('#txtVerticalValue').val();
        var horizontalValue = $('#txtHorizontalValue').val();
        var chartTitle = $('#txtChartTitle').val();
        var showIndex = SanjhaSettings.IsShowIndexChecked();
        var colorValues = SanjhaSettings.GetColors();
        var chartData = SanjhaSettings.ConvertData(SanjhaSettings.config.chartData);
        var myData = JSON2.stringify({
            chartNo: SanjhaSettings.config.moduleId,
            chartTypeID: chartTypeID,
            verticalValue: verticalValue,
            horizontalValue: horizontalValue,
            chartTitle: chartTitle,
            fileExtension: SanjhaSettings.config.extension,
            showIndex: showIndex,
            colorValues: colorValues,
            chartData: chartData
        });
        $.ajax({
            type: SanjhaSettings.config.type,
            contentType: SanjhaSettings.config.contentType,
            data: myData,
            url: SanjhaSettings.config.serviceUrl + "AddChart",
            dataType: SanjhaSettings.config.dataType,
            success: function () {
                    SageFrame.messaging.show("Chart Created Successfully!", "Success");
            },
            error: function (e) {
                console.log(e);
            }
        });
    },
    GetChartData: function (dataConvert) {
        var myData = JSON2.stringify({
            ChartNo: SanjhaSettings.config.moduleId,
        });
        $.ajax({
            type: SanjhaSettings.config.type,
            contentType: SanjhaSettings.config.contentType,
            data: myData,
            url: SanjhaSettings.config.serviceUrl + "GetChartData",
            dataType: SanjhaSettings.config.dataType,
            success: function (data) {
                var value = data.d;
                SanjhaSettings.config.chartData = value;
                if (value != null) {
                    if (dataConvert) {
                        var chartType = $('#dListChart').val();
                        SanjhaSettings.ChartChange(chartType,value);
                    }
                    else {
                        var chartDataValue = value.ChartData;
                        var chartData = eval('(' + chartDataValue + ')');
                        $('#dListChart').val(value.ChartTypeID);
                        if ($('#dListChart').val() == "1") {
                            SanjhaSettings.config.fieldLength = chartData.datasets.length + 1;
                            $('#txtVerticalValue').val(value.VerticalValue);
                            $('#txtHorizontalValue').val(value.HorizontalValue);
                            $('#txtChartTitle').val(value.ChartTitle);
                            if (value.ShowIndex == 1) {
                                $('#chkShowIndex').prop('checked', true);
                            }
                            else {
                                $('#chkShowIndex').prop('checked', false);
                            }
                            var colorHtml = "<table>";
                            for (var i = 0; i < chartData.datasets.length; i++) {
                                colorHtml += "<tr><td><p id='pColor'>" + chartData.datasets[i].label + "</p></td><td><input type='color' id='color" + (i + 1) + "' value='" + chartData.datasets[i].fillColor + "'></td></tr>";
                            }
                            $("#divColors").html(colorHtml);
                        }
                        else {
                            SanjhaSettings.config.fieldLength = chartData.length;
                            $('#dListChart').val(value.ChartTypeID);
                            $('#txtVerticalValue').hide();
                            $('#txtHorizontalValue').hide();
                            $('#lblVerticalValue').hide();
                            $('#lblHorizontalValue').hide();
                            $('#txtChartTitle').val(value.ChartTitle);
                            if (value.ShowIndex == 1) {
                                $('#chkShowIndex').prop('checked', true);
                            }
                            else {
                                $('#chkShowIndex').prop('checked', false);
                            }
                            var colorHtml = "<table>";
                            for (var i = 0; i < chartData.length; i++) {
                                colorHtml += "<tr><td><p id='pColor'>" + chartData[i].label + "</p></td><td><input type='color' id='color" + (i + 1) + "' value='" + chartData[i].color + "'></td></tr>";
                            }
                            $("#divColors").html(colorHtml);
                        }
                    }
                }
                else {
                    console.log("no chart present");
                }
            },
            error: function (err) {
                console.log(err);
            }
        });
    },
    ConvertData: function (value) {
        
        if (value != null && value != "") {
            var chartData = eval('(' + value.ChartData + ')');;
            if ($('#dListChart').val() == "1") {
                var newData = "{ labels:[";
                for (var i = 0; i < chartData.length; i++) {
                    newData += "\""+chartData[i].label + "\""+ ",";
                }
                newData += "], datasets:[{ label: \"" + value.VerticalValue + "\", fillColor: \""+$("#color1").val() +"\", data: [";
                for (var i = 0; i < chartData.length; i++) {
                    newData += chartData[i].value + ",";
                }
                newData += "]}]}"
                return newData;
            }
            else {
                var newData = "[";
                for (var i = 0; i < chartData.datasets[0].data.length; i++) {
                    newData += "{value: " + chartData.datasets[0].data[i]+ ", color: \"" + $("#color"+(i+1)).val() +"\", label: \""  + chartData.labels[i] + "\"},";
                }
                newData += "]";
                return newData;
            }
        }
        else {
            return "";
        }
    },
    ChartChange: function (chartType, value) {
        var chartData = eval('(' + value.ChartData + ')');;
        if (chartType == "1") {
            var colorHtml = "<table>";
            colorHtml += "<tr><td><p id='pColor'>" + value.VerticalValue + "</p></td><td><input type='color' id='color1' value='#" + (Math.random() * 0xFFFFFF << 0).toString(16) + "'></td></tr>";
            $("#divColors").html(colorHtml);
            $('#txtVerticalValue').val(value.VerticalValue);
            $('#txtHorizontalValue').val(value.HorizontalValue);
        }
        else {
            if (chartData.hasOwnProperty('labels') && chartData.datasets.length > 1)
            {
                $("#lblChartStatus").html("<p class='err'>The Selected File does not have valid data for Pie</p>");
                $('#dListChart').val("1");
            }
            else {
                var colorHtml = "<table>";
                for (var i = 0; i < chartData.datasets[0].data.length; i++) {
                    colorHtml += "<tr><td><p id='pColor'>" + chartData.labels[i] + "</p></td><td><input type='color' id='color" + (i + 1) + "' value='#" + (Math.random() * 0xFFFFFF << 0).toString(16) + "'></td></tr>";
                }
                $("#divColors").html(colorHtml);
            }
        }
    }
}



$(function () {
    SanjhaSettings.config.moduleId = moduleID;
    SanjhaSettings.GetChartData();
    $('#fileDataSource').change(function () {
        var analysingGif = "<p><img src=\"/Modules/SanjhaCharts/img/giphy.gif\" width=\"30\" style=\"vertical-align:middle\"/>  Analysing File</p>";
        $('#lblFileStatus').html(analysingGif);
    })
    $('#fileDataSource').fileupload({
        dataType: SanjhaSettings.config.dataType,
        url: SanjhaSettings.config.handlerURL,
        done: function (e, data) {
            SanjhaSettings.config.extension = data.result;
            SanjhaSettings.AnalyseFile();
        }
    })
    

    $('#dListChart').on('change', function () {
        if ($('#dListChart').val() == "2") {
            $('#txtVerticalValue').hide();
            $('#txtHorizontalValue').hide();
            $('#lblVerticalValue').hide();
            $('#lblHorizontalValue').hide();
            SanjhaSettings.AnalyseFilePie();
        }
        else {
            $('#txtVerticalValue').show();
            $('#txtHorizontalValue').show();
            $('#lblVerticalValue').show();
            $('#lblHorizontalValue').show();
            SanjhaSettings.AnalyseFile();
        }
    });
    
    $('#btnSave').bind("click", function () {
        SanjhaSettings.AddChart();
    })
});