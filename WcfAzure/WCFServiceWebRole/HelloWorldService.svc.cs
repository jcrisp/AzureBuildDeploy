using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace WCFServiceWebRole
{
    public class HelloWorldService : IHelloWorldService
    {
        public string SayHi(string name)
        {
            return "Greetings and welcome to you, " + name;
        }

    }
}
