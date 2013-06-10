using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using PTLRuntime.NETScript;
using System.Drawing;

namespace ind
{

#region (BB)Bollinger Band
	//---------------------------------------------------
	// Project: Bollinger
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    
    public class BB : NETIndicator
    {
  
        public BB()
            : base()
        {
        	ProjectName = "Bollinger Band";
        	Comments = "Provides a relative definition of high and low based on standard deviation and a simple moving average";
            SetIndicatorLine("line1", Color.Green, 1, LineStyle.SimpleChart);
            SetIndicatorLine("line2", Color.Red, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
	    }
		public const int  LOWER_BAND = 0;
		public const int  UPPER_BAND = 1;

        [InputParameter("Sources prices for MA", 0, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrices = ptl.LOW;
		
		[InputParameter("Type of moving average", 1, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MAType = "SMA"; 
        
        [InputParameter("Period of MA for envelopes", 2)]
        public int MAPeriod = 5;
        [InputParameter("Value of confidence interval", 3, 1)]
        public double d = 1.0;

        public override void OnQuote()
        {
        	int count = platform.BarsCount(platform.Symbol, platform.Period); 
        	// Current amount of bars on the history
    	    // Getting amount of bars on the history
		    // Checking, if current amount of bars 
		    // more, than period of moving average. If it is
		    // then the calculation is possible
		    if(count>MAPeriod)
		    {
		        double maValue = platform.iCustom(MAType, platform.Symbol, platform.Period, 0, 0, MAPeriod, SourcePrices);
		        double summa = 0.0;
		        // Calulation of the summa
		        int i = 0; 
		        while(i<MAPeriod)
		        {
		            summa += ptl.MathSqr(ptl.GetPrice(SourcePrices, i) - maValue);
		            i++;
		        };
		        // Calculation of deviation value
	        	summa = d*ptl.MathSqrt(summa/MAPeriod);
		        // Setting value
		        platform.SetValue(LOWER_BAND, 0, maValue - summa);
		        platform.SetValue(UPPER_BAND, 0, maValue + summa);
    		 }
        }
    }
#endregion
	
#region (CHANNEL)Price Channel
   	//---------------------------------------------------
	// Project: PriceChanel
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class CHANNEL : NETIndicator
    {
  
        public CHANNEL()
            : base()
        {
        	ProjectName = "Price Channel";
        	Comments = "Based on measurement of min and max prices for the definite number of periods";
            SetIndicatorLine("line1", Color.Red, 1, LineStyle.SimpleChart);
            SetIndicatorLine("line2", Color.Blue, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

        [InputParameter("Period of price channel", 0)]
        public int PrPeriod = 10;
		
		
		public const double MIN = 10000000.0;
              
        public override void OnQuote()
        {
            int count = platform.BarsCount(platform.Symbol, platform.Period);
			if(count > PrPeriod)
			{
			    int i = 0;
			    int period = 0;
			    double high = 0.0;
			    double low = MIN;
			    // Calculation of max&min prices
			    while( (i<count) && (period<PrPeriod))
			    {
			        if(!ptl.IsEmpty(i))
			        {
			            double price = ptl.High[i];
			            if(price>high)
			                high = price;
			            price = ptl.Low[i];
			            if(price<low)
			                low = price;    
			            period++;
			        };
			        i++;
			    }
			    if(low<MIN)
			    {
			        platform.SetValue(0, 0, high);
			        platform.SetValue(1, 0, low);
			    }
			}  
        }
    }
#endregion

#region (KETLER)Ketler Channel
  	//---------------------------------------------------
	// Project: KetlerChannel
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class KETLER : NETIndicator
    {
  
        public KETLER()
            : base()
        {
        	ProjectName = "Ketler Channel";
        	Comments = "KETLER";
            SetIndicatorLine("line1", Color.Coral, 1, LineStyle.SimpleChart);
            SetIndicatorLine("line2", Color.Red, 1, LineStyle.SimpleChart);
            SetIndicatorLine("line3", Color.Purple, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

       [InputParameter("Sources prices for MA", 0, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrice = ptl.CLOSE;
        
        [InputParameter("Type of Moving Average", 1, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MAType = "SMA"; 

		[InputParameter("Period of MA for Ketler's Channel", 2)]
        public int MAPeriod = 5;
		[InputParameter("Coefficient of channel's width", 3, 1)]
        public double Offset = 2.0;
		
        public override void OnQuote()
        {  
            double middleTR = platform.iCustom(MAType, platform.Symbol, platform.Period, 0, 0, MAPeriod, SourcePrice);
		    double maaTR = 0.0;
		    switch(MAType)
		    {		    
		        case "SMA":
		            maaTR = Offset*CalcTRSMA();
		            break;
		            
		        case "EMA":
		            maaTR = Offset*CalcTREMA();
		            break;
		            
		        case "MMA":
		            maaTR = Offset*CalcTRMMA();
		            break;
		            
		        case "LWMA":
		            maaTR = Offset*CalcTRLWMA();
		            break;            
		    }
		    
		    platform.SetValue(0, 0, middleTR);
		    platform.SetValue(1, 0,	middleTR + maaTR);
		    platform.SetValue(2, 0, middleTR - maaTR);
           
        }
        
        public double CalcTRSMA()
		{
			int count = platform.BarsCount(platform.Symbol, platform.Period);
		    // Current amount of bars on the history
		    // Getting amount of bars on the history
		    // Checking, if current amount of bars 
		    // more, than period of moving average. If it is
		    // then the calculation is possible
		    if(count>MAPeriod)
		    {
		        int i = 0;          // Usual counter
		        double summa = 0.0; // Sum of prices
		        int period = 0;     // period counter
		        // Loop of calculation. The loop skips empty bars
		        while( (period<MAPeriod) && (i<count) )
		        {
		            // Chiking, if the current bar is empty
		            if(!ptl.IsEmpty(i))
		            {
		                // Bar is not empty, adding it's price to the summa
		                summa += ptl.TrueRange[i];
		                // increment of period counter
		                period++;
		            }
		            // going to the next bar
		            i++;
		        }
		        // Setting the current value of the indicator
		        return summa/MAPeriod;   
		    }
		    return 0.0;		
		}
		

		public double CalcTREMA()
		{
			int count = platform.BarsCount(platform.Symbol, platform.Period);
		    // Current amount of bars on the history
		    // Getting amount of bars on the history
		    // Checking, if current amount of bars 
		    // more, than period of moving average. If it is
		    // then the calculation is possible
		    if(count>MAPeriod)
		    {
		        // Calculation of a coefficient
		        double k = 2.0/(MAPeriod + 1);
		        // Getting current price
			    double summa = ptl.TrueRange[0]; // Sum of prices
    	        for (int i = 1; i < MAPeriod; i++)
        	     	summa += k * (ptl.TrueRange[i] - summa);

                return summa;
		    }
		    
		    return 0.0;
		}
		
		public double CalcTRLWMA()
		{
			int count = platform.BarsCount(platform.Symbol, platform.Period);
		    // Current amount of bars on the history
		    // Getting amount of bars on the history
		    // Checking, if current amount of bars 
		    // more, than period of moving average. If it is
		    // then the calculation is possible
		    if(count>MAPeriod)
		    {
		        int i = 0;                               // Usual counter
		        double numerator = 0.0;                  // Numerator of the rate
		        double denominator = 0.0;                // Denominator of the rate
		        int period = MAPeriod;           // period counter
		        double k = 1.0/MAPeriod;              // coefficient
		        // Loop of calculation. The loop skips empty bars
		        while( (period>0) && (i<count) )
		        {
		            // Chiking, if the current bar is empty
		            if(!ptl.IsEmpty(i))
		            {
		                // Bar is not empty, adding it's price to the summa
		                numerator += period*ptl.TrueRange[i];
		                denominator += period;
		                // increment of period counter
		                period --;
		            }
		            // going to the next bar
		            i++;
		        }
		        // Setting the current value of the indicator
		        return numerator/denominator;   
		    }
		    
		    return 0.0;
		}
		
		public double CalcTRMMA()
		{
			int count = platform.BarsCount(platform.Symbol, platform.Period);
		    // Current amount of bars on the history
		    // Getting amount of bars on the history
		    // Checking, if current amount of bars 
		    // more, than period of moving average. If it is
		    // then the calculation is possible
		    if(count>MAPeriod)
		    {
		        int i = 0;                        // Usual counter
		        double mma = ptl.TrueRange[0];   // Current price
		        int period = 0;                   // period counter
		        double k = 1.0/MAPeriod;       // coefficient
		        // Loop of calculation. The loop skips empty bars
		        while( (period<MAPeriod) && (i<count) && (mma>0.0) )
		        {
		            // Chiking, if the current bar is empty
		            if(!ptl.IsEmpty(i))
		            {
		                // Bar is not empty, adding it's price to the summa
		                double price = ptl.TrueRange[i];
		                mma = price*k + mma*(1.0 - k);
		                // increment of period counter
		                period++;
		            }
		            // going to the next bar
		            i++;
		        }
		        // Setting the current value of the indicator
		        return mma;
		    }
		    
		    return 0.0;
		}
    }
#endregion
   
#region (MAE)Moving Average Envelope
    //---------------------------------------------------
	// Project: Envelope
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class MAE : NETIndicator
    {
  
        public MAE()
            : base()
        {
        	ProjectName = "Moving Average Envelope";
        	Comments = "Demonstrates a range of the prices discrepancy from a Moving Average";
            SetIndicatorLine("line1", Color.Purple, 1, LineStyle.SimpleChart);
            SetIndicatorLine("line2", Color.LightSeaGreen, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

		public int LOWER_BAND = 0;
		public int UPPER_BAND = 1;

        

        [InputParameter("Sources prices for MA", 0, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrices = ptl.LOW;
        
        [InputParameter("Type of Moving Average", 1, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MAType = "SMA"; 

		[InputParameter("Period of MA for envelopes", 2)]
        public int MAPeriod = 5;
        [InputParameter("Upband deviation in %", 3, 1)]
        public double UpShift = 0.1;
        [InputParameter("Downband deviation in %", 4, 1)]
        public double DownShift = 0.1;

        public override void OnQuote()
        {
            int count = platform.BarsCount(platform.Symbol, platform.Period);
            if(count>MAPeriod)
     		{
         	double maValue; maValue = platform.iCustom(MAType, platform.Symbol, platform.Period, 0, 0, MAPeriod, SourcePrices);
         	platform.SetValue(LOWER_BAND, 0, (1.0 - DownShift*0.01)*maValue);
         	platform.SetValue(UPPER_BAND, 0, (1.0 + UpShift*0.01)*maValue);
     		}
        }
    }
#endregion
    
   //---------------mql4---------------//

#region (BBF)Bollinger Band Flat
	[FullRefresh]
    [KillExceptions]
	public class BBF : NETIndicator
    {
  
        public BBF()
            : base()
        {
        	ProjectName = "Bollinger Band Flat";
        	Comments = "Provides the same data as BB, but drawn in separate field and easier to recognize whether price is in our out of band";
            SetIndicatorLine("line1", Color.Aqua, 1, LineStyle.SimpleChart);
			SetIndicatorLine("line2", Color.Red, 1, LineStyle.SimpleChart);
			SetIndicatorLine("line3", Color.Red, 1, LineStyle.SimpleChart);
			SetIndicatorLine("line4", Color.Yellow, 1, LineStyle.SimpleChart);
            SeparateWindow = true;      
        }

        [InputParameter("Period", 0)]
        public int period = 9;
        
        [InputParameter("Shift", 1)]
        public int shift = 0;
        
        [InputParameter("Type of MA", 2, new object[] {
            "Simple", mql4.MODE_SMA,
            "Exponential", mql4.MODE_EMA,
            "Modified", mql4.MODE_SMMA,
           	"Linear Weighted", mql4.MODE_LWMA}
        )]
        public int method=0;
        
        [InputParameter("Source prices", 3, new object[] {
             "Close", mql4.PRICE_CLOSE,
             "Open", mql4.PRICE_OPEN,
             "High", mql4.PRICE_HIGH,
             "Low", mql4.PRICE_LOW,
             "Typical", mql4.PRICE_TYPICAL,
             "Medium", mql4.PRICE_MEDIAN,
             "Weighted", mql4.PRICE_WEIGHTED}
        )]
        public int price=0;
       
       [InputParameter("Deviation", 4, 1)]
        public double deviation=1.5;
        
        
        public IArray ExtMapBuffer1;
		public IArray ExtMapBuffer2;
		public IArray ExtMapBuffer3;
		public IArray ExtMapBuffer4;
			
		public override void Init()
		{ 
			platform.SetIndexBuffer(0, ref ExtMapBuffer1);
			platform.SetIndexBuffer(1, ref ExtMapBuffer2);
			platform.SetIndexBuffer(2, ref ExtMapBuffer3);
			platform.SetIndexBuffer(3, ref ExtMapBuffer4);
		}
        
        public override void OnQuote()
        {
        	 int limit = 0, counted_bars = platform.IndicatorCounted();
		     double ima = 0.0, std = 0.0;
		     if(counted_bars<0) return;
		     if(counted_bars>0) counted_bars--;
		     limit=mql4.Bars-counted_bars;
		     for(int i=0; i<limit; i++)
		     {
			    ima=mql4.iMA(mql4.NULL,0,period,shift,method,price,i);
		       std=deviation*mql4.iStdDev(mql4.NULL,0,period,shift,method,price,i);
				 ExtMapBuffer1[i]=0;
		       ExtMapBuffer2[i]=std;
		       ExtMapBuffer3[i]=-std;
		       ExtMapBuffer4[i]=mql4.Close[i]-ima;
		     }
		}
    }
#endregion
    
}

