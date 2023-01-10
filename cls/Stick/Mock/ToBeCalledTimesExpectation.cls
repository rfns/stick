Class Stick.Mock.ToBeCalledTimesExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method SetSharedExpectation(groupManager As Stick.Mock.AbstractExpectationManager)
{
  set groupManager.CallsExpected = ..Value
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy, methodName As %String) As %Status
{
  set methodSpy = spy.GetMethodSpy(methodName)
  merge argsExpected = ..GetExpectationManager().ArgsExpected
  set times = methodSpy.CallCount
  
  if $data(argsExpected) > 0 {
    set times = methodSpy.GetTimesCalledWithArguments(.argsExpected)
  }
  
  set expectedArgs = ##class(Stick.Helper).SerializeArguments(.argsExpected)
  
  if times '= ..Value {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have been called exactly %2 time(s) with arguments '%3' (got called %4 time(s))", methodName, ..Value, expectedArgs, times))
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

