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

Method OnPreEvaluate(spy As Stick.Spy, methodName As %String) As %Status
{
  set methodSpy = spy.GetMethodSpy(methodName)
  
  if methodSpy.CallCount = 0 {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' doesn't seem to be called.", methodName))
  }
  
  set expectedCallsCount = ..GetExpectedCallsCount()
  
  if methodSpy.CallCount > expectedCallsCount {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' has been called %2 times, expected only %3.", methodName, methodSpy.CallCount, expectedCallsCount))
  }
   
  return $$$OK
}

}

