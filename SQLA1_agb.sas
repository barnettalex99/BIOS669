%LET job=SQLA1;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run; /*opens a log file to write to

*********************************************************************
*  Assignment:    SQLA                                         
*                                                                    
*  Description:   First set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          1/19/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLA1_agb.sas   
*
*  Purpose:       Produce a display for evaluating whether treatment
*                 groups are fairly balanced across the METS sites.
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         MIMIC data
*
*  Output:        PDF file      
*                                                                    
********************************************************************;
*/

OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER;
ODS _ALL_ CLOSE;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";

LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly;


/* PDF output */
ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL;

proc format; 
	value $genderfmt
		'M' = "Male"
		'F' = "Female"
	; 
run; 

PROC SQL NUMBER;

CREATE TABLE question1a AS
	select * 
	from mimic.patients; 


    TITLE "A) Full MIMIC.PATIENTS data set";
    SELECT *
        FROM question1a;

    TITLE "B) Full MIMIC.PATIENTS data set with selected columns";
    SELECT SUBJECT_ID, GENDER, DOB, DOD
        FROM question1a;

    TITLE "C) Full MIMIC.PATIENTS data set with selected columns and formatted gender";
    SELECT SUBJECT_ID, GENDER FORMAT=$genderfmt., DOB, DOD
        FROM question1a;

    TITLE "D) Full MIMIC.PATIENTS data set with selected columns, formatted gender, and age at death";
    SELECT SUBJECT_ID, GENDER FORMAT=$genderfmt., DOB, DOD,
                FLOOR((DOD - DOB) / 365.25) AS AgeAtDeath "Age at death"
        FROM question1a;

    TITLE "E) Full MIMIC.PATIENTS data set with selected columns, formatted gender, and death age for individuals under 120 years at death";
    SELECT SUBJECT_ID, GENDER FORMAT=$genderfmt., DOB, DOD,
                FLOOR((DOD - DOB) / 365.25) AS AgeAtDeath "Age at death"
        FROM question1a
            WHERE CALCULATED AgeAtDeath < 120;
            /* or you could use HAVING AgeAtDeath < 120 */

    TITLE "F) Male patients less than 120 years old at death";
    SELECT SUBJECT_ID, GENDER FORMAT=$genderfmt., FLOOR((DOD - DOB) / 365.25) AS AgeAtDeath "Age at death"
        FROM question1a
            WHERE CALCULATED AgeAtDeath < 120 AND GENDER = "M";
            /* or you could use other combinations such as
               where gender = 'M'
               having AgeAtDeath < 120
            */

    TITLE "G) Male patients less than 120 years old at death, ordered by age at death";
    SELECT SUBJECT_ID, GENDER FORMAT=$genderfmt., FLOOR((DOD - DOB) / 365.25) AS AgeAtDeath "Age at death"
        FROM question1a
            WHERE CALCULATED AgeAtDeath < 120 AND GENDER = "M"
        ORDER BY AgeAtDeath DESC;

    /* H */
    CREATE TABLE HIGH_AGE AS SELECT SUBJECT_ID, GENDER FORMAT=$genderfmt., 
            FLOOR((DOD - DOB) / 365.25) AS AgeAtDeath "Age at death"
        FROM question1a
        WHERE 80 <= CALCULATED AgeAtDeath < 120
        /* or HAVING 80 <= AgeAtDeath < 120 */
        ORDER BY SUBJECT_ID;

QUIT;

TITLE "H) Patients 80 and older (but less than 120) at death";
PROC PRINT DATA = HIGH_AGE;
RUN;

ODS PDF CLOSE;

proc printto; run; /*closes open log file