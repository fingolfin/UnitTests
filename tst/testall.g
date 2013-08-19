LoadPackage("UnitTests");
d := DirectoriesPackageLibrary("UnitTests", "tst")[1];

# Scan over all *.unit files in this directory
# TODO: Turn this into a RunUnitsInDir function
files := DirectoryContents( d );
for f in files do
    if Length(f) > 5 and f{[Length(f)-4 .. Length(f)]} = ".unit" then
        Print("Running unit tests in tst/", f, "\n");
        suite := InstantiateTestSuite(Filename(d, f));
        RunTestSuite(suite);
    fi;
od;
