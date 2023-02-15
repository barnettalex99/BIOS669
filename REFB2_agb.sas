%LET job=REFB2;
%LET onyen=agb;
%LET outdir= /home/u63044704/BIOS699/REFB;
OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME mets "/home/u63044704/my_shared_file_links/klh52250/METS";

*********************************************************************
*  Assignment:    REFB2                                         
*                                                                    
*  Description:   First collection of SAS refresher problems using 
*                           METS study data
*
*  Name:             Alex Barnett
*
*  Date:              1/12/22                         
*------------------------------------------------------------------- 
*  Job name:      REFB2_agb.sas
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
ods pdf file='/home/u63044704/BIOS699/REFB/REFB2_agb.pdf';

/* proc printto log="/home/u63044704/BIOS699/REFB/REFB2_agb.log"; */

%LET analyte = Sodium;
%LET variableName = LABA11;

title "Values Outside the Reasonable Range for &analyte";

data &analyte;
	set mets.laba_669;
	keep BID &variableName VALUEIS;
	if &variableName > 150 then VALUEIS = 'too high';
	if &variableName < 130 then VALUEIS = 'too low';
run;

proc print data = &analyte;
	var BID &variableName VALUEIS;
	where &variableName is not missing and (&variableName <130 or &variableName > 150);
run;


%LET analyte = Calcium;
%LET variableName = LABA15;

title "Values Outside the Reasonable Range for &analyte";

data &analyte;
	set mets.laba_669;
	keep BID &variableName VALUEIS;
	if &variableName > 10.5 then VALUEIS = 'too high';
	else if &variableName < 8 then VALUEIS = 'too low';
run;

proc print data = &analyte;
	var BID &variableName VALUEIS;
	where &variableName is not missing and (&variableName <8 or &variableName > 10.5);
run;

%LET analyte = Protein;
%LET variableName = LABA16;

title "Values Outside the Reasonable Range for &analyte";

data &analyte;
	set mets.laba_669;
	keep BID &variableName VALUEIS;
	if &variableName > 9 then VALUEIS = 'too high';
	else if &variableName < 6 then VALUEIS = 'too low';
run;

proc print data = &analyte;
	var BID &variableName VALUEIS;
	where &variableName is not missing and (&variableName <6 or &variableName > 9);
run;

%LET analyte = HDL;
%LET variableName = LABA5;

title "Values Outside the Reasonable Range for &analyte";

data &analyte;
	set mets.laba_669;
	keep BID &variableName VALUEIS;
	if &variableName < 25 then VALUEIS = 'too low';
run;

proc print data = &analyte;
	var BID &variableName VALUEIS;
	where &variableName is not missing and (&variableName <25);
run;

%LET analyte = LDL;
%LET variableName = LABA6;

title "Values Outside the Reasonable Range for &analyte";

data &analyte;
	set mets.laba_669;
	keep BID &variableName VALUEIS;
	if &variableName > 200 then VALUEIS = 'too high';
run;

proc print data = &analyte;
	var BID &variableName VALUEIS;
	where &variableName is not missing and (&variableName >200);
run;

ods pdf close;

