#############################################################################
##
#W  PackageInfo.g       GAP 4 Package `UnitTests'                    Max Horn
##

SetPackageInfo( rec(

PackageName := "UnitTests",
Subtitle    := "Unit tests for GAP",
Version     := "2013.08.19",
#Version     := "0.1dev",
#Date        := "09/01/2013",

Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( ~.Date{[ 9, 10 ]}, "/", ~.Date{[ 6, 7 ]}, "/", ~.Date{[ 1 .. 4 ]} ),

Persons          := [
  rec( LastName      := "Horn",
       FirstNames    := "Max",
       IsAuthor      := true,
       IsMaintainer  := true,
       Email         := "max.horn@math.uni-giessen.de",
       WWWHome       := "http://www.quendi.de/math",
       PostalAddress := Concatenation(
               "AG Algebra\n",
               "Mathematisches Institut\n",
               "JLU Gießen\n",
               "Arndtstraße 2\n",
               "D-35392 Gießen\n",
               "Germany" ),
       Place         := "Gießen",
       Institution   := "Justus-Liebig-Universität Gießen"
     )
    ],

Status         := "dev",
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


AutoDoc := rec(
    TitlePage := rec(
        Copyright := Concatenation(
                    "&copyright; 2013 Max Horn<P/>\n",
                    "The &UnitTests; package is free software;\n",
                    "you can redistribute it and/or modify it under the terms of the\n",
                    "<URL Text='GNU General Public License'>http://www.fsf.org/licenses/gpl.html</URL>\n",
                    "as published by the Free Software Foundation; either version 2 of the License,\n",
                    "or (at your option) any later version.\n"
                ),
    ),
),
    

Keywords := [
  "unit tests",
  ]
));

