using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace LinearRegression
{
    /// <summary>
    /// LinearRegression
    /// 
    /// </summary>
    public class LinearRegression : NETIndicator 
    {
        public LinearRegression()
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
            base.ProjectName = "LinearRegression";
            #endregion 
            
            base.SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            base.SetIndicatorLine("line2", Color.Red, 1, LineStyle.SimpleChart);
            base.SetIndicatorLine("line3", Color.Red, 1, LineStyle.SimpleChart);
            base.SeparateWindow = false;
        }
        
        [InputParameter("Period",0)]
        public int LrPeriod = 10;

		[InputParameter("Wight",1)]
        public double Wight = 2.0;
		
        public const int LINE1 = 0;
        public const int LINE2 = 1;
        public const int LINE3 = 2;
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
   			double a=(sumY-sumX*b)/LrPeriod;
 			
 			double sum = 0.0;
 			
   			for(int j=0; j<LrPeriod; j++)
   			{
      			double ext1 = b*j+a;
      			sum+=(BidClose(j)-ext1)*(BidClose(j)-ext1);      			
   			}
   			
   			double Dev = Wight*Math.Sqrt(sum/LrPeriod);
   			
   			for(int k=0; k<LrPeriod; k++)
   			{
      			double r = b*k+a;
      			double ext2=r+Dev;
      			double ext3=r-Dev;
      			SetValue(LINE1,k,r);
      			SetValue(LINE2,k,ext2);
      			SetValue(LINE3,k,ext3);
      		}
   			
   			SetValue(LINE1,LrPeriod,0.0);
   			SetValue(LINE2,LrPeriod,0.0);
   			SetValue(LINE3,LrPeriod,0.0);
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{
			
		} 
     }
}
