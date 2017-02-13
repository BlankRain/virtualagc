### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	RESTART_TABLES_AND_RESTARTS_ROUTINE.agc
## Purpose:	A module for revision 0 of BURST120 (Sunburst).
##		It is part of the source code for the Lunar Module's (LM)
##		Apollo Guidance Computer (AGC) for Apollo 5.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2016-09-30 RSB	Created draft version.
##		2016-10-04 RSB	Transcribed.
##		2016-10-30 MAS	Some spelling corrections and a missing 2CADR symbol.
##		2016-11-01 RSB	Typos.
##		2016-11-02 RSB	More typos.
##		2016-11-03 RSB	Added a bunch of SBANK= workarounds.
##		2016-12-03 RSB  Used octopus/ProoferComments to proof comments.
##				Fixed 17 errors in 15 pages, but process isn't
##				complete.
##		2016-12-05 RSB	Fixed more comments with octopus/ProoferComments;
##				comment-proofing process complete.
##		2017-02-08 RSB	Comment-text fixes identified while proofing Artemis 72.

## Page 62
# RESTART TABLES
#  DO NOT REMOVE FROM THE BEGINNING OF THIS BANK
# ------------------
#
# THERE ARE TWO FORMS OF RESTART TABLES FOR EACH GROUP.  THEY ARE KNOWN AS THE EVEN RESTART TABLES AND THE ODD
# RESTART TABLES.  THE ODD TABLES HAVE ONLY ONE ENTRY OF THREE LOCATIONS WHILE THE EVEN TABLES HAVE TWO ENTRIES
# EACH USING THREE LOCATIONS.  THE INFORMATION AS TO WHETHER IT IS A JOB, WAITLIST, OR A LONGCALL IS GIVEN BY THE
# WAY THINGS ARE PUT IN TO THE TABLES.
#      A JOB HAS ITS PRIORITY STORED IN PRDTTAB OF THE CORRECT PHASE SPOT WITH ITS 2CADR IN THE CADRTAB. FOR
# EXAMPLE,
#
#		5.7SPOT		OCT	23000
#				2CADR	SOMEJOB
#
# A RESTART OF GROUP 5 WITH PHASE SEVEN WOULD THEN CAUSE SOMEJOB TO BE RESTARTED WITH A PRIORITY OF 23.
#
# A LONGCALL HAS ITS GENADR OF ITS 2CADR STORED NEGATIVELY AND ITS BBCON STORED POSITIVELY.  IN ITS PRDTTAB IS
# PLACED THE LOCATION OF A DP REGISTER THAT CONTAINS THE DELTA TIME THAT LONGCALL HAD BEEN ORIGINALLY STARTED
# WITH.  EXAMPLE,
#
#		3.6SPOT		GENADR	DELTAT
#			       -GENADR	LONGTASK
#				BBCON	LONGTASK

#				OCT	31000
#				2CADR	JOBAGAIN
#
# THIS WOULD START UP LONGTASK AT THE APPROPRIATE TIME, OR IMMEDIATELY IF THE TIME HAD ALREADY PASSED.  IT SHOULD
# BE NOTED THAT IF DELTAT IS IN A SWITCHED E BANK, THIS INFORMATOIN SHOULD BE IN THE BBCON OF THE 2CADR OF THE
# TASK.  FROM ABOVE, WE SEE THAT THE SECOND PART OF THIS PHASE WOULD BE STARTED AS A JOB WITH A PRIORITY OF 31.
#
# WAITLIST CALLS ARE IDENTIFIED BY THE FACT THAT THEIR 2CADR IS STORED NEGATIVELY.  IF PRDTTAB OF THE PHASE SPOT
# IS POSITIVE, THEN IT CONTAINS THE DELTA TIME, IF PRDTTAB IS NEGATIVE THEN IT IS THE -GENADR OF AN ERASABLE
# LOCATION CONTAINING THE DELTA TIME, THAT IS, THE TIME IS STORED INDIRECTLY.  IT SHOULD BE NOTED AS ABOVE, THAT
# IF THE TIME IS STORED INDIRECTLY, THE BBCON MUST CONTAIN THE NECESSARY E BANK INFORMATION IF APPLICABLE.  WITH
# WAITLIST WE HAVE ONE FURTHER OPTION, IF -0 IS STORED IN PRDTTAB, IT WILL CAUSE AN IMMEDIATE RESTART OF THE
# TASK.  EXAMPLES,
#
#				OCT	77777		THIS WILL CAUSE AN IMMEDIATE RESTART
#				-2CADR	ATASK		OF THE TASK :ATASK:
#	
#				DEC	200		IF THE TIME OF THE 2 SECONDS SINCE DUMMY
#				-2CADR	DUMMY		WAS PUT ON WAITLIST IS UP, IT WILL BEGIN
#							IN 10 MS, OTHERWISE IT WILL BEGIN WHEN
#							IT NORMALLY WOULD HAVE BEGUN.
#
#				-GENADR	DTIME		WHERE DTIME CONTAINS THE DELTA TIME
#				-2CADR	TASKTASK	OTHERWISE THIS IS AS ABOVE
#
# ***** NOW THE TABLES THEMSELVES *****
## Page 63

