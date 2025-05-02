##  <#GAPDoc Label="AssertionFailure">
##  <ManSection>
##    <Func Arg="arg" Name="AssertionFailure"/>
##    <Returns>nothing</Returns>
##    <Description>
##      Called by assert functions to signal that the assertion failed.
##      Accepts any number of arguments, which are combined to form a
##      description of the assertion failure.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AssertionFailure" );

##  <#GAPDoc Label="AssertEqual">
##  <ManSection>
##    <Func Arg="a, b" Name="AssertEqual"/>
##    <Returns>nothing</Returns>
##    <Description>
##      Compare the two parameters using = and trigger a test assertion if
##      they are not equal. This is similar in effect to
##      <Code>AssertTrue(a = b)</Code> but results in a more instructive
##      failure report.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AssertEqual" );

##  <#GAPDoc Label="AssertTrue">
##  <ManSection>
##    <Func Arg="a" Name="AssertTrue"/>
##    <Returns>nothing</Returns>
##    <Description>
##      Trigger a test assertion if the parameter does not equal true.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AssertTrue" );

##  <#GAPDoc Label="AssertFalse">
##  <ManSection>
##    <Func Arg="a" Name="AssertFalse"/>
##    <Returns>nothing</Returns>
##    <Description>
##      Trigger a test assertion if the parameter does not equal false.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AssertFalse" );

##  <#GAPDoc Label="AssertError">
##  <ManSection>
##    <Func Arg="msg, f, args" Name="AssertError"/>
##    <Returns>nothing</Returns>
##    <Description>
##      Assert that calling the function <A>f</A> with the argument list
##      <A>args</A> signals an error whose error message begins with <A>msg</A>.
##      Trigger a test assertion if this is not true, that is, if <A>f</A>
##      applied to <A>args</A> either does not signal an error, or signals
##       an error whose message does not begin with <A>msg</A>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AssertError" );


DeclareCategory( "IsTest", IsObject );

DeclareCategory( "IsTestContainer", IsObject );

DeclareCategory( "IsTestCase", IsTestContainer );

DeclareCategory( "IsTestSuite", IsTestContainer );

DeclareCategory( "IsParametrizedTestCase", IsObject );

DeclareOperation( "MakeTest", [ IsString, IsFunction, IsBool ] );

DeclareAttribute( "TestName", IsTest );

DeclareAttribute( "TestFunction", IsTest );

DeclareProperty( "IsExpectedFail", IsTest );

DeclareOperation( "Run", [ IsTest, IsPosInt ] );

##  <#GAPDoc Label="TestCase">
##  <ManSection>
##    <Func Arg="f" Name="TestCase"/>
##    <Returns>a test case</Returns>
##    <Description>
##      Create a test case.  The argument <A>f</A> is a function taking
##      four functions as arguments:
##      <C>Setup</C>, <C>TearDown</C>, <C>Test</C> and <C>FailingTest</C>
##      (see section <Ref Sect="InsideTest"/>).
##      The function <A>f</A> uses these four functions to create the test case.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "TestCase", [ IsFunction ] );

DeclareAttribute( "SetupFunction", IsTestCase );

DeclareAttribute( "TearDownFunction", IsTestCase );

DeclareAttribute( "Tests", IsTestCase );

DeclareOperation( "TestSuite", [ IsDenseList ] );

DeclareAttribute( "TestContainers", IsTestSuite );

DeclareAttribute( "NumberOfTests", IsTestContainer );

DeclareOperation( "Run", [ IsTestContainer ] );

DeclareOperation( "Run", [ IsTestContainer, IsPosInt ] );

DeclareOperation( "ParametrizedTestCase", [ IsDenseList, IsFunction ] );

DeclareAttribute( "InstantiationFunction", IsParametrizedTestCase );

DeclareAttribute( "FilterList", IsParametrizedTestCase );

DeclareOperation( "Instantiate", [ IsParametrizedTestCase, IsDenseList ] );
