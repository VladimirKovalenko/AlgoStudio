using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace SendOrderClass
{
    /// <summary>
    /// SendOrderClass
    /// 
    /// </summary>
    public class SendOrderClass : NETStrategy
    {
        private const int magicNumber = 352320;
        
		private double takeProfit = 200.0;
		
		private double stopLoss = 200.0;
		
		private double lots = 1.0;        
        

        public SendOrderClass()
            : base()
        {
			#region // Initialization
            base.Author = "Karol Marchewka";
            base.Comments = "";
            base.Company = "PFSoft";
            base.Copyrights = "Karol Marchewka";
            base.DateOfCreation = "06.01.2013";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "SendOrderClass";
            #endregion 
        }
        
        public double TakeProfit
        {
        	get { return this.takeProfit; }
        	set { this.takeProfit = value; }
        }
        
        public double StopLoss
       	{
           	get { return this.stopLoss; }
           	set { this.stopLoss = value; }
        }
        
        public double Lots
        {
            get { return this.lots; }
            set { this.lots = value; }
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
			SendLongOrder();
			SendShortOrder();
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{
			
		} 
		
		public void SendLongOrder()
		{
    		int ticket;
    		
    		ticket = mql4.OrderSend(mql4.Symbol(), mql4.OP_BUY, this.lots, mql4.Ask, 0, mql4.Bid - (this.stopLoss * mql4.Point), mql4.Ask + (this.takeProfit * mql4.Point), "Long Order", magicNumber, 0, mql4.Blue);
    		
    		if (ticket > 0)
    		{
        		if (mql4.OrderSelect(ticket, mql4.SELECT_BY_TICKET, mql4.MODE_TRADES))
        		{
            		mql4.Print("Long order opened at: ", mql4.OrderOpenPrice());
            	}
            	else
            	{
                	mql4.Print("Order error: ", mql4.GetLastError());
                }
        	}
    	}		
		
		public void SendShortOrder()
		{
    		int ticket;
    		
    		ticket = mql4.OrderSend(mql4.Symbol(), mql4.OP_SELL, this.lots, mql4.Bid, 0, mql4.Ask + (this.stopLoss * mql4.Point), mql4.Bid - (this.takeProfit * mql4.Point), "Short Order", magicNumber, 0, mql4.Red);
    		
    		if (ticket > 0)
    		{
        		if (mql4.OrderSelect(ticket, mql4.SELECT_BY_TICKET, mql4.MODE_TRADES))
        		{
            		mql4.Print("Short order opened at: ", mql4.OrderOpenPrice());
            	}
            	else
            	{
                	mql4.Print("Order error: ", mql4.GetLastError());
                }
        	}
    	}			
   	}
}
