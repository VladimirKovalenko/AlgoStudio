//---------------------------------------------------
// Project: Untitled3
// Language: MQL4
// Type: Strategy
// Author: 
// Company: 
// Copyright: 
// Created: 31.10.2012
//---------------------------------------------------
//Stop Out должен выбивать из уровня вложности
//Step over не заходит в вложенные функции

int init()
{

  return(0);
}

int deinit()
{

  return(0);
}

int start()
{
	FF();
Print("1 level");
  return(0);
}

int FF(){
    int i=0; 
    double balance=AccountBalance();
    Print(i+balance," 2 Level");
   	}