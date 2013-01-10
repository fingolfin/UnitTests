LoadPackage("UnitTests");
d := DirectoriesPackageLibrary("UnitTests","examples");

# Run a simple test suite with some passing tests but
# also an expected fail and an unexpected pass.
suite := InstantiateTestSuite(Filename(d,"smallgroup.unit"));
RunTestSuite(suite);

# Run a parametrized test suite
suite := InstantiateTestSuite(Filename(d,"additive.unit"), 42, -19);
RunTestSuite(suite);

# Run the same test suite, but instantiate it with different parameters.
# This time two int lists.
suite := InstantiateTestSuite(Filename(d,"additive.unit"), [17,0], [-17,42]);
RunTestSuite(suite);
