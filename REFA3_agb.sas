*********************************************************************
*  Assignment:    REFA3                                         
*                                                                    
*  Description:   First collection of SAS refresher problems using 
*                           METS study data
*
*  Name:             Alex Barnett
*
*  Date:              1/12/22                         
*------------------------------------------------------------------- 
*  Job name:      REFA3_agb.sas   
*
*  Purpose:       Produce a display for evaluating whether treatment
*                         groups are fairly balanced across the METS sites.
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         METS data set dr_669 (could also list macros or 
*                      other external files that you are accessing)
*
*  Output:       RTF file (you might also be making permanent data
*                       sets, xls files, etc. that you should list here)     
*                                                                    
********************************************************************;
%LET job=REFA3;
%LET onyen=agb;
%LET outdir= /home/u63044704/BIOS699/REFA;
OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME mets "/home/u63044704/my_shared_file_links/klh52250/METS";

/* proc printto log="/home/u63044704/BIOS699/REFA/REFA3_agb.log"; */

ods pdf file='/home/u63044704/BIOS699/REFA/REFA3_agb.pdf' pdftoc=2;

data dr_data;
	set mets.dr_669;
run;

data rdma_data;
	set mets.rdma_669;
run;

data ieca_data;
	set mets.ieca_669;
run;

data combined;
	merge dr_data rdma_data ieca_data;
	by BID;
run;

data diff_calculated;
	set combined;
	days_diff = intck ('day', IECA0B, RDMA0B);
run;

proc print data = diff_calculated;
	var BID PSite RDMA0B IECA0B days_diff;
	where days_diff > 14 or days_diff < 3;
run;
ods pdf close;