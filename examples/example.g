LoadPackage("UnitTests");

additive := ParametrizedTestCase( [ IsAdditiveElement, IsAdditiveElement ],
function( Setup, TearDown, Test, FailingTest, a, b )
        # would be nice if "a+b" was available as both string and evaluated value

        Test("plus", function()
                AssertEqual( a, 1 * a );
                AssertEqual( a + a, 2 * a );
                # Commutative, associative
                AssertEqual( a + b, b + a );
                AssertEqual( (a + b) + a, a + (b + a) );
        end);

        Test("ainv", function()
                AssertEqual( -(-a), a );
                AssertEqual( -(a+b), -a - b );
                AssertEqual( -a, (-1) * a );
                AssertTrue( IsZero( a + (-a) ) );
        end);

        Test("zero", function()
                # is zero neutral and idempotent?
                AssertEqual( a + Zero(a), a );
                AssertEqual( Zero(a) + Zero(a), Zero(a) );
                AssertEqual( Zero(Zero(a)), Zero(a) );
                # Some alternative ways to produce zero
                AssertEqual( Zero( a ), a - a );
                AssertEqual( Zero( a ), 0 * a );
        end );
end );

additive_suite := TestSuite( [ Instantiate( additive, [ 42, -19 ] ),
                               Instantiate( additive, [ [ 17, 0 ], [ -17, 42 ] ] ) ] );

smallgroup := TestCase( function( Setup, TearDown, Test, FailingTest )
        local G, oldlevel;

        # Optionally perform some setup whenever an instance
        # of this test suite is run.
        Setup(function()
                oldlevel := InfoLevel(InfoWarning);
                SetInfoLevel(InfoWarning, 1);
                G := SmallGroup(8, 4);
                return true; # return false to indicate a setup failure
        end);

        # Optionally perform some setup after an instance
        # of this test suite has been run.
        TearDown(function()
                SetInfoLevel(InfoWarning, oldlevel);
        end);

        # a working test
        Test("group size", function()
                AssertEqual( Size(G), 8 );
        end);

        # another working test
        Test("small group id", function()
                AssertEqual( IdSmallGroup(G), [8, 4] );
        end);

        # a failing test (oops)
        Test("small group id", function()
                AssertTrue( IsAbelian(G) );
        end);

        # a known-to-fail test
        FailingTest("size_expected_fail", function()
                AssertEqual( Size(G), 7 );
        end);

        # a known-to-fail test that actually passes
        FailingTest("dummy_unexpected_pass", function()
                AssertEqual( 17, 17 );
        end);
end );

all_tests := TestSuite( [ additive_suite, smallgroup ] );

Run( all_tests );
