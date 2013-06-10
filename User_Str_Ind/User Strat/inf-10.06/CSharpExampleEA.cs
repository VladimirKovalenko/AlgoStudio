using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace CSharpExampleEA
{
    /// <summary>
    /// CSharpExampleEA
    /// 
    /// </summary>
    public class CSharpExampleEA : NETStrategy
    {
        private const int magicNumber = 352320;

		private double takeProfit = 200.0;
		
		private double stopLoss = 200.0;
		
		private double lots = 1.0;
		
		private int startTrading = 8;
		
		private int stopTrading = 16;
		
		private int rsiPeriod = 14;
		
		private int superTrendPeriod = 42;
		
		private int rsiLevel = 50;
        
        public CSharpExampleEA()
            : base()
        {
			#region // Initialization
            base.Author = "Karol Marchewka";
            base.Comments = "";
            base.Company = "PFSoft";
            base.Copyrights = "Karol Marchewka";
            base.DateOfCreation = "07.01.2013";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "CSharpExampleEA";
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
        
        public int StartTrading
        {
            get { return this.startTrading; }
            set { this.startTrading = value; }
        }
        
        public int StopTrading
        {
            get { return this.stopTrading; }
            set { this.stopTrading = value; }
        }
        
        public int RsiPeriod
        {
           	get { return this.rsiPeriod; }
           	set { this.rsiPeriod = value; }
        }
        
		public int SuperTrendPeriod
		{
    		get { return this.superTrendPeriod; }
    		set { this.superTrendPeriod = value; }
    	}
    	
    	public int RsiLevel
    	{
        	get { return this.rsiLevel; }
        	set { this.rsiLevel = value; }
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
   			if (mql4.Bars < rsiPeriod || mql4.Bars < superTrendPeriod)
   			{
    			Print("Bars less than RsiPeriod " + RsiPeriod + " or less then SuperTrendPeriod " + SuperTrendPeriod);          			 
   			}
   			else
   			{
				if (TradingHours() == true)
				{
    				if (CountLongPositions() == 0 && SuperTrendUp() != mql4.NULL && Rsi1() > this.rsiLevel && Rsi2() <= this.rsiLevel)
    				{
        				if (CountShortPositions() > 0)
        				{
            				CloseShortPositions();
            			}
            
            			SendLongOrder();
       				}
       	
       				if (CountShortPositions() == 0 && SuperTrendDown() != mql4.NULL && Rsi1() < this.rsiLevel && Rsi2() >= this.rsiLevel)
       				{
           				if (CountLongPositions() > 0)
           				{
               				CloseLongPositions();
            			}
            
            			SendShortOrder();
        			}
    			}
        	}
     	}
     	
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{
			
		}

		public double Rsi1()
		{
    		double rsi = 0.0;
    		
    		rsi = mql4.iRSI(mql4.Symbol(), mql4.Period(), this.rsiPeriod, mql4.PRICE_CLOSE, 1);
    		
    		return (rsi);
    	}
    	
    	public double Rsi2()
		{
    		double rsi = 0.0;
    		
    		rsi = mql4.iRSI(mql4.Symbol(), mql4.Period(), this.rsiPeriod, mql4.PRICE_CLOSE, 2);
    		
    		return (rsi);
    	}    	
		
		public double SuperTrendUp()
		{
    		double superTrendUp = 0.0;
    		
    		superTrendUp = mql4.iCustom(mql4.Symbol(), mql4.Period(), "SuperTrend", this.superTrendPeriod, 0, 0);
    		
    		return (superTrendUp);    		
    	}
    	
    	public double SuperTrendDown()
    	{
        	double superTrendDown = 0.0;
        	
        	superTrendDown = mql4.iCustom(mql4.Symbol(), mql4.Period(), "SuperTrend", this.superTrendPeriod, 1, 0);
        	
        	return (superTrendDown);
        }
        
		public bool TradingHours()
		{
    		bool canTrade = false;
    		int TimeHout=mql4.Hour();
    		if ( TimeHout>= this.startTrading && TimeHout<= this.stopTrading)
    		{
        		canTrade = true;
        	}
        	else
        	{
            	canTrade = false;
            }
            
            return (canTrade);
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
		
		public void CloseLongPositions()
		{
    		for (int i = 0; i < mql4.OrdersTotal(); i++)
    		{
        		mql4.OrderSelect(i, mql4.SELECT_BY_POS, mql4.MODE_TRADES);
        		
        		if (mql4.OrderSymbol() == mql4.Symbol() && mql4.OrderMagicNumber() == magicNumber)
        		{
            		if (mql4.OrderType() == mql4.OP_BUY)
            		{
                		mql4.OrderClose(mql4.OrderTicket(), mql4.OrderLots(), mql4.Bid, 0, mql4.Aqua);
                	}
            	}
        	}
    	}
		
		public void CloseShortPositions()
		{
    		for (int i = 0; i < mql4.OrdersTotal(); i++)
    		{
        		mql4.OrderSelect(i, mql4.SELECT_BY_POS, mql4.MODE_TRADES);
        		
        		if (mql4.OrderSymbol() == mql4.Symbol() && mql4.OrderMagicNumber() == magicNumber)
        		{
            		if (mql4.OrderType() == mql4.OP_SELL)
            		{
                		mql4.OrderClose(mql4.OrderTicket(), mql4.OrderLots(), mql4.Ask, 0, mql4.Magenta);
                	}
            	}
        	}
    	}		
		
		public void SendLongOrder()
		{
    		int ticket;
    		
    		ticket = mql4.OrderSend(mql4.Symbol(), mql4.OP_BUY, this.lots, mql4.Ask, 0, mql4.Bid - (this.stopLoss * mql4.Point), mql4.Ask + (this.takeProfit * mql4.Point), "Long Order", magicNumber, 0, mql4.Blue);
    		
    		if (ticket > 0)
    		{
        		if (mql4.OrderSelect(ticket, mql4.SELECT_BY_TICKET, mql4.MODE_TRADES))
        		{
            		Print("Long order opened at: ", mql4.OrderOpenPrice());
            	}
            	else
            	{
                	Print("Order error: ", mql4.GetLastError());
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
            		Print("Short order opened at: ", mql4.OrderOpenPrice());
            	}
            	else
            	{
                	Print("Order error: ", mql4.GetLastError());
                }
        	}
    	}			
  	}
}
