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
##    <Example>
##    </Example>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "AssertEqual" );
