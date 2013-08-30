using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace CSharpTester_1
{
    /// <summary>
    /// CSharpTester_1
    /// 
    /// </summary>
    public class CSharpTester_1 : NETStrategy
    {
        private const int magicNumber = 34221;

		private double takeProfit = 200.0;
		
		private double stopLoss = 800.0;
		
		private double lots = 1.0;    
		
		private int cciPeriodM1 = 89;
		
		private int cciPeriodM15 = 55;
		
		private int cciPeriodH1 = 34;
        
        public CSharpTester_1()
            : base()
        {
			#region // Initialization
            base.Author = "Karol Marchewka";
            base.Comments = "";
            base.Company = "PFSoft";
            base.Copyrights = "Karol Marchewka";
            base.DateOfCreation = "09.01.2013";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "CSharpTester_1";
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
        
        public int CciPeriodM1
        {
            get { return this.cciPeriodM1; }
            set { this.cciPeriodM1 = value; }
        }
        
        public int CciPeriodM15
        {
            get { return this.cciPeriodM15; }
            set { this.cciPeriodM15 = value; }
        }
        
        public int CciPeriodH1
        {
            get { return this.cciPeriodH1; }
            set { this.CciPeriodH1 = value; }
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
  			if (mql4.iBars(mql4.Symbol(), mql4.PERIOD_M1) < this.cciPeriodM1 || mql4.iBars(mql4.Symbol(), mql4.PERIOD_M15) < this.cciPeriodM15 || mql4.iBars(mql4.Symbol(), mql4.PERIOD_H1) < this.cciPeriodH1)   			
   			{
    			mql4.Print("Bars less than CciPeriodM1 " + this.cciPeriodM1 + " or less than CciPeriodM15 " + this.cciPeriodM15 + " or less than CciPeriodH1 " + this.cciPeriodH1);          			 
   			}
   			else
   			{    	
   				if (CountLongPositions() == 0 && CciM1() <= -200 && CciM15() >= 0 && CciM15() < 100 && CciH1() >= 100)
   				{
       				SendLongOrder();
       			}
       			if (CountShortPositions() == 0 && CciM1() >= 200 && CciM15() <= 0 && CciM15() > -100 && CciH1() <= -100)
       			{
           			SendShortOrder();
           		}
   			}
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{  		
 
		} 
		
		public double CciM1()
		{
    		double cci = 0.0;
    		
    		cci = mql4.iCCI(mql4.Symbol(), mql4.PERIOD_M1, this.cciPeriodM1, mql4.PRICE_CLOSE, 0);
    		
    		return (cci);
    	}	
    	
		public double CciM15()
		{
    		double cci = 0.0;
    		
    		cci = mql4.iCCI(mql4.Symbol(), mql4.PERIOD_M15, this.cciPeriodM15, mql4.PRICE_CLOSE, 0);
    		
    		return (cci);
    	}		    	
		
		public double CciH1()
		{
    		double cci = 0.0;
    		
    		cci = mql4.iCCI(mql4.Symbol(), mql4.PERIOD_H1, this.cciPeriodH1, mql4.PRICE_CLOSE, 0);
    		
    		return (cci);
    	}			
		
		public int CountLongPositions()
		{
    		int longPositions = 0;
    		
    		for (int i = 0; i < mql4.OrdersTotal(); i++)
    		{
        		mql4.OrderSelect(i, mql4.SELECT_BY_POS, mql4.MODE_TRADES);
        		
        		if (mql4.OrderSymbol() == mql4.Symbol() && mql4.OrderMagicNumber() == magicNumber)
        		{
            		if (mql4.OrderType() == mql4.OP_BUY)
            		{
                		longPositions++;
                	}
            	}
        	}
        	
        	return (longPositions);
    	}		
		
		public int CountShortPositions()
		{
    		int shortPositions = 0;
    		
    		for (int i = 0; i < mql4.OrdersTotal(); i++)
    		{
        		mql4.OrderSelect(i, mql4.SELECT_BY_POS, mql4.MODE_TRADES);
        		
        		if (mql4.OrderSymbol() == mql4.Symbol() && mql4.OrderMagicNumber() == magicNumber)
        		{
            		if (mql4.OrderType() == mql4.OP_SELL)
            		{
                		shortPositions++;
                	}
            	}
        	}
        	
        	return (shortPositions);
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
