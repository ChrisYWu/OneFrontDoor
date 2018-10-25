using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Portal.Framework.Types;

namespace DPSG.Portal.Framework.SDM
{
    public class TimeLineRepository
    {
        public List<AppointmentInfo> GetList()
        {
            List<AppointmentInfo> olist = new List<AppointmentInfo>();
            AppointmentInfo objAppointmentInfo;
            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "15";
            objAppointmentInfo.Subject = "A15";
            objAppointmentInfo.StartDate = Convert.ToDateTime("11/02/2014");
            objAppointmentInfo.EndDate = Convert.ToDateTime("11/24/2014");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "14";
            objAppointmentInfo.Subject = "A14";
            objAppointmentInfo.StartDate = Convert.ToDateTime("11/02/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("11/24/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "13";
            objAppointmentInfo.Subject = "A13";
            objAppointmentInfo.StartDate = Convert.ToDateTime("05/02/2014");
            objAppointmentInfo.EndDate = Convert.ToDateTime("07/24/2014");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "12";
            objAppointmentInfo.Subject = "A12";
            objAppointmentInfo.StartDate = Convert.ToDateTime("11/02/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("12/24/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "16";
            objAppointmentInfo.Subject = "A16";
            objAppointmentInfo.StartDate = Convert.ToDateTime("11/09/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("12/24/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "11";
            objAppointmentInfo.Subject = "A11";
            objAppointmentInfo.StartDate = Convert.ToDateTime("01/02/2014");
            objAppointmentInfo.EndDate = Convert.ToDateTime("01/24/2014");
            olist.Add(objAppointmentInfo);


            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "1";
            objAppointmentInfo.Subject = "A1";
            objAppointmentInfo.StartDate = Convert.ToDateTime("09/22/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("09/24/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "2";
            objAppointmentInfo.Subject = "A2";
            objAppointmentInfo.StartDate = Convert.ToDateTime("09/25/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("09/28/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "3";
            objAppointmentInfo.Subject = "A3";
            objAppointmentInfo.StartDate = Convert.ToDateTime("09/30/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("10/2/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "4";
            objAppointmentInfo.Subject = "A4";
            objAppointmentInfo.StartDate = Convert.ToDateTime("09/27/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("09/28/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "5";
            objAppointmentInfo.Subject = "A5";
            objAppointmentInfo.StartDate = Convert.ToDateTime("10/2/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("10/3/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "6";
            objAppointmentInfo.Subject = "A6";
            objAppointmentInfo.StartDate = Convert.ToDateTime("07/27/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("07/28/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "7";
            objAppointmentInfo.Subject = "A7";
            objAppointmentInfo.StartDate = Convert.ToDateTime("06/7/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("06/28/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "8";
            objAppointmentInfo.Subject = "A8";
            objAppointmentInfo.StartDate = Convert.ToDateTime("01/09/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("01/18/2013");
            olist.Add(objAppointmentInfo);


            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "9";
            objAppointmentInfo.Subject = "A9";
            objAppointmentInfo.StartDate = Convert.ToDateTime("05/27/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("05/28/2013");
            olist.Add(objAppointmentInfo);

            objAppointmentInfo = new AppointmentInfo();
            objAppointmentInfo.ID = "10";
            objAppointmentInfo.Subject = "A10";
            objAppointmentInfo.StartDate = Convert.ToDateTime("02/27/2013");
            objAppointmentInfo.EndDate = Convert.ToDateTime("02/28/2013");
            olist.Add(objAppointmentInfo);

            return olist;
        }
    }
}
