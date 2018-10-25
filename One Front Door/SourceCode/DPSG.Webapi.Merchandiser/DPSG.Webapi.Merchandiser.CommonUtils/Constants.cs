using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Webapi.Merchandiser.CommonUtils
{
    public class Constants
    {
        public class Promotion
        {
            public const string FILTER_TYPE_ACCOUNTS = "Account";
            public const string FILTER_TYPE_BRANDS = "Brand";
            public const string FILTER_TYPE_PACKAGE = "Package";
            public const string FILTER_TYPE_OTHER = "Other";
            public const string FILTER_TYPE_CHANNEL = "Channel";
        }

        public class Event
        {
            //public const int PROGRAM_IMAGE_RESIZE_HEIGHT = 38;
            //public const int PROGRAM_IMAGE_RESIZE_WIDTH = 78;

            public const int PROGRAM_IMAGE_RESIZE_HEIGHT = 76;
            public const int PROGRAM_IMAGE_RESIZE_WIDTH = 156;

            public const int EVENT_PHASE_CONCEPT = 1;

        }
    }
}
