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

InstallGlobalFunction( AssertError, function(msg, f, args)
	local res, errmsg;
	res := CALL_WITH_CATCH(f, args);
	if res[1] then
		AssertionFailure("expected Error(", msg, "...) but got no error");
	else
		errmsg := res[2][2];
		if not StartsWith(errmsg, msg) then
			AssertionFailure("expected Error(", msg, "...) but got Error(", errmsg, ")");
		fi;
	fi;
end );

BindGlobal( "FamilyOfTests", NewFamily("tests") );

InstallMethod( MakeTest, [ IsString, IsFunction, IsBool ],
function(name, f, expected_fail)
	local test, type;
	test := rec();
	type := NewType(FamilyOfTests,
			IsTest and IsComponentObjectRep and IsAttributeStoringRep);
	ObjectifyWithAttributes(test, type,
				TestName, name,
				TestFunction, f,
				IsExpectedFail, expected_fail);
	return test;
end );

InstallMethod( String, [ IsTest ],
function(test)
	return Concatenation("<test ", TestName(test), ">");
end );

InstallMethod( Run, [ IsTest, IsPosInt ],
function(test, nr)
	local OriginalErrorInnerFunction, res, success, type, message;
	OriginalErrorInnerFunction := ErrorInner;
	MakeReadWriteGlobal("ErrorInner");
	ErrorInner := function(arg)
		local errmsg;
		errmsg := Concatenation(List(arg[2], String));
		JUMP_TO_CATCH([ "error", errmsg ]);
	end;
	MakeReadOnlyGlobal("ErrorInner");
	res := CALL_WITH_CATCH(TestFunction(test), []);
	MakeReadWriteGlobal("ErrorInner");
	ErrorInner := OriginalErrorInnerFunction;
	MakeReadOnlyGlobal("ErrorInner");

	# Output status
	success := res[1];
	if success then
		Print(TextAttr.bold, TextAttr.2, "ok ", TextAttr.reset);
	else
		Print(TextAttr.bold, TextAttr.1, "not ok ", TextAttr.reset);
	fi;
	# Output test number
	Print(nr);
	# Output description
	Print(" ", TestName(test));
	# Output directive, if any (i.e. mark test as expected fail, or as skipped
	if IsExpectedFail(test) then
		Print(" # TODO");
	fi;
	Print("\n");
	# Optionally: Display diagnostics
	if not success then
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
	return success;
end );

BindGlobal( "FamilyOfTestCases", NewFamily("test cases") );

InstallMethod( TestCase, [ IsFunction ],
function(f)
	local Setup, TearDown, Test, FailingTest,
	      setup_func, tear_down_func, tests,
	      nargs, test_case, type;

	nargs := NumberArgumentsFunction(f);
	if nargs <> 4 then
		Error("Test case instantiation function must take at least 4 arguments ",
		      "(Setup, TearDown, Test, FailingTest)");
	fi;

	Setup := function(fn)
		if not IsFunction(fn) or NumberArgumentsFunction(fn) <> 0 then
			Error("Argument to Setup must be a function taking no arguments");
		fi;
		if IsBound(setup_func) then
			Error("Setup function already set");
		fi;
		setup_func := fn;
	end;
	TearDown := function(fn)
		if not IsFunction(fn) or NumberArgumentsFunction(fn) <> 0 then
			Error("Argument to TearDown must be a function taking no arguments");
		fi;
		if IsBound(tear_down_func) then
			Error("TearDown function already set");
		fi;
		tear_down_func := fn;
	end;
	Test := function(name, fn)
		if not IsString(name) then
			Error("First argument to Test must be a string");
		fi;
		if not IsFunction(fn) or NumberArgumentsFunction(fn) <> 0 then
			Error("Second argument to Test must be a function taking no arguments");
		fi;
		Add(tests, MakeTest(name, fn, false));
	end;
	FailingTest := function(name, fn)
		if not IsString(name) then
			Error("First argument to FailingTest must be a string");
		fi;
		if not IsFunction(fn) or NumberArgumentsFunction(fn) <> 0 then
			Error("Second argument to FailingTest must be a function taking no arguments");
		fi;
		Add(tests, MakeTest(name, fn, true));
	end;

	tests := [];
	f(Setup, TearDown, Test, FailingTest);
	if not IsBound(setup_func) then
		setup_func := ReturnTrue;
	fi;
	if not IsBound(tear_down_func) then
		tear_down_func := ReturnTrue;
	fi;

	test_case := rec();
	type := NewType(FamilyOfTestCases,
			IsTestCase and IsComponentObjectRep and IsAttributeStoringRep);
	ObjectifyWithAttributes(test_case, type,
				SetupFunction, setup_func,
				TearDownFunction, tear_down_func,
				Tests, tests,
				NumberOfTests, Length(tests));
	return test_case;
end );