PRDTTAB		EQUALS	24000			# USED TO FIND THE PRIORITY OR DELTA TIME
CADRTAB		EQUALS	24001			# THIS AND THE NEXT LOCATION (RELATIVE)
						#     CONTAIN THE RESTART CADR
				
		BANK	06
		EBANK=	LST1			# GOPROG MUST SWITCH IN THIS EBANK
		
PHS2CADR	GENADR	PHSPART2		# DO NOT REMOVE THE FOLLOWING 6 LOCATIONS
PRT2CADR	GENADR	GETPART2		#     FROM BEGINNING OF BANK
LGCLCADR	GENADR	LONGCALL
FVACCADR	GENADR	FINDVAC
WTLTCADR	GENADR	WAITLIST
RTRNCADR	TC	SWRETURN
				
1.2SPOT		OCT	10000			# TEMPORARY ENTRY TO ESTABLISH TABLE
		EBANK=	LST1
		2CADR	DUMMYJOB
		
		OCT	10000
		EBANK=	LST1
		2CADR	DUMMYJOB
		
# ANY MORE GROUP 1.EVEN RESTART VALUES SHOULD GO HERE

## The following line was not present in the original program.
		SBANK=	LOWSUPER
1.3SPOT		DEC	195
		EBANK=	ETHROT
	       -2CADR	PCNTOVER
		
# ANY MORE GROUP 1.ODD RESTART VALUES SHOULD GO HERE

2.2SPOT		OCT	20000
		EBANK=	TDEC
		2CADR	11REDO2
		
		GENADR	TDECTEMP
	       -GENADR	TIG11-30
	        EBANK=	TDEC
	        BBCON	TIG11-30

2.4SPOT		DEC	7000
		EBANK=	TDEC
	       -2CADR	POSTKALC
	       
	        OCT	20000
	        EBANK=	TDEC
	        2CADR	CALLKALC

# ANY MORE GROUP 2.EVEN RESTART VALUES SHOULD GO HERE
## Page 64

2.3SPOT		OCT	77777		# MISSION SCHEDULING PACKAGE TO SET UP
		EBANK=	LST1
	       -2CADR	REDOMDUE

## The following line was not present in the original code.
		SBANK=
2.5SPOT		DEC	5500
		EBANK=	TDEC
	       -2CADR	SIVB2
		
2.7SPOT		OCT	77777
		EBANK=	TDEC
	       -2CADR	SBORBA

2.11SPOT	DEC	400
		EBANK=	TDEC
	       -2CADR	SBORB8

2.13SPOT       -GENADR	DT-LIFT
		EBANK=	TGRR
	       -2CADR   LIFTOFF
	       
## The following line was not present in the original code.
		SBANK=	LOWSUPER
2.15SPOT        DEC     700
                EBANK=  TDEC
               -2CADR   TIG4-41
               
2.17SPOT        DEC     200
                EBANK=  TDEC
               -2CADR   TIG4-34

2.21SPOT        OCT     77777
                EBANK=  TDEC
               -2CADR   DPSTART

2.23SPOT	DEC	750	
		EBANK=	TDEC
	       -2CADR	TIG11

2.25SPOT	OCT	77777
		EBANK=	TDEC
	       -2CADR	MP11HOLD

