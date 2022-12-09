Class Stick.Mock.AbstractExpectationManager [ Abstract ]
{

Property Mock As Stick.Mock [ Private ];

Property Expectations As list Of Stick.Mock.AbstractExpectation [ Private ];

Property GroupKey As %String [ ReadOnly ];

Property GroupIndex As %String [ ReadOnly ];

Property CallsExpected As %Integer [ InitialExpression = 1 ];

Property ArgsExpected [ MultiDimensional ];

Method %OnNew(mock As Stick.Mock, groupKey As %String, groupIndex As %String) As %Status
{
  set ..Mock = mock
  set i%GroupKey = groupKey
  set i%GroupIndex = groupIndex
  do ..Mock.AddExpectationManager($this)
  return $$$OK
}

Method GetExpectedCallsCount() As %Integer
{
  return ..Mock.GetExpectedCallsCount()
}

Method AddExpectation(expectation As Stick.Mock.AbstractExpectation) As Stick.Mock.AbstractExpectation
{
  do ..Expectations.Insert(expectation)
  return expectation
}

Method Verify()
{
  set returnSC = $$$OK
  set sc = $$$OK
  set titleErrorMessage = "One more more expectation were not met:"
  
  for i=1:1:..Expectations.Count() {
    set expectation = ..Expectations.GetAt(i) 
    set sc = $$$ADDSC(sc, expectation.Met())
  }
  
  if $$$ISERR(sc) {
    return $$$EMBEDSC(sc, $$$ERROR($$$GeneralError, titleErrorMessage))
  }
  
  return $$$OK
}

Method GetStub() As Stick.Stub
{
  return ..Mock.GetStub()
}

Method GetSpy() As Stick.Spy
{
  return ..GetStub().GetSpy()
}

Method PreEvaluate(spy As Stick.Spy) As %Status
{
  return ..OnPreEvaluate(spy, ..GroupKey)
}

Method OnPreEvaluate(spy As Stick.Spy, groupKey As %String, callsExpected As %Integer) As %Status
{
  return $$$OK
}

}

