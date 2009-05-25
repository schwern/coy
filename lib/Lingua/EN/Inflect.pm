package Lingua::EN::Inflect;

use strict;
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA);
use Env;

require Exporter;

@ISA = qw(Exporter);

$VERSION = '1.85';

%EXPORT_TAGS =
(
	ALL =>		[ qw( classical inflect
			      PL PL_N PL_V PL_ADJ NO NUM A AN
			      PL_eq PL_N_eq PL_V_eq PL_ADJ_eq
			      PART_PRES
			      ORD
			      NUMWORDS
		     	      def_noun def_verb def_adj def_a def_an )],

	INFLECTIONS =>	[ qw( classical inflect
			      PL PL_N PL_V PL_ADJ PL_eq
			      NO NUM A AN PART_PRES )],

	PLURALS =>	[ qw( classical inflect
			      PL PL_N PL_V PL_ADJ NO NUM
			      PL_eq PL_N_eq PL_V_eq PL_ADJ_eq )],

	COMPARISONS =>	[ qw( classical 
			      PL_eq PL_N_eq PL_V_eq PL_ADJ_eq )],

	ARTICLES =>	[ qw( classical inflect NUM A AN )],

	NUMERICAL =>	[ qw( ORD NUMWORDS )],

	USER_DEFINED =>	[ qw( def_noun def_verb def_adj def_a def_an )],
);

Exporter::export_ok_tags(qw( ALL ));

# SUPPORT CLASSICAL PLURALIZATIONS

my $classical = 0;

sub classical
{
	$classical = (!@_ || $_[0]);
}

my $persistent_count;

sub NUM(;$$)	# (;$count,$show)
{
	if (defined $_[0])
	{
		$persistent_count = $_[0];
		return $_[0] if !defined($_[1]) || $_[1];
	}
	else
	{
		$persistent_count = undef;
	}
	return '';
}


# 0. PERFORM GENERAL INFLECTIONS IN A STRING

sub inflect($)
{
	my $save_persistent_count = $persistent_count;
	my @sections = split /(NUM\([^)]*\))/, $_[0];
	my $inflection = "";

	foreach ( @sections )
	{
		unless (s/NUM\(\s*?(?:([^),]*)(?:,([^)]*))?)?\)/ NUM($1,$2) /xe)
		{
		    1 while
		       s/\bPL   \( ([^),]*) (, ([^)]*) )? \)  / PL($1,$3)   /xeg
		    || s/\bPL_N \( ([^),]*) (, ([^)]*) )? \)  / PL_N($1,$3) /xeg
		    || s/\bPL_V \( ([^),]*) (, ([^)]*) )? \)  / PL_V($1,$3) /xeg
		    || s/\bAN?  \( ([^),]*) (, ([^)]*) )? \)  / A($1,$3)    /xeg
		    || s/\bNO   \( ([^),]*) (, ([^)]*) )? \)  / NO($1,$3)   /xeg
		    || s/\bORD  \( ([^)]*) \)                 / ORD($1)   /xeg
		}

		$inflection .= $_;
	}

	$persistent_count = $save_persistent_count;
	return $inflection;
}


# 1. PLURALS

my %PL_sb_irregular_s = 
(
	"ephemeris"	=> "ephemerides",
	"iris"		=> "irises|irides",
	"clitoris"	=> "clitorises|clitorides",
	"corpus"	=> "corpuses|corpora",
	"opus"		=> "opuses|opera",
	"genus"		=> "genera",
	"mythos"	=> "mythoi",
	"penis"		=> "penises|penes",
	"testis"	=> "testes",
);

my %PL_sb_irregular =
(
	"child"		=> "children",
	"brother"	=> "brothers|brethren",
	"loaf"		=> "loaves",
	"hoof"		=> "hoofs|hooves",
	"beef"		=> "beefs|beeves",
	"money"		=> "monies",
	"mongoose"	=> "mongooses",
	"ox"		=> "oxen",
	"cow"		=> "cows|kine",
	"soliloquy"	=> "soliloquies",
	"graffito"	=> "graffiti",
	"prima donna"	=> "prima donnas|prime donne",
	"octopus"	=> "octopuses|octopodes",
	"genie"		=> "genies|genii",
	"ganglion"	=> "ganglions|ganglia",
	"trilby"	=> "trilbys",
	"turf"		=> "turfs|turves",

	%PL_sb_irregular_s,
);

my $PL_sb_irregular = join '|', keys %PL_sb_irregular;

# CLASSICAL "..a" -> "..ata"

my $PL_sb_C_a_ata = join "|", map { chop; $_; }
(
	"anathema", "bema", "carcinoma", "charisma", "diploma",
	"dogma", "drama", "edema", "enema", "enigma", "lemma",
	"lymphoma", "magma", "melisma", "miasma", "oedema",
	"sarcoma", "schema", "soma", "stigma", "stoma", "trauma",
	"gumma", "pragma",
);

# UNCONDITIONAL "..a" -> "..ae"

my $PL_sb_U_a_ae = join "|", 
(
	"alumna", "alga", "vertebra",
);

# CLASSICAL "..a" -> "..ae"

my $PL_sb_C_a_ae = join "|", 
(
	"amoeba", "antenna", "formula", "hyperbola",
	"medusa", "nebula", "parabola", "abscissa",
	"hydra", "nova", "lacuna", "aurora", ".*umbra",
);

# CLASSICAL "..en" -> "..ina"

my $PL_sb_C_en_ina = join "|", map { chop; chop; $_; }
(
	"stamen",	"foramen",	"lumen",
);