2.27SPOT	DEC	100
		EBANK=	TDEC
	       -2CADR	MP11OUT

2.31SPOT	OCT	20000	
		EBANK=	TDEC
	        2CADR	11REDO1

2.33SPOT	OCT	20000
		EBANK=	TDEC
## Page 65
	        2CADR	INTRTN

2.35SPOT	GENADR	TDECTEMP
	       -GENADR	TIG11-30
		EBANK=	TDEC
	        BBCON	TIG11-30

2.37SPOT	OCT	77777
		EBANK=	TDEC
	       -2CADR	MOVENDX

2.41SPOT	DEC	1000	
		EBANK=	TDEC
	       -2CADR	CCSMPRET

2.43SPOT	DEC	7000
		EBANK=	TDEC
	       -2CADR	POSTKALC

2.45SPOT	DEC	1100
		EBANK=	TDEC
	       -2CADR	182LMP

2.47SPOT	DEC	5000
		EBANK=	TDEC
	       -2CADR	228LMP

2.51SPOT	DEC	50
		EBANK=	AVGEXIT
	       -2CADR	9ULLOFF

2.53SPOT	DEC	250
		EBANK=	AVGEXIT
	       -2CADR	9EDBATT

2.55SPOT       -GENADR	TDECTEMP
		EBANK=	TDEC
	       -2CADR	CUTOFF

2.57SPOT	DEC	500
		EBANK=	TDEC
	       -2CADR	87LMP

## The following line was not present in the original code.
		SBANK=
2.61SPOT	OCT	77777
		EBANK=	TGRR
	       -2CADR	REDO2.61

2.63SPOT	OCT	77777
		EBANK=	TGRR
	       -2CADR	REDO2.63

## Page 66
# ANY MORE GROUP 2.0DD RESTART VALUES SHOULD GO HERE

3.2SPOT		EQUALS	1.2SPOT

# ANY MORE GROUP 3.EVEN RESTART VALUES SHOULD GO HERE

## The following line was not present in the original code.
		SBANK=	LOWSUPER
3.3SPOT		DEC	50
		EBANK=	TDEC
	       -2CADR	ABMON

3.5SPOT		OCT	77777
		EBANK=	TDEC
	       -2CADR	TUMTASK

## The following line was not present in the original code.
		SBANK=
3.7SPOT		GENADR	DT-LETJT
	       -GENADR	POSTLET	
		EBANK=	TGRR
	        BBCON	POSTLET

## The following line was not present in the original code.
		SBANK=	LOWSUPER
3.11SPOT	OCT	77777
		EBANK=	MTIMER4
	       -2CADR	REDO3.11

3.13SPOT	DEC	100
		EBANK=	MTIMER4
	       -2CADR	MMAINT

3.15SPOT	DEC	1200
		EBANK=	TDEC
	       -2CADR	NEXLMP

3.17SPOT	DEC	200
		EBANK=	TDEC
	       -2CADR	NEXLMP1

3.21SPOT	DEC	100
		EBANK=	TDEC
	       -2CADR	NEXLMP2

3.23SPOT	DEC	6000
		EBANK=	TDEC
	       -2CADR	NEXLMP3

3.25SPOT	DEC	100
		EBANK=	TDEC
	       -2CADR	MP11TASK

3.27SPOT	OCT	20000
		EBANK=	XSM
	       	2CADR	REDO3.27

## Page 67
## The following line was not present in the original code.
		SBANK=
3.31SPOT	OCT	77777
		EBANK=	TTGO
	       -2CADR	DUMMY13

3.33SPOT	DEC	2500
		EBANK=	TTGO
	       -2CADR	TRMDMY13

# ANY MORE GROUP 3.0DD RESTART VALUES SHOULD GO HERE

4.2SPOT		EQUALS	1.2SPOT

# ANY MORE GROUP 4.EVEN RESTART VALUES SHOULD GO HERE

## The following line was not present in the original code.
		SBANK=	LOWSUPER
4.3SPOT		OCT	30000	
		EBANK=	ETHROT
	        2CADR	ACCLJOB

## The following line was not present in the original code.
		SBANK=
4.5SPOT		OCT	10000	
		EBANK=	RATEINDX
	        2CADR	COLDSOAK

