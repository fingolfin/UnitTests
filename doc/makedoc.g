LoadPackage( "GAPDoc" );

# Determine GAPROOT
if IsRecord(GAPInfo.SystemEnvironment) and
   IsBound(GAPInfo.SystemEnvironment.GAPROOT) then
	GAPROOT:=GAPInfo.SystemEnvironment.GAPROOT;
else
	GAPROOT:="../../..";
fi;
Display(GAPROOT);

# Some settings
SetGapDocLaTeXOptions( "utf8" );

# Update bib
#bib := ParseBibFiles( "doc/AutoDoc.bib" );
#WriteBibXMLextFile( "doc/AutoDocBib.xml", bib );

# List of files to scan
files := [ "../PackageInfo.g" ];;

# Update the VERSION file
PrintTo( "../VERSION", PackageInfo( "UnitTests" )[1].Version );

# Generate the documentation
main := "UnitTests";;
bookname := "UnitTests";;
MakeGAPDocDoc( ".", main, files, bookname, GAPROOT, "MathJax" );;

# Copy over the style files (only available in newer GAPDoc versions)
if IsBound(CopyHTMLStyleFiles) then
	CopyHTMLStyleFiles(".");
fi;

# Generate .lab file (needed for other packages which want to
# have refs to our manual).
GAPDocManualLab( "UnitTests" );
