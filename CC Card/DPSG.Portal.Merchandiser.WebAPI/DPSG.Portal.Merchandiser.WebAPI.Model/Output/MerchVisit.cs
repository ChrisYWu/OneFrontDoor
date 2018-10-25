using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class MerchVisitRaw : OutputBase
    {
        List<MerchVisitExecution> _merchVisitExecutionLst;

        public List<MerchVisitExecution> MerchVisitExecutions
        {
            get { return _merchVisitExecutionLst; }
            set { _merchVisitExecutionLst = value; }
        }

        List<MerchVisitPhotoRaw> _merchVisiPhotoLst;

        public List<MerchVisitPhotoRaw> MerchVisitPhotos
        {
            get { return _merchVisiPhotoLst; }
            set { _merchVisiPhotoLst = value; }
        }

        List<MerchVisitSignatureRaw> _merchVisitSignature;
        public List<MerchVisitSignatureRaw> MerchVisitSignatures
        {
            get { return _merchVisitSignature; }
            set { _merchVisitSignature = value; }
        }

        List<AdhocMileage> _adhocMileage;
        public List<AdhocMileage> AdhocMileages
        {
            get { return _adhocMileage; }
            set { _adhocMileage = value; }
        }

        List<MerchVisitDNS> _merchVisitDNS;

        public List<MerchVisitDNS> MerchVisitDNS
        {
            get { return _merchVisitDNS; }
            set { _merchVisitDNS = value; }
        }
    }

    public class MerchVisit : OutputBase
    {
        public List<MerchVisitExecution> MerchVisitExecutions { get; set; }

        public List<MerchVisitPhoto> MerchVisitPhotos { get; set; }

        public List<MerchVisitSignature> MerchVisitSignatures { get; set; }

        public List<AdhocMileage> AdhocMileages { get; set; }

        public List<MerchVisitDNS> MerchVisitDNS { get; set; }

    }

    public class MerchVisitDNS
    {
        public int DNSReasonID { get; set; }
        public String DispatchDate { get; set; }
        public String GSN { get; set; }
        public int MerchGroupID { get; set; }
        public int RouteID { get; set; }
        public int ClientSequence { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public bool IsOffRouteStop { get; set; }
        public int SameStoreSequence { get; set; }
        public DateTime DNSCheckInTime { get; set; }
        public String DNSCheckInTimeZone { get; set; }
        public decimal DNSCheckInLatitude { get; set; }
        public decimal DNSCheckInLongitude { get; set; }
    }

    public class MerchVisitExecution
    {   
        //MerchStopCheckIN
        public Int64 MerchStopID { get; set; }
              
        public string DispatchDate { get; set; }
        public string GSN { get; set; }
        public int MerchGroupID { get; set; }
        public int ClientSequence { get; set; }      
        public int SameStoreSequence { get; set; }      
        public Int64 SAPAccountNumber { get; set; }
        public Boolean IsOffRouteStop { get; set; }
        public DateTime ClientCheckInTime { get; set; }
        public string ClientCheckInTimeZone { get; set; }        
        public decimal? CheckInLatitude { get; set; }
        public decimal? CheckInLongitude { get; set; }
        public Int32 DriveTimeInMinutes { get; set; }
        public decimal? StandardMileage { get; set; }
        public decimal? UserMileage { get; set; }
     

        //MerchStopCheckOut

        public DateTime? ClientCheckOutTime { get; set; }
        public string ClientCheckOutTimeZone { get; set; }        
        public decimal? CheckOutLatitude { get; set; }
        public decimal? CheckOutLongitude { get; set; }
        public int? CasesHandeled { get; set; }
        public int? CasesInBackroom { get; set; }
        public string Comments { get; set; }
        public int? AtAccountTimeInMinute { get; set; }

    }

    public class MerchVisitPhoto
    {
        public string DispatchDate { get; set; }
        public string GSN { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public int ClientPhotoID { get; set; }
        public string Caption { get; set; }
        public string PictureName { get; set; }
        public int SizeInByte { get; set; }
        public string Extension { get; set; }
        public string PictureURL { get; set; }
        public string PictureSAS { get; set; }

    }

    public class MerchVisitPhotoRaw : MerchVisitPhoto
    {
        //--------------------
        public string ConnectionString { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }
        public string AccessLevel { get; set; }
    }


    public class MerchVisitSignature
    {
        public string DispatchDate { get; set; }
        public string GSN { get; set; }
        public Int64 SAPAccountNumber { get; set; }
        public string ManagerName { get; set; }
        public string SignatureName { get; set; }
        public string ImageURL { get; set; }
        public string ImageSAS { get; set; }
    }

    public class MerchVisitSignatureRaw : MerchVisitSignature
    {
        //--------------------
        public string ConnectionString { get; set; }
        public string RelativeURL { get; set; }
        public string AbsoluteURL { get; set; }
        public string StorageAccount { get; set; }
        public string Container { get; set; }
        public string AccessLevel { get; set; }
    }


    public class AdhocMileage
    {
        public string DispatchDate { get; set; }
        public string GSN { get; set; }
        public int ClientMileageID {get; set;}
        public decimal UserMileage { get; set; }
        public string Description { get; set; }
    }

}
