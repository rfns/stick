Class Stick.Mock.ToUseArgumentsExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Method, methodName As %String) As %Status
{
  merge args = spy.Calls(callIndex).Arguments
  merge expectedArgs = ..Value
  
  set usedArgsList = ""
  set expectedArgsList = ""
  
  do SerializeArgs
    
  if '##class(Stick.Helper).ArgumentCompare(.expectedArgs, .args) {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have been called with args '%2', (used '%3' instead)", methodName, $lts(expectedArgsList), $lts(usedArgsList)))
  }
  
  return $$$OK
  
SerializeArgs
  set key = ""
  for  set key=$order(args(key))  quit:key=""  set $list(usedArgsList, *+1) = args(key)
  set key = ""
  for  set key=$order(expectedArgs(key))  quit:key=""  set $list(expectedArgsList, *+1) = expectedArgs(key)
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

Method AndBeCalledOnce() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ExpectationManager.ToBeCalledOnce()
}

Method AndBeCalledTwice() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ExpectationManager.ToBeCalledTwice()
}

Method AndBeCalledThrice() As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ExpectationManager.ToBeCalledThrice()
}

Method AndBeCalledNTimes(n As %Integer) As Stick.Mock.ToBeCalledTimesExpectation
{
  return ..ExpectationManager.ToBeCalledNTimes(n)
}

Method AndPassthrough() As Stick.Mock.ToPassthroughExpectation
{
  return ..ExpectationManager.ToPassthrough()
}

}

