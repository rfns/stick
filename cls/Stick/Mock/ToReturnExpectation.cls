Class Stick.Mock.ToReturnExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method AddBehavior(methodStub As Stick.Stub.Method)
{
  do methodStub.ThenReturn(..Value)
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Method, methodName As %String) As %Status
{
  if spy.Calls(callIndex).ReturnedValue '= ..Value {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have returned '%2' (returned '%3' instead)", methodName, ..Value, spy.LastReturnedValue))
  }
  
  return $$$OK
}

}