InstallMethod( String, [ IsTestCase ],
function(test_case)
	return "<test case>";
end );

InstallMethod( Run, [ IsTestCase, IsPosInt ],
function(test_case, start_nr)
	local setup, tear_down, tests, nr, successes, test;
	setup := SetupFunction(test_case);
	tear_down := TearDownFunction(test_case);
	tests := Tests(test_case);
	if not setup() then
		Print("Test setup failed!");
		return false;
	fi;
	nr := start_nr;
	successes := 0;
	for test in tests do
		if Run(test, nr) then
			successes := successes + 1;
		fi;
		nr := nr + 1;
	od;
	tear_down();
	return successes;
end );

BindGlobal( "FamilyOfParametrizedTestCases", NewFamily("parametrized test cases") );

InstallMethod( ParametrizedTestCase, [ IsDenseList, IsFunction ],
function(filter_list, f)
	local n_params, p_test_case, type;
	n_params := NumberArgumentsFunction(f) - 4;
	if n_params < 0 then
		Error("Instantiation function for parametrized test case must take at least 4 arguments ",
		      "(Setup, TearDown, Test, FailingTest)");
	fi;
	if Length(filter_list) <> n_params then
		Error("Wrong length of filter list (is ", Length(filter_list),
		      ", should be ", n_params, ")");
	fi;
	if not ForAll(filter_list, IsFilter) then
		Error("Elements of filter list must be filters");
	fi;
	p_test_case := rec();
	type := NewType(FamilyOfParametrizedTestCases,
			IsParametrizedTestCase and IsComponentObjectRep and IsAttributeStoringRep);
	ObjectifyWithAttributes(p_test_case, type,
				InstantiationFunction, f,
				FilterList, filter_list);
	return p_test_case;
end );

InstallMethod( String, [ IsParametrizedTestCase ],
function(test_case)
	return "<parametrized test case>";
end );

InstallMethod( Instantiate, [ IsParametrizedTestCase, IsDenseList ],
function(p_test_case, args)
	local filter_list, n_params, i, filter, f;
	filter_list := FilterList(p_test_case);
	n_params := Length(filter_list);
	if Length(args) <> n_params then
		Error("Wrong number of arguments for parametrized test case ",
		      "(expected ", n_params, ", got ", Length(args), ")");
	fi;
	for i in [1..n_params] do
		filter := filter_list[i];
		if not filter(args[i]) then
			Error("Not in filter ", filter, ": ", args[i]);
		fi;
	od;
	f := function(Setup, TearDown, Test, FailingTest)
		CallFuncList(InstantiationFunction(p_test_case),
			     Concatenation([Setup, TearDown, Test, FailingTest], args));
	end;
	return TestCase(f);
end );

BindGlobal( "FamilyOfTestSuites", NewFamily("test suites") );

InstallMethod( TestSuite, [ IsDenseList ],
function(test_containers)
	local test_suite, type;
	if not ForAll(test_containers, IsTestContainer) then
		Error("Argument to TestSuite not a list of test containers");
	fi;
	test_suite := rec();
	type := NewType(FamilyOfTestSuites,
			IsTestSuite and IsComponentObjectRep and IsAttributeStoringRep);
	ObjectifyWithAttributes(test_suite, type,
				TestContainers, test_containers,
				NumberOfTests, Sum(test_containers, NumberOfTests));
	return test_suite;
end );

InstallMethod( String, [ IsTestSuite ],
function(test_suite)
	return "<test suite>";
end );

InstallMethod( Run, [ IsTestSuite, IsPosInt ],
function(test_suite, start_nr)
	local nr, successes, test_container;
	nr := start_nr;
	successes := 0;
	for test_container in TestContainers(test_suite) do
		successes := successes + Run(test_container, nr);
		nr := nr + NumberOfTests(test_container);
	od;
	return successes;
end );

InstallMethod( Run, [ IsTestContainer ],
function(test_container)
	local total, successes;
	total := NumberOfTests(test_container);
	Print("1..", total, "\n");
	successes := Run(test_container, 1);
	# TODO: Measure elapsed time
	# TODO: The following statistics really should be handled and printed by a test
	# harness, not by us.
	Print("Results: ", successes, " succeeded, ",
	      total - successes, " failed, total ", total, "\n");
end );
