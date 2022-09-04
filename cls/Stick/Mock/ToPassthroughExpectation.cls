Class Stick.Mock.ToPassthroughExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method AddBehavior(methodStub As Stick.Stub.Method)
{
  do methodStub.ThenPassthrough()
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Method, methodName As %String)
{
    
  set exception = spy.Calls(callIndex).ExceptionThrown
  
  if $isobject(exception) {
    set receivedMessage = $System.Status.GetErrorText(exception.AsStatus())
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have passthrough the call to the implementater but threw an exception instead (exception is '%2')", methodName, receivedMessage))
  }
  
  return $$$OK
}

}

