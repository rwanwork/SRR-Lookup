SRR-Lookup
==========


Introduction
------------

The National Centre for Biotechnology Information ([NCBI](https://www.ncbi.nlm.nih.gov/)) maintains the Sequence Read Archive ([SRA](https://www.ncbi.nlm.nih.gov/sra)), a repository for next generation sequencing (NGS) data.  Runs of NGS data are each assigned an accession number that is prefixed with SRR.  These runs are in turn associated with other information such as the Series (GSE).

This repository contains a simple Perl script that maps SRR accession number to other pieces of information.  All of this is contained in a flat file at [ftp://ftp.ncbi.nlm.nih.gov/sra/reports/Metadata/SRA_Accessions.tab](ftp://ftp.ncbi.nlm.nih.gov/sra/reports/Metadata/SRA_Accessions.tab) that is periodically updated.  As of November 2018, the size of this file is 4.4 GB.  Thus, this script merely makes multiple passes over this file.

As an aside, there are alternatives to this script, including using NCBI's `esearch` and `efetch` utilities, as described [here](https://www.ncbi.nlm.nih.gov/books/NBK25499/).  This Perl script is merely an alternative.


Preliminaries
-------------

Download the [file](ftp://ftp.ncbi.nlm.nih.gov/sra/reports/Metadata/SRA_Accessions.tab) of SRA accessions and store it in the current directory.


Requirements
------------

| Software               | Version | Required? | Ubuntu package  | Anaconda package|
| ---------------------- | ------- | --------- | --------------- | --------------- |
|Perl                    | 5.26.1  | Yes       |perl             |perl             |
|AppConfig (Perl module) | 1.71-2  | Yes       |libappconfig-perl|perl-appconfig   |

Experiments with this software have been successfully run on Ubuntu 18.04.

The versions represent the tools used during software development or when running the script.  The software requirements are quite modest and lower versions should work without problems.


Organization
------------

After cloning this repository from GitHub, the following directory structure is obtained:

    ├── Examples                Examples to test SRR-Lookup against.
    │   ├── *                   Files related to a very simple test case.
    ├── LICENSE                 Software license (GNU GPL v3).
    ├── srr-lookup.pl           The Perl main script.
    └── README.md               This README file.


Running examples
----------------

### test

In the Examples/ directory is a small test case that includes a set of SRR accession numbers and a tiny subset of the SRA_Accessions file.  The script can be run on this example by typing the following:

  * `cat Examples/test.txt | perl ./srr-lookup.pl --sra Examples/SRA_Accessions-small.tab`

Output is sent to standard out in tab-separated format and should look like this:

    Run	Experiment	GSM	Submission	Sample	Study	Biosample	Bioproject	Replacement
    SRR6795732	SRX3754750	GSM3024344	SRA663352	SRS3010770	SRP133768	SAMN08628238	PRJNA436570	-
    SRR6795733	SRX3754751	GSM3024345	SRA663352	SRS3010769	SRP133768	SAMN08628237	PRJNA436570	-
    SRR6795734	SRX3754752	GSM3024346	SRA663352	SRS3010771	SRP133768	SAMN08628236	PRJNA436570	-
    SRR6795735	SRX3754753	GSM3024347	SRA663352	SRS3010773	SRP133768	SAMN08628235	PRJNA436570	-
    SRR6795736	SRX3754754	GSM3024348	SRA663352	SRS3010772	SRP133768	SAMN08628234	PRJNA436570	-
    SRR6795737	SRX3754755	GSM3024349	SRA663352	SRS3010774	SRP133768	SAMN08628233	PRJNA436570	-
    SRR6795738	SRX3754756	GSM3024350	SRA663352	SRS3010775	SRP133768	SAMN08628232	PRJNA436570	-
    SRR6795739	SRX3754757	GSM3024351	SRA663352	SRS3010776	SRP133768	SAMN08628231	PRJNA436570	-


About SRR-Lookup
----------------

This software was written for during the preparation for the following [manuscript](https://www.ncbi.nlm.nih.gov/pubmed/29731431):

E. van der Wal, P. Herrero-Hernandez, R. Wan, M. Broeders, S. L. M. in 't Groen, T. J. M. van Gestel, W. F. J. van IJcken, T. H. Cheung, A. T. van der Ploeg, G. J. Schaaf, W. W. M. P. Pijnappel. Large-Scale Expansion of Human iPSC-Derived Skeletal Muscle Cells for Disease Modeling and Cell-Based Therapeutic Strategies. Stem Cell Report, 10(6): 1975-1990, 2018.

It was implemented by Raymond Wan as part of my employment at the 
Hong Kong University of Science and Technology.  My contact details:

     E-mails:  rwan.work@gmail.com 
               OR 
               raymondwan@ust.hk

My homepage is [here](http://www.rwanwork.info/).

The latest version of SRR-Lookup can be downloaded from [GitHub](https://github.com/rwanwork/SRR-Lookup).

If you have any information about bugs, suggestions for the documentation or just have some general comments, feel free to write to one of the above addresses.


Copyright and License
---------------------

     SRR-Lookup (SRR Lookup)
     Copyright (C) 2018 by Raymond Wan

SRR-Lookup is distributed under the terms of the GNU General
Public License (GPL, version 3 or later) -- see the file LICENSE for details.

Permission is granted to copy, distribute and/or modify this document under the
terms of the GNU Free Documentation License, Version 1.3 or any later version
published by the Free Software Foundation; with no Invariant Sections, no
Front-Cover Texts and no Back-Cover Texts. A copy of the license is included
with the archive as LICENSE.

Thursday, November 1, 2018

