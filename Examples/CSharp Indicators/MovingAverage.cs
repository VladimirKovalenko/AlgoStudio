using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using PTLRuntime.NETScript;
using System.Drawing;

namespace ind
{

#region (3MAS)3MASignal
    //---------------------------------------------------
	// Project: 3MASignal
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC
	// Copyright: (C) PFSoft LLC Dnepropetrovsk Ukraine
	// Created: Nov, 29, 2006
	//---------------------------------------------------
    public class MAS3 : NETIndicator
    {
  
        public MAS3()
            : base()
        {
        	ProjectName = "3MASignal";
        	Comments = "Offers buy and sell signals according to intersections of three moving averages";
            SetIndicatorLine("line1", Color.Blue, 5, LineStyle.HistogrammChart);
            SeparateWindow = true;
        }

        [InputParameter("Short Moving Average Period", 0)]
        public int ShortMaPeriod = 5;
		[InputParameter("Middle Moving Average Period", 1)]
        public int MiddleMaPeriod = 10;
		[InputParameter("Long Moving Average Period", 2)]
        public int LongMaPeriod = 25;
        [InputParameter("Amount of bars passed before opening position", 3)]
        public int BarsInterval = 1;

		public const int NO_TREND = 0;    // No trend detected
		public const int UP_TREND = 1;    // Up trend detected
		public const int DOWN_TREND = -1;  // Down trend detected


 
        public override void OnQuote()
        {
            platform.SetValue(0, 0, system.IntToDouble(TradeSignal()));
        }
        public int GetMaxPeriod(int shortPeriod, int middlePeriod, int longPeriod)
		{
		    int maxValue; 
		    if(shortPeriod>middlePeriod)
		        maxValue = shortPeriod;
		    else
		        maxValue = longPeriod;
		    
		    if(maxValue>longPeriod)
		        return maxValue;
		    else
		        return longPeriod;
		}
		
		public int CompareMA(double shMa, double midMA, double lgMa)
		{
		    if( (midMA>lgMa)&&(midMA<shMa) )
		    {
		        return UP_TREND;
		    }
		    if( (midMA>shMa)&&(midMA<lgMa) )
		    {
		        return DOWN_TREND;
		    }
		    return NO_TREND;
		}
		
