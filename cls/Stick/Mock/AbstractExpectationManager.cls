Class Stick.Mock.AbstractExpectationManager [ Abstract ]
{

Property Mock As Stick.Mock [ Private ];

Property Expectations As list Of Stick.Mock.AbstractExpectation [ Private ];

Property GroupKey As %String [ ReadOnly ];

Method %OnNew(mock As Stick.Mock, groupKey As %String) As %Status
{
  set ..Mock = mock
  set i%GroupKey = groupKey
  do ..Mock.AddExpectationManager($this)
  return $$$OK
}

Method AddExpectation(expectation As Stick.Mock.AbstractExpectation) As Stick.Mock.AbstractExpectation
{
  do ..Expectations.Insert(expectation)
  return expectation
}

Method Verify(callIndex As %Integer, expectationGroupCount As %Integer)
{
  for i=1:1:..Expectations.Count() $$$ThrowOnError(..Expectations.GetAt(i).DoAssert(callIndex, expectationGroupCount))
}

Method GetStub() As Stick.Stub
{
  return ..Mock.GetStub()
}

Method GetSpy()
{
  return ..GetStub().GetSpy(..GroupKey)
}

Method GetPropertySpy() As Stick.Spy.ICommon
{
  return ..GetStub().GetPropertySpy(..GroupKey)
}

Method PreEvaluate(callIndex As %Integer, spy As Stick.Spy.ICommon, groupKey As %String, callsExpected As %Integer) As %Status
{
  return ..OnPreEvaluate(callIndex, spy, groupKey, callsExpected)
}

Method OnPreEvaluate(callIndex As %Integer, spy As Stick.Spy.ICommon, groupKey As %String, callsExpected As %Integer) As %Status
{
  return $$$OK
}

}

