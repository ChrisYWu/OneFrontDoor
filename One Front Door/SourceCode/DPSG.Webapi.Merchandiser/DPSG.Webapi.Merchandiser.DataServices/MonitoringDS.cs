
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DPSG.Webapi.Merchandiser.Model;
using System.Data.SqlClient;

namespace DPSG.Webapi.Merchandiser.DataServices
{
    public class MonitoringDS : MerchandiserConnectionWrapper
    {



        public bool EditRouteMerchandiser(int routeID, int dayOfWeek, string GSN, bool isForDelete)
        {

            //    @RouteID int,
            //    @DayOfWeek int,
            //    @GSN varchar(50),
            //	  @isForDelete bit = 0
            bool isSuccess = false;

            try
            {
             this.CreateSession();
       

                SqlParameter[] pars = {  new SqlParameter("@RouteID", routeID),
                                         new SqlParameter("@DayOfWeek", dayOfWeek),
                                         new SqlParameter("@GSN", GSN),
                                         new SqlParameter("@isForDelete", isForDelete)
                                     };

                this.ExecuteNonQuery(Constants.Planning.StoredProcedures.EditRouteMerchandiser, pars);
                isSuccess = true;
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            { this.CloseSession(); }




            return isSuccess; 

        }

        public PlanningRouteMerchandiserOutput GetRouteMerchandiserByMerchGroupID(int merchGroupId)
        {
            PlanningRouteMerchandiserOutput output = new PlanningRouteMerchandiserOutput();

            this.CreateSession();
            SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", merchGroupId)};
            SDMReader reader = this.ExecuteReader(Constants.Planning.StoredProcedures.GetRouteMerchandiserByMerchGroupID, pars);

            //List<PlRouteMerchandiser> plRouteMerchandiser = new List<PlRouteMerchandiser>();
            //List<PlMerchandiser> plMerchandiser = new List<PlMerchandiser>();
            //List<PlRoute> plRoute = new List<PlRoute>();
            List<PlRouteMerchandiser> _RouteMerchandiserList = new List<PlRouteMerchandiser>();
            List<PlMerchandiser> _MerchandiserList = new List<PlMerchandiser>();
            List<PlRoute> _RouteList = new List<PlRoute>();

            if (reader != null)
            {
                //plRouteMerchandiser = reader.GetResults<PlRouteMerchandiser>().ToList();
                //plMerchandiser = reader.GetResults<PlMerchandiser>().ToList();
                //plRoute = reader.GetResults<PlRoute>().ToList();
                //output.RouteMerchandiserList = reader.GetResults<PlRouteMerchandiser>().ToList();
                //output.MerchandiserList = reader.GetResults<PlMerchandiser>().ToList();
                //output.RouteList = reader.GetResults<PlRoute>().ToList();

                 _RouteMerchandiserList = reader.GetResults<PlRouteMerchandiser>().ToList();
                 _MerchandiserList = reader.GetResults<PlMerchandiser>().ToList();
                 _RouteList = reader.GetResults<PlRoute>().ToList();

            }

            // this may no need in uI
            output.RouteMerchandiserList = _RouteMerchandiserList;
            output.MerchandiserList = _MerchandiserList;
            output.RouteList = _RouteList;




            List<MerchToDayRoute> mtdList = new List<MerchToDayRoute>();
            //List<PlRoute> arMonday = new List<PlRoute>();
            //List<PlRoute> arTuesday = new List<PlRoute>();
            //List<PlRoute> arWednesday = new List<PlRoute>();
            //List<PlRoute> arThursday = new List<PlRoute>();
            //List<PlRoute> arFriday = new List<PlRoute>();
            //List<PlRoute> arSaturday = new List<PlRoute>();
            //List<PlRoute> arSunday = new List<PlRoute>();

            if (_RouteMerchandiserList.Count > 0)
            {
                          
                MerchToDayRoute mtd = new MerchToDayRoute(); 

                    for (int i = 0; i < _MerchandiserList.Count ; i++)
                    {

                        mtd = new MerchToDayRoute();
                        mtd.MerchGroupID = _MerchandiserList[i].MerchGroupID;
                        mtd.GSN = _MerchandiserList[i].GSN;
                        mtd.FirstName = _MerchandiserList[i].FirstName;
                        mtd.LastName = _MerchandiserList[i].LastName;
                        mtd.Email = _MerchandiserList[i].Email;
                        mtd.Phone = _MerchandiserList[i].Phone;
                        mtd.AbsoluteURL = _MerchandiserList[i].AbsoluteURL;

                        mtd.Monday.isOffDay = !_MerchandiserList[i].Mon;
                        mtd.Tuesday.isOffDay = !_MerchandiserList[i].Tues;
                        mtd.Wednesday.isOffDay = !_MerchandiserList[i].Wed;
                        mtd.Thursday.isOffDay = !_MerchandiserList[i].Thu;
                        mtd.Friday.isOffDay = !_MerchandiserList[i].Fri;
                        mtd.Saturday.isOffDay = !_MerchandiserList[i].Sat;
                        mtd.Sunday.isOffDay = !_MerchandiserList[i].Sun;

                    for (int x = 0; x< _RouteMerchandiserList.Count; x++)
                    {
                        if (_MerchandiserList[i].GSN == _RouteMerchandiserList[x].GSN)
                        {
                            switch(_RouteMerchandiserList[x].DayOfWeek)
                            {
                                case 1:   //Sunday
                                    mtd.Sunday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    mtd.Sunday.RouteID = _RouteMerchandiserList[x].RouteID;
                                    mtd.Sunday.RouteName = _RouteMerchandiserList[x].RouteName;
                                    mtd.Sunday.isRouteAssigned = (_RouteMerchandiserList[x].RouteID > 0);
                                    //    arSunday.Add(new PlRoute(_RouteMerchandiserList[x].RouteID, _RouteMerchandiserList[x].RouteName, _RouteMerchandiserList[x].MerchGroupID));
                                    break;
                                case 2:   //Monday
                                    mtd.Monday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    mtd.Monday.RouteID = _RouteMerchandiserList[x].RouteID;
                                    mtd.Monday.RouteName = _RouteMerchandiserList[x].RouteName;
                                    mtd.Monday.isRouteAssigned = (_RouteMerchandiserList[x].RouteID > 0);
                                  //  arMonday.Add(new PlRoute(_RouteMerchandiserList[x].RouteID, _RouteMerchandiserList[x].RouteName, _RouteMerchandiserList[x].MerchGroupID));
                                    break;
                                case 3:   //Tuesday
                                    mtd.Tuesday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    mtd.Tuesday.RouteID = _RouteMerchandiserList[x].RouteID;
                                    mtd.Tuesday.RouteName = _RouteMerchandiserList[x].RouteName;
                                    mtd.Tuesday.isRouteAssigned = (_RouteMerchandiserList[x].RouteID > 0);
                               //     arTuesday.Add(new PlRoute(_RouteMerchandiserList[x].RouteID, _RouteMerchandiserList[x].RouteName, _RouteMerchandiserList[x].MerchGroupID));
                                    break;
                                case 4:   //Wednesday
                                    mtd.Wednesday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    mtd.Wednesday.RouteID = _RouteMerchandiserList[x].RouteID;
                                    mtd.Wednesday.RouteName = _RouteMerchandiserList[x].RouteName;
                                    mtd.Wednesday.isRouteAssigned = (_RouteMerchandiserList[x].RouteID > 0);
                             //     arWednesday.Add(new PlRoute(_RouteMerchandiserList[x].RouteID, _RouteMerchandiserList[x].RouteName, _RouteMerchandiserList[x].MerchGroupID));
                                    break;
                                case 5:   //Thursday
                                    mtd.Thursday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    mtd.Thursday.RouteID = _RouteMerchandiserList[x].RouteID;
                                    mtd.Thursday.RouteName = _RouteMerchandiserList[x].RouteName;
                                    mtd.Thursday.isRouteAssigned = (_RouteMerchandiserList[x].RouteID > 0);
                                //    arThursday.Add(new PlRoute(_RouteMerchandiserList[x].RouteID, _RouteMerchandiserList[x].RouteName, _RouteMerchandiserList[x].MerchGroupID));
                                    break;
                                case 6:   //Friday
                                    mtd.Friday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    mtd.Friday.RouteID = _RouteMerchandiserList[x].RouteID;
                                    mtd.Friday.RouteName = _RouteMerchandiserList[x].RouteName;
                                    mtd.Friday.isRouteAssigned = (_RouteMerchandiserList[x].RouteID > 0);
                                   // arFriday.Add(new PlRoute(_RouteMerchandiserList[x].RouteID, _RouteMerchandiserList[x].RouteName, _RouteMerchandiserList[x].MerchGroupID));
                                    break;
                                case 7:   //Saturday
                                    mtd.Saturday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    mtd.Saturday.RouteID = _RouteMerchandiserList[x].RouteID;
                                    mtd.Saturday.RouteName = _RouteMerchandiserList[x].RouteName;
                                    mtd.Saturday.isRouteAssigned = (_RouteMerchandiserList[x].RouteID > 0);
                                    //arSaturday.Add(new PlRoute(_RouteMerchandiserList[x].RouteID, _RouteMerchandiserList[x].RouteName, _RouteMerchandiserList[x].MerchGroupID));
                                    break;

                            }
                        }

                    }


                    mtdList.Add(mtd);

                }

            }


            output.MerchToDayRouteList = mtdList;
            //output.MerchToRoutesUI.RouteList = new List<PlRoute>();
           // output.MerchToRoutesUI.MerchToDayRouteList = new List<MerchToDayRoute>();
           // output.MerchToRoutesUI.RouteList = _RouteList;
           // output.MerchToRoutesUI.MerchToDayRouteList = mtdList;

            //output.MerchToRoutesUI.AssignedMonday = arMonday;
            //output.MerchToRoutesUI.AssignedTuesday = arThursday;  
            //output.MerchToRoutesUI.AssignedWednesday = arWednesday;
            //output.MerchToRoutesUI.AssignedThursday = arThursday;
            //output.MerchToRoutesUI.AssignedFriday = arFriday;
            //output.MerchToRoutesUI.AssignedSaturday = arSaturday;
            //output.MerchToRoutesUI.AssignedSunday = arSunday;



            //--------------------------------------------------------------------------------------------------


            List<RouteToDayMerch> rtdList = new List<RouteToDayMerch>();

            if (_RouteMerchandiserList.Count > 0)
            {

                RouteToDayMerch rtd = new RouteToDayMerch();

                for (int i = 0; i < _RouteList.Count; i++)
                {

                     rtd = new RouteToDayMerch();

                    rtd.MerchGroupID = _RouteList[i].MerchGroupID;

                    rtd.RouteID = _RouteList[i].RouteID;
                    rtd.RouteName = _RouteList[i].RouteName;


                    //rtd.Monday.isOffDay = !_MerchandiserList[i].Mon;
                    //rtd.Tuesday.isOffDay = !_MerchandiserList[i].Tues;
                    //rtd.Wednesday.isOffDay = !_MerchandiserList[i].Wed;
                    //rtd.Thursday.isOffDay = !_MerchandiserList[i].Thu;
                    //rtd.Friday.isOffDay = !_MerchandiserList[i].Fri;
                    //rtd.Saturday.isOffDay = !_MerchandiserList[i].Sat;
                    //rtd.Sunday.isOffDay = !_MerchandiserList[i].Sun;

                    for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                    {
                        if (_RouteList[i].RouteID == _RouteMerchandiserList[x].RouteID)
                        {
                            switch (_RouteMerchandiserList[x].DayOfWeek)
                            {
                                case 1:   //Sunday
                                    rtd.Sunday.isOffDay = _RouteMerchandiserList[x].Sun;
                                    rtd.Sunday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    rtd.Sunday.isMerchAssigned = !string.IsNullOrEmpty((_RouteMerchandiserList[x].GSN));
                                    rtd.Sunday.LastName = _RouteMerchandiserList[x].LastName;
                                    rtd.Sunday.FirstName = _RouteMerchandiserList[x].FirstName;
                                    rtd.Sunday.Phone = _RouteMerchandiserList[x].Phone;
                                    rtd.Sunday.Email = _RouteMerchandiserList[x].Email;
                                    rtd.Sunday.GSN = _RouteMerchandiserList[x].GSN;
                                    rtd.Sunday.AbsoluteURL = _RouteMerchandiserList[x].AbsoluteURL;
                                    break;

                                case 2:   //Monday
                                    rtd.Monday.isOffDay = _RouteMerchandiserList[x].Mon;
                                    rtd.Monday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    rtd.Monday.isMerchAssigned = !string.IsNullOrEmpty((_RouteMerchandiserList[x].GSN));
                                    rtd.Monday.LastName = _RouteMerchandiserList[x].LastName;
                                    rtd.Monday.FirstName = _RouteMerchandiserList[x].FirstName;
                                    rtd.Monday.Phone = _RouteMerchandiserList[x].Phone;
                                    rtd.Monday.Email = _RouteMerchandiserList[x].Email;
                                    rtd.Monday.GSN = _RouteMerchandiserList[x].GSN;
                                    rtd.Monday.AbsoluteURL = _RouteMerchandiserList[x].AbsoluteURL;

                                    break;
                                case 3:   //Tuesday
                                    rtd.Tuesday.isOffDay = _RouteMerchandiserList[x].Tues;
                                    rtd.Tuesday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    rtd.Tuesday.isMerchAssigned = !string.IsNullOrEmpty((_RouteMerchandiserList[x].GSN));
                                    rtd.Tuesday.LastName = _RouteMerchandiserList[x].LastName;
                                    rtd.Tuesday.FirstName = _RouteMerchandiserList[x].FirstName;
                                    rtd.Tuesday.Phone = _RouteMerchandiserList[x].Phone;
                                    rtd.Tuesday.Email = _RouteMerchandiserList[x].Email;
                                    rtd.Tuesday.GSN = _RouteMerchandiserList[x].GSN;
                                    rtd.Tuesday.AbsoluteURL = _RouteMerchandiserList[x].AbsoluteURL;
                                    break;
                                case 4:   //Wednesday
                                    rtd.Wednesday.isOffDay = _RouteMerchandiserList[x].Wed;
                                    rtd.Wednesday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    rtd.Wednesday.isMerchAssigned = !string.IsNullOrEmpty((_RouteMerchandiserList[x].GSN));
                                    rtd.Wednesday.LastName = _RouteMerchandiserList[x].LastName;
                                    rtd.Wednesday.FirstName = _RouteMerchandiserList[x].FirstName;
                                    rtd.Wednesday.Phone = _RouteMerchandiserList[x].Phone;
                                    rtd.Wednesday.Email = _RouteMerchandiserList[x].Email;
                                    rtd.Wednesday.GSN = _RouteMerchandiserList[x].GSN;
                                    rtd.Wednesday.AbsoluteURL = _RouteMerchandiserList[x].AbsoluteURL;

                                    break;
                                case 5:   //Thursday
                                    rtd.Thursday.isOffDay = _RouteMerchandiserList[x].Thu;
                                    rtd.Thursday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    rtd.Thursday.isMerchAssigned = !string.IsNullOrEmpty((_RouteMerchandiserList[x].GSN));
                                    rtd.Thursday.LastName = _RouteMerchandiserList[x].LastName;
                                    rtd.Thursday.FirstName = _RouteMerchandiserList[x].FirstName;
                                    rtd.Thursday.Phone = _RouteMerchandiserList[x].Phone;
                                    rtd.Thursday.Email = _RouteMerchandiserList[x].Email;
                                    rtd.Thursday.GSN = _RouteMerchandiserList[x].GSN;
                                    rtd.Thursday.AbsoluteURL = _RouteMerchandiserList[x].AbsoluteURL;
                                    break;
                                case 6:   //Friday
                                    rtd.Friday.isOffDay = _RouteMerchandiserList[x].Fri;
                                    rtd.Friday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    rtd.Friday.isMerchAssigned = !string.IsNullOrEmpty((_RouteMerchandiserList[x].GSN));
                                    rtd.Friday.LastName = _RouteMerchandiserList[x].LastName;
                                    rtd.Friday.FirstName = _RouteMerchandiserList[x].FirstName;
                                    rtd.Friday.Phone = _RouteMerchandiserList[x].Phone;
                                    rtd.Friday.Email = _RouteMerchandiserList[x].Email;
                                    rtd.Friday.GSN = _RouteMerchandiserList[x].GSN;
                                    rtd.Friday.AbsoluteURL = _RouteMerchandiserList[x].AbsoluteURL;

                                    break;
                                case 7:   //Saturday
                                    rtd.Saturday.isOffDay = _RouteMerchandiserList[x].Sat;
                                    rtd.Saturday.DayOfWeek = _RouteMerchandiserList[x].DayOfWeek;
                                    rtd.Saturday.isMerchAssigned = !string.IsNullOrEmpty((_RouteMerchandiserList[x].GSN));
                                    rtd.Saturday.LastName = _RouteMerchandiserList[x].LastName;
                                    rtd.Saturday.FirstName = _RouteMerchandiserList[x].FirstName;
                                    rtd.Saturday.Phone = _RouteMerchandiserList[x].Phone;
                                    rtd.Saturday.Email = _RouteMerchandiserList[x].Email;
                                    rtd.Saturday.GSN = _RouteMerchandiserList[x].GSN;
                                    rtd.Saturday.AbsoluteURL = _RouteMerchandiserList[x].AbsoluteURL;
                                    break;

                            }
                        }

                    }


                    rtdList.Add(rtd);

                }

            }


            //  output.RouteToDayMerchList = rtdList;

          output.RouteToDayMerchList = rtdList;


            // -------------------------------------------------------------------------------
            plAssigned _Assigned = new plAssigned();


            List<PlRouteMerchandiser> arMonday = new List<PlRouteMerchandiser>();
            List<PlRouteMerchandiser> arTuesday = new List<PlRouteMerchandiser>();
            List<PlRouteMerchandiser> arWednesday = new List<PlRouteMerchandiser>();
            List<PlRouteMerchandiser> arThursday = new List<PlRouteMerchandiser>();
            List<PlRouteMerchandiser> arFriday = new List<PlRouteMerchandiser>();
            List<PlRouteMerchandiser> arSaturday = new List<PlRouteMerchandiser>();
            List<PlRouteMerchandiser> arSunday = new List<PlRouteMerchandiser>();



            for (int x = 0; x < _RouteMerchandiserList.Count; x++)
            {

                    switch (_RouteMerchandiserList[x].DayOfWeek)
                {
                        case 1:   //Sunday
                          arSunday.Add(_RouteMerchandiserList[x]);
                        break;

                       case 2:   //Monday
                             arMonday.Add(_RouteMerchandiserList[x]);
                       break;

                        case 3:   //Tuesday
                             arTuesday.Add(_RouteMerchandiserList[x]);
                        break;

                        case 4:   //Wednesday
                            arWednesday.Add(_RouteMerchandiserList[x]);
                        break;

                        case 5:   //Thursday
                           arThursday.Add(_RouteMerchandiserList[x]);
                        break;

                        case 6:   //Friday
                            arFriday.Add(_RouteMerchandiserList[x]);
                        break;

                        case 7:   //Saturday
                           arSaturday.Add(_RouteMerchandiserList[x]);
                        break;


                    }
                

            }

            _Assigned.Monday = arMonday;
            _Assigned.Tuesday = arTuesday;
            _Assigned.Wednesday = arWednesday;
            _Assigned.Thursday = arTuesday;
            _Assigned.Friday = arFriday;
            _Assigned.Saturday = arSunday;
            _Assigned.Sunday = arSunday;


            output.AssignedDays = _Assigned;

            // --------------------------------------------------------------------------------------


            plRouteToAssig _rToa = new plRouteToAssig();

            bool isFound = false;

            for (int r = 0; r < _RouteList.Count; r++)
            {
                //Sunday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 1)   //Saturday
                    {
                        if (_RouteList[r].RouteID == _RouteMerchandiserList[x].RouteID)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _rToa.Sunday.Add(_RouteList[r]);

                }


                //Monday    ------------------------------------------------------------
                isFound = false; 
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {   
                    if (_RouteMerchandiserList[x].DayOfWeek == 2)   //Monday
                    {
                        if(_RouteList[r].RouteID == _RouteMerchandiserList[x].RouteID)
                        {
                            isFound = true;
                            break;
                        }
                    }                                          

                }
                if (!isFound)
                 {
                    _rToa.Monday.Add(_RouteList[r]);

                 }


                //Tuesday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 3)   //Tuesday
                    {
                        if (_RouteList[r].RouteID == _RouteMerchandiserList[x].RouteID)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _rToa.Tuesday.Add(_RouteList[r]);

                }


                //Wednesday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 4)   //Wednesday
                    {
                        if (_RouteList[r].RouteID == _RouteMerchandiserList[x].RouteID)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _rToa.Wednesday.Add(_RouteList[r]);

                }

                //Thursday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 5)   //Thursday
                    {
                        if (_RouteList[r].RouteID == _RouteMerchandiserList[x].RouteID)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _rToa.Thursday.Add(_RouteList[r]);

                }

                //Friday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 6)   //Friday
                    {
                        if (_RouteList[r].RouteID == _RouteMerchandiserList[x].RouteID)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _rToa.Friday.Add(_RouteList[r]);

                }


                //Saturday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 7)   //Saturday
                    {
                        if (_RouteList[r].RouteID == _RouteMerchandiserList[x].RouteID)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _rToa.Saturday.Add(_RouteList[r]);

                }




            }




            output.RouteToAssigne = _rToa;




            // --------------------------------------------------------------------------------------


            plMerchToAssigne _mToa = new plMerchToAssigne();

            isFound = false;

            for (int m = 0; m < _MerchandiserList.Count; m++)
            {

                //Sunday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 1)   //Saturday
                    {
                        if (_MerchandiserList[m].GSN == _RouteMerchandiserList[x].GSN)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _mToa.Sunday.Add(_MerchandiserList[m]);

                }

                //Monday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 2)   //Monday
                    {
                        if (_MerchandiserList[m].GSN == _RouteMerchandiserList[x].GSN)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _mToa.Monday.Add(_MerchandiserList[m]);

                }


                //Tuesday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 3)   //Tuesday
                    {
                        if (_MerchandiserList[m].GSN == _RouteMerchandiserList[x].GSN)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _mToa.Tuesday.Add(_MerchandiserList[m]);

                }


                //Wednesday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 4)   //Wednesday
                    {
                        if (_MerchandiserList[m].GSN == _RouteMerchandiserList[x].GSN)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _mToa.Wednesday.Add(_MerchandiserList[m]);

                }

                //Thursday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 5)   //Thursday
                    {
                        if (_MerchandiserList[m].GSN == _RouteMerchandiserList[x].GSN)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _mToa.Thursday.Add(_MerchandiserList[m]);

                }

                //Friday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 6)   //Friday
                    {
                        if (_MerchandiserList[m].GSN == _RouteMerchandiserList[x].GSN)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _mToa.Friday.Add(_MerchandiserList[m]);

                }


                //Saturday    ------------------------------------------------------------
                isFound = false;
                for (int x = 0; x < _RouteMerchandiserList.Count; x++)
                {
                    if (_RouteMerchandiserList[x].DayOfWeek == 7)   //Saturday
                    {
                        if (_MerchandiserList[m].GSN == _RouteMerchandiserList[x].GSN)
                        {
                            isFound = true;
                            break;
                        }
                    }

                }
                if (!isFound)
                {
                    _mToa.Saturday.Add(_MerchandiserList[m]);

                }

               


            }




            output.MerchToAssigne = _mToa;





            return output; 
        }









        public MonitorDetailOutput GetMontinorDetail(int merchStopID)
        {
            try
            {
                MonitorDetailOutput detail = new MonitorDetailOutput();

                this.CreateSession();
                SqlParameter[] pars = { new SqlParameter("@MerchStopID", merchStopID) };
                SDMReader reader = this.ExecuteReader(Constants.Dispatch.StoredProcedures.GetGetMornitoringDetail, pars);

                if (reader != null)
                {
                    var output = reader.GetResults<MonitorDetail>().ToList();
                    var picture = reader.GetResults<MonitorStorePicture>().ToList();
                    var signature = reader.GetResults<MonitorStoreSignature>().ToList();
                    var execution = reader.GetResults<DisplayBuildExecution>().ToList();

                    detail.Details = output;
                    detail.StorePictures = picture;
                    detail.StoreSignature = signature;
                    detail.BuildExecution = execution;
                }

                return detail;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }

        }

        public MonitorLandingOutput GetMonitorLanding(int merchGroupId, DateTime dispatchDate, string filterPhrase)
        {
            try
            {
                MonitorLandingOutput output = new MonitorLandingOutput();

                this.CreateSession();
                SqlParameter[] pars = {  new SqlParameter("@MerchGroupID", merchGroupId),
                                         new SqlParameter("@DispatchDate",dispatchDate),
                                         new SqlParameter("@SearchPhrase", filterPhrase)};
               SDMReader reader = this.ExecuteReader(Constants.Dispatch.StoredProcedures.GetMonitoringLanding, pars);             

                List<MerchandisingProgressRAW> progressesRaw = new List<MerchandisingProgressRAW>();
                List<MerchandisingStopRaw> stopsRaw = new List<MerchandisingStopRaw>();

                if (reader != null)
                {
                    progressesRaw = reader.GetResults<MerchandisingProgressRAW>().ToList();
                    stopsRaw = reader.GetResults<MerchandisingStopRaw>().ToList();
                }

                foreach (var v in progressesRaw)
                {
                    var progress = new MerchandisingProgress()
                    {
                        GSN = v.GSN,
                        FirstName = v.FirstName,
                        LastName = v.LastName,
                        AbsoluteURL = v.AbsoluteURL,
                        MilageAdhocLabel = v.MilageAdhocLabel,
                        TotalTimeLabel = v.TotalTimeLabel,
                        MileageTotalLabel = v.MileageTotalLabel,
                        RouteName = v.RouteName,
                        RouteStatusLabel = v.RouteStatusLabel
                    };

                    progress.Stops = stopsRaw.Where(c => c.GSN == v.GSN)
                        .Select(c => new MerchandisingStop()
                        {
                            AccountName = c.AccountName,
                            ConnectorType = c.ConnectorType,
                            DriveTime = c.DriveTime,
                            Mileage = c.Mileage,
                            SequenceLabel = c.SequenceLabel,
                            SequenceOrder = c.SequenceOrder,
                            TimeSpan = c.TimeSpan,
                            DisplayBuildStatus = c.DisplayBuildStatus,
                            MerchStopID = c.MerchStopID,
                            DNSReason = c.DNSReason
                        }).ToList();



                    for (int i = 0; i < progress.Stops.Count(); i++)
                    {
                        if( i+1 < progress.Stops.Count())
                        {
                            progress.Stops[i].EndDriveTime = progress.Stops[i + 1].DriveTime;
                            progress.Stops[i].EndMileage = progress.Stops[i + 1].Mileage;
                            progress.Stops[i].EndConnectorType = progress.Stops[i + 1].ConnectorType;
                        }
                    }


                        output.Add(progress);
                }



             

                
                return output;
            }
            catch (Exception e) { throw (e); }
            finally { this.CloseSession(); }
        }
        



    }
}
