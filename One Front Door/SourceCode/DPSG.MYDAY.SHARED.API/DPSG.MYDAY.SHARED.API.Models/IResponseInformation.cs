
namespace DPSG.MYDAY.SHARED.API.Models
{
    public interface IResponseInformation
    {
        string ErrorMessage { get; set; }
        int ResponseStatus { get; set; }
        string StackTrace { get; set; }
    }
}
