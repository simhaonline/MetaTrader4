
//----
#property indicator_chart_window
//----
extern double bingo=0.00050;
extern int GOfset=0;
extern int GOfset_m=0;  //0-60
extern int Visible=1;
extern string Tstart="06:00:00";
extern double period=-1;
string TD,TD1;
datetime td,end_time,go_time,ten;
string timeGo,timeEnd,te,tg;
double H,L,C,P,caEU, caeubuy, caeusell;
double R1,R2,R3,S1,S2,S3;
int D,n;
string Tgo,Ten;
double F_val_U,F_val_D;
double Fp_val_U,Fp_val_D=2;
datetime Tu,Td;
string EtiH1,EtiH2;
double DiffNew,DiffOld;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   //ChartSetSymbolPeriod(0,NULL,PERIOD_M5);
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,True); // Visualizza la descrizione degli Oggetti
   ChartSetInteger(0,CHART_AUTOSCROLL,True);        // Scorre il grafico alla fine 
   ChartSetInteger(0, CHART_MODE,CHART_CANDLES); // Grafico a Candele
   ChartSetInteger(0,CHART_SCALEFIX,false);          // Fissa Scala Grafico   
   ChartSetInteger(0,CHART_SHOW_GRID,False);         // Mostra Griglia
   EtiH1=IntegerToString(7+(period*-1),0)   ;
   EtiH2=IntegerToString(7+(period*-1)+1,0);
   DeleteObj();
  
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
 
   DeleteObj();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
  
   D=DayOfWeek();
   if(D==1)n=3;
   else  n=1;
   
   
   
   TD1=TimeToStr(CurTime(),TIME_DATE);
   td=StrToTime(TD1);//-24*60*60;
   TD=TimeToStr(td,TIME_DATE);
   Tgo=Tstart;
   tg=StringConcatenate(TD," ",Tgo);
   ten=StrToTime(TD1)-period*60*60;
   Ten=TimeToStr(ten);
   datetime td1=StrToTime(tg)-GOfset*60*60-GOfset_m*60;
   string t1=TimeToStr(td1,TIME_DATE|TIME_MINUTES);
   go_time=StrToTime(t1);
   end_time=StrToTime(Ten);
   int T_Hour=TimeHour(CurTime());
   //if(T_Hour>=  && T_Hour <23)
     if(TimeCurrent() >= ten  && TimeCurrent()<= go_time) DeleteObj();
     
     
     
   tg=StringConcatenate(TD," ",Tgo);
//----
   //datetime td1=StrToTime(tg)-GOfset*60*60-GOfset_m*60;
   //string t1=TimeToStr(td1,TIME_DATE|TIME_MINUTES);
   //go_time=StrToTime(t1);
   //end_time=StrToTime(Ten);
  
   int BarGo=iBarShift(NULL,0,go_time,false);
   //Print( "BarGo",BarGo);
   
   int BarEnd=iBarShift(NULL,0,end_time,false);
   //Print("BarEnd",BarEnd);