4.7SPOT		OCT	15000	
		EBANK=	TGRR
	        2CADR	MP2JOB

## The following line was not present in the original code.
		SBANK=	LOWSUPER
4.11SPOT	OCT	25000
		EBANK=	ETHROT
	        2CADR	PCNTJOB

4.13SPOT	GENADR	TDECTEMP
	       -GENADR	TIG9-66
		EBANK=	TDEC
	        BBCON	TIG9-66

4.15SPOT	OCT	27000
		EBANK=	TDEC
	        2CADR	ORBINTJB

4.17SPOT       -GENADR	TDECTEMP +1
		EBANK=	AVGEXIT
	       -2CADR	TIG9-0

# ANY MORE GROUP 4.0DD RESTART VALUES SHOULD GO HERE

5.2SPOT		OCT	21000
		EBANK=	RAVEGON
	        2CADR	NORMLIZE

		DEC	200
## Page 68
		EBANK=	DVCNTR
	       -2CADR	REREADAC

5.4SPOT		DEC	200
		EBANK=	BMEMORY
	       -2CADR	PREREAD
	       
## The following line was not present in the original code.
		SBANK=
	        OCT	32000
	        EBANK=	LST1
	        2CADR	LASTBIAS

## The following line was not present in the original code.
		SBANK=	LOWSUPER
5.6SPOT		DEC	200
		EBANK=	DVCNTR
	       -2CADR	REREADAC
	       
	       	OCT	20000
	       	EBANK=	DVCNTR
	       	2CADR	SERVICER
	       	
# ANY MORE GROUP 5.EVEN RESTART VALUES SHOULD GO HERE

5.3SPOT		DEC	200
		EBANK=	DVCNTR
	       -2CADR	REREADAC

5.5SPOT		2DEC	0		# 5.5 SPOT NOT USED

		DEC	0
		
5.7SPOT		OCT	20000	
		EBANK=	XSM
	        2CADR	RSTGTS1

5.11SPOT	OCT	77777
		EBANK=	XSM
	       -2CADR	ALLOOP1

5.13SPOT	OCT	20000
		EBANK=	XSM
	        2CADR 	WTLISTNT

5.15SPOT	OCT	20000
		EBANK=	XSM
	        2CADR	NOCHORLD

5.17SPOT	OCT	20000
		EBANK=	XSM
	        2CADR	GEOSTRT4

5.21SPOT	OCT	20000
## Page 69
		EBANK=	XSM
	        2CADR	ALFLT1

5.23SPOT	OCT	77777
		EBANK=	XSM
	       -2CADR	SPECSTS

5.25SPOT	OCT	20000
		EBANK=	XSM
	        2CADR	RESTAIER

5.27SPOT	DEC	400
		EBANK=	DVTOTAL
	       -2CADR	PREREAD

5.31SPOT	OCT	77777
		EBANK=	NEGXDV
	       -2CADR	REDO5.31

5.33SPOT	OCT	77777
		EBANK=	DVCNTR
	       -2CADR	PREREAD

5.35SPOT       -GENADR	RSDTTEMP
		EBANK=	DVTOTAL
	       -2CADR	PREREAD

## The following line was not present in the original code.
		SBANK=
5.37SPOT	OCT	77777
		EBANK=	TGRR
	       -2CADR	SETPIPDT

# ANY MORE GROUP 5.ODD RESTART VALUES SHOULD GO HERE

6.2SPOT		DEC	500
		EBANK=	DNTMBUFF
	       -2CADR	DAPOFF
	       
	        OCT	30000
	        EBANK=	DNTMBUFF
	        2CADR	TGOFF

# ANY MORE GROUP 6.EVEN RESTART VALUES SHOULD GO HERE

6.3SPOT		DEC	500
		EBANK=	DNTMBUFF
	       -2CADR   DAPOFF

6.5SPOT		OCTAL	33000
		EBANK=	STBUFF
	        2CADR	I=4.CONT

## Page 70
6.7SPOT		OCT	30000
		EBANK=	STBUFF
	        2CADR	UPQUITRM

## The following line was not present in the original code.
		SBANK=	LOWSUPER
6.11SPOT       -GENADR	DAPOFFDT
		EBANK=	DNTMBUFF
	       -2CADR	11DAPOFF