# UNCONDITIONAL "..um" -> "..a"

my $PL_sb_U_um_a = join "|", map { chop; chop; $_; }
(
	"bacterium",	"agendum",	"desideratum",	"erratum",
	"stratum",	"datum",	"ovum",		"extremum",
	"candelabrum",
);

# CLASSICAL "..um" -> "..a"

my $PL_sb_C_um_a = join "|", map { chop; chop; $_; }
(
	"maximum",	"minimum",	"momentum",	"optimum",
	"quantum",	"cranium",	"curriculum",	"dictum",
	"phylum",	"aquarium",	"compendium",	"emporium",
	"enconium",	"gymnasium",	"honorarium",	"interregnum",
	"lustrum", 	"memorandum",	"millenium", 	"rostrum", 
	"spectrum",	"speculum",	"stadium",	"trapezium",
	"ultimatum",	"medium",	"vacuum",	"velum", 
	"consortium",
);

# UNCONDITIONAL "..us" -> "i"

my $PL_sb_U_us_i = join "|", map { chop; chop; $_; }
(
	"alumnus",	"alveolus",	"bacillus",	"bronchus",
	"locus",	"nucleus",	"stimulus",	"meniscus",
);

# CLASSICAL "..us" -> "..i"

my $PL_sb_C_us_i = join "|", map { chop; chop; $_; }
(
	"focus",	"radius",	"genius",
	"incubus",	"succubus",	"nimbus",
	"fungus",	"nucleolus",	"stylus",
	"torus",	"umbilicus",	"uterus",

);

# CLASSICAL "..us" -> "..us"  (ASSIMILATED 4TH DECLENSION LATIN NOUNS)

my $PL_sb_C_us_us = join "|",
(
	"status", "apparatus", "prospectus", "sinus",
	"hiatus", "impetus", "plexus",
);

# UNCONDITIONAL "..on" -> "a"

my $PL_sb_U_on_a = join "|", map { chop; chop; $_; }
(
	"criterion",	"perihelion",	"aphelion",
	"phenomenon",	"prolegomenon",	"noumenon",
	"organon",	"asyndeton",	"hyperbaton",
);

# CLASSICAL "..on" -> "..a"

my $PL_sb_C_on_a = join "|", map { chop; chop; $_; }
(
	"oxymoron",
);

# CLASSICAL "..o" -> "..i"  (BUT NORMALLY -> "..os")

my @PL_sb_C_o_i = 
(
	"solo",		"soprano",	"basso",	"alto",
	"contralto",	"tempo",
);
my $PL_sb_C_o_i = join "|", map { my $w=$_; chop $w; $w; } @PL_sb_C_o_i;

# ALWAYS "..o" -> "..os"

my $PL_sb_U_o_os = join "|",
(
	"albino",	"archipelago",	"armadillo",
	"commando",	"crescendo",	"fiasco",
	"ditto",	"dynamo",	"embryo",
	"ghetto",	"guano",	"inferno",
	"jumbo",	"lumbago",	"magneto",
	"manifesto",	"medico",	"octavo",
	"photo",	"pro",		"quarto",	
	"canto",	"lingo",	"generalissimo",
	"stylo",	"rhino",


	@PL_sb_C_o_i,
);


# UNCONDITIONAL "..ex" -> "..ices"

my $PL_sb_U_ex_ices = join "|", map { chop; chop; $_; }
(
	"codex",	"murex",	"silex",
);

# CLASSICAL "..ex" -> "..ices"

my $PL_sb_C_ex_ices = join "|", map { chop; chop; $_; }
(
	"vortex",	"vertex",	"cortex",	"latex",
	"pontifex",	"apex",		"index",	"simplex",
);

# ARABIC: ".." -> "..i"

my $PL_sb_C_i = join "|", 
(
	"afrit",	"afreet",	"efreet",
);

# HEBREW: ".." -> "..im"

my $PL_sb_C_im = join "|",
(
	"goy",		"seraph",	"cherub",
);

# UNCONDITIONAL "..man" -> "..mans"

my $PL_sb_U_man_mans = join "|", 
qw(
	human
	Alabaman Bahaman Burman German
	Hiroshiman Liman Nakayaman Oklahoman
	Panaman Selman Sonaman Tacoman Yakiman
	Yokohaman Yuman
);

my @PL_sb_uninflected_s =
(
# PAIRS OR GROUPS SUBSUMED TO A SINGULAR...
        "breeches", "britches", "clippers", "gallows", "hijinks",
	"headquarters", "pliers", "scissors", "testes", "herpes",
	"pincers", "shears", "proceedings",

# UNASSIMILATED LATIN 4th DECLENSION

	"cantus", "coitus", "nexus",

# RECENT IMPORTS...
	"contretemps", "corps", "debris",
	".*ois",
	
# DISEASES
	".*measles", "mumps",

# MISCELLANEOUS OTHERS...
	"diabetes", "jackanapes", "series", "species", "rabies",
	"chassis", "innings", "news", "mews",
);

my $PL_sb_uninflected = join "|",
(
# SOME FISH AND HERD ANIMALS
	".*fish", "tuna", "salmon", "mackerel", "trout",
	"bream", "sea[- ]bass", "carp", "cod", "flounder", "whiting", 

	".*deer", ".*sheep", "wildebeest", "swine", "eland", "bison",
	"elk",

# ALL NATIONALS ENDING IN -ese
        "Portuguese", "Japanese", "Chinese", "Vietnamese", "Burmese",
        "Lebanese", "Siamese", "Senegalese", "Bhutanese", "Sinhalese",

# SOME WORDS ENDING IN ...s (OFTEN PAIRS TAKEN AS A WHOLE)

	@PL_sb_uninflected_s,

# DISEASES
	".*pox",


# OTHER ODDITIES
	"graffiti", "djinn"
);