//  Comment("Start ",Ten," end ", t1);
  int h=Highest(NULL,0,MODE_HIGH,BarEnd-BarGo,BarGo);
  
   H=iHigh(NULL,0,h);
   //Print("H day",H);
  
   int l=Lowest(NULL,0,MODE_LOW,BarEnd-BarGo,BarGo);
   L=iLow(NULL,0,l);
   //Print("L day",L);
  
   C=iOpen(NULL,0,BarGo);
   caEU=iOpen(NULL,0,BarEnd);
   caeubuy=((C+caEU)/2)+bingo;
   caeusell=((C+caEU)/2)-bingo;
  

   P=NormalizeDouble((L+H+C)/3,4);
   int mediavirile=(H-L)*10000;
   R1=2*P-L;
   S1=2*P-H;
   R2=P+(H-L);
   R3=2*P-2*L+H;
   S2=P-H+L;
   S3=2*P-2*H+L;
   
   if (Visible==1)
     {
     
      
      
      ObjectCreate("Pivot",OBJ_HLINE,0,go_time,P);
      ObjectCreate("CaUS",OBJ_HLINE,0,0,C);//Close 
      ObjectCreate("CaEU",OBJ_HLINE,0,0,caEU);//Close 
      ObjectCreate(0,"TRENDZEROCINQUE", OBJ_TREND,0,end_time,caEU,      go_time, C);
      ObjectCreate("L",OBJ_HLINE,0,0,L);
      ObjectCreate("H",OBJ_HLINE,0,0,H);
      ObjectCreate("Start1",OBJ_VLINE,0,go_time,0);// 00:00 GMT
      ObjectCreate("Ore "+EtiH1,OBJ_VLINE,0,go_time+120*60,0);//00:00 GMT
      ObjectCreate("Ore "+EtiH2,OBJ_VLINE,0,go_time+180*60,0);// 00:00 GMT
      ObjectCreate("End1",OBJ_VLINE,0,end_time,0);//  06:00 GMT
      ObjectCreate("R11",OBJ_HLINE,0,go_time,R1);
      ObjectCreate("R12",OBJ_HLINE,0,go_time,R2);
      ObjectCreate("R13",OBJ_HLINE,0,go_time,R3);
      ObjectCreate("S11",OBJ_HLINE,0,go_time,S1);
      ObjectCreate("S12",OBJ_HLINE,0,go_time,S2);
      ObjectCreate("S13",OBJ_HLINE,0,go_time,S3);
      ObjectSetString(0,"Pivot",OBJPROP_TEXT,"Pivot");
      ObjectSetString(0,"CaUS",OBJPROP_TEXT,"CaUS");//Close 
      ObjectSetString(0,"CaEU",OBJPROP_TEXT,"CaEU");//Close 
      ObjectSetString(0,"L",OBJPROP_TEXT,"L");
      ObjectSetString(0,"H",OBJPROP_TEXT,"H");
      ObjectSetString(0,"R11",OBJPROP_TEXT,"R1");
      ObjectSetString(0,"R12",OBJPROP_TEXT,"R2");
      ObjectSetString(0,"R13",OBJPROP_TEXT,"R3");
      ObjectSetString(0,"S11",OBJPROP_TEXT,"S1");
      ObjectSetString(0,"S12",OBJPROP_TEXT,"S2");
      ObjectSetString(0,"S13",OBJPROP_TEXT,"S3");
      ObjectSet( "R11",OBJPROP_COLOR,DarkGreen);
      ObjectSet( "R12",OBJPROP_COLOR,DarkGreen);
      ObjectSet( "R13",OBJPROP_COLOR,DarkGreen);
      ObjectSet( "S11",OBJPROP_COLOR,Brown);
      ObjectSet( "S12",OBJPROP_COLOR,Brown);
      ObjectSet( "S13",OBJPROP_COLOR,Brown);
      ObjectSet( "Pivot",OBJPROP_COLOR,Yellow );
      ObjectSet( "Start1",OBJPROP_COLOR,Yellow);
      ObjectSet( "Ore "+EtiH1,OBJPROP_COLOR,Green);
      ObjectSet( "Ore "+EtiH2,OBJPROP_COLOR,Blue);
      ObjectSet( "End1",OBJPROP_COLOR,Yellow );
      ObjectSet( "CaUS",OBJPROP_COLOR,Yellow );
      ObjectSet( "L",OBJPROP_COLOR,Red );
      ObjectSet( "CaEU",OBJPROP_COLOR,Magenta );
      ObjectSet( "R11",OBJPROP_STYLE, STYLE_DASH );
      ObjectSet( "R12",OBJPROP_STYLE, STYLE_DASH );
      ObjectSet( "R13",OBJPROP_STYLE, STYLE_DASH );
      ObjectSet( "S11",OBJPROP_STYLE, STYLE_DASH );
      ObjectSet( "S12",OBJPROP_STYLE, STYLE_DASH );
      ObjectSet( "S13",OBJPROP_STYLE, STYLE_DASH );
      ObjectSet( "H",OBJPROP_COLOR,Green);
      ObjectSet("Start1",OBJPROP_WIDTH,1);
      ObjectSet("Ore "+EtiH1,OBJPROP_WIDTH,1);
      ObjectSet("Ore "+EtiH2,OBJPROP_WIDTH,1);
      ObjectSet("End1",OBJPROP_WIDTH,1);
      ObjectSet("CaUS",OBJPROP_WIDTH,2);
      ObjectSet("Caeu",OBJPROP_WIDTH,2);
      ObjectSet("L",OBJPROP_WIDTH,2);
      ObjectSet("H",OBJPROP_WIDTH,2);
      ObjectSet("Pivot",OBJPROP_WIDTH,1);
      ObjectSet( "Pivot",OBJPROP_STYLE, STYLE_DASH );
      ObjectSet( "Ore "+EtiH1,OBJPROP_STYLE, STYLE_DASH );
      ObjectSet( "Ore "+EtiH2,OBJPROP_STYLE, STYLE_DASH );
      ObjectSet("TRENDZEROCINQUE", OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet("TRENDZEROCINQUE", OBJPROP_COLOR, White);
      ObjectSetInteger(0,"TRENDZEROCINQUE",OBJPROP_WIDTH,2);
             ObjectsRedraw();
     }
 // Test Orario
if (TimeCurrent() >go_time)   
      {
          
          for(int i=BarEnd; i >= BarGo ;i--) 
      {
         
            DiffNew= iFractals(NULL,0,MODE_UPPER,i)-ObjectGetValueByTime(0,"TRENDZEROCINQUE",iTime(NULL,0,i),0) ;
            DiffOld= Fp_val_U - ObjectGetValueByTime(0,"TRENDZEROCINQUE",Tu,0);   
            if ((iFractals(NULL,0,MODE_UPPER,i) >0) &&   ( DiffNew > DiffOld ))
             {
                  Fp_val_U = iFractals(NULL,0,MODE_UPPER,i) ;
                  Tu= iTime(NULL,0,i);
              
             }
          
             DiffNew=ObjectGetValueByTime(0,"TRENDZEROCINQUE",iTime(NULL,0,i),0) - iFractals(NULL,0,MODE_LOWER,i);
             DiffOld= ObjectGetValueByTime(0,"TRENDZEROCINQUE",Td,0)- Fp_val_D;                  
             
            if  ((iFractals(NULL,0,MODE_LOWER,i) >0)  && ( DiffNew > DiffOld ) ) //testo solo se e' un frattale e la distanza dal Trend
            {
                Fp_val_D = iFractals(NULL,0,MODE_LOWER,i) ;
                Td= iTime(NULL,0,i);
            }
       }     
               
                  
            ObjectCreate(0,"LDINAMICO", OBJ_TREND,0,Td,Fp_val_D-0.00005,  go_time+ (Td-end_time), Fp_val_D-0.00005 + ((C-caEU)));
            ObjectCreate(0,"HDINAMICO", OBJ_TREND,0,Tu,Fp_val_U+0.00005,  (go_time+ (Tu-end_time)), Fp_val_U+0.00005 + ((C-caEU)));
            ObjectSet("HDINAMICO", OBJPROP_STYLE, STYLE_SOLID);
            ObjectSetInteger(0,"HDINAMICO",OBJPROP_WIDTH,2);
            ObjectSetInteger(0,"LDINAMICO",OBJPROP_WIDTH,2);
            ObjectSet("HDINAMICO", OBJPROP_COLOR, Green);
            ObjectSet("LDINAMICO", OBJPROP_STYLE, STYLE_SOLID);
            ObjectSet("LDINAMICO", OBJPROP_COLOR, Red);
            ObjectSetString(0,"LDINAMICO",OBJPROP_TEXT,"L Din");
            ObjectSetString(0,"HDINAMICO",OBJPROP_TEXT,"H Din");
      
      }
return(0);
  }
//+------------------------------------------------------------------+
//|Cancella tutti gli oggetti                                        |
//+------------------------------------------------------------------+
void DeleteObj()
{
   ObjectDelete("P");
   ObjectDelete("Pivot");
   ObjectDelete("CaEU");
   ObjectDelete("CaUS");
   ObjectDelete("TRENDZEROCINQUE");
   ObjectDelete("HDINAMICO");
   ObjectDelete("LDINAMICO"); 
   ObjectDelete("H");
   ObjectDelete("L");
   ObjectDelete("Start1");
   ObjectDelete("Ore "+EtiH1);
   ObjectDelete("Ore "+EtiH2);
   ObjectDelete("End1");
   ObjectDelete("R11");
   ObjectDelete("R12");
   ObjectDelete("R13");
   ObjectDelete("S11");
   ObjectDelete("S12");
   ObjectDelete("S13");

}