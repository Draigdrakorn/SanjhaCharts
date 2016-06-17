<%@ WebHandler Language="C#" Class="SanjhaFileHandler" %>

using System;
using System.Web;
using System.Json;

public class SanjhaFileHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        if (context.Request.Files.Count > 0)
        {
            var file = context.Request.Files[0];
            string fileExtension = VirtualPathUtility.GetExtension(file.FileName);
            string path = context.Server.MapPath("/Modules/SanjhaCharts/Temp/" + "tempFile" + fileExtension);
            file.SaveAs(path);
            context.Response.ContentType = "text/plain";
            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            var result = fileExtension;
            context.Response.Write(serializer.Serialize(result));
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}