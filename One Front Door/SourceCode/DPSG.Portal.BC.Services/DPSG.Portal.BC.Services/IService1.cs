using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using DPSG.Portal.BC.Types;
using System.Net.Security;
using DPSG.Portal.BC.Services.DataContract;

namespace DPSG.Portal.BC.Services
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    
    [ServiceContract]
    public interface IService1
    {
        [OperationContract]
        [FaultContract(typeof(ExceptionErrorMsg))]
        List<BCBottler> GetBottlers(string LastModifiedDate);


    }  

}
