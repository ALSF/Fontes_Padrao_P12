#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc}  WSTRM030

@author Rogerio Ribeiro da Cruz
@since 13/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
Function WSTRM030()
Return

WSSTRUCT TEPMTraining
	WSDATA Company		AS String
	WSDATA Branch		AS String
	WSDATA CourseCode	AS String
ENDWSSTRUCT

WSSTRUCT TReservation
	WSDATA Company		AS String
	WSDATA Branch		AS String
	WSDATA Registration	AS String
	WSDATA RequestDate	AS Date
	WSDATA Operation	AS String	//L = Lista espera; R = Reserva; S = Solicitar
ENDWSSTRUCT


//-------------------------------------------------------------------
/*/{Protheus.doc}  RHTrainingReservations

@author Rogerio Ribeiro da Cruz
@since 29/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
WSSERVICE RHTrainingReservations DESCRIPTION "Reservas"
	WSDATA Training AS TEPMTraining
	WSDATA Reservation AS TReservation
	WSDATA Message AS String Optional
	
	WSMETHOD SetReservation	DESCRIPTION "Grava as reservas"
ENDWSSERVICE                                  


//-------------------------------------------------------------------
/*/{Protheus.doc}  SetReservation

@author Rogerio Ribeiro da Cruz
@since 29/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
WSMETHOD SetReservation;
		WSRECEIVE Training, Reservation;
		WSSEND Message;
		WSSERVICE RHTrainingReservations		
	dbSelectArea("RAY")
	dbSetOrder(1)		//RAY_FILIAL+RAY_CURSO

	If !dbSeek(xFilial("RAY", Self:Training:Branch) + Self:Training:CourseCode)
		SetSoapFault("SetReservation", "Treinamento não encontrado!")
		Return .F.
	EndIf
	

	lFind:= FindReservation(Self:Training, Self:Reservation)
	lCancel:= Empty(Self:Reservation:Operation)
	
	If lFind .AND. lCancel
		CancelReservation(Self:Training, Self:Reservation)
	ElseIf !lCancel
		SaveReservation(Self:Training, Self:Reservation, !lFind)
	EndIf			
Return .T.


//-------------------------------------------------------------------
/*/{Protheus.doc}  CancelReservation

@author Rogerio Ribeiro da Cruz
@since 29/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
Static Function CancelReservation(oTraining, oReservation)
	RecLock("RA3", .F.)
	RA3->(dbDelete())
	RA3->(MsUnlock())
Return


//-------------------------------------------------------------------
/*/{Protheus.doc}  SaveReservation

@author Rogerio Ribeiro da Cruz
@since 29/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
Static Function SaveReservation(oTraining, oReservation, lInsert)
	RecLock("RA3", lInsert)

	If lInsert 
		RA3->RA3_FILIAL	:= xFilial("RA3", oReservation:Branch)
		RA3->RA3_MAT	:= oReservation:Registration
		RA3->RA3_CURSO	:= oTraining:CourseCode
		RA3->RA3_CALEND	:= Space(GetSx3Cache("RA3_CALEND", "X3_TAMANHO"))      
		RA3->RA3_TURMA	:= Space(GetSx3Cache("RA3_TURMA", "X3_TAMANHO"))
	EndIf

	RA3->RA3_RESERV	:= oReservation:Operation
	RA3->RA3_DATA	:= oReservation:RequestDate
	
	RA3->(MsUnlock())
Return


//-------------------------------------------------------------------
/*/{Protheus.doc}  FindReservation

@author Rogerio Ribeiro da Cruz
@since 29/04/2010
@version 11.0
/*/
//-------------------------------------------------------------------
Static Function FindReservation(oTraining, oReservation)
	Local lFind := .F.
	Local cCalend:= Space(GetSx3Cache("RA3_CALEND", "X3_TAMANHO"))
	Local cTurma:= Space(GetSx3Cache("RA3_TURMA", "X3_TAMANHO"))

	dbSelectArea("RA3")
	dbSetOrder(1)	//RA3_FILIAL, RA3_MAT, RA3_CURSO
							 
	If dbSeek(xFilial("RA3", oReservation:Branch) + oReservation:Registration + oTraining:CourseCode)  
		While !Eof() .AND.;
				xFilial("RA3", oReservation:Branch) == RA3->RA3_FILIAL .AND.;
				oReservation:Registration == RA3->RA3_MAT .AND.;
				oTraining:CourseCode ==	RA3->RA3_CURSO
			If RA3->RA3_CALEND == cCalend .AND.;
				RA3->RA3_TURMA == cTurma
				lFind:= .T.
				Exit
			EndIf	
			DBSkip()
		EndDo	
	EndIf
Return lFind