# SINGULAR WORDS ENDING IN ...s (ALL INFLECT WITH ...es)

my $PL_sb_singular_s = join '|',
(
	".*ss",
        "acropolis", "aegis", "alias", "arthritis", "asbestos", "atlas",
        "bathos", "bias", "bronchitis", "bursitis", "caddis", "cannabis",
        "canvas", "chaos", "cosmos", "dais", "digitalis", "encephalitis",
        "epidermis", "ethos", "gas", "glottis", "hepatitis", "hubris",
        "ibis", "lens", "mantis", "marquis", "metropolis",
        "neuritis", "pathos", "pelvis", "polis", "rhinoceros",
        "sassafras", "tonsillitis", "trellis", ".*us",
);

my $PL_v_special_s = join '|',
(
	$PL_sb_singular_s,
	@PL_sb_uninflected_s,
	keys %PL_sb_irregular_s,
	'(.*[csx])is',
	'(.*)ceps',
	'[A-Z].*s',
);

my $PL_sb_military = 'major|lieutenant|brigadier|adjutant|quartermaster';
my $PL_sb_general = '((?!'.$PL_sb_military.').*?)((-|\s+)general)';

my $PL_prep = join '|', qw (
        about above across after among around at athwart before behind
        below beneath beside besides between betwixt beyond but by
        during except for from in into near of off on onto out over
        since till to under until unto upon with
);

my $PL_sb_prep_compound = '(.*?)((-|\s+)(in|to|of|at|de)(-|\s+)(.*))';


my %PL_pron_nom =
(
#	NOMINATIVE		REFLEXIVE

"i"	=> "we",	"myself"   =>	"ourselves",
"you"	=> "you",	"yourself" =>	"yourselves",
"she"	=> "they",	"herself"  =>	"themselves",
"he"	=> "they",	"himself"  =>	"themselves",
"it"	=> "they",	"itself"   =>	"themselves",
"they"	=> "they",	"themself" =>	"themselves",

#	POSSESSIVE

"mine"	 => "ours",
"yours"	 => "yours",
"hers"	 => "theirs",
"his"	 => "theirs",
"its"	 => "theirs",
"theirs" => "theirs",
);

my %PL_pron_acc =
(
#	ACCUSATIVE		REFLEXIVE

"me"	=> "us",	"myself"   =>	"ourselves",
"you"	=> "you",	"yourself" =>	"yourselves",
"her"	=> "them",	"herself"  =>	"themselves",
"him"	=> "them",	"himself"  =>	"themselves",
"it"	=> "them",	"itself"   =>	"themselves",
"them"	=> "them",	"themself" =>	"themselves",
);

my $PL_pron_acc = join '|', keys %PL_pron_acc;

my %PL_v_irregular_pres =
(
#	1st PERS. SING.		2ND PERS. SING.		3RD PERS. SINGULAR
#				3RD PERS. (INDET.)	

"am"	=> "are",	"are"	=> "are",	"is"	 => "are",
"was"	=> "were",	"were"	=> "were",	"was"	 => "were",
"have"  => "have",	"have"  => "have",	"has"	 => "have",
);

my $PL_v_irregular_pres = join '|', keys %PL_v_irregular_pres;

my %PL_v_ambiguous_pres =
(
#	1st PERS. SING.		2ND PERS. SING.		3RD PERS. SINGULAR
#				3RD PERS. (INDET.)	

"act"	=> "act",	"act"	=> "act",	"acts"	  => "act",
"blame"	=> "blame",	"blame"	=> "blame",	"blames"  => "blame",
"can"	=> "can",	"can"	=> "can",	"can"	  => "can",
"must"	=> "must",	"must"	=> "must",	"must"	  => "must",
"fly"	=> "fly",	"fly"	=> "fly",	"flies"	  => "fly",
"copy"	=> "copy",	"copy"	=> "copy",	"copies"  => "copy",
"drink"	=> "drink",	"drink"	=> "drink",	"drinks"  => "drink",
"fight"	=> "fight",	"fight"	=> "fight",	"fights"  => "fight",
"fire"	=> "fire",	"fire"	=> "fire",	"fires"   => "fire",
"like"	=> "like",	"like"	=> "like",	"likes"   => "like",
"look"	=> "look",	"look"	=> "look",	"looks"   => "look",
"make"	=> "make",	"make"	=> "make",	"makes"   => "make",
"reach"	=> "reach",	"reach"	=> "reach",	"reaches" => "reach",
"run"	=> "run",	"run"	=> "run",	"runs"    => "run",
"sink"	=> "sink",	"sink"	=> "sink",	"sinks"   => "sink",
"sleep"	=> "sleep",	"sleep"	=> "sleep",	"sleeps"  => "sleep",
"view"	=> "view",	"view"	=> "view",	"views"   => "view",
);

my $PL_v_ambiguous_pres = join '|', keys %PL_v_ambiguous_pres;


my $PL_v_irregular_non_pres = join '|',
(
"did", "had", "ate", "made", "put", 
"spent", "fought", "sank", "gave", "sought",
"shall", "could", "ought", "should",
);

my $PL_v_ambiguous_non_pres = join '|',
(
"thought", "saw", "bent", "will", "might", "cut",
);

my $PL_count_zero = join '|',
(
0, "no", "zero", "nil"
);

my $PL_count_one = join '|',
(
1, "a", "an", "one", "each", "every", "this", "that",
);

