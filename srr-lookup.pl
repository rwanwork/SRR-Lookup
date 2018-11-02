#!/usr/bin/perl
#  Author:  Raymond Wan
#  Organizations:  Division of Life Science, 
#                  Hong Kong University of Science and Technology
#  Copyright (C) 2018, Raymond Wan, All rights reserved.

use warnings;
use strict;
use diagnostics;

use AppConfig;
use AppConfig::Getopt;
use Pod::Usage;


########################################
##  Important constants
########################################

my %srr;
my %srr_to_submission;
my %srr_to_experiment;
my %srr_to_sample;
my %srr_to_study;
my %srr_to_biosample;
my %srr_to_bioproject;
my %srr_to_replacedby;

my %experiments_lookup;
my %experiment_to_gsm;

my %submissions_lookup;
my %submission_to_gse;


########################################
##  Important variables
########################################

##  Arguments provided by the user
my $verbose_arg = 0;
my $sra_arg = "";


########################################
##  Process arguments
########################################
##  Create AppConfig and AppConfig::Getopt objects
my $config = AppConfig -> new ({
           GLOBAL => {
             DEFAULT => undef,     ##  Default value for new variables
           }
  });

my $getopt = AppConfig::Getopt -> new ($config);

$config -> define ("verbose!", {
           ARGCOUNT => AppConfig::ARGCOUNT_NONE
  });                        ##  Verbose output
$config -> define ("sra", {
           ARGCOUNT => AppConfig::ARGCOUNT_ONE,
           ARGS => "=s"
  });                        ##  File of SRA accessions
$config -> define ("help!", {
           ARGCOUNT => AppConfig::ARGCOUNT_NONE
  });                        ##  Help screen

##  Process the command-line options
$config -> getopt ();


########################################
##  Validate the settings
########################################

if ($config -> get ("help")) {
  pod2usage (-verbose => 0);
  exit (1);
}

$verbose_arg = 0;
if ($config -> get ("verbose")) {
  $verbose_arg = 1;
}

if (!defined ($config -> get ("sra"))) {
  printf STDERR "EE\tThe option --sra requires the path to the file of SRA accessions.\n";
  exit (1);
}
$sra_arg = $config -> get ("sra");


########################################
##  Store the list of reads
########################################

while (<STDIN>) {
  my $read_acc = $_;
  chomp ($read_acc);
  
  if ($read_acc !~ /^SRR/) {
    printf STDERR "WW\tThe read %s is not valid as it does not start with SRR.\n";
  }
  
  $srr{$read_acc} = $read_acc;
}


########################################
##  Perform multiple passes over the accession file
########################################

##  First pass -- get all the information that we can get using the read names and type RUN
my $fn = $sra_arg;
open (my $fp, "<", $fn) or die "EE\tCould not find $fn.\n";
while (<$fp>) {
  my $line = $_;
  chomp ($line);
  
  my ($accession, $submission, $status, $updated, $published, $received, $type, $center, $visibility, $alias, $experiment, $sample, $study, $loaded, $spots, $bases, $md5sum, $biosample, $bioproject, $replacedby) = split /\t/, $line;
  if ($type ne "RUN") {
    next;
  }

  if (defined ($srr{$accession})) {
    my $key = $accession;
    
    $submissions_lookup{$submission} = $submission;
    $experiments_lookup{$experiment} = $experiment;

    $srr_to_submission{$key} = $submission;
    $srr_to_experiment{$key} = $experiment;
    $srr_to_sample{$key} = $sample;
    $srr_to_study{$key} = $study;
    $srr_to_biosample{$key} = $biosample;
    $srr_to_bioproject{$key} = $bioproject;
    $srr_to_replacedby{$key} = $replacedby;
  }
}
close ($fp);


##  Second pass -- get all the information that we can using the type EXPERIMENT
open ($fp, "<", $fn) or die "EE\tCould not find $fn.\n";
while (<$fp>) {
  my $line = $_;
  chomp ($line);
  
  my ($accession, $submission, $status, $updated, $published, $received, $type, $center, $visibility, $alias, $experiment, $sample, $study, $loaded, $spots, $bases, $md5sum, $biosample, $bioproject, $replacedby) = split /\t/, $line;
  if ($type ne "EXPERIMENT") {
    next;
  }

  if (defined ($experiments_lookup{$accession})) {
    my $key = $accession;
    
    $experiment_to_gsm{$key} = $alias;
  }
}
close ($fp);


##  Third pass -- get all the information that we can using the type STUDY
open ($fp, "<", $fn) or die "EE\tCould not find $fn.\n";
while (<$fp>) {
  my $line = $_;
  chomp ($line);
  
  my ($accession, $submission, $status, $updated, $published, $received, $type, $center, $visibility, $alias, $experiment, $sample, $study, $loaded, $spots, $bases, $md5sum, $biosample, $bioproject, $replacedby) = split /\t/, $line;
  if ($type ne "STUDY") {
    next;
  }

#   if (defined ($study_lookup{$accession})) {
#     my $key = $accession;
#     
#     $study_to_gse{$key} = $alias;
#   }
}
close ($fp);

printf "Run";
printf "\tExperiment";
printf "\tGSM";
printf "\tSubmission";
printf "\tSample";
printf "\tStudy";
printf "\tBiosample";
printf "\tBioproject";
printf "\tReplacement";
printf "\n";

foreach my $key (sort (keys %srr)) {
  printf "%s", $srr{$key};
  
  printf "\t%s", $srr_to_experiment{$key};
  printf "\t%s", $experiment_to_gsm{$srr_to_experiment{$key}};
  printf "\t%s", $srr_to_submission{$key};
#   printf "\t%s", $study_to_gse{$srr_to_study{$key}};
  printf "\t%s", $srr_to_sample{$key};
  printf "\t%s", $srr_to_study{$key};
  printf "\t%s", $srr_to_biosample{$key};
  printf "\t%s", $srr_to_bioproject{$key};
  printf "\t%s", $srr_to_replacedby{$key};
  
  printf "\n";
}


=pod

=head1 NAME

srr-lookup.pl -- Map the sequence read accession identifiers from NCBI's Sequence Read Archive to other related values.

Output format is in tabular format.

=head1 SYNOPSIS

./srr-lookup.pl --sra Examples/SRA_Accessions-small.tab <test.txt >output.tsv

=head1 DESCRIPTION

TBD

=head1 EXAMPLE

=over 5

cat Examples/test.txt | perl ./srr-lookup.pl --sra Examples/SRA_Accessions-small.tab

=back

=head1 NOTES

TBD

=head1 LIMITATIONS

TBD

=head1 AUTHOR

Raymond Wan <raymondwan@ust.hk> or <rwan.work@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2018, Raymond Wan, All rights reserved.


