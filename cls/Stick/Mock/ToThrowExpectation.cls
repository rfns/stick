Class Stick.Mock.ToThrowExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method AddBehavior(methodStub As Stick.Stub.Method)
{
  for i=1:1:methodStub.LastCallLimitIncrease  do methodStub.ThenThrow(..Value)
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy, methodName As %String)
{
  
  set methodSpy = spy.GetMethodSpy(methodName)
  
  set expectedStatus = ..Value.AsStatus()
  set receivedStatus = $select($isobject(methodSpy.Calls(callIndex).ExceptionThrown) : methodSpy.Calls(callIndex).ExceptionThrown.AsStatus(), 1: "")
  set expectedMessage = $System.Status.GetErrorText(expectedStatus)
  set receivedMessage = $select($$$ISERR(receivedStatus): $System.Status.GetErrorText(receivedStatus), 1: "")
  
  if expectedMessage '= receivedMessage {
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have thrown '%2' (but got '%3' instead)", methodName, expectedMessage, receivedMessage))
  }
  
  return $$$OK
}

}