my %PL_adj_special =
(
"a"    => "some",	"an"   =>  "some",
"this" => "these",	"that" => "those",
);
my $PL_adj_special = join '|', keys %PL_adj_special;

my %PL_adj_poss =
(
"my"    => "our",
"your"	=> "your",
"its"	=> "their",
"her"	=> "their",
"his"	=> "their",
"their"	=> "their",
);
my $PL_adj_poss = join '|', keys %PL_adj_poss;


sub checkpat
{
local $SIG{__WARN__} = sub {0};
do {$@ =~ s/at.*?$//;
    die "\nBad user-defined singular pattern:\n\t$@\n"}
	if (!eval "'' =~ m/$_[0]/; 1;" or $@);
return @_;
}

sub checkpatsubs
{
checkpat($_[0]);
if (defined $_[1])
{
	local $SIG{__WARN__} = sub {0};
	do {$@ =~ s/at.*?$//;
	    die "\nBad user-defined plural string: '$_[1]'\n\t$@\n"}
		if (!eval "qq{$_[1]}; 1;" or $@);
}
return @_;
}

my @PL_sb_user_defined = ();
my @PL_v_user_defined  = ();
my @PL_adj_user_defined  = ();
my @A_a_user_defined   = ();

sub def_noun($$)
{
	unshift @PL_sb_user_defined, checkpatsubs(@_);
	return 1;
}

sub def_verb($$$$$$)
{
	unshift @PL_v_user_defined, checkpatsubs(@_[4,5]);
	unshift @PL_v_user_defined, checkpatsubs(@_[2,3]);
	unshift @PL_v_user_defined, checkpatsubs(@_[0,1]);
	return 1;
}

sub def_adj($$)
{
	unshift @PL_adj_user_defined, checkpatsubs(@_);
	return 1;
}

sub def_a($)	
{
unshift @A_a_user_defined, checkpat(@_,'a');
return 1;
}

sub def_an($)
{
unshift @A_a_user_defined, checkpat(@_,'an');
return 1;
}

sub ud_match($@)
{
my $word = shift;
for (my $i=0; $i < @_; $i+=2)
{
	if ($word =~ /^(?:$_[$i])$/i)
	{
		last unless defined $_[$i+1];
		return eval '"'.$_[$i+1].'"';
	}
}
return undef;
}

do
{
local $SIG{__WARN__} = sub {0};
my $rcfile;

$rcfile = $INC{'Lingua//EN/Inflect.pm'} || '';
$rcfile =~ s/Inflect.pm$/.inflectrc/;
do $rcfile or die "\nBad .inflectrc file ($rcfile):\n\t$@\n"
if $rcfile && -r $rcfile && -s $rcfile;

$rcfile = "$ENV{HOME}/.inflectrc" || '';
do $rcfile or die "\nBad .inflectrc file ($rcfile):\n\t$@\n"
if $rcfile && -r $rcfile && -s $rcfile;
};

sub postprocess($$)	# FIX PEDANTRY AND CAPITALIZATION :-)
{
my ($orig, $inflected) = @_;
$inflected =~ s/([^|]+)\|(.+)/ $classical?$2:$1 /e;
return $orig =~ /^I$/	? $inflected
 : $orig =~ /^[A-Z]+$/	? uc $inflected
 : $orig =~ /^[A-Z]/	? ucfirst $inflected
 :			  $inflected;
}

sub PL($;$)
#   PL($word,$number)
{
my ($str, $count) = @_;
my ($pre, $word, $post) = ($str =~ m/\A(\s*)(.+?)(\s*)\Z/);
return $str unless $word;
my $plural = postprocess $word,  _PL_special_adjective($word,$count)
			  || _PL_special_verb($word,$count)
			  || _PL_noun($word,$count);
return $pre.$plural.$post;
}

sub PL_N($;$)	
#   PL_N($word,$number)
{
my ($str, $count) = @_;
my ($pre, $word, $post) = ($str =~ m/\A(\s*)(.+?)(\s*)\Z/);
return $str unless $word;
my $plural = postprocess $word, _PL_noun($word,$count);
return $pre.$plural.$post;
}

sub PL_V($;$)	
#   PL_V($word,$number)
{
my ($str, $count) = @_;
my ($pre, $word, $post) = ($str =~ m/\A(\s*)(.+?)(\s*)\Z/);
return $str unless $word;
my $plural = postprocess $word, _PL_special_verb($word,$count)
			  || _PL_general_verb($word,$count);
return $pre.$plural.$post;
}

sub PL_ADJ($;$)	
#   PL_ADJ($word,$number)
{
my ($str, $count) = @_;
my ($pre, $word, $post) = ($str =~ m/\A(\s*)(.+?)(\s*)\Z/);
return $str unless $word;
my $plural = postprocess $word, _PL_special_adjective($word,$count)
			  || $word;
return $pre.$plural.$post;
}

sub PL_eq($$)	  { _PL_eq(@_, \&PL); }
sub PL_N_eq($$)	  { _PL_eq(@_, \&PL_N); }
sub PL_V_eq($$)	  { _PL_eq(@_, \&PL_V); }
sub PL_ADJ_eq($$) { _PL_eq(@_, \&PL_ADJ); }

