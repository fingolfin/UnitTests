#############################################################################
##
#W  PackageInfo.g       GAP 4 Package `UnitTests'                    Max Horn
##

SetPackageInfo( rec(

PackageName := "UnitTests",
Subtitle    := "Unit tests for GAP",
Version     := "0.1dev",
Date        := "09/01/2013",
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "0.1dev">
##  <!ENTITY RELEASEDATE "January 2013">
##  <#/GAPDoc>

Persons          := [
  rec( LastName      := "Horn",
       FirstNames    := "Max",
       IsAuthor      := true,
       IsMaintainer  := true,
       Email         := "max@quendi.de",
       WWWHome       := "http://www.quendi.de/math.php",
       PostalAddress := Concatenation(
               "AG Algebra\n",
               "Mathematisches Institut\n",
               "JLU Gießen\n",
               "Arndtstrasse 2\n",
               "D-35392 Gießen\n",
               "Germany" ),
       Place         := "Gießen",
       Institution   := "Justus-Liebig-Universität Gießen"
     )
    ],

Status         := "Dev",
#CommunicatedBy := "TODO",
#AcceptDate     := "01/2004",

PackageWWWHome := "https://github.com/fingolfin/UnitTests/",

ArchiveFormats := ".tar.gz .zip",
# TODO: Use https://github.com/fingolfin/UnitTests/archive/TAGNAME.tar.gz ?
ArchiveURL     := Concatenation( ~.PackageWWWHome, "UnitTests-", ~.Version ),
# TODO: Replace "master" with tag generated from Version ?
README_URL     := Concatenation( ~.PackageWWWHome, "blob/master/README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "blob/master/PackageInfo.g" ),
AbstractHTML   := "TODO",

PackageDoc     := rec(
  BookName  := "UnitTests",
  ArchiveURLSubset := [ "doc" ],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Unit tests for GAP",
  Autoload  := true
),

Dependencies    := rec(
  GAP                    := ">= 4.5",
  NeededOtherPackages    := [
      [ "GAPDoc", ">= 1.0" ],
      #[ "AutDoc", ">=2012.07.29" ],
    ],
  SuggestedOtherPackages := [  ],
  ExternalConditions     := [ ]
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Autoload         := true,

Keywords := [
  "unit tests",
  ]
));

