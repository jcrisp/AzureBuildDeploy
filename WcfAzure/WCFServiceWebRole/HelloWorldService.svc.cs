using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Data.SqlClient;

namespace WCFServiceWebRole
{
    public class HelloWorldService : IHelloWorldService
    {
        public string SayHi(string name)
        {
            return "Greetings and welcome to you, " + name;
        }

        public string FindFirstGreetingUsingSqlAzure()
        {
            /* The "schema" to set up in SQL Azure :-) 
                create table Greetings ( pk int, greeting varchar(255) );
                CREATE UNIQUE CLUSTERED INDEX pkindex ON Greetings (pk)
                insert into Greetings values(1, 'Greetings Earthling!');
             */
            const string databaseServer = "__enter-id__.database.windows.net";
            const string userName = "user@__enter-id__";
            const string password = "secret password";

            var result = "";

            var connectionString = string.Format("Server=tcp:{0};Database=HelloWorld;User ID={1};Password={2};Trusted_Connection=False;Encrypt=True;",
                                                  databaseServer, userName, password);

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                result = (string) new SqlCommand("select top 1 greeting from Greetings", connection).ExecuteScalar();
            }

            return result;
        }

    }
}