# ANY MORE GROUP 6.0DD RESTART VALUES SHOULD GO HERE

SIZETAB		GENADR	1.2SPOT	-24006
		GENADR	1.3SPOT	-24004
		GENADR	2.2SPOT	-24006
		GENADR	2.3SPOT	-24004
		GENADR	3.2SPOT	-24006
		GENADR	3.3SPOT	-24004
		GENADR	4.2SPOT	-24006
		GENADR	4.3SPOT	-24004
		GENADR	5.2SPOT	-24006
		GENADR	5.3SPOT	-24004
		GENADR	6.2SPOT	-24006
		GENADR	6.3SPOT	-24004
		
## Page 71
RESTARTS	CA	MPAC +5		# GET GROUP NUMBER -1
		DOUBLE			# SAVE FOR INDEXING
		TS	TEMP2G

		CA	FVACCADR	# LET:S ASSUME THIS IS A JOB, THIS WILL
		TS	GOLOC	-1	# SAVE US A COUPLE OF LOCATIONS, BUT NOT 
					# NECESSARIALY ANY TIME  - SO BE IT -

		CA	PHS2CADR	# SET UP EXIT IN CASE IT IS AN EVEN
		TS	TEMPSWCH	# TABLE PHASE

		CA	RTRNCADR	# TO SAVE TIME ASSUME IT WILL GET NEXT
		TS	GOLOC +2	# GROUP AFTER THIS

		CA	TEMPPHS
		MASK	OCT1400
		CCS	A		# IS IT A VARIABLE OR TABLE RESTART
		TCF	ITSAVAR		# IT;S A VARIABLE RESTART

GETPART2	CCS	TEMPPHS		# IS IT AN X.1 RESTART
		CCS	A
		TCF	ITSATBL		# NO, ITS A TABLE RESTART

		CA	PRIO14		# IT IS AN X.1 RESTART, THEREFORE START
		TC	FINDVAC		# THE DISPLAY RESTART JOB
## The following line was not present in the original code.
		SBANK=
		EBANK=	LST1
		2CADR	INITDSP
## The following line was not present in the original code.
		SBANK=	LOWSUPER

		TC	RTRNCADR	# FINISHED WITH THIS GROUP, GET NEXT ONE

INITDSP		EQUALS	ENDOFJOB

ITSAVAR		MASK	OCT1400		# IS IT TYPE B ?
		CCS	A
		TCF	ITSLIKEB	# YES, IT IS TYPE B

		EXTEND			# STORE THE JOB (OR TASK) 2CADR FOR EXIT
		NDX	TEMP2G
		DCA	PHSNAME1
		DXCH	GOLOC

		CA	TEMPPHS		# SEE IF THIS IS A JOB, TASK, OR A LONGCAL
		MASK	OCT7
		AD	MINUS2
		CCS	A
		TCF	ITSLNGCL	# ITS A LONGCALL
		
OCT37776	OCT	37776		# CANT GET HERE

## Page 72
		TCF	ITSAWAIT

		TCF	ITSAJOB		# ITS A JOB

ITSAWAIT	CA	WTLTCADR	# SET UP WAITLIST CALL
		TS	GOLOC -1

		NDX	TEMP2G		# DIRECTLY STORED
		CA	PHSPRDT1
TIMETEST	CCS	A		# IS IT AN IMMEDIATE RESTART
		INCR	A		# NO.
		TCF	FINDTIME	# FIND OUT WHEN IT SHOULD BEGIN

		TCF	ITSINDIR	# STORED INDIRECTLY

		TCF	IMEDIATE	# IT WANTS AN IMMEDIATE RESTART

# ***** THIS MUST BE IN FIXED FIXED *****

		BLOCK	02
ITSINDIR	LXCH	GOLOC +1	# GET THE CORRECT E BANK IN CASE THIS IS
		LXCH	BB		# SWITCHED ERRASIBLE

		NDX	A		# GET THE TIME INDIRECTLY
		CA	1

		LXCH	BB		# RESTORE THE BB AND GOLOC
		LXCH	GOLOC +1

		TCF	FINDTIME	# FIND OUT WHEN IT SHOULD BEGIN

