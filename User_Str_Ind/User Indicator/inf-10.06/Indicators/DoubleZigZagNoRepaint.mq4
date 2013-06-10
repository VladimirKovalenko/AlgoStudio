//+------------------------------------------------------------------+
//| DoubleZigZagNoRepaint.mq4
//| Copyright © Pointzero-indicator.com
//| --
//| Tracks two zigzags over time without repainting any past signal.
//| Signals are painted only if they match a confirmed 5bar fractal.
//| Customizations at flaab.mrlinux[at]gmail.com
//+------------------------------------------------------------------+
#property copyright "Copyright © Arturo Lopez Perez"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red                  // Slow zigzag 
#property indicator_color2 Blue                 // Fast zigzag 
#property indicator_color3 DarkOrange           // Both zigzags

#define IName              "DoubleZigZagTrack"
#define ZZBack             1                    // Just 1bar past-repaint
#define ZZDev              5                    // ZigZag deviation

//-------------------------------
// Input parameters
//-------------------------------
extern bool CalculateOnBarClose    = true;
extern int  ZigZagFast             = 6;
extern int  ZigZagSlow             = 24;

//-------------------------------
// Buffers
//-------------------------------
double ExtMapBuffer1[];                         // Slow ZigZag
double ExtMapBuffer2[];                         // Fast ZigZag
double ExtMapBuffer3[];                         // Botg ZigZags

//-------------------------------
// Internal variables
//-------------------------------

// Fractals value -mine-
double fr_resistance       = 0;
double fr_support          = EMPTY_VALUE;
bool fr_resistance_change  = EMPTY_VALUE;
bool fr_support_change     = EMPTY_VALUE;

// ZigZag stores values
double zz_slow_high = 0;
double zz_slow_low = 0;
double zz_fast_high = 0;
double zz_fast_low = 0;

