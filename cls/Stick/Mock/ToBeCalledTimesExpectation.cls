Class Stick.Mock.ToBeCalledTimesExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Method, methodName As %String) As %Status
{
  if spy.CallCount '= ..Value {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have been called exactly %2 time(s) (got called %3)", methodName, ..Value, spy.CallCount))
  }
  
  return $$$OK
}

Method AndReturn(value = "") As Stick.Mock.ToReturnExpectation
{
  return ..ExpectationManager.ToReturn(value)
}

Method AndThrow(exception As %Exception.AbstractException) As Stick.Mock.ToThrowExpectation
{
  return ..ExpectationManager.ToThrow(exception)
}

Method ToReceiveArguments(args...) As Stick.Mock.ToReceiveArgumentsExpectation
{
  return ..ExpectationManager.ToReceiveArguments(args...)
}

Method ToNotReceiveArguments(args...) As Stick.Mock.ToNotReceiveArgumentsExpectation
{
  return ..ExpectationManager.ToNotReceiveArguments(args...)
}

Method ToPassthrough() As Stick.Mock.ToPassthroughExpectation
{
  return ..ExpectationManager.ToPassthrough()
}

}

