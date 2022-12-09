Class Stick.Mock.ToPassthroughExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method AddBehavior(methodStub As Stick.Stub.Method)
{
  for i=1:1:methodStub.LastCallLimitIncrease  do methodStub.ThenPassthrough()
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy, methodName As %String)
{
  
  set methodSpy = spy.GetMethod(methodName)
  set exception = methodSpy.Calls(callIndex).ExceptionThrown
  
  if $isobject(exception) {
    set receivedMessage = $System.Status.GetErrorText(exception.AsStatus())
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have passthrough the call to the implementater but threw an exception instead (exception is '%2')", methodName, receivedMessage))
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

}