sub _PL_eq($$$)
{
my ( $word1, $word2, $PL ) = @_;
my $classval = $classical;
my $result = "";
$result = "eq"	if !$result && $word1 eq $word2;
$result = "p:s" if !$result && $word1 eq &$PL($word2);
$result = "s:p" if !$result && &$PL($word1) eq $word2;
$classical = !$classval;
$result = "p:s" if !$result && $word1 eq &$PL($word2);
$result = "s:p" if !$result && &$PL($word1) eq $word2;
$classical = $classval;

if ($PL == \&PL || $PL == \&PL_N)
{
	$result = "p:p" 
		if !$result && _PL_check_plurals_N($word1,$word2);
	$result = "p:p" 
		if !$result && _PL_check_plurals_N($word2,$word1);
}
if ($PL == \&PL || $PL == \&PL_ADJ)
{
	$result = "p:p" 
		if !$result && _PL_check_plurals_ADJ($word1,$word2,$PL);
}

return $result;
}

sub _PL_reg_plurals($$$$)
{
$_[0] =~ /($_[1])($_[2]\|\1$_[3]|$_[3]\|\1$_[2])/
}

sub _PL_check_plurals_N($$)
{
my $pair = "$_[0]|$_[1]";
foreach ( values %PL_sb_irregular_s )	{ return 1 if $_ eq $pair; }
foreach ( values %PL_sb_irregular )	{ return 1 if $_ eq $pair; }

return 1 if _PL_reg_plurals($pair, $PL_sb_C_a_ata,   "as","ata")
	 || _PL_reg_plurals($pair, $PL_sb_C_a_ae,    "s","e")
	 || _PL_reg_plurals($pair, $PL_sb_C_en_ina,  "ens","ina")
	 || _PL_reg_plurals($pair, $PL_sb_C_um_a,    "ums","a")
	 || _PL_reg_plurals($pair, $PL_sb_C_us_i,    "uses","i")
	 || _PL_reg_plurals($pair, $PL_sb_C_on_a,    "ons","a")
	 || _PL_reg_plurals($pair, $PL_sb_C_o_i,     "os","i")
	 || _PL_reg_plurals($pair, $PL_sb_C_ex_ices, "exes","ices")
	 || _PL_reg_plurals($pair, $PL_sb_C_i,       "s","i")
	 || _PL_reg_plurals($pair, $PL_sb_C_im,      "s","im")

	 || _PL_reg_plurals($pair, '.*eau',       "s","x")
	 || _PL_reg_plurals($pair, '.*ieu',       "s","x")
	 || _PL_reg_plurals($pair, '.*tri',       "xes","ces")
	 || _PL_reg_plurals($pair, '.{2,}[yia]n', "xes","ges");


return 0;
}

sub _PL_check_plurals_ADJ($$$)
{
my ( $word1a, $word2a ) = @_;
my ( $word1b, $word2b ) = @_;

$word1a = '' unless $word1a =~ s/'s?$//;
$word2a = '' unless $word2a =~ s/'s?$//;
$word1b = '' unless $word1b =~ s/s'$//;
$word2b = '' unless $word2b =~ s/s'$//;

if ($word1a)
{
	return 1 if $word2a && ( _PL_check_plurals_N($word1a, $word2a)
				|| _PL_check_plurals_N($word2a, $word1a) );
	return 1 if $word2b && ( _PL_check_plurals_N($word1a, $word2b)
				|| _PL_check_plurals_N($word2b, $word1a) );
}
if ($word1b)
{
	return 1 if $word2a && ( _PL_check_plurals_N($word1b, $word2a)
				|| _PL_check_plurals_N($word2a, $word1b) );
	return 1 if $word2b && ( _PL_check_plurals_N($word1b, $word2b)
				|| _PL_check_plurals_N($word2b, $word1b) );
}


return "";
}

