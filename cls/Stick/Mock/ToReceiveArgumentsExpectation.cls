Class Stick.Mock.ToReceiveArgumentsExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method AddBehavior(methodStub As Stick.Stub.Method)
{
  merge args = ..Value 
  do methodStub.CallWithArguments(args...)
}

Method OnEvaluate2(callIndex As %Integer, spy As Stick.Spy, methodName As %String) As %Status
{
  set sc = $$$OK
  
  set i = callIndex
  set methodSpy = spy.GetMethodSpy(methodName)
  
  do {        
    kill receivedArgs, expectedArgs
    
    merge receivedArgs = methodSpy.Calls(i).Arguments
    merge expectedArgs = ..Value
  
    set usedArgsList = ##class(Stick.Helper).SerializeArguments(.receivedArgs)
    set expectedArgsList = ##class(Stick.Helper).SerializeArguments(.expectedArgs)  
    
    if '##class(Stick.Helper).ArgumentCompare(.expectedArgs, .receivedArgs) {
      return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have been called with args '%2' (received '%3' instead)", methodName, expectedArgsList, usedArgsList))
    }
    
    set i = i + 1
  } while i < ..ExpectationManager.CallsExpected
  
  return sc
}

Method SetSharedExpectation(manager As Stick.Mock.AbstractExpectationManager)
{
  merge manager.ArgsExpected = ..Value
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy, methodName As %String)
{
  set sc = $$$OK
  
  set i = callIndex
  set methodSpy = spy.GetMethodSpy(methodName)
  
  merge expectedArgs = ..Value
  
  set expectedArgsList = ##class(Stick.Helper).SerializeArguments(.expectedArgs)
             
  if methodSpy.GetTimesCalledWithArguments(.expectedArgs) = 0 {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have been called with args '%2'", methodName, expectedArgsList))
  }               
  
  return sc
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

