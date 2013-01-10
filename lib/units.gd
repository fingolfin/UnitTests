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



##  <#GAPDoc Label="InstantiateTestSuite">
##  <ManSection>
##    <Func Arg="filename[, params]" Name="InstantiateTestSuite"/>
##    <Returns>a test suite</Returns>
##    <Description>
##      Instantiate an (optionally parametrized) test suite.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "InstantiateTestSuite" );

##  <#GAPDoc Label="RunTestSuite">
##  <ManSection>
##    <Func Arg="suite" Name="RunTestSuite"/>
##    <Returns>TODO</Returns>
##    <Description>
##      Run a test suite.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "RunTestSuite" );
