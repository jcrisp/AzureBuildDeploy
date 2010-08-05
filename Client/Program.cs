using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;

namespace Client
{
    class Program
    {
        static void Main(string[] args)
        {
            var url = args[0];
            HelloWorldServiceClient client = new HelloWorldServiceClient("BasicHttpBinding_IHelloWorldService", url);
            var greeting = client.FindFirstGreetingUsingSqlAzure();
            Console.WriteLine("We got the greeting below via long path ConsoleApp <-> Azure WCF <-> Azure SQL:");
            Console.WriteLine(greeting);

            Console.WriteLine("Okay, lets check out the speed with 20 hits!");
            var start = DateTime.Now;
            for (int i = 0; i < 20; i++)
            {
                client.FindFirstGreetingUsingSqlAzure();
            }
            var duration = DateTime.Now - start;
            Console.WriteLine("On average, each hit is " + duration.TotalSeconds / 20 + " seconds.");
        }
    }
}
