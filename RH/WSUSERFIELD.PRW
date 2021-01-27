USER FUNCTION WSUSRFIELD()
Local cCursor :=  PARAMIXB[1]
Local aReturn := {}

DO CASE
   CASE cCursor == "SQG"
   		aadd(aReturn, "QG_ULTVAGA")   	//1
   		aadd(aReturn, "QG_ULTETAP")    	//2
   		aadd(aReturn, "QG_ULTDATA")    	//3
   		
   CASE cCursor == "SA1"              
   		aadd(aReturn, "A1_MUN") 	//1
   		aadd(aReturn, "A1_DDD") 	//2
   		aadd(aReturn, "A1_TEL")   	//3
   		aadd(aReturn, "A1_ULTCOM")  //4
   		aadd(aReturn, "A1_PESSOA")  //5
   		aadd(aReturn, "A1_TIPOCLI") //6
  		aadd(aReturn, "A1_SHIRINK") //7
   		aadd(aReturn, "A1_PRICOM")  //8  
   		aadd(aReturn, "A1_NROCOM")  //9
   		aadd(aReturn, "A1_SALDUP")  //10    
   		aadd(aReturn, "A1_NROPAG")  //11  
   		aadd(aReturn, "A1_SALPEDL") //12     		   		   		   		   		
   		aadd(aReturn, "A1_ATR")		//13                                            
   		aadd(aReturn, "A1_VACUM")   //14     		   		   		   		   		
   		aadd(aReturn, "A1_SALPED")  //15     		   		   		   		   		
   		
   	CASE cCursor == "SQS"
   		aadd(aReturn, "QS_DTABERT")  	//1
   		
   	CASE cCursor == "SE1"
   		aadd(aReturn, "E1_CLIENTE") //1
   		
   	CASE cCursor == "SE3"
   		aadd(aReturn, "E3_SERIE") //1
   		
   	CASE cCursor == "SB1"
   		aadd(aReturn, "B1_DUN") 	//1   		
   		aadd(aReturn, "B1_MASTER") 	//2  
   		
   CASE cCursor == "SCJ"
   		aadd(aReturn, "CJ_MENSA01")	//1 		
   		aadd(aReturn, "CJ_MOTIVO")	//2 		
   		
   CASE cCursor == "SC9"
   		aadd(aReturn, "C9_DATALIB")	//1 		
   		aadd(aReturn, "C9_PRCVEN")	//2 		   		
   		aadd(aReturn, "C9_CODBLOQ")	//3 
   		
	CASE cCursor == "SUS"
   		aadd(aReturn, "US_TIPO")	//1 		
   		aadd(aReturn, "US_SATIV")	//2 		
   		aadd(aReturn, "US_OBSERV")	//3 		
EndCase
//conout("entrou no WSUSRFIELD ")

Return( aReturn )