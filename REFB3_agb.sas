%LET job=REFB3;
%LET onyen=agb;
%LET outdir= /home/u63044704/BIOS699/REFB;
OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME mets "/home/u63044704/my_shared_file_links/klh52250/METS";

*********************************************************************
*  Assignment:    REFB3                                         
*                                                                    
*  Description:   First collection of SAS refresher problems using 
*                           METS study data
*
*  Name:             Alex Barnett
*
*  Date:              1/12/22                         
*------------------------------------------------------------------- 
*  Job name:      REFB3_agb.sas
*
*  Purpose:       Produce a display for evaluating whether treatment
*                         groups are fairly balanced across the METS sites.
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         METS data set dr_669 (could also list macros or 
*                      other external files that you are accessing)
*
*  Output:       PDF file (you might also be making permanent data
*                       sets, xls files, etc. that you should list here)     
*                                                                    
********************************************************************;
/* ods pdf file='/home/u63044704/BIOS699/REFB/REFB3_agb.pdf'; */

proc printto log="/home/u63044704/BIOS699/REFB/REFB3_agb.log";



title "Unscheduled Visits";

data merged_data;
	merge mets.uvfa_669(in= unscheduled rename=(UVFA0B = visitdate FORM=UVFFORM)) mets.cgia_669(rename=(CGIA0B = visitdate FORM=CGIFORM))
	mets.aesa_669(rename=(AESA0B = visitdate FORM=AESFORM)) mets.saea_669(rename=(SAEA0B = visitdate FORM=SAEFORM))
	mets.vsfa_669(rename=(VSFA0B = visitdate FORM=VSFFORM)) mets.auqa_669 (rename=(AUQA0B = visitdate FORM=AUQFORM)) mets.laba_669(rename=(LABA0B = visitdate FORM=LABAFORM)) mets.bsfa_669 (rename=(BSFA0B = visitdate FORM=BSFFORM))
	mets.smfa_669 (rename=(SMFA0B = visitdate FORM=SMFFORM));
	by bid visit visitdate;
	
	if unscheduled;
	forms = catx(', ', UVFFORM, CGIFORM, AESFORM, SAEFORM, VSFFORM, AUQFORM, SMFFORM);
run;

proc print data = merged_data;
	var bid visit visitdate UVFA1A UVFA1B UVFA1C UVFA1D forms;
run;


/* ods pdf close; */

