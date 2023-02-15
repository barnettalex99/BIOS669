%LET job=SQLF3;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

/* proc printto log="&outdir/Logs/&job._&onyen..log" new; run; */

*********************************************************************
*  Assignment:    SQLF3                                 
*                                                                    
*  Description:   Sixth set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          2/6/23                                      
*------------------------------------------------------------------- 
*  Job name:      SQLF3_agb.sas   
*
*  Purpose:       Redo REFB3 using PROC SQL and inexact matching
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         METS data
*
*  Output:        PDF file      
*                                                                    
********************************************************************;


/* OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER; */
/* ODS _ALL_ CLOSE; */
/* FOOTNOTE "Job &job._&onyen run on &sysdate at &systime"; */

LIBNAME mets "~/my_shared_file_links/klh52250/METS" access=readonly; 


/* PDF output */
/* ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL; */

TITLE 'Forms Filled Out at Unscheduled Visits';

PROC SQL Number;

CREATE TABLE joinedForms AS
	SELECT u.BID, u.visit, u.visitdate, u.UVFA1A, u.UVFA1B, u.UVFA1C, u.UVFA1D, u.UVFFORM, c.CGIFORM, a1.AESFORM, s.SAEFORM, v.VSFFORM, a2.AUQFORM, l.LABAFORM, b.BSFFORM, s2.SMFFORM 
	FROM mets.uvfa_669(rename=(UVFA0B = visitdate FORM=UVFFORM)) as u
		LEFT JOIN mets.cgia_669(rename=(CGIA0B = visitdate FORM=CGIFORM)) as c
		ON u.BID=c.BID AND u.visit=c.visit AND u.visitdate = c.visitdate
		LEFT JOIN mets.aesa_669(rename=(AESA0B = visitdate FORM=AESFORM)) as a1
		ON u.BID=a1.BID AND u.visit=a1.visit AND a1.visitdate = a1.visitdate
		LEFT JOIN mets.saea_669(rename=(SAEA0B = visitdate FORM=SAEFORM)) as s
		ON u.BID=s.BID AND u.visit=s.visit AND a1.visitdate = s.visitdate
		LEFT JOIN mets.vsfa_669(rename=(VSFA0B = visitdate FORM=VSFFORM)) as v
		ON u.BID=v.BID AND u.visit=v.visit AND a1.visitdate = v.visitdate
		LEFT JOIN mets.auqa_669(rename=(AUQA0B = visitdate FORM=AUQFORM)) as a2
		ON u.BID=a2.BID AND u.visit=a2.visit AND a1.visitdate = a2.visitdate
		LEFT JOIN mets.laba_669(rename=(LABA0B = visitdate FORM=LABAFORM)) as l
		ON u.BID=l.BID AND u.visit=l.visit AND a1.visitdate = l.visitdate
		LEFT JOIN mets.bsfa_669 (rename=(BSFA0B = visitdate FORM=BSFFORM)) as b
		ON u.BID=b.BID AND u.visit=b.visit AND a1.visitdate = b.visitdate
		LEFT JOIN mets.smfa_669 (rename=(SMFA0B = visitdate FORM=SMFFORM)) as s2
		ON u.BID=s2.BID AND u.visit=s2.visit AND a1.visitdate = s2.visitdate;

SELECT BID, visit, visitdate, (catx(', ', UVFFORM, CGIFORM, AESFORM, SAEFORM, VSFFORM, AUQFORM, SMFFORM))as forms
FROM JOINEDFORMS;
	
QUIT;


/* ODS PDF CLOSE; */
/*  */
/* proc printto; run; /*closes open log file */