sub _PL_noun($;$)
{
my ( $word, $count ) = @_;
my $value;				# UTILITY VARIABLE

# DEFAULT TO PLURAL

$count = $persistent_count
	if !defined($count) && defined($persistent_count);
$count = (defined $count and $count=~/^($PL_count_one)$/io or
	  defined $count and $classical and $count=~/^($PL_count_zero)$/io) ? 1  
       : 2;

return $word if $count==1;

# HANDLE USER-DEFINED NOUNS

return $value if defined($value = ud_match($word, @PL_sb_user_defined));


# HANDLE EMPTY WORD, SINGULAR COUNT AND UNINFLECTED PLURALS

$word eq ''			and return $word;

$word =~ /^($PL_sb_uninflected)$/i
				and return $word;

# HANDLE PRONOUNS

$word =~ /^((?:$PL_prep)\s+)($PL_pron_acc)$/i
				and return $1.$PL_pron_acc{lc($2)};

$value = $PL_pron_nom{lc($word)}
				and return $value;

$word =~ /^($PL_pron_acc)$/i
				and return $PL_pron_acc{lc($1)};

# HANDLE ISOLATED IRREGULAR PLURALS 

$word =~ /(.*)\b($PL_sb_irregular)$/i
				and return $1 . $PL_sb_irregular{lc $2};
$word =~ /($PL_sb_U_man_mans)$/i
				and return "$1s";

# HANDLE FAMILIES OF IRREGULAR PLURALS 

$word =~ /(.*)man$/i		and return "$1men";
$word =~ /(.*[ml])ouse$/i	and return "$1ice";
$word =~ /(.*)goose$/i		and return "$1geese";
$word =~ /(.*)tooth$/i		and return "$1teeth";
$word =~ /(.*)foot$/i		and return "$1feet";

# HANDLE UNASSIMILATED IMPORTS

$word =~ /(.*)ceps$/i		and return $word;
$word =~ /(.*)zoon$/i		and return "$1zoa";
$word =~ /(.*[csx])is$/i	and return "$1es";
$word =~ /($PL_sb_U_ex_ices)ex$/i	and return "$1ices";
$word =~ /($PL_sb_U_um_a)um$/i	and return "$1a";
$word =~ /($PL_sb_U_us_i)us$/i	and return "$1i";
$word =~ /($PL_sb_U_on_a)on$/i	and return "$1a";
$word =~ /($PL_sb_U_a_ae)$/i	and return "$1e";

# HANDLE INCOMPLETELY ASSIMILATED IMPORTS

if ($classical)
{
    $word =~ /(.*)trix$/i		and return "$1trices";
    $word =~ /(.*)eau$/i		and return "$1eaux";
    $word =~ /(.*)ieu$/i		and return "$1ieux";
    $word =~ /(.{2,}[yia])nx$/i		and return "$1nges";
    $word =~ /($PL_sb_C_en_ina)en$/i	and return "$1ina";
    $word =~ /($PL_sb_C_ex_ices)ex$/i	and return "$1ices";
    $word =~ /($PL_sb_C_um_a)um$/i	and return "$1a";
    $word =~ /($PL_sb_C_us_i)us$/i	and return "$1i";
    $word =~ /($PL_sb_C_us_us)$/i	and return "$1";
    $word =~ /($PL_sb_C_a_ae)$/i	and return "$1e";
    $word =~ /($PL_sb_C_a_ata)a$/i	and return "$1ata";
    $word =~ /($PL_sb_C_o_i)o$/i	and return "$1i";
    $word =~ /($PL_sb_C_on_a)on$/i	and return "$1a";
    $word =~ /$PL_sb_C_im$/i		and return "${word}im";
    $word =~ /$PL_sb_C_i$/i		and return "${word}i";
}


# HANDLE SINGULAR NOUNS ENDING IN ...s OR OTHER SILIBANTS

$word =~ /^($PL_sb_singular_s)$/i	and return "$1es";
$word =~ /^([A-Z].*s)$/			and return "$1es";
$word =~ /(.*)([cs]h|[zx])$/i		and return "$1$2es";
$word =~ /(.*)(us)$/i			and return "$1$2es";

# HANDLE ...f -> ...ves

$word =~ /(.*[eao])lf$/i	and return "$1lves"; 
$word =~ /(.*[^d])eaf$/i	and return "$1eaves";
$word =~ /(.*[nlw])ife$/i	and return "$1ives";
$word =~ /(.*)arf$/i		and return "$1arves";

# HANDLE ...y

$word =~ /(.*[aeiou])y$/i	and return "$1ys";
$word =~ /([A-Z].*y)$/		and return "$1s";
$word =~ /(.*)y$/i		and return "$1ies";

# HANDLE ...o

$word =~ /$PL_sb_U_o_os$/i	and return "${word}s";
$word =~ /[aeiou]o$/i		and return "${word}s";
$word =~ /o$/i			and return "${word}es";


# HANDLE COMPOUNDS ("Governor General", "mother-in-law", "aide-de-camp", ETC.)

$word =~ /^(?:$PL_sb_general)$/i
				and $value = $2
				and return _PL_noun($1,2,"$1s")
					   . $value;

$word =~ /^(?:$PL_sb_prep_compound)$/i
				and $value = $2 
				and return _PL_noun($1,2)
					   . $value;

# OTHERWISE JUST ADD ...s

return "${word}s";
}


sub _PL_special_verb($;$)
{
my ( $word, $count ) = @_;
$count = $persistent_count
	if !defined($count) && defined($persistent_count);
$count = (defined $count and $count=~/^($PL_count_one)$/io or
	  defined $count and $classical and $count=~/^($PL_count_zero)$/io) ? 1  
       : 2;

return undef if $count=~/^($PL_count_one)$/io;

my $value;				# UTILITY VARIABLE

# HANDLE USER-DEFINED VERBS

return $value if defined($value = ud_match($word, @PL_v_user_defined));

# HANDLE IRREGULAR PRESENT TENSE (SIMPLE AND COMPOUND)

$word =~ /^($PL_v_irregular_pres)((\s.*)?)$/i
		and return $PL_v_irregular_pres{lc $1}.$2;

# HANDLE IRREGULAR FUTURE, PRETERITE AND PERFECT TENSES 

$word =~ /^($PL_v_irregular_non_pres)((\s.*)?)$/i
		and return $word;

# HANDLE SPECIAL CASES

$word =~ /^($PL_v_special_s)$/		and return undef;
$word =~ /\s/				and return undef;

# HANDLE STANDARD 3RD PERSON (CHOP THE ...(e)s OFF SINGLE WORDS)

$word =~ /^(.*)([cs]h|[sx]|zz)es$/i	and return "$1$2";

$word =~ /^(..+)ies$/i			and return "$1y";
$word =~ /^(.+)oes$/i			and return "$1o";

$word =~ /^(.*[^s])s$/i			and return $1;

# OTHERWISE, A REGULAR VERB (HANDLE ELSEWHERE)

return undef;
}  

sub _PL_general_verb($;$)
{
my ( $word, $count ) = @_;
$count = $persistent_count
	if !defined($count) && defined($persistent_count);
$count = (defined $count and $count=~/^($PL_count_one)$/io or
	  defined $count and $classical and $count=~/^($PL_count_zero)$/io) ? 1  
       : 2;

return $word if $count=~/^($PL_count_one)$/io;

# HANDLE AMBIGUOUS PRESENT TENSES  (SIMPLE AND COMPOUND)

$word =~ /^($PL_v_ambiguous_pres)((\s.*)?)$/i
		and return $PL_v_ambiguous_pres{lc $1}.$2;

# HANDLE AMBIGUOUS PRETERITE AND PERFECT TENSES 

$word =~ /^($PL_v_ambiguous_non_pres)((\s.*)?)$/i
		and return $word;

# OTHERWISE, 1st OR 2ND PERSON IS UNINFLECTED

return $word;

}

