using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Net.NetworkInformation;
using PTLRuntime.NETScript;

namespace Untitled1
{
    /// <summary>
    /// Untitled1
    /// 
    /// </summary>
    public class Untitled1 : NETStrategy
    {
        [InputParameter("Server", 1, new object[] {
            "Trunk2(192.168.0.198)", "192.168.0.198",
            "Release(192.168.0.125)", "192.168.0.125",
            "fx(2.9.82.21)",  "2.9.82.21"}
        )]
        public string method = "2.9.82.21";
        
        public Untitled1()
            : base()
        {
			#region // Initialization
            base.Author = "Kovalenkov";
            base.Comments = "";
            base.Company = "PFSOFT";
            base.Copyrights = "";
            base.DateOfCreation = "05.04.2013";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "Untitled1";
            #endregion 


        }
        
//        public enum Grades { F = 0, D=1, C=2, B=3, A=4 };
//    	class Program
//    	{       
//	        static void Main(string[] args)
//	        {
//	            Console.WriteLine("First {0} a passing grade");
//	            Console.WriteLine("Second {0} a passing grade");
//	
//	            Console.WriteLine("\r\nRaising the bar!\r\n");
//	            Console.WriteLine("First {0} a passing grade.");
//	            Console.WriteLine("Second {0} a passing grade");
//	        }
//	    }
        /// <summary>
        /// This function will be called after creating
        /// </summary>
		public override void Init() 
		{
		
		}        
 
        /// <summary>
        /// Entry point. This function is called when new quote comes 
        /// </summary>
        public override void OnQuote()
        {
				int i=1;
//				string 	FXServer="5.9.82.21";
//				string SecindTrunk="192.168.0.198";
				Ping pingSender = new Ping();
				PingOptions options = new PingOptions();
				options.DontFragment = true;
				// Буфер 32 байта
				string data = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
				byte[] buffer = Encoding.ASCII.GetBytes(data);
				int timeout = 100;
				PingReply reply = pingSender.Send(string.Format("192.168.0.{0}", i), timeout, buffer, options);
				if (reply.Status == IPStatus.Success)
            	{
	                Print ("Address: ", reply.Address.ToString(), " Ping: ", reply.Status);
	                Print("RoundTrip time: ", reply.RoundtripTime);
	                Print("Time to live: ", reply.Options.Ttl);
	                Print("Don't fragment: ", reply.Options.DontFragment);
	                Print("Buffer size: ", reply.Buffer.Length);
	                Print("----------------");
            	}
            	else Print("Problems with ping");
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{

		} 
     }
}