		public int TradeSignal()
		{
		    string symbol; symbol = platform.Symbol;
		    int period; period = platform.Period; 
		    int count; count = platform.BarsCount(platform.Symbol, platform.Period);;
		    if(count>GetMaxPeriod(ShortMaPeriod, MiddleMaPeriod, LongMaPeriod))
		    {
		        // looking for BarsInterval back
		        int shift = 0;
		        int state = NO_TREND;
		        while(shift<BarsInterval)
		        {
		            double shortMa; 
		            shortMa = ptl.iMA(ShortMaPeriod, 0, shift);
		            
		            double middleMa;
		            middleMa = ptl.iMA(MiddleMaPeriod, 0, shift);
		            
		            double longMa; 
		            longMa  = ptl.iMA(LongMaPeriod, 0, shift);
		             
		            if(shift == 0)
		            {
		                // calculating beginning state
		                state = CompareMA(shortMa, middleMa, longMa);
		                //SetValue(1, shortMa);
		                //SetValue(2, middleMa);
		                //SetValue(3, longMa);
		            }
		            else
		            {
		                // depending on previous value, getting the current trend value
		                int curState; 
		                curState = CompareMA(shortMa, middleMa, longMa);
		                if(state==UP_TREND)
		                {
		                    // up trend is if current state is UP and previous is up also
		                    if(curState != UP_TREND)
		                        return NO_TREND;
		                }
		                if(state == DOWN_TREND)
		                {
		                    if(curState != DOWN_TREND)
		                        return NO_TREND;
		                }
		            }
		            shift++;
		        }
		        // returninig current state
		        return state;        
		    }
		    // NO trend is returned
		    return NO_TREND;
		}
        
    }
#endregion

#region (ALLIGATOR)Alligator
	//---------------------------------------------------
    // Project: Alligator
    // Type: Indicator
    // Author: PFSoft LLC
    // Company: PFSoft LLC /www.pfsoft.com/
    // Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
    // Created: Nov, 28,2006
    //---------------------------------------------------
    public class ALLIGATOR : NETIndicator
    {
		public ALLIGATOR()
            : base()
        {
        	ProjectName = "Alligator";
        	Comments = "Three moving averages with different colors, periods and calculation methods";
            SetIndicatorLine("JAW_LINE", Color.Green, 1, LineStyle.SimpleChart);
            SetIndicatorLine("TEETH_LINE", Color.Red, 1, LineStyle.SimpleChart);
            SetIndicatorLine("LIPS_LINE", Color.Blue, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

        [InputParameter("Type of Jaw Moving Average", 0, new object[]{
	         "Simple", "SMA",
	         "Exponential", "EMA",
	         "Modified", "MMA",
	         "Linear Weighted", "LWMA"}
        )]
        public string JawMAType = "SMA";
 		[InputParameter("Source price for Jaw Moving Average", 1, new object[]{
	         "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int JawSourcePrice = ptl.CLOSE;
       	[InputParameter("Period of Jaw Moving Average", 2)]
        public int JawMAPeiod = 13;
 		[InputParameter("Shift of Jaw Moving Average", 3)]
        public int JawMAShift = 8;
        
        [InputParameter("Type of Teeth Moving Average", 4, new object[]{
	         "Simple", "SMA",
	         "Exponential", "EMA",
	         "Modified", "MMA",
	         "Linear Weighted", "LWMA"}
        )]
        public string TeethMAType = "SMA";
 		[InputParameter("Source price for Jaw Moving Average", 5, new object[]{
	         "Close", ptl.CLOSE,
             "Open", ptl.OPEN,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int TeethSourcePrice = ptl.CLOSE;
        [InputParameter("Period of Teeth Moving Average", 6)]
        public int TeethMAPeiod = 8;
 		[InputParameter("Shift of Teeth Moving Average", 7)]
        public int TeethMAShift = 5;
        
        [InputParameter("Type of Lips Moving Average", 8, new object[]{
	         "Simple", "SMA",
	         "Exponential", "EMA",
	         "Modified", "MMA",
	         "Linear Weighted", "LWMA"}
        )]
        public string LipsMAType = "SMA";
 		[InputParameter("Source price for Jaw Moving Average", 9, new object[]{
	         "Close", ptl.CLOSE,
             "Open", ptl.OPEN,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int LipsSourcePrice = ptl.CLOSE;
        [InputParameter("Period of Lips Moving Average", 10)]
        public int LipsMAPeiod = 5;
 		[InputParameter("Shift of Lips Moving Average", 11)]
        public int LipsMAShift = 3;
        
        public override void OnQuote()
        {
		    platform.SetValue(0, 0, platform.iCustom(JawMAType, platform.Symbol, platform.Period, 0, JawMAShift, JawMAPeiod, JawSourcePrice ));
		    platform.SetValue(1, 0, platform.iCustom(TeethMAType, platform.Symbol, platform.Period, 0, TeethMAShift, TeethMAPeiod, TeethSourcePrice ));
    		platform.SetValue(2, 0, platform.iCustom(LipsMAType, platform.Symbol, platform.Period, 0, LipsMAShift, LipsMAPeiod, LipsSourcePrice ));
        }
    }
#endregion

#region (EMA)Exponential Moving Average
	//---------------------------------------------------
    // Project: Exponential Moving Average
    // Type: Indicator
    // Author: PFSoft LLC
    // Company: PFSoft LLC /www.pfsoft.com/
    // Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
    // Created: Nov, 28,2006
    //---------------------------------------------------
    public class EMA : NETIndicator
    {
  
        public EMA()
            : base()
        {
        	ProjectName = "Exponential Moving Average";
        	Comments = "The weighted price calculation for the last N periods";
            SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

        [InputParameter("Period of Exponential Moving Average", 0)]
        public int MaPeriod = 2;


        [InputParameter("Sources prices for MA", 1, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrice = ptl.CLOSE; // Calculation will be performed on Close prices
        
        public override void Init()
        {
            platform.SetIndexDrawBegin(0, MaPeriod);
        }


        public override void OnQuote()
        {
			// Getting current price
		    double price = platform.GetPrice(platform.Symbol, platform.Period, 
		    	0, SourcePrice, platform.GetFieldType(platform.Symbol));
		    
		    // Checking, if current amount of bars
		    // more, than period of moving average. If it is
		    // then the calculation is possible
		    int count = platform.BarsCount(platform.Symbol, platform.Period);
		    if(count>MaPeriod)
		    {
		        // Calculation of a coefficient
		        double k = 2.0/(MaPeriod + 1);
	            // Getting previous EMA
	            double prevEMA = platform.GetValue(0, 1);
                platform.SetValue(0, 0, prevEMA + k*(price - prevEMA));
		    }
		    else
			    platform.SetValue(0, 0, price);
          }
    }
#endregion

#region (LWMA)Lienar Weighted Moving Average
    //---------------------------------------------------
	// Project: Lienar Weighted Moving Average
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class LWMA : NETIndicator
    {
  
        public LWMA()
            : base()
        {
        	ProjectName = "Lienar Weighted Moving Average";
        	Comments = "The linear average price for the last N periods";
            SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
			SeparateWindow = false;
        }

        [InputParameter("Period of Simple Moving Average", 0)]
        public int MaPeriod = 2;


        [InputParameter("Period of Lienar Weighted Moving Average", 1, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrice = ptl.CLOSE; // Calculation will be performed on Close prices

        public override void OnQuote()
        {
           int count = platform.BarsCount(platform.Symbol, platform.Period);
           if(count>MaPeriod)
		   {
		       int i = 0;                               // Usual counter
		       double numerator = 0.0;                  // Numerator of the rate
		       double denominator = 0.0;                // Denominator of the rate
		       int period = MaPeriod;         			  // period counter
		       double k = 1.0/MaPeriod;            	  // coefficient
		       // Loop of calculation. The loop skips empty bars
		       while( (period>0) && (i<count) )
		       {
		           // Chiking, if the current bar is empty
		           if(!ptl.IsEmpty(i))
		           {
		               // Bar is not empty, adding it's price to the summa
		               numerator += period*ptl.GetPrice(SourcePrice, i);
		               denominator += period;
		               // increment of period counter
		               period--;
		           }
		           // going to the next bar
		           i++;
		       }
		       // Setting the current value of the indicator
		       platform.SetValue(0, 0, numerator/denominator);   
		   }
        }
    }
#endregion

#region (MMA)Modified Moving Average
    //---------------------------------------------------
	// Project: Modified Moving Average
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class MMA : NETIndicator
    {
  
        public MMA()
            : base()
        {
        	ProjectName = "Modified Moving Average";
        	Comments = "Moving Average comprises a sloping factor to help it overtake with the growing or declining value of the trading price of the currency";
            SetIndicatorLine("line1", Color.Lime, 4, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

        [InputParameter("Period of Simple Moving Average", 0)]
        public int MaPeriod = 2;


        [InputParameter("Sources prices for MA", 1, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrice = ptl.CLOSE; // Calculation will be performed on Close prices

        public override void OnQuote()
        {
        	int count = platform.BarsCount(platform.Symbol, platform.Period);
          	if(count>MaPeriod)
		    {
		        int i = 0;                               // Usual counter
		        double mma = ptl.GetPrice(SourcePrice); // Current price
		        int period = 0;                          // period counter
		        double k = 1.0/MaPeriod;              // coefficient
		        // Loop of calculation. The loop skips empty bars
		        while( (period<MaPeriod) && (i<count) && (mma>0.0) )
		        {
		            // Chiking, if the current bar is empty
		            if(!ptl.IsEmpty(i))
		            {
		                // Bar is not empty, adding it's price to the summa
		                double price = ptl.GetPrice(SourcePrice, i);
		                mma = price*k + mma*(1.0 - k);
		                // increment of period counter
		                period++;
		            }
		            // going to the next bar
		            i++;
		        }
		        // Setting the current value of the indicator
		        platform.SetValue(0, 0, mma);   
		    }
        }
    }
#endregion

#region (QSTICK)QStick
    //---------------------------------------------------
	// Project: QStick
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class QSTICK : NETIndicator
    {
  
        public QSTICK()
            : base()
        {
        	ProjectName = "QStick";
        	Comments = "Moving average that shows the difference between the prices at which an issue opens and closes";
            SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            SeparateWindow = true;
        }

        [InputParameter("Type of Moving Average", 0, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MAType = "SMA"; 

		[InputParameter("Period", 1)]
        public int MAPeriod = 20;

        public override void OnQuote()
        {
            int count = platform.BarsCount(platform.Symbol, platform.Period);
            if(count>MAPeriod)
		    {
		        ptl.Array[0] = ptl.Close - ptl.Open;
		        platform.SetValue(0, 0, GetMA(count, 0));
		    }
        }
        public double GetSMA(int count, int arrayNumber)
		{
		    int i = 0;          // Usual counter
		    double summa = 0.0; // Sum of prices
		    // Loop of calculation. The loop skips empty bars
		    while( (i<MAPeriod) && (i<count) )
		    {
		        summa += ptl.Array[i];
		        i += 1;
		    }
		    // Returning current value of the SMA
		    return summa/MAPeriod;
		}
		
		public double GetEMA(int count, int arrayNumber)
		{
		        // Calculation of a coefficient
		        double k = 2.0/(MAPeriod + 1);
		        // Getting current price
		        double value1 = platform.Array[arrayNumber, 1];
		        // returning value
		        return value1 + k*(ptl.Array[arrayNumber] - value1);
		}
		
		public double GetMMA(int count, int arrayNumber)
		{
		        int i = 0;                            // Usual counter
		        double mma = ptl.Array[arrayNumber]; // Current price
		        double k = 1.0/MAPeriod;           // coefficient
		        // Loop of calculation. The loop skips empty bars
		        while( (i<MAPeriod) && (i<count) )
		        {
		            // Bar is not empty, adding it's price to the summa
		            double price = platform.Array[arrayNumber, i];
		            mma = price*k + mma*(1.0 - k);
		            // going to the next bar
		            i++;
		        }
		        // Returning of mma
		        return mma;
		}
		
		public double GetLWMA(int count, int arrayNumber)
		{
		        int i = 0;                               // Usual counter
		        double numerator = 0.0;                  // Numerator of the rate
		        double denominator = 0.0;                // Denominator of the rate
		        double k = 1.0/MAPeriod;              // coefficient
		        int  period = MAPeriod;
		        // Loop of calculation. The loop skips empty bars
		        while( (i<MAPeriod) && (i<count) )
		        {
		            numerator += period*platform.Array[arrayNumber, i];
		            denominator += period;
		            period--;
		            i++;
		        };
		        // returning current value
		        if(denominator>0.0)
		            return numerator/denominator;
		        else
		            return 0.0;    
		}
		
		public double GetMA(int count, int arrayNumber)
		{	
			double result = 0.0;
		    switch(MAType)
		    {
		        case "SMA":
		            result = GetSMA(count, arrayNumber);
		            break;
		        case "EMA":
		            result = GetEMA(count, arrayNumber);
		            break;
		        case "LWMA":
		            result = GetLWMA(count, arrayNumber);
		            break;
		        case "MMA":
		            result = GetMMA(count, arrayNumber);    
		            break;
		    }
		    return result;
		}
	}
#endregion

#region (REGRESSION)Regression Line
   	//---------------------------------------------------
	// Project: LRI
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class REGRESSION : NETIndicator
    {
  
        public REGRESSION()
            : base()
        {
        	ProjectName = "Regression Line";
        	Comments = "Is the linear regression line used to measure trends";
            SetIndicatorLine("line1", Color.Crimson, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

        [InputParameter("Period of Linear Regression", 0)]
        public int LRIPeriod = 20;


        [InputParameter("Sources prices for MA", 1, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrice = ptl.CLOSE;

        public override void OnQuote()
        {
            int count = platform.BarsCount(platform.Symbol, platform.Period);
            if(count < LRIPeriod)
            	return;

			// Calculation of summa            
           	double sumX = 0.0;     // summa of periods
		    double sumY = 0.0;    // summa of prices
		    double sumXY = 0.0;  // summa of period*price  
		    double sumXX = 0.0;   // summa of sqr(price)
		    for (int i=0; i<LRIPeriod; i++)
		    {
		        double price = ptl.GetPrice(SourcePrice, i);
		        
		        sumX += i;
		        sumY += price;
		        sumXY += i*price;
		        sumXX += i*i;
		    }
		    
		    // Calculation of coefficients
		    double a = (sumX * sumY - LRIPeriod * sumXY) / (sumX * sumX - LRIPeriod * sumXX);
		    double b = (sumY - a * sumX) / LRIPeriod;

		    // Setting of current value
		    platform.SetValue(0, 0, b + a * LRIPeriod);
        }
    }
#endregion

#region (SMA)Simple Moving Average
    //---------------------------------------------------
    // Project: Simple Moving Average
    // Type: Indicator
    // Author: PFSoft LLC
    // Company: PFSoft LLC /www.pfsoft.com/
    // Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
    // Created: Nov, 28,2006
    //---------------------------------------------------
    public class SMA : NETIndicator
    {
  
        public SMA()
            : base()
        {
        	ProjectName = "Simple Moving Average";
        	Comments = "Average price for the last N periods";
            SetIndicatorLine("line1", Color.Red, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

        [InputParameter("Period of Simple Moving Average", 0)]
        public int MaPeriod = 1;


        [InputParameter("Sources prices for MA", 1, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrice = ptl.CLOSE; // Calculation will be performed on Close prices


        /// <summary>
        /// Entry point. This function is called when new quote comes
        /// </summary>
        public override void OnQuote()
        {
            int count; // Current amount of bars on the history
            //count = ptl.Count; // Getting amount of bars on the history
            count = platform.BarsCount(platform.Symbol, platform.Period);
            // Checking, if current amount of bars 
            // more, than period of moving average. If it is
            // then the calculation is possible
            if (count > MaPeriod)
            {
                double summa = 0.0; // Sum of prices
                int period = 0;     // period counter
                // Loop of calculation
                while (period < MaPeriod)
                {
                    // Adding bar's price to the summa
                    //summa += ptl.GetPrice(SourcePrice, period);
                    summa += platform.GetPrice(platform.Symbol, platform.Period, period, SourcePrice, platform.GetFieldType(platform.Symbol));
                        //ptl.GetPrice(SourcePrice, period);
                    // increment of period counter
                    period++;
                }
                // Setting the current value of the indicator
                //ptl.SetValue(0, summa / MaPeriod);
                platform.SetValue(0, 0, summa / MaPeriod);       
              }
        }
    }
#endregion

#region (SMMA)Smoothed Moving Average	
	//---------------------------------------------------
	// Project: SMMA
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class SMMA : NETIndicator
    {
  
        public SMMA()
            : base()
        {
        	ProjectName = "Smoothed Moving Average";
        	Comments = "Smoothed Moving Average";
            SetIndicatorLine("line1", Color.Red, 1, LineStyle.SimpleChart);
            SeparateWindow = false;
        }

        [InputParameter("Period of Smoothed Moving Average", 0)]
        public int MaPeriod = 2;


        [InputParameter("Sources prices for MA", 1, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW,
             "Typical", ptl.TYPICAL,
             "Medium", ptl.MEDIUM,
             "Weighted", ptl.WEIGHTED}
        )]
        public int SourcePrice = ptl.CLOSE;

        public override void OnQuote()
        {
            int count = platform.BarsCount(platform.Symbol, platform.Period);
		    if(count>=MaPeriod)
		    {
		        int i = 0;          // Usual counter
		        double summa = 0.0; // Sum of prices
		        int period = 0;     // period counter
		        // Loop of calculation. The loop skips empty bars
		        while( (period<MaPeriod) && (i<count) )
		        {
		            // Chiking, if the current bar is empty
		            if(!ptl.IsEmpty(i))
		            {
		                // Bar is not empty, adding it's price to the summa
		                summa += ptl.GetPrice(SourcePrice, i);
		                // increment of period counter
		                period++;
		            };
		            // going to the next bar
		            i++;
		        }
		        double prevMa = GetPrevSMMA(count);
		        if((count>MaPeriod) && (prevMa>0.0))
		        {
		            // Setting the current value of the indicator
		            platform.SetValue(0, 0,(summa - GetPrevSMMA(count) + ptl.GetPrice(SourcePrice))/MaPeriod);   
		        }
		        else
		        {
		            // Setting the current value of the indicator
		            platform.SetValue(0, 0, summa/MaPeriod);   
		        }
		    }
        }
        public double GetPrevSMMA(int count)
		{
		    int i = MaPeriod; 
		    if(i<count)
		    {
		        // Getting value of SMMA
		        double value = platform.GetValue(0, i);
		        // Returning valuem is it is not zero
		        if(value>0.0)
		            return value;
		        // Skipping zeros, while there's data in history
		        while(i<count)
		        {
		            value = platform.GetValue(0, i);
		            // Skipping zeros
		            if(value>0.0)
		                return value;
		            // Going to the previuos bar
		            i++;
		        }
		    }
		    // Here we are on the first element
		    return 0.0;
		}
    }
#endregion
    
    //---------------mql4---------------//

#region (KAMA)Kaufman Adaptive Moving Average    
    [FullRefresh]
    [KillExceptions]
	public class KAMA : NETIndicator
    {
  
        public KAMA()
            : base()
        {
        	ProjectName = "Kaufman Adaptive Moving Average";
        	Comments = "Is an exponential style average with a smoothing that varies according to recent data";
            SetIndicatorLine("line1", Color.Gray, 1, LineStyle.SimpleChart);
			SetIndicatorLine("line2", Color.Blue, 1, LineStyle.SimpleChart);
			SetIndicatorLine("line3", Color.Red, 1, LineStyle.SimpleChart);
            SeparateWindow = false;      
        }

        [InputParameter("periodAMA", 0)]
        public int periodAMA=10;
        
        [InputParameter("nfast", 1, 1)]
        public double nfast=2.0;
        
        [InputParameter("nslow", 2, 1)]
        public double nslow=30.0;
        
        [InputParameter("G", 3, 1)]
        public double G=2.0;
        
        [InputParameter("dK", 4, 1)]
        public double dK=2.0;

        [InputParameter("PriceType", 5, new object[] {
             "Close", mql4.PRICE_CLOSE,
             "Open", mql4.PRICE_OPEN,
             "High", mql4.PRICE_HIGH,
             "Low", mql4.PRICE_LOW,
             "Typical", mql4.PRICE_TYPICAL,
             "Medium", mql4.PRICE_MEDIAN,
             "Weighted", mql4.PRICE_WEIGHTED}
        )]
        public int PriceType=0;
        
        [InputParameter("AMA_Trend_Type", 6)]
        public int AMA_Trend_Type=1;
        
        public IArray AMAbuffer;
		public IArray upAMA;
		public IArray downAMA;
		public IArray AbsBuffer;
		
		public IArray AMA2Buffer;
		public IArray SumAMABuffer;
		public IArray StdAMA;
		
		public double slowSC = 0.0,fastSC = 0.0,dFS = 0.0;
		
		public double Price(int shift)
		{
			//----
			double res = 0;
			//----
			switch (PriceType)
			  {
				  case mql4.PRICE_OPEN: res=mql4.Open[shift]; break;
				  case mql4.PRICE_HIGH: res=mql4.High[shift]; break;
				  case mql4.PRICE_LOW: res=mql4.Low[shift]; break;
				  case mql4.PRICE_MEDIAN: res=(mql4.High[shift]+mql4.Low[shift])/2.0; break;
				  case mql4.PRICE_TYPICAL: res=(mql4.High[shift]+mql4.Low[shift]+mql4.Close[shift])/3.0; break;
				  case mql4.PRICE_WEIGHTED: res=(mql4.High[shift]+mql4.Low[shift]+2*mql4.Close[shift])/4.0; break;
				  default: res=mql4.Close[shift];break;
			  }
			return(res);
		}
		
		public override void Init()
		{ 
			mql4.IndicatorBuffers(7);
			mql4.SetIndexStyle(0,mql4.DRAW_LINE);
			platform.SetIndexBuffer(0,ref AMAbuffer);
			mql4.SetIndexStyle(1,mql4.DRAW_ARROW,0,2);
			mql4.SetIndexArrow(1,159);
			platform.SetIndexBuffer(1,ref upAMA);
			platform.SetIndexEmptyValue(1,0.0);
			mql4.SetIndexStyle(2,mql4.DRAW_ARROW,0,2);
			mql4.SetIndexArrow(2,159);
			platform.SetIndexBuffer(2,ref downAMA);
			platform.SetIndexEmptyValue(2,0.0);
			
			platform.SetIndexBuffer(3,ref AbsBuffer);
			platform.SetIndexBuffer(4,ref AMA2Buffer);
			platform.SetIndexBuffer(5,ref SumAMABuffer);
			platform.SetIndexBuffer(6,ref StdAMA);
			
			slowSC=(2.0 /(nslow+1));
			fastSC=(2.0 /(nfast+1));
			dFS=fastSC-slowSC;
					 
		}
        
        public override void OnQuote()
        {
        	int counted_bars=platform.IndicatorCounted();
			//----
		    int i = 0,limit = 0,limit2 = 0;
			double Noise = 0.0,ER = 0.0,SSC = 0.0;
			double SredneeAMA = 0.0,SumKvadratAMA = 0.0;
			double val1 = 0.0,val2 = 0.0;
			double dipersion = 0.0;
			if(counted_bars>0) 
			   {
			      limit=mql4.Bars-counted_bars;
			      limit2=limit;
			   }
			   if (counted_bars==0)
			   {
			      mql4.ArrayInitialize(ref AMAbuffer,0);
			      mql4.ArrayInitialize(ref upAMA,0);
			      mql4.ArrayInitialize(ref downAMA,0);
			      mql4.ArrayInitialize(ref AbsBuffer,0);
			      mql4.ArrayInitialize(ref AMA2Buffer,0);
			      mql4.ArrayInitialize(ref SumAMABuffer,0);
			      mql4.ArrayInitialize(ref StdAMA,0);
			      
			      limit=mql4.Bars-1;
			      limit2=mql4.Bars-periodAMA-1;
			   }
			   limit--;
			   limit2--;
			    for (i=limit;i>=0;i--)
			      {
			      AbsBuffer[i]=mql4.MathAbs(Price(i)-Price(i+1));
			      }   
			    for (i=limit2;i>=0;i--)
			      {
			      Noise=mql4.iMAOnArray(ref AbsBuffer,0,periodAMA,0,mql4.MODE_SMA,i)*periodAMA;
			      if (Noise!=0) ER=mql4.MathAbs(Price(i)-Price(i+periodAMA))/Noise; else ER=0;
			      SSC=system.MathPow(ER*dFS+slowSC,G);
			      AMAbuffer[i]=Price(i)*SSC+(double)AMAbuffer[i+1]*(1-SSC);
			      AMA2Buffer[i]=(double)AMAbuffer[i]*(double)AMAbuffer[i]+(double)AMA2Buffer[i+1];
			      SumAMABuffer[i]=(double)SumAMABuffer[i+1]+(double)AMAbuffer[i];
			      }   
			   for (i=limit2;i>=0;i--)
			      {
			      val1=0;
			      val2=0;
			      SredneeAMA=((double)SumAMABuffer[i]-(double)SumAMABuffer[i+periodAMA])/periodAMA;
			      SumKvadratAMA=(double)AMA2Buffer[i]-(double)AMA2Buffer[i+periodAMA];
			      dipersion=SumKvadratAMA/periodAMA-SredneeAMA*SredneeAMA;
			      if (dipersion<0)
			         {
			         StdAMA[i]=0;
			         }
			      else StdAMA[i]=mql4.MathSqrt(dipersion);
			
			      if (AMA_Trend_Type!=0)
			         {
			         if (mql4.MathAbs((double)AMAbuffer[i]-(double)AMAbuffer[i+1])>dK*mql4.Point)
			            {
			            if ((double)AMAbuffer[i]-(double)AMAbuffer[i+1]>0) val1=(double)AMAbuffer[i];
			            else val2=(double)AMAbuffer[i];
			            } 
			         }
			      else
			         {
			         if (mql4.MathAbs((double)AMAbuffer[i]-(double)AMAbuffer[i+1])>dK*(double)StdAMA[i])
			            {
			            if ((double)AMAbuffer[i]-(double)AMAbuffer[i+1]>0) val1=(double)AMAbuffer[i];
			            else val2=(double)AMAbuffer[i];
			            } 
			         }         
			      upAMA[i]=val1;
			      downAMA[i]=val2;
			      }
        }
    }
#endregion
    
#region (PPMA)Pivot Point Moving Average
    [FullRefresh]
    [KillExceptions]	
  	public class PPMA : NETIndicator
    {
  
        public PPMA()
            : base()
        {
        	ProjectName = "Pivot Point Moving Average";
        	Comments = "Uses the pivot point calculation as the input a simple moving average";
			SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            SetIndicatorLine("line2", Color.Yellow, 1, LineStyle.SimpleChart);
            SeparateWindow = false;      
        }
       
        public IArray pivot1; 
		public IArray curAvg;
				
		public override void Init()
		{
			platform.SetIndexBuffer(0, ref pivot1);
        	platform.SetIndexBuffer(1, ref curAvg);
		}
        
        public override void OnQuote()
        {
        	int counted = platform.IndicatorCounted();
         
         if(counted < 0) return;
         
         if (counted > 0) counted --;
         
         int limit = mql4.Bars - counted; 
         //int x = 6;
         //int y = x / 2;
         //Print("y = ", y);
  
         
         for (int i = 0; i < limit; i++)
         {            
              double h1 = mql4.High[i];
              double h2 = mql4.High[i+2];
              double h3 = mql4.High[i+3];
              double h4 = mql4.High[i+4];
              double h5 = mql4.High[i+5];
             
        
              double l1 = mql4.Low[i];
              double l2 = mql4.Low[i+2];
              double l3 = mql4.Low[i+3];
              double l4 = mql4.Low[i+4];
              double l5 = mql4.Low[i+5];
             
        
              double c1 = mql4.Close[i];
              double c2 = mql4.Close[i+2];
              double c3 = mql4.Close[i+3];
              double c4 = mql4.Close[i+4];
              double c5 = mql4.Close[i+5];
              

              double piv1 = h1 + l1 + c1;
              piv1 = piv1 / 3.0000;

              pivot1[i] = mql4.NormalizeDouble(piv1, 4);
              
              double pivot2 = h2 + l2 + c2;
              pivot2 = pivot2 / 3.0000;
              double pivot3 = h3 + l3 + c3;
              pivot3 = pivot3 / 3.0000;
              double pivot4 = h4 + l4 + c4;
              pivot4 = pivot4 / 3.0000;
              double pivot5 = h5 + l5 + c5;
              pivot5 = pivot5 / 3.0000;
              
              double tempAvg;
              
              tempAvg = piv1 + pivot2 + pivot3 + pivot4 + pivot5;
              tempAvg = tempAvg / 5.0000;
                   
              curAvg[i] = mql4.NormalizeDouble(tempAvg, 4);
          }
            
        }
    }
#endregion

#region (VWPA)Volume Weighted Average Price    
    [FullRefresh]
    [KillExceptions]	
  	public class VWPA : NETIndicator
    {
  
        public VWPA()
            : base()
        {
        	ProjectName = "Volume Weighted Average Price";
        	Comments = "Weighted Moving Average where Volume is used as weights";
            SetIndicatorLine("line1", Color.Indigo, 3, LineStyle.SimpleChart);
            SeparateWindow = false;      
        }

        [InputParameter("n", 0)]
        public int n=1;
        [InputParameter("shift", 1)]
        public int shift=0;
        
        public IArray ExtMapBuffer1; 
				
		public override void Init()
		{ 
			platform.SetIndexBuffer(0, ref ExtMapBuffer1);
			mql4.SetIndexShift(0,shift);
		}
        
        public override void OnQuote()
        {
           int counted_bars = platform.IndicatorCounted();
			//----
		   int i = 0,bar = 0;
		   bar = mql4.Bars-counted_bars;
		   
		   for (i=0;i<=bar;i++){
		      double sum1 = 0.0, sum2 = 0.0;
		      int ntmp;
		      for (ntmp=0;ntmp<=n;ntmp++){
		         sum1=sum1+mql4.Close[i+ntmp]*mql4.Volume[i+ntmp];
		         sum2=sum2+mql4.Volume[i+ntmp];
		      }
		      
		       ExtMapBuffer1[i]=sum1/sum2;
		            
		        }
		  }
    }
#endregion
    
}