sub _PL_special_adjective($;$)
{
my ( $word, $count ) = @_;
$count = $persistent_count
	if !defined($count) && defined($persistent_count);
$count = (defined $count and $count=~/^($PL_count_one)$/io or
	  defined $count and $classical and $count=~/^($PL_count_zero)$/io) ? 1  
       : 2;

return $word if $count=~/^($PL_count_one)$/io;


# HANDLE USER-DEFINED ADJECTIVES

my $value;
return $value if defined($value = ud_match($word, @PL_adj_user_defined));

# HANDLE KNOWN CASES

$word =~ /^($PL_adj_special)$/i
			and return $PL_adj_special{lc $1};

# HANDLE POSSESSIVES

$word =~ /^($PL_adj_poss)$/i
			and return $PL_adj_poss{lc $1};

$word =~ /^(.*)'s?$/	and do { my $pl = PL_N($1);
				 return "$pl'" . ($pl =~ m/s$/ ? "" : "s");
			       };

# OTHERWISE, NO IDEA

return undef;

}


# 2. INDEFINITE ARTICLES

# THIS PATTERN MATCHES STRINGS OF CAPITALS STARTING WITH A "VOWEL-SOUND"
# CONSONANT FOLLOWED BY ANOTHER CONSONANT, AND WHICH ARE NOT LIKELY
# TO BE REAL WORDS (OH, ALL RIGHT THEN, IT'S JUST MAGIC!)

my $A_abbrev = q{
(?! FJO | [HLMNS]Y.  | RY[EO] | SQU
  | ( F[LR]? | [HL] | MN? | N | RH? | S[CHKLMNPTVW]? | X(YL)?) [AEIOU])
[FHLMNRSX][A-Z]
};

# THIS PATTERN CODES THE BEGINNINGS OF ALL ENGLISH WORDS BEGINING WITH A
# 'y' FOLLOWED BY A CONSONANT. ANY OTHER Y-CONSONANT PREFIX THEREFORE
# IMPLIES AN ABBREVIATION.

my $A_y_cons = 'y(b[lor]|cl[ea]|fere|gg|p[ios]|rou|tt)';

# EXCEPTIONS TO EXCEPTIONS

my $A_explicit_an = join '|',
(
"euler",
"hour(?!i)", "heir", "honest", "hono",
);

sub A($;$) 
{
my ($str, $count) = @_;
my ($pre, $word, $post) = ( $str =~ m/\A(\s*)(.+?)(\s*)\Z/ );
return $str unless $word;
my $result = _indef_article($word,$count);
return $pre.$result.$post;
}

sub AN($;$) { goto &A }

sub _indef_article($;$)
{
my ( $word, $count ) = @_;

$count = $persistent_count
	if !defined($count) && defined($persistent_count);

return "$count $word"
	if defined $count && $count!~/^($PL_count_one)$/io;

# HANDLE USER-DEFINED VARIANTS

my $value;
return $value if defined($value = ud_match($word, @A_a_user_defined));

# HANDLE SPECIAL CASES

$word =~ /^($A_explicit_an)/i		and return "an $word";

# HANDLE ABBREVIATIONS

$word =~ /^($A_abbrev)/ox		and return "an $word";
$word =~ /^[aefhilmnorsx][.-]/i		and return "an $word";
$word =~ /^[a-z][.-]/i			and return "a $word";

# HANDLE CONSONANTS

$word =~ /^[^aeiouy]/i		and return "a $word";

# HANDLE SPECIAL VOWEL-FORMS

$word =~ /^e[uw]/i			and return "a $word";
$word =~ /^onc?e\b/i			and return "a $word";
$word =~ /^uni([^nmd]|mo)/i		and return "a $word";
$word =~ /^u[bcfhjkqrst][aeiou]/i	and return "a $word";

# HANDLE VOWELS

$word =~ /^[aeiou]/i		and return "an $word";

# HANDLE y... (BEFORE CERTAIN CONSONANTS IMPLIES (UNNATURALIZED) "i.." SOUND)

$word =~ /^($A_y_cons)/io	and return "an $word";

# OTHERWISE, GUESS "a"
				    return "a $word";
}

# 2. TRANSLATE ZERO-QUANTIFIED $word TO "no PL($word)"

sub NO($;$)
{
my ($str, $count) = @_;
my ($pre, $word, $post) = ($str =~ m/\A(\s*)(.+?)(\s*)\Z/);

$count = $persistent_count
	if !defined($count) && defined($persistent_count);
$count = 0 unless $count;

return "$pre$count " . PL($word,$count) . $post
	unless $count =~ /^$PL_count_zero$/;
return "${pre}no ". PL($word,0) . $post ;
}


# PARTICIPLES

sub PART_PRES
{
        local $_ = PL_V(shift,2);
           s/ie$/y/
        or s/ue$/u/
        or s/([auy])e$/$1/
        or s/i$//
        or s/([^e])e$/$1/
        or m/er$/
        or s/([^aeiou][aeiouy]([bdgmnprst]))$/$1$2/;
        return "${_}ing";
}



# NUMERICAL INFLECTIONS

my %nth =
(
	0 => 'th',
	1 => 'st',
	2 => 'nd',
	3 => 'rd',
	4 => 'th',
	5 => 'th',
	6 => 'th',
	7 => 'th',
	8 => 'th',
	9 => 'th',
	11 => 'th',
	12 => 'th',
	13 => 'th',
);


