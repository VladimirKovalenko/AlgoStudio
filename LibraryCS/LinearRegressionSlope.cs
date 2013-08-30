using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace LinearRegressionSlope
{
    /// <summary>
    /// RSquared
    /// </summary>
    public class LinearRegressionSlope : NETIndicator 
    {
        public LinearRegressionSlope()
            : base()
        {
			#region // Initialization
            base.Author = "";
            base.Comments = "";
            base.Company = "";
            base.Copyrights = "";
            base.DateOfCreation = "06.08.2013";
            base.ExpirationDate = 0;
            base.Version = "";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "LinearRegressionSlope";
            #endregion 
            
            base.SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            base.SetLevelLine("ZeroLevel",0.0);
            base.SeparateWindow = true;
        }
        
        [InputParameter("Period",0)]
        public int LrPeriod = 10;

        public const int LINE1 = 0;
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
          	double sumY=0.0;
          	double sumX=0.0;
          	double sumXY=0.0;
          	double sumX2=0.0;
          	
          	for(int i=0; i<LrPeriod; i++)
   			{
      			sumY+=BidClose(i);
      			sumXY+=BidClose(i)*i;
      			sumX+=i;
      			sumX2+=i*i;
   			}
   
   			double c=sumX2*LrPeriod-sumX*sumX;
   
   			if(c==0.0) return;
   			      
   			double b=(sumXY*LrPeriod-sumX*sumY)/c;
   			   	
      		SetValue(LINE1,-b);
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{
			
		} 
     }
}
