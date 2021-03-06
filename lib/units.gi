InstallGlobalFunction( AssertEqual, function(a,b)
	if not (a = b) then
		# FIXME: String, ViewString, PrintString, DisplayString... ???
		JUMP_TO_CATCH(Concatenation("expected <", String(a), "> but got <", String(a), ">"));
	fi;
end );

InstallGlobalFunction( AssertTrue, function(a)
  if not a then
	  JUMP_TO_CATCH("expected true but got false");
  fi;
end );

InstallGlobalFunction( AssertFalse, function(a)
  if a then
	  JUMP_TO_CATCH("expected false but got false");
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
	local i, success, total, res, oldBreakOnError;
	if not suite.setup() then
		Print("Test setup failed!");
		return false;
	fi;
	success := 0;
	total := Length(suite.tests);
	Print("1..", total, "\n");
	for i in [1..total] do
		#Print("Running test '", suite.tests[i][1], "' (", i, "/", total, "): ");
		oldBreakOnError := BreakOnError;
		BreakOnError := false;
		res := CALL_WITH_CATCH(suite.tests[i][2], []);
		BreakOnError := true;
		# Output status
		if res[1] then
			success := success + 1;
			Print(TextAttr.bold, TextAttr.2, "ok ", TextAttr.reset);
			#Print("ok ");
		else
			# TODO: distinguish between assertion failures, and errors
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
		if not res[1] then Print("# ", res[2], "\n"); fi;
		
	od;
	suite.teardown();

	# TODO: Measure elapsed time
	# TODO: The following statistics really should be handled and printed by a test
	# harness, not by us.
	Print("Results: ", success, " succeeded, ", total - success, " failed, total ", total, "\n");

	return success = total;
end );
