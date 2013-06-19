using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace TestStr
{
    /// <summary>
    /// TestStr
    /// ~!@#$%^&*()_+
    /// </summary>
    public class TestStr : NETStrategy
    {
        public TestStr()
            : base()
        {
			#region // Initialization
            base.Author = "~!@#$%^&*()_+";
            base.Comments = "~!@#$%^&*()_+";
            base.Company = "PFSOFT~!@#$%^&*()_+";
            base.Copyrights = "~!@#$%^&*()_+";
            base.DateOfCreation = "18.06.2013";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "TestStr";
            #endregion 


        }
        
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
			string ticker=OpenOrder(Symbol,ORDER_MARKET,Ask, OPERATION_BUY);
			Print(ticker);
			bool sel1=SelectOrder(ticker);					//t
			bool sel2=SelectOrder(0, true);					//t
			bool sel3=SelectOrder(0, false);				//f
			bool sel4=SelectOrder(ticker, false,false);		//t
			bool sel5=SelectOrder(ticker, false,true);		//t
			bool sel6=SelectOrder(ticker, true,false);		//f
			bool sel7=SelectOrder(ticker, true,true);		//f
			bool sel8=SelectPosition(0);					//t
			
			string orderid=OrderId();
			Print("");
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{
			
		} 
     }
}
