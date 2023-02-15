%LET job=SQLF4;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

/* proc printto log="&outdir/Logs/&job._&onyen..log" new; run; */

*********************************************************************
*  Assignment:    SQLF4                                     
*                                                                    
*  Description:   Sixth set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          2/6/23                                      
*------------------------------------------------------------------- 
*  Job name:      SQLF4_agb.sas   
*
*  Purpose:       Redo REFB3 using PROC SQL
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

CREATE TABLE mergedInexactDates AS
	SELECT u.BID, u.visit, u.UVFAvisitdate, c.CGIAvisitdate, a1.ASEAvisitdate, s.SAEAvisitdate, v.VSFAvisitdate, a2.AUQAvisitdate, l.LABAvisitdate, b.BSFAvisitdate, s2.SMFAvisitdate
	FROM mets.uvfa_669(rename=(UVFA0B = UVFAvisitdate FORM=UVFFORM)) as u
		LEFT JOIN mets.cgia_669(rename=(CGIA0B = CGIAvisitdate FORM=CGIFORM)) as c
		ON u.BID=c.BID AND u.visit=c.visit AND ((u.UVFAvisitdate = c.CGIAvisitdate) or ((intck('day',u.UVFAvisitdate, c.CGIAvisitdate) = 1)) or ((intck('day',u.UVFAvisitdate, c.CGIAvisitdate) = -1)))	
		LEFT JOIN mets.aesa_669(rename=(AESA0B = ASEAvisitdate FORM=AESFORM)) as a1
		ON u.BID=a1.BID AND u.visit=a1.visit AND ((u.UVFAvisitdate = a1.ASEAvisitdate) or ((intck('day',u.UVFAvisitdate, a1.ASEAvisitdate) = 1)) or ((intck('day',u.UVFAvisitdate, a1.ASEAvisitdate) = -1)))
		LEFT JOIN mets.saea_669(rename=(SAEA0B = SAEAvisitdate FORM=SAEFORM)) as s
		ON u.BID=s.BID AND u.visit=s.visit AND ((u.UVFAvisitdate = s.SAEAvisitdate) or ((intck('day',u.UVFAvisitdate, s.SAEAvisitdate) = 1)) or ((intck('day',u.UVFAvisitdate, s.SAEAvisitdate) = -1)))
		LEFT JOIN mets.vsfa_669(rename=(VSFA0B = VSFAvisitdate FORM=VSFFORM)) as v
		ON u.BID=v.BID AND u.visit=v.visit AND ((u.UVFAvisitdate = v.VSFAvisitdate) or ((intck('day',u.UVFAvisitdate, v.VSFAvisitdate) = 1)) or ((intck('day',u.UVFAvisitdate, v.VSFAvisitdate) = -1)))
		LEFT JOIN mets.auqa_669(rename=(AUQA0B = AUQAvisitdate FORM=AUQFORM)) as a2
		ON u.BID=a2.BID AND u.visit=a2.visit AND ((u.UVFAvisitdate = a2.AUQAvisitdate) or ((intck('day',u.UVFAvisitdate, a2.AUQAvisitdate) = 1)) or ((intck('day',u.UVFAvisitdate, a2.AUQAvisitdate) = -1)))
		LEFT JOIN mets.laba_669(rename=(LABA0B = LABAvisitdate FORM=LABAFORM)) as l
		ON u.BID=l.BID AND u.visit=l.visit AND ((u.UVFAvisitdate = l.LABAvisitdate) or ((intck('day',u.UVFAvisitdate, l.LABAvisitdate) = 1)) or ((intck('day',u.UVFAvisitdate, l.LABAvisitdate) = -1)))
		LEFT JOIN mets.bsfa_669 (rename=(BSFA0B = BSFAvisitdate FORM=BSFFORM)) as b
		ON u.BID=b.BID AND u.visit=b.visit AND ((u.UVFAvisitdate = b.BSFAvisitdate) or ((intck('day',u.UVFAvisitdate, b.BSFAvisitdate) = 1)) or ((intck('day',u.UVFAvisitdate, b.BSFAvisitdate) = -1)))
		LEFT JOIN mets.smfa_669 (rename=(SMFA0B = SMFAvisitdate FORM=SMFFORM)) as s2
		ON u.BID=s2.BID AND u.visit=s2.visit AND ((u.UVFAvisitdate = s2.SMFAvisitdate) or ((intck('day',u.UVFAvisitdate, s2.SMFAvisitdate) = 1)) or ((intck('day',u.UVFAvisitdate, s2.SMFAvisitdate) = -1)));

SELECT BID, visit, UVFAvisitdate LABEL='UVFA', CGIAvisitdate LABEL='CGIA', ASEAvisitdate LABEL='ASEA', SAEAvisitdate LABEL='SAEA', VSFAvisitdate LABEL='VSFA', AUQAvisitdate LABEL='AUQA', LABAvisitdate LABEL='LABA', BSFAvisitdate LABEL='BSFA', SMFAvisitdate LABEL='SMFA'
FROM MergedInexactDates;
	
QUIT;


/* ODS PDF CLOSE; */
/*  */
/* proc printto; run; /*closes open log file */