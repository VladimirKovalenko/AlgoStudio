using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

// This automated trading systems (ATS) uses special indicator
// generating trading signals. 3MACrosses indicator
// generates three trade signals, +1(constant UP_TREND)
// this is signal for buy, -1(constant DOWN_TREND)
// When the trend is reversed up or down, the ATS closes opened
// positions and opens reversed.
// The project is developed for demo purposes to show 
// features of ProTrader Automation System

namespace ThreeMACrossAdvisor
{
    /// <summary>
    /// 3MACrossAdvisor
    /// 3 MA Cross .NET
    /// </summary>
    public class ThreeMACrossAdvisor : NETStrategy
    {
    
        [InputParameter("Short Moving Average Period", 0, 1, 100)]
        public int ShortMaPeriod = 5;

        [InputParameter("Middle Moving Average Period", 1, 1, 100)]
        public int MiddleMaPeriod = 10;

        [InputParameter("Long Moving Average Period", 2, 1, 100)]
        public int LongMaPeriod = 25;


		/// <summary>
        /// Constant of BUY trade signal
        /// </summary>
		private const int UP_TREND = 1;     
		
		/// <summary>
        /// Constant of NO_TREND trade signal
        /// </summary>
		private const int NO_TREND = 0;     
		
		/// <summary>
        /// Constant of SELL SHORT trade signal
        /// </summary>
		private const int DOWN_TREND = -1;  
		
		
		/// <summary>
        /// Current state of ATS
        /// </summary>
		private int state;   
		
		
		/// <summary>
        /// ATS entered long position
        /// </summary>
		private const int ENTERED_BUY = 1;  
		
		/// <summary>
        /// ATS entered short position
        /// </summary>
		private const int ENTERED_SHORT = -1; 
		
		/// <summary>
        /// ATS exit the market
        /// </summary>
		private const int EXIT_MARKET = 0;    


        public ThreeMACrossAdvisor()
            : base()
        {
			#region // Initialization
            base.Author = "nicky";
            base.Comments = "3 MA Cross .NET";
            base.Company = "PFSoft";
            base.Copyrights = "(c) PFSoft";
            base.DateOfCreation = "19.01.2011";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "3MACrossAdvisor";
            #endregion 


        }
        
        /// <summary>
        /// This function will be called after creating
        /// </summary>
		public override void Init()
		{
    		// Here must be initialization code
    		// This code will be executed once when the strategy is created.
    		// This function is not obligatory, and can be excluded from the project		
		}        
 
        /// <summary>
        /// Entry point. This function is called when new quote comes 
        /// </summary>
        public override void OnQuote()
        {
		    // Calculation of trend 
		    int trend = (int)platform.iCustom("3MASignal", platform.Symbol, platform.Period, 0, 0, ShortMaPeriod, MiddleMaPeriod, LongMaPeriod, 1);
		    
		    // Depending on trend detection making trade orders    
		    switch(trend)
			{
		        case UP_TREND:
		            // Up trend detected. If we were in short position, first closing it
		            if(state == ENTERED_SHORT)
		            {
		                // If request for closing has been sent, setting the current state - 
		                // we have already exit the market
		                if(ptl.ClosePosition(platform.Account, platform.Symbol))
		                    state = EXIT_MARKET;
		                    
		                // exitting the program to give some time to
		                // the system for processing the order. Entrance will 
		                // be performed on the next quote
		                return;     
		            }
		            
		            // If we haven't aleady entered the market, do it 
		            if(state != ENTERED_BUY)
		            {
		                // Sending request for opening long position, and 
		                // setting the state - "Entered long position"
		                ptl.OpenOrder(platform.Symbol, ptl.ORDER_MARKET, 0.0, ptl.OPERATION_BUY, 0.1);
		                state = ENTERED_BUY;                
		            }
		    	    break;
		        
		        case DOWN_TREND:
		            //Down trend detected. If we were in long position, firstly closing it 
		            if(state == ENTERED_BUY)
		            {
		                // If request for closing has been sent, setting the current state - 
		                // we have already exit the market
		                if(ptl.ClosePosition(platform.Account, platform.Symbol))
		                    state = EXIT_MARKET;
		                
		                // exitting the program to give some time to
		                // the system for processing the order. Entrance will 
		                // be performed on the next quote
		                return;    
		            }
		            
		            // If we haven't aleady entered the market, do it  
		            if(state != ENTERED_SHORT)
		            {
		                // Sending request for opening long position, and 
		                // if request is sent, then setting the state - "Entered long position"
		                ptl.OpenOrder(platform.Symbol, ptl.ORDER_MARKET, 0.0, ptl.OPERATION_SELL, 0.1);
	                    state = ENTERED_SHORT;
		            }
		        	break;
		        
		    }
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{
			// Here must be deinitialization code
    		// This code will be executed once when the strategy is destroyed
    		// This function is not obligatory, and can be excluded from the project
		} 
     }
}
