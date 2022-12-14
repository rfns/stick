Class Stick.Mock.ToNotReceiveArgumentsExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Method, methodName As %String) As %Status
{
  merge args = spy.Calls(callIndex).Arguments
  merge expectedArgs = ..Value
  
  set usedArgsList = ""
  
  do SerializeArgs
    
  if args '= "" {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have been called without any args (but received '%2' instead)", methodName, $lts(usedArgsList)))
  }
  
  return $$$OK
  
SerializeArgs
  set key = ""
  for  set key=$order(args(key))  quit:key=""  set $list(usedArgsList, *+1) = args(key)  
  quit
}

Method AndReturn(value = "") As Stick.Mock.ToReturnExpectation
{
  return ..ExpectationManager.ToReturn(value)
}

Method AndThrow(exception As %Exception.AbstractException) As Stick.Mock.ToThrowExpectation
{
  return ..ExpectationManager.ToThrow(exception)
}

Method ToBeCalledOnce() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ExpectationManager.ToBeCalledOnce()
}

Method ToBeCalledTwice() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ExpectationManager.ToBeCalledTwice()
}

Method ToBeCalledThrice() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ExpectationManager.ToBeCalledThrice()
}

Method ToBeCalledNTimes(n As %Integer) As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ExpectationManager.ToBeCalledNTimes(n)
}

Method ToPassthrough() As Stick.Mock.ToPassthroughExpectation
{
  return ..ExpectationManager.ToPassthrough()
}

}

