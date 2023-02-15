/* %LET job=SQLC1; */
/* %LET onyen=agb; */
/* %LET outdir=/home/u63044704/BIOS669; */
/*  */
/* proc printto log="&outdir/Logs/&job._&onyen..log" new; run; /*opens a log file to write to */

*********************************************************************
*  Assignment:    SQLC                                        
*                                                                    
*  Description:   Third set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          1/25/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLC1_agb.sas   
*
*  Purpose:       Practice using JOIN statements.
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         MIMIC data
*
*  Output:        PDF file      
*                                                                    
********************************************************************;


/* OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER; */
/* ODS _ALL_ CLOSE; */
/* FOOTNOTE "Job &job._&onyen run on &sysdate at &systime"; */
/*  */
LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly; 


/* PDF output */
/* ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL; */


PROC SQL NUMBER;

CREATE TABLE birthday_month_patients AS
	select P.SUBJECT_ID, MONTH(P.DOB) as BirthMonth, MONTH(DATEPART(A.ADMITTIME)) as AdmitMonth
	from mimic.patients as P,
		mimic.admissions as A
	where P.SUBJECT_ID = A.SUBJECT_ID AND (MONTH(P.DOB) = MONTH(DATEPART(A.ADMITTIME))); 


    TITLE "Patients with The Same Birth Months and Admin Months";
    	SELECT SUBJECT_ID,
    	CASE 
    	WHEN BirthMonth = 1 THEN 'January'
    	WHEN BirthMonth = 2 THEN 'Feburary'
    	WHEN BirthMonth = 3 THEN 'March'
    	WHEN BirthMonth = 4 THEN 'April'
    	WHEN BirthMonth = 5 THEN 'May'
    	WHEN BirthMonth = 6 THEN 'June'
    	WHEN BirthMonth = 7 THEN 'July'
    	WHEN BirthMonth = 8 THEN 'August'
    	WHEN BirthMonth = 9 THEN 'September'
    	WHEN BirthMonth = 10 THEN 'October'
    	WHEN BirthMonth = 11 THEN 'November'
    	ELSE'December'
    	END as BirthAndAdmitMonth
        FROM birthday_month_patients;

QUIT;


/* ODS PDF CLOSE; */
/*  */
/* proc printto; run; /*closes open log file */ */