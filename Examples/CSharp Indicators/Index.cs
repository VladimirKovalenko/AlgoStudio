using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using PTLRuntime.NETScript;
using System.Drawing;

namespace ind
{

#region (ADX)Average Directional Index
    //---------------------------------------------------
	// Project: ADX
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class ADX : NETIndicator
    {
  
        public ADX()
            : base()
        {
        	ProjectName = "Average Directional Index";
        	Comments = "Determines the strength of a prevailing trend";
            SetIndicatorLine("adx", Color.Green, 1, LineStyle.SimpleChart);
            SetIndicatorLine("plusDI", Color.Blue, 1, LineStyle.SimpleChart);
            SetIndicatorLine("minusDI", Color.Red, 1, LineStyle.SimpleChart);
            SeparateWindow = true;
        }
        
        [InputParameter("Type of Moving Average", 0, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MAType = "SMA"; 

		[InputParameter("Period of Moving Average", 1, 1, 9999)]
        public int MAPeriod = 13;
        
        public const int ARRAY_PDM = 0;
		public const int ARRAY_MDM = 1;
		public const int ARRAY_TR = 2;
		public const int ARRAY_DX = 3;
       
        public override void OnQuote()
        {
             int count = platform.BarsCount(platform.Symbol, platform.Period);
	        if (count<2)
	          return;
	        // Calculation of true range and average true range
	        ptl.Array[ARRAY_TR] = ptl.TrueRange;
	        double smoothedTR = GetMA(count, ARRAY_TR);
	        // Calculation of directional movement (DMs)
	        double plusDM = ptl.High - ptl.High[1];
	        if(plusDM<0.0)
	            plusDM = 0.0;
	        double minusDM = ptl.Low[1] - ptl.Low;
	        if(minusDM<0.0)
	            minusDM = 0.0;
	        if(plusDM>minusDM)
	            minusDM = 0.0;
	        else
	            plusDM = 0.0;
	        ptl.Array[ARRAY_PDM] = plusDM;
	        ptl.Array[ARRAY_MDM] = minusDM;
	    
	        // Calculation of directional indices (DIs)
	        double plusDI;
	        double minusDI;
	        if(smoothedTR>0.0)
	        {
	            plusDI = 100.0*(GetMA(count, ARRAY_PDM)/smoothedTR);
	            minusDI = 100.0*(GetMA(count, ARRAY_MDM)/smoothedTR);
	        }
	        else
	        {
	            plusDI = 0.0;
	            minusDI = 0.0;
	        };
	        // Calculation of DX (ADX)
	        ptl.Array[ARRAY_DX] = (ptl.MathAbs(plusDI - minusDI)/(plusDI + minusDI))*100.0;
	        double adx = GetMA(count, ARRAY_DX);
	        // Setting values
	        platform.SetValue(0, 0, adx);
	        platform.SetValue(1, 0, plusDI);
	        platform.SetValue(2, 0, minusDI);
        }
        public double GetSMA(int count, int arrayNumber)
		{
		    int i = 0;          // Usual counter
		    double summa = 0.0; // Sum of prices
		    // Loop of calculation. The loop skips empty bars
		    while( (i<MAPeriod) && (i<count) )
		    {
		        summa += platform.Array[arrayNumber, i];
		        i++;
		    }
		    // Returning current value of the SMA
		    return summa/MAPeriod;
		}
		
		public double GetEMA(int count, int arrayNumber)
		{
			// Calculation of a coefficient
			double k = 2.0/(MAPeriod + 1);
	        
		    double summa = ptl.Array[arrayNumber]; // Sum of prices
            for (int i = 1; i < MAPeriod; i++)
            {
               	double price = platform.Array[arrayNumber, i];
             	summa += k * (price - summa);
			}
		    return summa;
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
		        int period = MAPeriod;
		        // Loop of calculation. The loop skips empty bars
		        while( (i<MAPeriod) && (i<count) )
		        {
		            numerator += period*platform.Array[arrayNumber, i];
		            denominator += period;
		            period--;
		            i++;
		        }
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

#region (ATR)Average True Range
	//---------------------------------------------------
	// Project: AveTrueRange
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class ATR : NETIndicator
    {
  
        public ATR()
            : base()
        {
        	ProjectName = "Average True Range";
        	Comments = "Measures market volatility";
            SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            SeparateWindow = true;
        }

        [InputParameter("Period of Moving Average", 0, 1, 9999)]
        public int MAPeriod = 13;
       
       [InputParameter("Type of Moving Average", 1, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MAType = "SMA"; 
      
        public override void OnQuote()
        {
           int count; count = platform.BarsCount(platform.Symbol, platform.Period);

		    if(count>MAPeriod)
		    {
		        switch(MAType)
		        {
		            case "SMA":
		                platform.SetValue(0, 0, GetSMA(count));
		                break;
		                
		            case "EMA":
		                platform.SetValue(0, 0, GetEMA(count));
		                break;
		                
		            case "MMA":
		                platform.SetValue(0, 0, GetMMA(count));
		                break;
		                
		            case "LWMA":
		                platform.SetValue(0, 0, GetLWMA(count));
		                break;    
		       }
		    }
        }
        public double GetSMA(int count)
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
		        };
		        // going to the next bar
		        i++;
		    }
		    // Returning current value of the SMA
		    return summa/MAPeriod;
		}
		
		public double GetEMA(int count)
		{
			// Calculation of a coefficient
			double k = 2.0/(MAPeriod + 1);
	        
		    double summa = ptl.TrueRange; // Sum of prices
            for (int i = 1; i < MAPeriod; i++)
             	summa += k * (ptl.TrueRange[i] - summa);

	        // Returning value
	        return summa;
		}
		
		public double GetMMA(int count)
		{
	        int i = 0;                               // Usual counter
	        double mma; mma = ptl.TrueRange; // Current price
	        int period = 0;                          // period counter
	        double k = 1.0/MAPeriod;              // coefficient
	        // Loop of calculation. The loop skips empty bars
	        while( (period<MAPeriod) && (i<count) && (mma>0.0) )
	        {
	            // Chiking, if the current bar is empty
	            if(!ptl.IsEmpty(i))
	            {
	                // Bar is not empty, adding it's price to the summa
	                double price; price = ptl.TrueRange[i];
	                mma = price*k + mma*(1.0 - k);
	                // increment of period counter
	                period++;
	            }
	            // going to the next bar
	            i++;
	        }
	        // Returning of mma
	        return mma;
		}
		
		public double GetLWMA(int count)
		{
		        int i = 0;                               // Usual counter
		        double numerator = 0.0;                  // Numerator of the rate
		        double denominator = 0.0;                // Denominator of the rate
		        int period = MAPeriod;          		 // period counter
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
		                period--;
		            };
		            // going to the next bar
		            i++;
		        };
		        // returning current value
		        if(denominator>0.0)
		            return numerator/denominator;
		        else
		            return 0.0;    
		}
    }
#endregion

#region (CCI)Commodity Channel Index
    //---------------------------------------------------
    // Project: Commodity Channel Index
    // Type: Indicator
    // Author: PFSoft LLC
    // Company: PFSoft LLC /www.pfsoft.com/
    // Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
    // Created: Nov, 28,2006
    //---------------------------------------------------
    public class CCI : NETIndicator
    {
  
        public CCI()
            : base()
        {
        	ProjectName = "Commodity Channel Index";
        	Comments = "Measures the position of price in relation to its moving average";
            SetIndicatorLine("line1", Color.Red, 1, LineStyle.SimpleChart);
            SeparateWindow = true;
        }

        [InputParameter("Type of Moving Average", 0, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MAType = "SMA"; 

		[InputParameter("Period of Moving Average", 1, 1, 9999)]
        public int MaPeriod = 14;
           
        public override void OnQuote()
        {
            int count = platform.BarsCount(platform.Symbol, platform.Period);
		    if(count>MaPeriod)
		    {
		        double ma = platform.iCustom(MAType, platform.Symbol, platform.Period, 0, 0, MaPeriod, ptl.TYPICAL);
		        double d = 0;
		        for (int i=0; i<MaPeriod && i<count; i++)
	                d += ptl.MathAbs(ptl.Typical[i] - ma);

		        d = 0.015*(d/MaPeriod);
		        if(d>0.0)
		        {
		            // Setting the value
		            platform.SetValue(0, 0, (ptl.Typical - ma)/d);
		        }
		    }
        }
    }
#endregion

#region (DMI)Directional Movement Index
    //---------------------------------------------------
	// Project: DMI
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class DMI : NETIndicator
    {
  
        public DMI()
            : base()
        {
         	ProjectName = "Directional Movement Index";
         	Comments = "Identifies whether there is a definable trend in the market";
            SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            SetIndicatorLine("line2", Color.Red, 1, LineStyle.SimpleChart);
            SeparateWindow = true;
        }

        [InputParameter("Type of Moving Average", 0, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MAType = "SMA"; 

		[InputParameter("Period of Moving Average", 1, 1, 9999)]
        public int MAPeriod = 13;
        
        public  int ARRAY_PDM = 0;
		public  int ARRAY_MDM = 1;
		public  int ARRAY_TR = 2;
      
        public override void OnQuote()
        {
          	int count = platform.BarsCount(platform.Symbol, platform.Period);
	        if (count<2)
	          return;
	        // Calculation of true range and average true range
	        ptl.Array[ARRAY_TR] = ptl.TrueRange;
	        double smoothedTR = GetMA(count, ARRAY_TR);
	        // Calculation of directional movement (DMs)
	        double plusDM = ptl.High - ptl.High[1];
	        if(plusDM<0.0)
	            plusDM = 0.0;
	        double minusDM = ptl.Low[1] - ptl.Low;
	        if(minusDM<0.0)
	            minusDM = 0.0;
	        if(plusDM>minusDM)
	            minusDM = 0.0;
	        else
	            plusDM = 0.0;
	        ptl.Array[ARRAY_PDM] = plusDM;
	        ptl.Array[ARRAY_MDM] = minusDM;
	    
	        // Calculation of directional indices (DIs)
	        double plusDI;
	        double minusDI;
	        if(smoothedTR>0.0)
	        {
	            plusDI = 100.0*(GetMA(count, ARRAY_PDM)/smoothedTR);
	            minusDI = 100.0*(GetMA(count, ARRAY_MDM)/smoothedTR);
	        }
	        else
	        {
	            plusDI = 0.0;
	            minusDI = 0.0;
	        };
	        platform.SetValue(0, 0, plusDI);
	        platform.SetValue(1, 0, minusDI);
        }
         public double GetSMA(int count, int arrayNumber)
		{
		    int i = 0;          // Usual counter
		    double summa = 0.0; // Sum of prices
		    // Loop of calculation. The loop skips empty bars
		    while( (i<MAPeriod) && (i<count) )
		    {
		        summa += platform.Array[arrayNumber, i];
		        i++;
		    }
		    // Returning current value of the SMA
		    return summa/MAPeriod;
		}
		
		public double GetEMA(int count, int arrayNumber)
		{
			// Calculation of a coefficient
			double k = 2.0/(MAPeriod + 1);
	        
		    double summa = ptl.Array[arrayNumber]; // Sum of prices
            for (int i = 1; i < MAPeriod; i++)
            {
               	double price = platform.Array[arrayNumber, i];
             	summa += k * (price - summa);
			}
		    return summa;
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
		        int period = MAPeriod;
		        // Loop of calculation. The loop skips empty bars
		        while( (i<MAPeriod) && (i<count) )
		        {
		            numerator += period*platform.Array[arrayNumber, i];
		            denominator += period;
		            period--;
		            i++;
		        }
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

#region (PVI)Positive Volume Index
	//---------------------------------------------------
    // Project: PVI
    // Type: Indicator
    // Author: PFSoft LLC
    // Company: PFSoft LLC /www.pfsoft.com/
    // Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
    // Created: Nov, 28,2006
    //---------------------------------------------------
    public class PVI : NETIndicator
    {
  
        public PVI()
            : base()
        {
        	ProjectName = "Positive Volume Index";
        	Comments = "Changes on the periods in which value of volume has increased in comparison with the previous period";
            SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            SeparateWindow = true;
        }

        [InputParameter("Sources prices for MA", 0, new object[] {
             "Close", ptl.CLOSE,
             "Open", ptl.OPEN ,
             "High", ptl.HIGH,
             "Low", ptl.LOW}
        )]
        public int SourcePrices = ptl.CLOSE;
		
		public int PVI_ = 0;

        public override void OnQuote()
        {
            if(platform.BarsCount(platform.Symbol, platform.Period)>1)
		    {
		        int volume = ptl.Volume;
		        int volume1 = ptl.Volume[1];
		        double prevPVI = platform.Array[PVI_, 1];
		        if(volume>volume1)
		        {
		            double price = ptl.GetPrice(SourcePrices);
		            double price1 = ptl.GetPrice(SourcePrices, 1);
		            double curPVI = prevPVI + (prevPVI*(price-price1)/price1);
		            ptl.Array[PVI_] = curPVI;
		            platform.SetValue(0, 0, curPVI);
		        }
		        else
		        {
		            ptl.Array[PVI_] = prevPVI;
		            platform.SetValue(0, 0, prevPVI);
		        };
		    }
		    else
		    {
		        ptl.Array[PVI_] = 1.0;
		    }
        }
    }
#endregion

#region (ROC)Rate of Change
	//---------------------------------------------------
	// Project: ROC
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: Nov, 28,2006
	//---------------------------------------------------
    public class ROC : NETIndicator
    {
  
        public ROC()
            : base()
        {
        	ProjectName = "Rate of Change";
        	Comments = "Shows the speed at which price is changing";
            SetIndicatorLine("line1", Color.Brown, 1, LineStyle.SimpleChart);
            SeparateWindow = true;
        }

        [InputParameter("Period of momentum:", 0)]
        public int MomPeriod = 20;

        public override void OnQuote()
        {           
            int count = platform.BarsCount(platform.Symbol, platform.Period);
            if(count>MomPeriod)
		    {
		        double price = ptl.Close;
		        double pricen = ptl.Close[MomPeriod];
		        platform.SetValue(0, 0, 100.0*((price-pricen)/pricen));
		    }
        }
    }
#endregion
	
#region (RSI)Relative Strength Index
    //---------------------------------------------------
    // Project: RSI
    // Type: Indicator
    // Author: PFSoft LLC
    // Company: PFSoft LLC /www.pfsoft.com/
    // Copyright: (C) PFSoft LLC Dnepropetrovsk. Ukraine
    // Created: Nov, 28,2006
    //---------------------------------------------------
    public class RSI : NETIndicator
    {

        public RSI()
            : base()
        {
            ProjectName = "Relative Strength Index";
            SetIndicatorLine("line1", Color.Green, 1, LineStyle.SimpleChart);
            SetIndicatorLine("line2", Color.SkyBlue, 1, LineStyle.SimpleChart);
            SetLevelLine("line3", 0, Color.Red, 1, LineStyle.SimpleChart);
            SetLevelLine("line4", 0, Color.Yellow, 1, LineStyle.SimpleChart);            
            SeparateWindow = true;
        }

        public const int RSI_METHOD_SIMPLE = 0;
        public const int RSI_METHOD_EXPON = 1;

        [InputParameter("RSI Period:", 0, 1, 100, 0, 1)]
        public int RSIPeriod = 20;

        [InputParameter("RSI Method:", 0, new object[] {
            "Simple", RSI_METHOD_SIMPLE,
			"Exponential", RSI_METHOD_EXPON}
        )]
        public int RSIMethod = RSI_METHOD_EXPON;

        [InputParameter("Up line level", 2, 0.0, 100.0, 0, 1)]
        public double UpLine = 80.0;
        [InputParameter("Bottom line level", 3, 0.0, 100.0, 0, 1)]
        public double BottomLine = 20.0;

        [InputParameter("Period of Moving Average", 4)]
        public int MAPeriod = 5;
        [InputParameter("Type of Moving Average", 5, new object[] {
            "Simple", "SMA",
            "Exponential", "EMA",
            "Modified", "MMA",
           	"Linear Weighted", "LWMA"}
        )]
        public string MaType = "SMA";

        public IArray U_Buf;      // buffer positive diffs
        public IArray D_Buf;	  // buffer negative diffs

        double pos, neg;
       


        public override void Init()
        {
            platform.SetIndexBuffer(5, ref U_Buf);
            platform.SetIndexBuffer(6, ref D_Buf);
            
            SetLevelLine("line3", UpLine);
            SetLevelLine("line4", BottomLine);
            
            platform.SetIndexDrawBegin(0, RSIPeriod);
            platform.SetIndexDrawBegin(1, RSIPeriod);
        }



        public override void OnQuote()
        {
            int count = platform.BarsCount(platform.Symbol, platform.Period);

            if (count < 2)
                return;

            double df = ptl.Close[0] - ptl.Close[1];
            pos = df > 0 ? df : 0;
            neg = df < 0 ? -df : 0;


            if (count <= RSIPeriod)
            {
                U_Buf[0] = ((double)U_Buf[1] * (count - 1) + pos) / count;
                D_Buf[0] = ((double)D_Buf[1] * (count - 1) + neg) / count;
                return;
            }

           
            switch (RSIMethod)
            {
                case RSI_METHOD_SIMPLE:
                    CalcSimple(count);
                    break;
                case RSI_METHOD_EXPON:
                    CalcExpon(count);
                    break;
            }


           
            platform.SetValue(1, 0, GetMA(count));
        }

        public double GetSMA(int count)
        {
            int i = 0;          // Usual counter
            double summa = 0.0; // Sum of prices
            // Loop of calculation. The loop skips empty bars
            while ((i < MAPeriod) && (i < count))
            {
                summa += platform.Array[0, i];
                i++;
            }
            // Returning current value of the SMA
            return summa / MAPeriod;
        }

        public double GetEMA(int count)
        {
			// Calculation of a coefficient
			double k = 2.0/(MAPeriod + 1);
	        
		    double summa = ptl.Array[0]; // Sum of prices
            for (int i = 1; i < MAPeriod; i++)
            {
               	double price = platform.Array[0, i];
             	summa += k * (price - summa);
			}
		    return summa;
        }

        public double GetMMA(int count)
        {
            int i = 0;                            // Usual counter
            double mma = ptl.Array[0]; // Current price
            double k = 1.0 / MAPeriod;           // coefficient
            // Loop of calculation. The loop skips empty bars
            while ((i < MAPeriod) && (i < count))
            {
                // Bar is not empty, adding it's price to the summa
                double price = platform.Array[0, i];
                mma = price * k + mma * (1.0 - k);
                // going to the next bar
                i++;
            }
            // Returning of mma
            return mma;
        }

        public double GetLWMA(int count)
        {
            int i = 0;                               // Usual counter
            double numerator = 0.0;                  // Numerator of the rate
            double denominator = 0.0;                // Denominator of the rate
            double k = 1.0 / MAPeriod;              // coefficient
            int period = MAPeriod;
            // Loop of calculation. The loop skips empty bars
            while ((i < MAPeriod) && (i < count))
            {
                numerator += period * platform.Array[0, i];
                denominator += period;
                period--;
                i++;
            }
            // returning current value
            if (denominator > 0.0)
                return numerator / denominator;
            else
                return 0.0;
        }

        public double GetMA(int count)
        {
            double result = 0.0;
            switch (MaType)
            {
                case "SMA":
                    result = GetSMA(count);
                    break;
                case "EMA":
                    result = GetEMA(count);
                    break;
                case "LWMA":
                    result = GetLWMA(count);
                    break;
                case "MMA":
                    result = GetMMA(count);
                    break;
            }
            return result;
        }


        public void CalcSimple(int count)
        {
           
            double prepos = 0, preneg = 0;
            if (count > RSIPeriod + 1)
            {
                double pre = ptl.Close[RSIPeriod] - ptl.Close[RSIPeriod + 1];
                if (pre >= 0)
                    prepos = pre;
                else
                    preneg = -pre;
            }


			double U, D;
            U_Buf[0] = U = (double)U_Buf[1] + (pos - prepos) / RSIPeriod;
            D_Buf[0] = D = (double)D_Buf[1] + (neg - preneg) / RSIPeriod;
            

            //double rsi = 100 * (1.0 - 1.0 / (1.0 + U_Buf[0] / D_Buf[0]));
            double rsi;
            if (U == 0 && D == 0)
                rsi = 50;
            else
                rsi = 100 * U / (U + D);

            ptl.Array[0] = rsi;
            platform.SetValue(0, 0, rsi);
        }



        public void CalcExpon(int count)
        {
           
            double rsi;
            double U, D;

            U_Buf[0] = U = ((double)U_Buf[1] * (RSIPeriod - 1) + pos) / RSIPeriod;
            D_Buf[0] = D = ((double)D_Buf[1] * (RSIPeriod - 1) + neg) / RSIPeriod;

            //rsi = 100 * (1.0 - 1.0 / (1.0 + U_Buf[0] / D_Buf[0]));

            if (U == 0 && D == 0)
                rsi = 50;
            else
                rsi = 100 * U / (U + D);

            ptl.Array[0] = rsi;
            platform.SetValue(0, 0, rsi);

        }
    }

#endregion

#region (SD)Standard Deviation
	//---------------------------------------------------
	// Project: StdDev
	// Language: ProTraderLanguage
	// Type: Indicator
	// Author: PFSoft LLC
	// Company: PFSoft LLC /www.pfsoft.com/
	// Copyright: (C) PFSoft LLC Dnepopetrovsk. Ukraine
	// Created: 04.12.2008
	//---------------------------------------------------
    public class SD : NETIndicator
    {
  
        public SD()
            : base()
        {
        	ProjectName = "Standard Deviation";
        	Comments = "Shows the difference of the volatility value from the average one";
            SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            SeparateWindow = true;
        }

		[InputParameter("Source price for Moving Average", 0, new object[] {
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
            "Simple", ptl.MODE_SMA,
            "Exponential", ptl.MODE_EMA,
            "Modified", ptl.MODE_SMMA,
            "Linear Weighted", ptl.MODE_LWMA}
        )]
        public int MAType = ptl.MODE_SMA; 

        [InputParameter("Period of indicator", 2)]
        public int MaPeriod = 20;

        
        public override void OnQuote()
        {
         	int count = platform.BarsCount(platform.Symbol, platform.Period);
			if (MaPeriod < count)
			{
				double dAmount = 0;
				double dMovingAverage = ptl.iMAEx(MaPeriod, MAType, 0, SourcePrice, 0);
				int j = 0;
				while (j < MaPeriod)
				{
					double dAPrice = ptl.GetPrice(SourcePrice, j);
					dAmount += ptl.MathSqr(dAPrice - dMovingAverage);
					j += 1;
				}
				platform.SetValue(0, 0, ptl.MathSqrt(dAmount/MaPeriod));
			}   
        }
    }
#endregion

	//---------------mql4---------------//
		
#region (ARSI)Adaptive Relative Strength Index	
	[FullRefresh]
    [KillExceptions]	
  	public class ARSI : NETIndicator
    {
  
        public ARSI()
            : base()
        {
        	ProjectName = "Adaptive Relative Strength Index";
        	Comments = "Is a more flexible variant of Relative Strength Index";
            SetIndicatorLine("line1", Color.DodgerBlue, 1, LineStyle.SimpleChart);
            SeparateWindow = true;      
        }

        [InputParameter("ARSIPeriod", 0)]
        public int ARSIPeriod = 14;
        
        public IArray ARSIbuf; 
		public IArray adrsiup;
		public IArray adrsidn;
		
		public override void Init()
		{ 
			string short_name = "ARSI (" + ARSIPeriod + ")";
					
			mql4.SetIndexStyle(0,mql4.DRAW_LINE); 
			platform.SetIndexBuffer(0,ref ARSIbuf);
					 
		}
        
        public override void OnQuote()
        {
        	int i, counted_bars = platform.IndicatorCounted(); 
			int limit = 0;
		
			if(mql4.Bars <= ARSIPeriod) 
				return ;
		
			if(counted_bars < 0)
			{
				return ;
			}
			
			if(counted_bars == 0)
			{
				limit = mql4.Bars;
			}
			if(counted_bars > 0)
			{
				limit = mql4.Bars - counted_bars;
			}
			
			double sc = 0;
			for(i = limit; i >= 0; i--)
			{
				sc = mql4.MathAbs(mql4.iRSI(mql4.NULL, 0, ARSIPeriod, mql4.PRICE_CLOSE, i)/100.0 - 0.5) * 2.0;
		
				if( mql4.Bars - i <= ARSIPeriod)
					ARSIbuf[i] = mql4.Close[i];
				else		
					ARSIbuf[i] =  Convert.ToDouble(ARSIbuf[i+1]) + sc * (mql4.Close[i] - Convert.ToDouble(ARSIbuf[i+1]));
			}
            
        }
    }
#endregion

#region (KRI)Kairi Relative Index
    [FullRefresh]
    [KillExceptions]	
  	public class KRI : NETIndicator
    {
  
        public KRI()
            : base()
        {
        	ProjectName = "Kairi Relative Index";
        	Comments = "Kairi Relative Index";
            SetIndicatorLine("line1", Color.Red, 1, LineStyle.SimpleChart);
            SeparateWindow = true;      
        }

        [InputParameter("KRIPeriod", 0)]
        public int KRIPeriod = 13;
        
        public IArray KRIBuffer; 
		
		
		public override void Init()
		{ 
			string short_name;
		   	platform.SetIndexBuffer(0, ref KRIBuffer);
		   	short_name = "KRI ("+KRIPeriod+")";
		   	platform.IndicatorShortName(short_name);
		   	mql4.SetIndexLabel(0, short_name);
		   	platform.SetIndexDrawBegin(0, KRIPeriod);
		}
        
        public override void OnQuote()
        {
        	int i = 0;
        	int counted_bars = platform.IndicatorCounted();
			//----
			if (mql4.Bars <= KRIPeriod) return;
			//---- initial zero
			if (counted_bars < 1)
			      for (i = 1; i <= KRIPeriod; i++) KRIBuffer[mql4.Bars-i] = 0.0;
			//----
			i = mql4.Bars-KRIPeriod-1;
		    if (counted_bars >= KRIPeriod) i = mql4.Bars-counted_bars-1;
		    while(i >= 0) {
		       double ma = mql4.iMA(mql4.NULL,0,KRIPeriod,0,mql4.MODE_SMA, mql4.PRICE_CLOSE,i);
		       KRIBuffer[i] = ((mql4.Close[i]-ma)/ma)*100;
		       i--;
  			   }            
        }
    }
#endregion

#region (SI)Swing Index
    [FullRefresh]
    [KillExceptions]	
  	public class SI : NETIndicator
    {
  
        public SI()
            : base()
        {
        	ProjectName = "Swing Index";
        	Comments = "Is used to confirm trend line breakouts on price charts";
            SetIndicatorLine("line1", Color.DarkBlue, 1, LineStyle.SimpleChart);
            SeparateWindow = true;      
        }

        [InputParameter("T", 0, 1)]
        public double T = 300.0;
        
        public IArray ExtMapBuffer1; 
		public IArray SIBuffer;
				
		public override void Init()
		{
			mql4.IndicatorBuffers(2);
		    platform.SetIndexBuffer(0, ref ExtMapBuffer1);
		    mql4.SetIndexLabel(0, "Swing Index");
		    platform.SetIndexBuffer(1, ref SIBuffer);
		}
        
        public override void OnQuote()
        {
        	int i = 0;
        	int counted_bars = platform.IndicatorCounted();
			int limit = 0;
		
			double R = 0, K = 0, TR = 0, ER = 0, SH = 0, Tpoints = 0;
			if(counted_bars == 0) 
			   limit = mql4.Bars - 1;
			if(counted_bars > 0) 
			   limit = mql4.Bars - counted_bars;
			Tpoints = T*mql4.MarketInfo(mql4.Symbol(), mql4.MODE_POINT);
			for(i = limit; i >= 0; i--)
			 {
			   TR = mql4.iATR(mql4.Symbol(), 0, 1, i);
			   if(mql4.Close[i+1] >= mql4.Low[i] && mql4.Close[i+1] <= mql4.High[i]) 
			       ER = 0; 
			   else 
			     {
			       if(mql4.Close[i+1] > mql4.High[i]) 
			           ER = mql4.MathAbs(mql4.High[i] - mql4.Close[i+1]);
			       if(mql4.Close[i+1] < mql4.Low[i]) 
			           ER = mql4.MathAbs(mql4.Low[i] - mql4.Close[i+1]);
			     }
			   K = mql4.MathMax(mql4.MathAbs(mql4.High[i] - mql4.Close[i+1]), mql4.MathAbs(mql4.Low[i] - mql4.Close[i+1]));
			   SH = mql4.MathAbs(mql4.Close[i+1] - mql4.Open[i+1]);
			   R = TR - 0.5*ER + 0.25*SH;
			   if(R == 0) 
			       SIBuffer[i] = 0; 
			   else 
			       SIBuffer[i] = 50*(mql4.Close[i] - mql4.Close[i+1] + 0.5*(mql4.Close[i] - mql4.Open[i]) + 
			                     0.25*(mql4.Close[i+1] - mql4.Open[i+1]))*(K / Tpoints) / R;
			   ExtMapBuffer1[i] = (double)ExtMapBuffer1[i+1] + (double)SIBuffer[i];
            }
        }
    }
#endregion
    
#region (TSI)True Strength Index
    [FullRefresh]
    [KillExceptions]	
  	public class TSI : NETIndicator
    {
  
        public TSI()
            : base()
        {
        	ProjectName = "True Strength Index";
        	Comments = "Is a variation of the Relative Strength Indicator which uses a " +
        	"doubly-smoothed exponential moving average of price momentum to eliminate choppy price changes and spot trend changes";
            SetIndicatorLine("line1", Color.Yellow, 1, LineStyle.SimpleChart);
            SeparateWindow = true;      
        }

        [InputParameter("First_R", 0)]
        public int First_R = 5;
        [InputParameter("Second_S", 1)]
        public int Second_S = 8;
        
        public IArray TSI_Buffer;
		public IArray MTM_Buffer;
		public IArray EMA_MTM_Buffer;
		public IArray EMA2_MTM_Buffer;
		public IArray ABSMTM_Buffer;
		public IArray EMA_ABSMTM_Buffer;
		public IArray EMA2_ABSMTM_Buffer;
		
		public override void Init()
		{ 
			mql4.IndicatorBuffers(7);
			platform.SetIndexBuffer(1, ref MTM_Buffer);
			platform.SetIndexBuffer(2, ref EMA_MTM_Buffer);
			platform.SetIndexBuffer(3, ref EMA2_MTM_Buffer);
			platform.SetIndexBuffer(4, ref ABSMTM_Buffer);
			platform.SetIndexBuffer(5, ref EMA_ABSMTM_Buffer);
			platform.SetIndexBuffer(6, ref EMA2_ABSMTM_Buffer);
			
			platform.SetIndexBuffer(0,ref TSI_Buffer);
			mql4.SetIndexLabel(0,"TSI");
		}
        
        public override void OnQuote()
        {
        	int    counted_bars = platform.IndicatorCounted();
			int limit = 0,i = 0;
			limit=mql4.Bars-counted_bars-1;
			for (i=mql4.Bars-1;i>=0;i--)
			  {
			  MTM_Buffer[i]=mql4.Close[i]-mql4.Close[i+1];//iMomentum(NULL,0,1,PRICE_CLOSE,i);
			  ABSMTM_Buffer[i]=mql4.MathAbs((double)MTM_Buffer[i]);
			  //TSI_Buffer[i]=ABSMTM_Buffer[i];
			  }
			  
			for (i=mql4.Bars-1;i>=0;i--)
			  {
			  EMA_MTM_Buffer[i]=mql4.iMAOnArray(ref MTM_Buffer,0,First_R,0,mql4.MODE_EMA,i);
			  EMA_ABSMTM_Buffer[i]=mql4.iMAOnArray(ref ABSMTM_Buffer,0,First_R,0,mql4.MODE_EMA,i);
			  //TSI_Buffer[i]=EMA_ABSMTM_Buffer[i];
			  }
			
			for (i=mql4.Bars-1;i>=0;i--)
			  {
			  EMA2_MTM_Buffer[i]=mql4.iMAOnArray(ref EMA_MTM_Buffer,0,Second_S,0,mql4.MODE_EMA,i);
			  EMA2_ABSMTM_Buffer[i]=mql4.iMAOnArray(ref EMA_ABSMTM_Buffer,0,Second_S,0,mql4.MODE_EMA,i);
			  //TSI_Buffer[i]=EMA2_ABSMTM_Buffer[i];
			  }
			
			for (i=mql4.Bars-1;i>=0;i--)
			  {
			  TSI_Buffer[i]=100.0*(double)EMA2_MTM_Buffer[i]/(double)EMA2_ABSMTM_Buffer[i];
			  }            
        }

    }
#endregion
}