# ***** YOUB MAY RETURN TO SWITCHED FIXED *****

		BANK	06
FINDTIME	COM			# MAKE NEGATIVE SINCE IT WILL BE SUBTRACTD
		TS	L		# AND SAVE
		NDX	TEMP2G
		CS	TBASE1
		EXTEND
		SU	TIME1
		CCS	A
		COM
		AD	OCT37776
		AD	ONE
		AD	L
		CCS	A
		CA	ZERO
		TCF	+2
		TCF	+1
IMEDIATE	AD	ONE
## Page 73
		TC	GOLOC -1
ITSLIKEB	CA	RTRNCADR	# TYPE B,             SO STORE RETURN IN
		TS	TEMPSWCH	# TEMPSWCH IN CASE OF AN EVEN PHASE

		CA	PRT2CADR	# SET UP EXIT TO GET TABLE PART OF THIS
		TS	GOLOC +2	# VARIABLE TYPE OF PHASE

		CA	TEMPPHS		# MAKE THE PHASE LOOK RIGHT FOR THE TABLE
		MASK	OCT177		# PART OF THIS VARIABLE PHASE
		TS	TEMPPHS

		EXTEND
		NDX	TEMP2G		# OBTAIN THE JOB;S 2CADR
		DCA	PHSNAME1
		DXCH	GOLOC

ITSAJOB		NDX	TEMP2G		# NOW ADD THE PRIORITY AND LET;S GO
		CA	PHSPRDT1
		TC	GOLOC -1
		
ITSATBL		TS	CYR		# FIND OUT IF THE PHASE IS ODD OR EVEN
		CCS	CYR
		TCF	+1		# IT;S EVEN
		TCF	ITSEVEN

		CA	RTRNCADR	# IN CASE THIS IS THE SECOND PART OF A
		TS	GOLOC +2	# TYPE B RESTART, WE NEED PROPER EXIT

		CA	TEMPPHS		# SET UP POINTER FOR FINDING OUR PLACE IN
		TS	SR		# THE RESTART TABLES
		AD	SR
		NDX	TEMP2G
		AD	SIZETAB +1
		TS	POINTER

CONTBL2		EXTEND			# FIND OUT WHAT;S IN THE TABLE
		NDX	POINTER
		DCA	CADRTAB		# GET THE 2CADR

		LXCH	GOLOC +1	# STORE THE BB INFORMATION

		CCS	A		# IS IT A JOB OR IS IT TIMED
		INCR	A		# POSITIVE, MUST BE A JOB
		TCF	ITSAJOB2

		INCR	A		# MUST BE EITHER A WAITLIST OR LONGCALL
		TS	GOLOC		# LET-S STORE THE CORRECT CADR

		CA	WTLTCADR	# SET UP OUR EXIT TO WAITLIST
		TS	GOLOC -1

## Page 74
		CA	GOLOC +1	# NOW FIND OUT IF IT IS A WAITLIST CALL
		MASK	BIT10		# THIS SHOULD BE ONE IF WE HAVE -BB
		CCS	A		# FOR THAT MATTER SO SHOULD BE BITS 9,8,7,
					# 6,5, AND LAST BUT NOT LEAST (PERHAPS NOT
					# IN IMPORTANCE ANYWAY.  BIT 4
		TCF	ITSWTLST	# IT IS A WAITLIST CALL

		NDX	POINTER		# OBTAIN THE ORIGINAL DELTA T
		CA	PRDTTAB		# ADDRESS FOR THIS LONGCALL

		TCF	ITSLGCL1	# NOW GO GET THE DELTA TIME

# ***** THIS MUST BE IN FIXED FIXED *****

		BLOCK	02
ITSLGCL1	LXCH	GOLOC +1	# OBTAIN THE CORRECT E BANK
		LXCH	BB
		LXCH	GOLOC +1	# AND PRESERVE OUR E AND F BANKS

		EXTEND			# GET THE DELTA TIME
		NDX	A
		DCA	0

		LXCH	GOLOC +1	# RESTORE OUR E AND F BANK
		LXCH	BB		# RESTORE THE TASKS E AND F BANKS
		LXCH	GOLOC +1	# AND PRESERVE OUR L
		TCF	ITSLGCL2	# NOT LET:S PROCESS THIS LONGCALL

