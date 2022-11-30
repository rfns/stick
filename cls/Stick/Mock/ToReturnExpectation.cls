Class Stick.Mock.ToReturnExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method AddBehavior(methodStub As Stick.Stub.Method)
{
  do methodStub.ThenReturn(..Value)
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy, methodName As %String) As %Status
{
  set methodSpy = spy.GetMethodSpy(methodName)
  
  if methodSpy.Calls(callIndex).ReturnedValue '= ..Value {
    set returnedValue = methodSpy.Calls(callIndex).ReturnedValue
    if $extract(returnedValue, 1, 2) = "0 " && $listvalid($extract(3, $length(returnedValue))) {
      set returnedValue = $System.Status.GetErrorText(returnedValue)
    }
    return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have returned '%2' (returned '%3' instead)", methodName, ..Value, returnedValue))
  }
  
  return $$$OK
}

}

