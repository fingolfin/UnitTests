# TODO: It would be nicer if the assertions provided more info, e.g.
# the precise line where the assertion occurred
AssertEqual := function(a,b)
	if not (a = b) then
		# FIXME: String, ViewString, PrintString, DisplayString... ???
		JUMP_TO_CATCH(Concatenation("expected <", String(a), "> but instead got <", String(a), ">"));
	fi;
end;

AssertTrue := function(a)
  if not a then
	  JUMP_TO_CATCH("Assertion Failure\n");
  fi;
end;

AssertFalse := function(a)
  if a then
	  JUMP_TO_CATCH("Assertion Failure\n");
  fi;
end;


__TEST_CASE_TMP__:=fail;
ReadTestCase := function(filename)
	local suite, AddSetup, AddTearDown, AddTest, AddFailingTest, func_src; #, func;
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
	AddTest := function(name,test)
		Add(suite.tests, [name,test,false]);
	end;
	AddFailingTest := function(name,test)
		Add(suite.tests, [name,test,true]);
	end;
	#func := ReadAsFunction(filename);
	# TODO: ReadAsFunction does not quite work as I want it to,
	# it does not pass on the local vars.
	# Workaround: Use ReadAsFunction on a custom stream.
	# That stream wraps the file; it prepends
	#  func := function(AddSetup, AddTearDown, AddTest)
	# and append "end;"
	func_src := StringFile("unit-test.g");
	func_src := Concatenation(
		"__TEST_CASE_TMP__ := function(AddSetup, AddTearDown, AddTest, AddFailingTest)\n",
		func_src,
		"\n",
		"end;\n");
	Read(InputTextString(func_src));
	CallFuncList(__TEST_CASE_TMP__, [AddSetup, AddTearDown, AddTest, AddFailingTest]); # populate the suite

# TODO: how can we optionally add further (optional?) parameters
# in order to create a parametrized test suite? 

	return suite;
end;;

RunTestSuite := function(suite)
	local i, success, total, res;
	if not suite.setup() then
		Print("Test setup failed!");
		return false;
	fi;
	success := 0;
	total := Length(suite.tests);
	for i in [1..total] do
		Print("Running test '", suite.tests[i][1], "' (", i, "/", total, "): ");
		res := CALL_WITH_CATCH(suite.tests[i][2], []);
		if res[1] = true then
			success := success + 1;
			if suite.tests[i][3] then Print("unexpected "); fi;
			Print("success\n");
		else
			if suite.tests[i][3] then Print("expected "); fi;
			Print("failure\n");
			if suite.tests[i][3] then Print("  ", res[2], "\n"); fi;
		fi;
	od;
	suite.teardown();
	# TODO: Measure elapsed time
	Print("Results: ", success, " succeeded, ", total - success, " failed, total ", total, "\n");
	
	return success = total;
end;
