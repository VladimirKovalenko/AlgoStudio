using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace Level2Test
{
    /// <summary>
    /// Level2Test
    /// Test Level2
    /// </summary>
    public class Level2Test : NETIndicator 
    {
    
    	[InputParameter("Required Lots", 0, 0, 1000)]
    	public double RequiredAmount = 90;
    	
        public Level2Test()
            : base()
        {
			#region // Initialization
            base.Author = "nicky";
            base.Comments = "Test Level2";
            base.Company = "PFSoft";
            base.Copyrights = "(c) PFSoft";
            base.DateOfCreation = "13.09.2010";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "Level2Test";
            #endregion 
            
            base.SetIndicatorLine("line1", Color.Blue, 1, LineStyle.SimpleChart);
            base.SeparateWindow = false;
        }
        
        /// <summary>
        /// This function will be called after creating
        /// </summary>
		public override void Init()
		{
			NewLevel2Quote += new NewLevel2QuoteHandler(NewLevel2QuoteComes);
			PriceSubscribe(QUOTE_LEVEL2);
		}        
 
        /// <summary>
        /// Entry point. This function is called when new quote comes 
        /// </summary>
        public override void OnQuote()
        {
        }
        
        /// <summary>
        /// This function will be called before removing
        /// </summary>
		public override void Complete()
		{
			NewLevel2Quote -= new NewLevel2QuoteHandler(NewLevel2QuoteComes);
			PriceUnsubscribe(QUOTE_LEVEL2);
			Comment("");
		} 
		
		private void NewLevel2QuoteComes(string symbol)
		{
			int ask_count = GetLevel2Count(ASK);
			int bid_count = GetLevel2Count(BID);
			
			string result = string.Format("Bid ({0}):\t\t\t\tAsk ({1}):\n", bid_count, ask_count);
			for (int i = 0; i<Math.Max(ask_count, bid_count); i++)
			{
				string ask = (i<ask_count) ? GetLevel2MMID(ASK, i) + ":  " + GetLevel2Price(ASK, i) + "     " + GetLevel2Size(ASK, i) : "";
				string bid = (i<bid_count) ? GetLevel2MMID(BID, i) + ":  " + GetLevel2Price(BID, i) + "     " + GetLevel2Size(BID, i) : "";
				
				bid= bid.PadRight(50);
				
				result += bid + ask + "\n";
			}
			
			result += string.Format("\nApproximated prices for {0} lots: bid {1} / ask {2}",
				RequiredAmount,
				GetLevel2VWAPByQuantity(BID, RequiredAmount),
				GetLevel2VWAPByQuantity(ASK, RequiredAmount));
			
			Comment(result);
		}
     }
}
