using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace RegressionTrader
{
    /// <summary>
    /// RegressionTrader
    /// 
    /// </summary>
    public class RegressionTrader : NETStrategy
    {
        public RegressionTrader()
            : base()
        {
			#region // Initialization
            base.Author = "";
            base.Comments = "";
            base.Company = "";
            base.Copyrights = "";
            base.DateOfCreation = "08.08.2013";
            base.ExpirationDate = 0;
            base.Version = "";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "RegressionTrader";
            #endregion
        }
        
        [InputParameter("Period",0)]
        public int LrPeriod = 10;
        
        [InputParameter("Wight",1)]
        public double Wight = 2.0;
        
        private int trade = 0;// 0 - out of Market, 1 - Long position, -1 - Short position;
        
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
			#region LinearRegression
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
			#endregion
			
			#region TradeRules
			if(PositionsCount()<1)
			{
				if(b<0.0)
				{
					OpenOrder(OPERATION_BUY);
					trade = 1;
				}
				if(b>0.0)
				{
					OpenOrder(OPERATION_SELL);
					trade = -1;
				}
			}
			else
			{
				SelectPosition(0);
				int op = OrderOperation();
				if(b>0.0)
				{
					if(op==OPERATION_BUY)
					{
						ClosePosition(Account, Symbol);
						trade = 0;
					}
				}
				if(b<0.0)
				{
					if(op==OPERATION_SELL)
					{
						ClosePosition(Account, Symbol);
						trade = 0;
					}
				}
			}
			#endregion
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{
			
		} 
     }
}
