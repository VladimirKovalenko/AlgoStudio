using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using PTLRuntime.NETScript;

namespace OrderSpeedCheck
{
    /// <summary>
    /// OrderSpeedCheck
    /// </summary>
    public class OrderSpeedCheck : NETStrategy
    {
    	[InputParameter("NumberOfPosition", 0, 1,1000)]
        public int PosNumb = 2;		// оличество устанавливаемых позиций
        

		
        public OrderSpeedCheck()
            : base()
        {
			#region // Initialization
            base.Author = "Kovalenkov";
            base.Comments = "";
            base.Company = "PFSOFT";
            base.Copyrights = "";
            base.DateOfCreation = "19.04.2013";
            base.ExpirationDate = 0;
            base.Version = "1.0";
            base.Password = "66b4a6416f59370e942d353f08a9ae36";
            base.ProjectName = "OrderSpeedCheck";
            #endregion 
        }
       
        public int counter=0;
        private string OpPos;
		
		public void sendByTimerServerTime()
		{
			double ServerTime=0,EndtTime=0;
			
			if(counter<PosNumb)
			{
				ServerTime=GetServerTime(Symbol);
				OpPos=OpenOrder(OPERATION_BUY);
				counter++;
				System.Threading.Thread.Sleep(5000);//—лип дл€ того что б на сервере наверн€ка успело все пройти.
			}
			
			bool selector=SelectOrder(OpPos, false,true);
			
			if(selector)
			{
				if(ServerTime==0) return;
				EndtTime=OrderOpenTime();
				double delta=EndtTime-ServerTime;
				Print(EndtTime+" "+ServerTime+" "+new TimeSpan((long)delta));//ѕроблема в том что временами значени€ отрицательные. «начит где-то погрешность
			}
		}
		
		public void sendByCurrentTime()
		{
			// текущее врем€ в итках
			long startTime = DateTime.Now.Ticks;
			OpPos=OpenOrder(OPERATION_BUY);
			long endTime = DateTime.Now.Ticks;
			Print(startTime-endTime);
		}
		
        /// <summary>
        /// Entry point. This function is called when new quote comes 
        /// </summary>
        public override void OnQuote()
        {
        	sendByCurrentTime();
        }
     }
}
