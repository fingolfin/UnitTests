LoadPackage("AutoDoc");

AutoDoc(
    "UnitTests",
    rec(
        scaffold := rec(
            includes := [
                "intro.xml",
                "methods.xml",
                ],
        ),
    )
);

QUIT;