sub ORD
{
	$_[0] . ($nth{$_[0]%100} || $nth{$_[0]%10});
}


my %default_args = 
(
	'group'   => 0,
	'comma'   => ',',
	'and'     => 'and',
	'zero'    => 'zero',
	'decimal' => 'point',
);

my @unit = ('',qw(one two three four five six seven eight nine));
my @teen = qw(ten eleven twelve thirteen fourteen
	      fifteen sixteen seventeen eighteen nineteen);
my @ten  = ('','',qw(twenty thirty forty fifty sixty seventy eighty ninety));
my @mill = map { (my $val=$_) =~ s/_/illion/; " $val" }
	   ('',qw(thousand m_ b_ tr_ quadr_ quint_ sext_ sept_ oct_ non_ dec_));

sub mill { my $ind = $_[0]||0;
	   die "Number out of range\n" if $ind > $#mill;
	   return $ind<@mill ? $mill[$ind] : ' ???illion'; }

sub unit { return $unit[$_[0]]. mill($_[1]); }

sub ten
{
	return $ten[$_[0]] . ($_[0]&&$_[1]?'-':'') . $unit[$_[1]] . mill($_[2])
		if $_[0] ne '1';
	return $teen[$_[1]]. $mill[$_[2]||0];
}

sub hund
{
	return unit($_[0]) . " hundred" . ($_[1] || $_[2] ? " $_[4] " : '')
	     . ten($_[1],$_[2]) . mill($_[3]) . ', ' if $_[0];
	return ten($_[1],$_[2]) . mill($_[3]) . ', ' if $_[1] || $_[2];
	return '';
}

sub enword
{
	my ($num,$group,$zero,$comma,$and) = @_;

	if ($group==1)
	{
		$num =~ s/(\d)/ ($1 ? unit($1) :" $zero")."$comma " /eg;
	}
	elsif ($group==2)
	{
		$num =~ s/(\d)(\d)/ ($1 ? ten($1,$2) : $2 ? " $zero " . unit($2) : " $zero $zero") . "$comma " /eg;
		$num =~ s/(\d)/ ($1 ? unit($1) :" $zero")."$comma " /e;
	}
	elsif ($group==3)
	{
		$num =~ s/(\d)(\d)(\d)/ ($1 ? unit($1) :" $zero")." ".($2 ? ten($2,$3) : $3 ? " $zero " . unit($3) : " $zero $zero") . "$comma " /eg;
		$num =~ s/(\d)(\d)/ ($1 ? ten($1,$2) : $2 ? " $zero " . unit($2) : " $zero $zero") . "$comma " /e;
		$num =~ s/(\d)/ ($1 ? unit($1) :" $zero")."$comma " /e;
	}
	elsif ($num+0==0)
	{
		$num = $zero;
	}
	else
	{
		$num =~ s/\A\s*0+//;
		my $mill = 0;
		1 while $num =~ s/(\d)(\d)(\d)(?=\D*\Z)/ hund($1,$2,$3,$mill++,$and) /e;
		$num =~ s/(\d)(\d)(?=\D*\Z)/ ten($1,$2,$mill)."$comma " /e;
		$num =~ s/(\d)(?=\D*\Z)/ unit($1,$mill) . "$comma "/e;
	}
	return $num;
}

sub NUMWORDS($;@)
{
	my $num = shift;
	my %arg = ( %default_args, @_ );
	my $group = $arg{group};

	die "Bad chunking option: $group\n" unless $group =~ /\A[0-3]\Z/;
	my $sign = ($num =~ /\A\s*\+/) ? "plus"
		 : ($num =~ /\A\s*\-/) ? "minus"
		 : '';

	my $zero = $arg{zero};
	my $comma = $arg{comma};
	my $and = $arg{'and'};

	my @chunks = ($arg{decimal})
			? $group ? split(/\./, $num) : split(/\./, $num, 2)
			: ($num);

	my $first = 1;

	if ($chunks[0] eq '') { $first=0; shift @chunks; }

	foreach ( @chunks )
	{
		s/\D//g;
		$_ = '0' unless $_;

		if (!$group && !$first) { $_ = enword($_,1,$zero,$comma,$and) }
		else         	        { $_ = enword($_,$group,$zero,$comma,$and) }

		s/, \Z//;
		s/\s+,/,/g;
		s/, (\S+)\s+\Z/ $and $1/ if !$group and $first;
		s/\s+/ /g;
		s/(\A\s|\s\Z)//g;
		$first = '' if $first;
	}

	my @numchunks = ();
	if ($first =~ /0/)
	{
		unshift @chunks, '';
	}
	else
	{
		@numchunks = split /\Q$comma /, $chunks[0];
	}

	foreach (@chunks[1..$#chunks])
	{
		push @numchunks, $arg{decimal};
		push @numchunks, split /\Q$comma /;
	}

	if (wantarray)
	{
		unshift @numchunks, $sign if $sign;
		return @numchunks
	}
	elsif ($group)
	{
		return ($sign?"$sign ":'') .  join ", ", @numchunks;
	}
	else
	{
		$num = ($sign?"$sign ":'') . shift @numchunks;
		$first = ($num !~ /$arg{decimal}\Z/);
		foreach ( @numchunks )
		{
			if (/\A$arg{decimal}\Z/)
			{
				$num .= " $_";
				$first = 0;
			}
			elsif ($first)
			{
				$num .= "$comma $_";
			}
			else
			{
				$num .= " $_";
			}
		}
		return $num;
	}
}

1;

__END__
