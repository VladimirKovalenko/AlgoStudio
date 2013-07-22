int start()
{
	double rsi[101];
	double irsi;  
	ArraySetAsSeries(rsi,true);
	for(int counter=100; counter>=0; counter--)  
	{
		rsi[counter]=Close[counter];
		if(counter==1)
			irsi=rsi[counter];
	}

	double iAC				=iAC(NULL, 0, 0);
	double iAD				=iAD(NULL, 0, 0);
	double iAlligator		=iAlligator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_GATORJAW, 1);
	double iADX				=iADX(NULL,0,14,PRICE_HIGH,MODE_MAIN,0);
	double iATR				=iATR(NULL,0,12,0);
	double iAO				=iAO(NULL, 0, 2);
	double iBearsPower		=iBearsPower(NULL, 0, 13,PRICE_CLOSE,0);
	double iBands			=iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,0);
	double iBandsOnArray	=iBandsOnArray(rsi,0,2,0,0,MODE_LOWER,0);
	double iBullsPower		=iBullsPower(NULL, 0, 13,PRICE_CLOSE,0);
	double iFractals		=iFractals(NULL, 0, MODE_UPPER, 3);
	double iForce			=iForce(NULL, 0, 13,MODE_SMA,PRICE_CLOSE,0);
	double iEnvelopesOnArray=iEnvelopesOnArray(rsi,10,13,MODE_SMA,0,0.2,MODE_UPPER,0);
	double iEnvelopes		=iEnvelopes(NULL, 0, 13,MODE_SMA,10,PRICE_CLOSE,0.2,MODE_UPPER,0);	
	double iDeMarker		=iDeMarker(NULL, 0, 13, 1);
	double iCustom			=iCustom(NULL, 0, "SampleInd",13,1,0);
	double iCCIOnArray		=iCCIOnArray(rsi,0,12,0);
	double iCCI				=iCCI(Symbol(),0,12,PRICE_TYPICAL,0);
	double iStdDevOnArray	=iStdDevOnArray(rsi,100,10,0,MODE_EMA,0);
	double iStochastic		=iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0);
	double iWPR				=iWPR(NULL,0,14,0);
	double iStdDev			=iStdDev(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,0);
	double iRVI				=iRVI(NULL, 0, 10,MODE_MAIN,0);
	double iRSIOnArray		=iRSIOnArray(rsi,1000,14,0);
	double iRSI				=iRSI(NULL,0,14,PRICE_CLOSE,0);
	double iSAR				=iSAR(NULL,0,0.02,0.2,0);
	double iOBV				=iOBV(NULL, 0, PRICE_CLOSE, 1);
	double iMACD			=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
	double iOsMA			=iOsMA(NULL,0,12,26,9,PRICE_OPEN,1);
	double iMAOnArray		=iMAOnArray(rsi,0,5,0,MODE_LWMA,0);
	double iMA				=iMA(NULL,0,13,8,MODE_SMMA,PRICE_MEDIAN,0);
	double iMFI				=iMFI(NULL,0,14,0);
	double iMomentumOnArray=iMomentumOnArray(rsi,100,12,0);
	double iMomentum		=iMomentum(NULL,0,12,PRICE_CLOSE,0);
	double iBWMFI			=iBWMFI(NULL, 0, 0);
	double iIchimoku		=iIchimoku(NULL, 0, 9, 26, 52, MODE_TENKANSEN, 1);
	double iGator			=iGator(NULL, 0, 13, 8, 8, 5, 5, 3, MODE_SMMA, PRICE_MEDIAN, MODE_UPPER, 1);
  return(0);
}

