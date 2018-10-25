
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace DPSG.Webapi.Merchandiser.Model
{


    public class PlanningRouteMerchandiserOutput : PlanningRouteMerchandiser, IResponseInformation
    {
        public int ReturnStatus { get; set; }
        public string Message { get; set; }
        public string CorrelationID { get; set; }
        public string StackTrace { get; set; }
    }

    public class PlanningRouteMerchandiserInput
    {
        public System.Int32 MerchGroupID { get; set; }
    }



    public class PlanningRouteMerchandiser
    {
        public plAssigned AssignedDays { get; set; }

        public plRouteToAssig RouteToAssigne { get; set; }

        public plMerchToAssigne MerchToAssigne { get; set; }

        public List<MerchToDayRoute> MerchToDayRouteList { get; set; }
        public List<PlRoute> RouteList { get; set; }
        public List<RouteToDayMerch> RouteToDayMerchList { get; set; }
        public List<PlMerchandiser> MerchandiserList { get; set; }    
        public List<PlRouteMerchandiser> RouteMerchandiserList { get; set; }
 
  

        public PlanningRouteMerchandiser()
        {
            this.AssignedDays = new plAssigned();
            this.RouteToAssigne = new plRouteToAssig();
            this.MerchToAssigne = new plMerchToAssigne(); 
        }

    }



    public class plMerchToAssigne
    {
        public List<PlMerchandiser> Monday { get; set; }
        public List<PlMerchandiser> Tuesday { get; set; }
        public List<PlMerchandiser> Wednesday { get; set; }
        public List<PlMerchandiser> Thursday { get; set; }
        public List<PlMerchandiser> Friday { get; set; }
        public List<PlMerchandiser> Saturday { get; set; }
        public List<PlMerchandiser> Sunday { get; set; }

        public plMerchToAssigne()
        {
            this.Monday = new List<Model.PlMerchandiser>();
            this.Tuesday = new List<Model.PlMerchandiser>();
            this.Wednesday = new List<Model.PlMerchandiser>();
            this.Thursday = new List<Model.PlMerchandiser>();
            this.Friday = new List<Model.PlMerchandiser>(); ;
            this.Sunday = new List<Model.PlMerchandiser>();
            this.Saturday = new List<Model.PlMerchandiser>();
        }
    }

    public class plRouteToAssig
    {
        public List<PlRoute> Monday { get; set; }
        public List<PlRoute> Tuesday { get; set; }
        public List<PlRoute> Wednesday { get; set; }
        public List<PlRoute> Thursday { get; set; }
        public List<PlRoute> Friday { get; set; }
        public List<PlRoute> Saturday { get; set; }
        public List<PlRoute> Sunday { get; set; }

        public plRouteToAssig()
        {
            this.Monday = new List<Model.PlRoute>();
            this.Tuesday = new List<Model.PlRoute>();
            this.Wednesday = new List<Model.PlRoute>();
            this.Thursday = new List<Model.PlRoute>();
            this.Friday = new List<Model.PlRoute>(); ;
            this.Sunday = new List<Model.PlRoute>();
            this.Saturday = new List<Model.PlRoute>();
        }
    }

    public class plAssigned
        {
        public List<PlRouteMerchandiser> Monday { get; set; }
        public List<PlRouteMerchandiser> Tuesday { get; set; }
        public List<PlRouteMerchandiser> Wednesday { get; set; }
        public List<PlRouteMerchandiser> Thursday { get; set; }
        public List<PlRouteMerchandiser> Friday { get; set; }
        public List<PlRouteMerchandiser> Saturday { get; set; }
        public List<PlRouteMerchandiser> Sunday { get; set; }

        public plAssigned()
        {
            this.Monday = new List<Model.PlRouteMerchandiser>();
            this.Tuesday = new List<Model.PlRouteMerchandiser>();
            this.Wednesday = new List<Model.PlRouteMerchandiser>();
            this.Thursday = new List<Model.PlRouteMerchandiser>();
            this.Friday = new List<Model.PlRouteMerchandiser>(); ;
            this.Sunday =  new List<Model.PlRouteMerchandiser>();
            this.Saturday = new List<Model.PlRouteMerchandiser>();
        }
    }


    public class PlRouteMerchandiser
    {
        public string Day { get; set; }
        public int DayOfWeek { get; set; }
        public string GSN { get; set; }
        public int RouteID { get; set; }
        public int MerchGroupID { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public bool Mon { get; set; }
        public bool Tues { get; set; }
        public bool Wed { get; set; }
        public bool Thu { get; set; }
        public bool Fri { get; set; }
        public bool Sat { get; set; }
        public bool Sun { get; set; }
        public string RouteName { get; set; }
        public string AbsoluteURL { get; set; }
    }


    public class PlMerchandiser
    {
       public string GSN { get; set; }
        public int MerchGroupID { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public bool Mon { get; set; }
        public bool Tues { get; set; }
        public bool Wed { get; set; }
        public bool Thu { get; set; }
        public bool Fri { get; set; }
        public bool Sat { get; set; }
        public bool Sun { get; set; }
        public string AbsoluteURL { get; set; }
    }


    public class PlRoute
    {
        public int RouteID { get; set; }
        public int MerchGroupID { get; set; }
        public string RouteName { get; set; }


        public PlRoute()
        {
            this.RouteID = -1;
            this.RouteName = String.Empty;
            this.MerchGroupID = -1;
        }
        public PlRoute(int routeID, string routeName,  int merchGroupID)
        {
            this.RouteID = routeID;
            this.RouteName = routeName;
            this.MerchGroupID = merchGroupID;
        }
    }


    public class MerchToDayRoute
    {


        public int MerchGroupID { get; set; }

        public string GSN { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public DayRoute Monday { get; set; }
        public DayRoute Tuesday { get; set; }
        public DayRoute Wednesday { get; set; }
        public DayRoute Thursday { get; set; }
        public DayRoute Friday { get; set; }
        public DayRoute Saturday { get; set; }
        public DayRoute Sunday { get; set; }

        public string AbsoluteURL { get; set; }


        public MerchToDayRoute()
        {
            this.Sunday = new DayRoute(1);
            this.Monday = new DayRoute(2);
            this.Tuesday =  new DayRoute(3);
            this.Wednesday = new DayRoute(4);
            this.Thursday  = new DayRoute(5);
            this.Friday  = new DayRoute(6);
            this.Saturday = new DayRoute(7);
            
        }
    }

    public class DayRoute
    {
        public int RouteID { get; set; }
        public string RouteName { get; set; }
        public int DayOfWeek { get; set; }
        public bool isOffDay { get; set; }
        public bool isRouteAssigned { get; set; }

        public DayRoute(int datOfWeek)
        {
            this.RouteID = -1;
            this.isOffDay = true;
            this.isRouteAssigned = false;
            this.RouteName = string.Empty;
            this.DayOfWeek = datOfWeek; 

        }
    }


    public class RouteToDayMerch    {


        public int RouteID { get; set; }
        public int MerchGroupID { get; set; }
        public string RouteName { get; set; }

        public DayMerch Monday { get; set; }
        public DayMerch Tuesday { get; set; }
        public DayMerch Wednesday { get; set; }
        public DayMerch Thursday { get; set; }
        public DayMerch Friday { get; set; }
        public DayMerch Saturday { get; set; }
        public DayMerch Sunday { get; set; }


        public RouteToDayMerch()
        {
            this.Sunday = new DayMerch(1);
            this.Monday = new DayMerch(2);
            this.Tuesday = new DayMerch(3);
            this.Wednesday = new DayMerch(4);
            this.Thursday = new DayMerch(5);
            this.Friday = new DayMerch(6);
            this.Saturday = new DayMerch(7);
          
        }
    }

    public class DayMerch
    {
        public string GSN { get; set; }
        public int MerchGroupID { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public int DayOfWeek { get; set; }
        public bool isOffDay { get; set; }
        public bool isMerchAssigned { get; set; }
        public string AbsoluteURL { get; set; }

        public DayMerch(int datOfWeek)
        {
            this.MerchGroupID = -1;
            this.GSN = string.Empty;
            this.LastName = string.Empty;
            this.FirstName = string.Empty;
            this.Email  = string.Empty;
            this.Phone = string.Empty;
            this.AbsoluteURL = string.Empty;

            this.isOffDay = true;
            this.isMerchAssigned = false;
            this.DayOfWeek = datOfWeek;
            

        }




    }





    public class PlRouteToMerchUI
    {
        public List<RouteToDayMerch> RouteToDayMerchList { get; set; }
        public List<PlMerchandiser> MerchandiserList { get; set; }

        public List<PlMerchandiser> AssignedMonday { get; set; }
        public List<PlMerchandiser> AssignedTuesday { get; set; }
        public List<PlMerchandiser> AssignedWednesday { get; set; }
        public List<PlMerchandiser> AssignedThursday { get; set; }
        public List<PlMerchandiser> AssignedFriday { get; set; }
        public List<PlMerchandiser> AssignedSaturday { get; set; }
        public List<PlMerchandiser> AssignedSunday { get; set; }

        public PlRouteToMerchUI()
        {
            this.MerchandiserList = new List<PlMerchandiser>();
            this.RouteToDayMerchList = new List<RouteToDayMerch>();

            this.AssignedMonday = new List<PlMerchandiser>();
            this.AssignedTuesday = new List<PlMerchandiser>();
            this.AssignedWednesday = new List<PlMerchandiser>();
            this.AssignedThursday = new List<PlMerchandiser>();
            this.AssignedFriday = new List<PlMerchandiser>();
            this.AssignedSaturday = new List<PlMerchandiser>();
            this.AssignedSunday = new List<PlMerchandiser>();

        }

    }


    // removed - not using, may be need so keeping here

    public class PlMerchToRouteUI
    {
        public List<MerchToDayRoute> MerchToDayRouteList { get; set; }
        public List<PlRoute> RouteList { get; set; }

        public List<PlRoute> AssignedMonday { get; set; }
        public List<PlRoute> AssignedTuesday { get; set; }
        public List<PlRoute> AssignedWednesday { get; set; }
        public List<PlRoute> AssignedThursday { get; set; }
        public List<PlRoute> AssignedFriday { get; set; }
        public List<PlRoute> AssignedSaturday { get; set; }
        public List<PlRoute> AssignedSunday { get; set; }

        public PlMerchToRouteUI()
        {
            this.RouteList = new List<PlRoute>();
            this.MerchToDayRouteList = new List<MerchToDayRoute>();

            this.AssignedMonday = new List<PlRoute>();
            this.AssignedTuesday = new List<PlRoute>();
            this.AssignedWednesday = new List<PlRoute>();
            this.AssignedThursday = new List<PlRoute>();
            this.AssignedFriday = new List<PlRoute>();
            this.AssignedSaturday = new List<PlRoute>();
            this.AssignedSunday = new List<PlRoute>();
        }

    }

}
