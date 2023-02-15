%LET job=LUTA;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run;

*********************************************************************
*  Assignment:    LUTA                                    
*                                                                    
*  Description:   Look Up Tables Practice 
*
*  Name:          Alex Barnett
*
*  Date:          2/8/23                                      
*------------------------------------------------------------------- 
*  Job name:      LUTA_agb.sas   
*
*  Purpose:       Use Look Up Tables techniques to sort/view data
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         METS data
*
*  Output:        PDF file      
*                                                                    
********************************************************************;


OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER;
ODS _ALL_ CLOSE;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";

LIBNAME mets "~/my_shared_file_links/klh52250/METS" access=readonly; 


/* PDF output */
ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL;



Data remove_records;
	set mets.omra_669;
	WtLiabMed=scan(OMRA1, 1);
	where OMRA5A= 'Y' AND OMRA4= '06';
run;

proc sort data=remove_records (keep = BID WtLiabMed) out=sorted_records nodupkey;
    by WtLiabMed BID;
run;

DATA lookup;
LENGTH med $15 class $4 ;
INPUT med class ;
CARDS;
CLOZAPINE HIGH
ZYPREXA HIGH
RISPERIDONE HIGH
SEROQUEL HIGH
INVEGA HIGH
CLOZARIL HIGH
OLANZAPINE HIGH
RISPERDAL HIGH
ZIPREXA HIGH
LARI HIGH
QUETIAPINE HIGH
RISPERDONE HIGH
RISPERIDAL HIGH
RISPERIDOL HIGH
SERAQUEL HIGH
ABILIFY LOW
GEODON LOW
ARIPIPRAZOLE LOW
HALOPERIDOL LOW
PROLIXIN LOW
ZIPRASIDONE LOW
GEODONE LOW
HALDOL LOW
PERPHENAZINE LOW
FLUPHENAZINE LOW
THIOTRIXENE LOW
TRILAFON LOW
TRILOFAN LOW
;

TITLE 'Method 1: Data Step MERGE';

proc sort data=lookup(rename=(med=WtLiabMed)) out=sorted_lookup nodupkey;
    by WtLiabMed;
run;
 
DATA merge_lu; 
    MERGE sorted_records(IN=inmain) sorted_lookup; 
    BY WtLiabMed; 
    IF inmain; 
RUN; 
 
TITLE 'Method 2: SQL Left Join';

PROC SQL; 
    CREATE TABLE leftjoin_lu AS 
        SELECT r.BID, r.WtLiabMed, l.class
            FROM sorted_records AS r 
                LEFT JOIN 
                 sorted_lookup AS l 
            ON l.WtLiabMed=r.WtLiabMed 
            ORDER BY WtLiabMed; 
QUIT;

TITLE 'Method 3: Format Using Data Set';

DATA fmt; 
    SET sorted_lookup(RENAME=(WtLiabMed=START class=LABEL)); 
    RETAIN FMTNAME '$medsfmt';  
RUN; 
 
PROC FORMAT CNTLIN=fmt; 
RUN; 
 
DATA fmtds_lu; 
    SET sorted_records; 
    LENGTH Class $4; 
    Class=PUT(WtLiabMed, $medsfmt.);  
RUN;

TITLE 'Checking Method 1';

PROC FREQ data=merge_lu;
	table class*WtLiabmed / LIST MISSING;
Run;

TITLE 'Checking All Together';

Data all_merged;
	MERGE merge_lu(rename=(class=class1)) leftjoin_lu(rename=(class=class2)) fmtds_lu(rename=(class=class3));
	BY WtLiabMed;
run;

PROC FREQ data=all_merged;
	table class1*class2*class3 / LIST MISSING;
run;

TITLE 'All Participants with Non Listed Drugs';

proc print data=merge_lu;
	where class is MISSING;
	var BID WtLiabMed;
run;


ODS PDF CLOSE;

proc printto; run; /*closes open log file*/