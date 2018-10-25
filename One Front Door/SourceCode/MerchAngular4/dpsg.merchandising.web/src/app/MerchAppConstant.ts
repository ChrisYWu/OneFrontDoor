export class MerchConstant {

    // ********Local Environment ********

     //public static get WebAPI_ENDPOINT(): string { return 'http://bplnshp02:2000/MerchPortalWebAPI/'; }
      //public static get WebAPI_ENDPOINT(): string { return 'http://merchandiser/'; }
    // // public static get WebAPI_ENDPOINT(): string { return 'http://localhost:8888/'; }
      //public static get MYDAY_WebAPI_ENDPOINT(): string { return 'http://webservices-dev.dpsg.net/'; }

    //***** Integration Enviornment *********

        //public static get WebAPI_ENDPOINT(): string { return 'http://merchandising-int.dpsg.net/'; }
      //   public static get WebAPI_ENDPOINT(): string { return '/'; }
       //  public static get MYDAY_WebAPI_ENDPOINT(): string { return 'http://webservices-int.dpsg.net/merchwebapi/'; }

    // *************** QA Environment****************

     //public static get WebAPI_ENDPOINT(): string { return 'http://merchandising-qa.dpsg.net/'; }
     //public static get WebAPI_ENDPOINT(): string { return '/'; }
     //public static get MYDAY_WebAPI_ENDPOINT(): string { return 'http://webservices-qa.dpsg.net/merchwebapi/'; }

    // *********** PROD Environment *************

      //public static get WebAPI_ENDPOINT(): string { return 'http://merchandising.dpsg.net/'; }
      public static get WebAPI_ENDPOINT(): string { return '/'; }
      public static get MYDAY_WebAPI_ENDPOINT(): string { return 'http://webservices.dpsg.net/merchwebapi/'; }
   
   
}