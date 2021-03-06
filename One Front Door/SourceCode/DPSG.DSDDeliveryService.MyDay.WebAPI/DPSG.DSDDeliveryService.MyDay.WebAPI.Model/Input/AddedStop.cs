﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.DSDDeliveryService.MyDay.WebAPI.Model.Input
{
    public class AddedStop
    {
        public DateTime? DeliveryDateUTC { get; set; }
        public int RouteID { get; set; }
        public int Servicetime { get; set; }
        public string StopType { get; set; }
        public string SAPAccountNumber { get; set; }
        public int? Quantity { get; set; }

        public string LastModifiedBy { get; set; }
        public DateTime LastModifiedUTC { get; set; }
    }

    public class AddedStops
    {
        public List<AddedStop> Stops { get; set; }
    }
}
