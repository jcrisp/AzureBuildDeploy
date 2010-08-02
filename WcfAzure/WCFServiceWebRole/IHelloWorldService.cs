using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace WCFServiceWebRole
{
    [ServiceContract]
    public interface IHelloWorldService
    {
        [OperationContract]
        string SayHi(string name);

    }

}
