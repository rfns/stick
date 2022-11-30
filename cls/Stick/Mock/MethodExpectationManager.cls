Class Stick.Mock.MethodExpectationManager Extends (%RegisteredObject, Stick.Mock.AbstractExpectationManager)
{

Method ToBeCalledNTimes(n As %Integer) As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..AddExpectation(##class(Stick.Mock.ToBeCalledTimesExpectation).Assign($this, n))
}

Method ToBeCalledOnce() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ToBeCalledNTimes(1)
}

Method ToBeCalledTwice() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ToBeCalledNTimes(2)
}

Method ToBeCalledThrice() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ToBeCalledNTimes(3)
}

Method ToReceiveArguments(args...) As Stick.Mock.ToReceiveArgumentsExpectation
{
  return ..AddExpectation(##class(Stick.Mock.ToReceiveArgumentsExpectation).Assign($this, .args))
}

Method ToNotReceiveArguments(args...) As Stick.Mock.ToNotReceiveArgumentsExpectation
{
  return ..AddExpectation(##class(Stick.Mock.ToNotReceiveArgumentsExpectation).Assign($this, .args))
}

Method ToReturn(value = "") As Stick.Mock.MethodExpectationManager
{
  return ..AddExpectation(##class(Stick.Mock.ToReturnExpectation).Assign($this, value))
}

Method ToThrow(exception As %Exception.StatusException) As Stick.Mock.ToThrowExpectation
{
  return ..AddExpectation(##class(Stick.Mock.ToThrowExpectation).Assign($this, exception))
}

Method ToPassthrough() As Stick.Mock.ToPassthroughExpectation
{
  return ..AddExpectation(##class(Stick.Mock.ToPassthroughExpectation).Assign($this))
}

Method OnPreEvaluate(callIndex As %Integer, spy As Stick.Spy, methodName As %String, callsExpected As %Integer) As %Status
{
  set methodSpy = spy.GetMethodSpy(methodName)
  
  if '$isobject(methodSpy) || ($isobject(methodSpy) && '$data(methodSpy.Calls)) {
    return $$$ERROR($$$GeneralError, $$$FormatText("method '%1' doesn't seem to be called.", methodName))
  }  
  
  if methodSpy.CallCount > callsExpected {
    return $$$ERROR($$$GeneralError, $$$FormatText("Unexpected method call: '%1' seems to have been called more than expected. (got called %2 but expected only %3 time(s))", methodName, methodSpy.CallCount, callsExpected))
  }
  
  if methodSpy.CallCount < callsExpected {
    return $$$ERROR($$$GeneralError, $$$FormatText("Missing method call: expected '%1' to be called %2 time(s). (got called only %3 times(s))", methodName, callsExpected, methodSpy.CallCount))
  }
  
  return $$$OK
}

}