# ***** YOUB MAY RETURN TO SWITCHED FIXED *****

		BANK	06
ITSLGCL2	DXCH	LONGTIME

		EXTEND			# CALCULATE TIME LEFT
		DCS	TIME2
		DAS	LONGTIME
		EXTEND
		DCA	LONGBASE
		DAS	LONGTIME

		CCS	LONGTIME	# FIND OUT HOW THIS SHOULD BE RESTARTED
		TCF	LONGCLCL
		TCF	+2
		TCF	IMEDIATE -3
		CCS	LONGTIME +1
		TCF	LONGCLCL
		NOOP			# CAN:T GET HERE   *********
		TCF	IMEDIATE -3
		TCF	IMEDIATE

## Page 75
LONGCLCL	CA	LGCLCADR	# WE WILL GO TO LONGCALL
		TS	GOLOC -1

		EXTEND			# PREPARE OUR ENTRY TO LONGCALL
		DCA	LONGTIME
		TC	GOLOC -1

ITSLNGCL	CA	WTLTCADR	# ASSUME IT WILL GO TO WAITLIST
		TS	GOLOC -1

		NDX	TEMP2G
		CS	PHSPRDT1	# GET THE DELTA T ADDRESS

		TCF	ITSLGCL1	# NOW GET THE DELTA TIME

ITSWTLST	CS	GOLOC +1	# CORRECT THE BBCON INFORMATION
		TS	GOLOC +1

		NDX	POINTER		# GET THE DT AND FIND OUT IF IT WAS STORED
		CA	PRDTTAB		# DIRECTLY OR INDIRECTLY

		TCF	TIMETEST	# FIND OUT HOW THE TIME IS STORED

ITSAJOB2	XCH	GOLOC		# STORE THE CADR

		CA	FVACCADR	# STORE TC FINDVAC.
		TS	GOLOC	-1

		NDX	POINTER		# ADD THE PRIORITY AND LET;S GO
		CA	PRDTTAB

		TC	GOLOC	-1

ITSEVEN		CA	TEMPSWCH	# SET UP FOR EITHER THE SECOND PART OF THE
		TS	GOLOC +2	# TABLE, OR A RETURN FOR THE NEXT GROUP

		NDX	TEMP2G		# SET UP POINTER FOR OUR LOCATION WITHIN
		CA	SIZETAB		# THE TABLE
		AD	TEMPPHS		# THIS MAY LOOK BAD BUT LET;S SEE YOU DO
		AD	TEMPPHS		# BETTER IN TIME OR NUMBERR OF LOCATIONS
		AD	TEMPPHS
		TS	POINTER

		TCF	CONTBL2		# NOW PROCESS WHAT IS IN THE TABLE

PHSPART2	CA	THREE		# SET THE POINTER FOR THE SECOND HALF OF
		ADS	POINTER		# THE TABLE

		CA	RTRNCADR	# THIS WILL BE OUR LAST TIME THROUGH THE
		TS	GOLOC +2	# EVEN TABLE, SO AFTER IT GET THE NEXT
## Page 76					
					# GROUP
		TCF	CONTBL2		# SO LET;S GET THE SECOND ENTRY IN THE TBL

TEMPPHS		EQUALS	MPAC
TEMP2G		EQUALS	MPAC +1
POINTER		EQUALS	MPAC +2
TEMPSWCH	EQUALS	MPAC +3
GOLOC		EQUALS	VAC5 +20D
MINUS2		EQUALS	NEG2
OCT177		EQUALS	LOW7

# SETRSTRT - RESTART FLAG UP OR DOWN DEPENDING ON CONTENTS OF ERASABLE RSTRTWRD.

# CALLING SEQUENCE
#               CAF	BITX		USE BIT CORRESPONDING TO MISS PHASE NUM.
#		TC	SETRSTRT

		BLOCK	02

SETRSTRT	LXCH	Q
		MASK	RSTRTWRD
		EXTEND
		BZF	+4
		
		TC	FLAG1UP		# USER MISSION PHASE IS RESTARTABLE
		OCT	04000
		TC	L
		
 +4		TC	FLAG1DWN	# USER MISSION PHASE NOT RESTARTABLE
 		OCT	04000
 		TC	L