// Offset in chart
int    nShift;   

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
    // ZigZag signals
    SetIndexStyle(0, DRAW_ARROW, STYLE_DOT, 1);
    SetIndexArrow(0, 108);
    SetIndexBuffer(0, ExtMapBuffer1);
    SetIndexStyle(1, DRAW_ARROW, STYLE_DOT, 1);
    SetIndexArrow(1, 108);
    SetIndexBuffer(1, ExtMapBuffer2);
    SetIndexStyle(2, DRAW_ARROW, STYLE_DOT, 1);
    SetIndexArrow(2, 108);
    SetIndexBuffer(2, ExtMapBuffer3);
   
    // Data window
    IndicatorShortName("Double ZigZag No-repaint");
    SetIndexLabel(0, "Slow ZigZag");
    SetIndexLabel(1, "Fast ZigZag"); 
    SetIndexLabel(2, "Both ZigZags"); 
    
    // Copyright
    Comment("Copyright © http://www.pointzero-indicator.com");
   
    // Chart offset calculation
    switch(Period())
    {
        case     1: nShift = 1;   break;    
        case     5: nShift = 3;   break; 
        case    15: nShift = 5;   break; 
        case    30: nShift = 10;  break; 
        case    60: nShift = 15;  break; 
        case   240: nShift = 20;  break; 
        case  1440: nShift = 80;  break; 
        case 10080: nShift = 100; break; 
        case 43200: nShift = 200; break;               
    }
    nShift = nShift * 3;
    return(0);
}

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
    return(0);
  }
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
    // Start, limit, etc..
    int start = 0;
    int limit;
    int counted_bars = IndicatorCounted();

    // nothing else to do?
    if(counted_bars < 0) 
        return(-1);

    // do not check repeated bars
    limit = Bars - 1 - counted_bars;
    
    // Check if ignore bar 0
    if(CalculateOnBarClose == true) start = 1;
    
    // Check the signal foreach bar from past to present
    for(int i = limit; i >= start; i--)
    {
        // Last fractals
        double resistance = upper_fractal(i);
        double support = lower_fractal(i);
        
        // Stores if there is a signal and the type
        int SlowSignal = EMPTY_VALUE;
        int FastSignal = EMPTY_VALUE;
        
        //--------------------------------------------------------
        // Slow ZigZag
        //--------------------------------------------------------
        
        // If set up
        if(ZigZagSlow > 0)
        {
            // Slow zigzag values
            double zz_slow_high_t = iCustom(Symbol(), 0, "ZigZag", ZigZagSlow, ZZDev, ZZBack, 1, i);
            if(zz_slow_high_t != 0) zz_slow_high = zz_slow_high_t;
        
            // Zig Zag low
            double zz_slow_low_t  = iCustom(Symbol(), 0, "ZigZag", ZigZagSlow, ZZDev, ZZBack, 2, i);
            if(zz_slow_low_t != 0) zz_slow_low = zz_slow_low_t;
        
            // Show signal if it is a fractal and matches last zigzag high value
            if(fr_support_change == true && fr_support == zz_slow_low)
            {
               // There is signal
               SlowSignal = OP_BUY;
            
            } else 
       
            // Show signal if it is a fractal and matches last zigzag low value
            if(fr_resistance_change == true && fr_resistance == zz_slow_high)
            {
               // Store signal
               SlowSignal = OP_SELL;
            }
        }
        
        //--------------------------------------------------------
        // Fast ZigZag
        //--------------------------------------------------------
        
        // If set up
        if(ZigZagFast > 0)
        {
            // Slow zigzag values
            double zz_fast_high_t = iCustom(Symbol(), 0, "ZigZag", ZigZagFast, ZZDev, ZZBack, 1, i);
            if(zz_fast_high_t != 0) zz_fast_high = zz_fast_high_t;
        
            // Zig Zag low
            double zz_fast_low_t  = iCustom(Symbol(), 0, "ZigZag", ZigZagFast, ZZDev, ZZBack, 2, i);
            if(zz_fast_low_t != 0) zz_fast_low = zz_fast_low_t;
        
            // Show signal if it is a fractal and matches last zigzag high value
            if(fr_support_change == true && fr_support == zz_fast_low)
            {
               // There is signal
               FastSignal = OP_BUY;
            
            } else 
       
            // Show signal if it is a fractal and matches last zigzag low value
            if(fr_resistance_change == true && fr_resistance == zz_fast_high)
            {
               // There is signal
               FastSignal = OP_SELL;
            }
        }
        
        //--------------------------------------------------------
        // Paint signals
        // --
        // If we have two active zigzags -slow and fast- the slow
        // signals will always match with the fast signals. However,
        // we do paint them separately in case an user whats to show 
        // only one zigzag track.
        //--------------------------------------------------------
            
        // Do both zigzag agree on the signal?
        if(SlowSignal == FastSignal && SlowSignal != EMPTY_VALUE)
        {
            if(SlowSignal == OP_BUY)
            {
               ExtMapBuffer3[i+2] = fr_support - nShift*Point;
            } else {
               ExtMapBuffer3[i+2] = fr_resistance + nShift*Point;
            }
            
        // Is in only a slow zigzag signal?
        } else if(SlowSignal != EMPTY_VALUE) {
            
            if(SlowSignal == OP_BUY)
            {
               ExtMapBuffer1[i+2] = fr_support - nShift*Point;
            } else {
               ExtMapBuffer1[i+2] = fr_resistance + nShift*Point;
            }
            
         // Is only a fast zigzag signal?
         } else if(FastSignal != EMPTY_VALUE) {
            
            if(FastSignal == OP_BUY)
            {
               ExtMapBuffer2[i+2] = fr_support - nShift*Point;
            } else {
               ExtMapBuffer2[i+2] = fr_resistance + nShift*Point;
            }
         }
    }
    return(0);
}

//+------------------------------------------------------------------+
//| Custom code ahead
//+------------------------------------------------------------------+

/**
* Returns fractal resistance
* @param int shift
* @param int bk
*/
double upper_fractal(int shift = 1)
{
   double middle = iHigh(Symbol(), 0, shift + 2);
   double v1 = iHigh(Symbol(), 0, shift);
   double v2 = iHigh(Symbol(), 0, shift+1);
   double v3 = iHigh(Symbol(), 0, shift + 3);
   double v4 = iHigh(Symbol(), 0, shift + 4);
   if(middle > v1 && 
      middle > v2 && 
      middle > v3 && 
      middle > v4
      //&& v2 > v1 && v3 > v4 // Uncomment me for perfect fractals
      )
   {
      fr_resistance = middle;
      fr_resistance_change = true;
   } else {
      fr_resistance_change = false;
   }
   return(fr_resistance);
}

/**
* Returns fractal support and stores wether it has changed or not
* @param int shift
*/

double lower_fractal(int shift = 1)
{
   double middle = iLow(Symbol(), 0, shift + 2);
   double v1 = iLow(Symbol(), 0, shift);
   double v2 = iLow(Symbol(), 0, shift+1);
   double v3 = iLow(Symbol(), 0, shift + 3);
   double v4 = iLow(Symbol(), 0, shift + 4);
   if(middle < v1 && 
      middle < v2 && 
      middle < v3 && 
      middle < v4
      //&& v2 < v1 && v3 < v4  //Uncomment me for perfect fractals
      )
   {
      fr_support = middle;
      fr_support_change = true;
   } else {
      fr_support_change = false;
   }
   return(fr_support);
}

//+------------------------------------------------------------------+

