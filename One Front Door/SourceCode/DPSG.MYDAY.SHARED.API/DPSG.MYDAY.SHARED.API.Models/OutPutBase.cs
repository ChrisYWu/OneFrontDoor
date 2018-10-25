namespace DPSG.MYDAY.SHARED.API.Models
{
    public class OutputBase : Models.IResponseInformation
    {
        public string ErrorMessage { get; set; }
        public int ResponseStatus { get; set; }
        public string StackTrace { get; set; }
    }
}
