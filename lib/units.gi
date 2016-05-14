InstallGlobalFunction( AssertionFailure, function(arg)
	JUMP_TO_CATCH(["assertion failure",
		       Concatenation(List(arg, String))]);
end );

InstallGlobalFunction( AssertEqual, function(a,b)
	if not (a = b) then
		# FIXME: String, ViewString, PrintString, DisplayString... ???
		AssertionFailure("expected <", a, "> but got <", b, ">");
	fi;
end );

InstallGlobalFunction( AssertTrue, function(a)
	if not a then
		AssertionFailure("expected true but got false");
	fi;
end );

InstallGlobalFunction( AssertFalse, function(a)
	if a then
		AssertionFailure("expected false but got true");
	fi;
end );


__TEST_SUITE_FUNC__ := fail;

InstallGlobalFunction( InstantiateTestSuite, function(arg)
	local filename, suite, AddSetup, AddTearDown, AddTestCase, AddFailingTestCase, func_src;
	filename := arg[1];
	suite := rec(
				setup := ReturnTrue,
				teardown := ReturnTrue,
				tests := []
			);
	AddSetup := function(setup)
		suite.setup := setup;
	end;
	AddTearDown := function(teardown)
		suite.teardown := teardown;
	end;
	AddTestCase := function(name,test)
		Add(suite.tests, [name,test,false]);
	end;
	AddFailingTestCase := function(name,test)
		Add(suite.tests, [name,test,true]);
	end;

    # Read the test suite code, and "wrap" it into a function declaration.
    # Then let GAP parse this. Unfortunately, there seems to be no way to
    # parse it in the local context, hence we must assign the function resulting
    # from the parsing to a global variable.
	func_src := StringFile(filename);
	func_src := Concatenation(
		"__TEST_SUITE_FUNC__:=function(AddSetup,AddTearDown,AddTestCase,AddFailingTestCase,args)\n",
		"  CallFuncList(function(arg)\n",
		     func_src, "\n",
		"  end, args);\n",
		"end;\n" );
	Read(InputTextString(func_src));

	# now execute the new function to populate "suite"
	CallFuncList(__TEST_SUITE_FUNC__, [AddSetup, AddTearDown, AddTestCase, AddFailingTestCase, arg{[2..Length(arg)]}]);

	return suite;
end );

# Run a test suite, output results in TAP format, or at least try to.
# See <http://en.wikipedia.org/wiki/Test_Anything_Protocol>
InstallGlobalFunction( RunTestSuite, function(suite)
	local i, success, total, res, OriginalErrorInnerFunction, type, message;
	if not suite.setup() then
		Print("Test setup failed!");
		return false;
	fi;
	success := 0;
	total := Length(suite.tests);
	Print("1..", total, "\n");
	for i in [1..total] do
		#Print("Running test '", suite.tests[i][1], "' (", i, "/", total, "): ");
		OriginalErrorInnerFunction := ErrorInner;
		MakeReadWriteGlobal("ErrorInner");
		ErrorInner := function(arg)
			local errmsg;
			errmsg := Concatenation( List( arg[ 2 ], String ) );
			JUMP_TO_CATCH( [ "error", errmsg ] );
		end;
		MakeReadOnlyGlobal("ErrorInner");
		res := CALL_WITH_CATCH(suite.tests[i][2], []);
		MakeReadWriteGlobal("ErrorInner");
		ErrorInner := OriginalErrorInnerFunction;
		MakeReadOnlyGlobal("ErrorInner");
		# Output status
		if res[1] then
			success := success + 1;
			Print(TextAttr.bold, TextAttr.2, "ok ", TextAttr.reset);
			#Print("ok ");
		else
			Print(TextAttr.bold, TextAttr.1, "not ok ", TextAttr.reset);
			#Print("not ok ");
		fi;
		# Output test number
		Print(i);
		# Output description
		Print(" ", suite.tests[i][1]);
		# Output directive, if any (i.e. mark test as expected fail, or as skipped
		if suite.tests[i][3] then Print(" # TODO"); fi;
		Print("\n");
		# Optionally: Display diagnostics
		if not res[1] then
			type := res[2][1];
			message := res[2][2];
			if type = "assertion failure" then
				Print("# ", message, "\n");
			elif type = "error" then
				Print("# unexpected error: ", message, "\n");
			else
				# this should not happen
				Error("bad value from JUMP_TO_CATCH: ", res[2]);
			fi;
		fi;
		
	od;
	suite.teardown();

	# TODO: Measure elapsed time
	# TODO: The following statistics really should be handled and printed by a test
	# harness, not by us.
	Print("Results: ", success, " succeeded, ", total - success, " failed, total ", total, "\n");

	return success = total;
end );
