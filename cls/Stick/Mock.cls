Class Stick.Mock Extends %RegisteredObject
{

Property Stub As Stick.Stub [ Private ];

Property MethodExpectationManagers As list Of Stick.Mock.MethodExpectationManager [ Private ];

Property LastExpectationGroupIndex As %Integer [ InitialExpression = 0 ];

Method %OnNew(className As %RegisteredObject = "", args...) As %Status
{
  set ..Stub = ##class(Stick.Stub).%New(className, args...)
  return $$$OK
}

ClassMethod Create(className As %RegisteredObject = "", args...) As Stick.Mock
{
  return ..%New(className, args...)
}

Method EnsureMethodStubExists(methodName As %String) [ Private ]
{
  if '..Stub.IsMethodStubbed(methodName) {
    do ..Stub.When(methodName)
  }
}

Method GetSpy()
{
  return ..Stub.GetSpy()
}

Method GetExpectedCallsCount() As %Integer
{
  set expectedCalls = 0
  
  for i=1:1:..MethodExpectationManagers.Count() {
    set expectedCalls = expectedCalls + ..MethodExpectationManagers.GetAt(i).CallsExpected
  }
  
  return expectedCalls
}

Method Expects(methodName As %String) As Stick.Mock.MethodExpectationManager
{
  do ..EnsureMethodStubExists(methodName)
  set ..LastExpectationGroupIndex = ..LastExpectationGroupIndex + 1
  return ##class(Stick.Mock.MethodExpectationManager).%New($this, methodName, ..LastExpectationGroupIndex)
}

Method GetStub() As Stick.Stub
{
  return ..Stub
}

Method AddExpectationManager(expectationManager As Stick.Mock.AbstractExpectationManager)
{
  if expectationManager.%IsA("Stick.Mock.MethodExpectationManager") {
    do ..AddMethodExpectationManager(expectationManager)
  }
}

Method AddMethodExpectationManager(expectationManager As Stick.Mock.MethodExpectationManager)
{
  do ..AddToExpectationManagerGroups(..MethodExpectationManagers, expectationManager)
}

Method AddToExpectationManagerGroups(groups As %ListOfObjects, expectationManager As Stick.Mock.AbstractExpectationManager) [ Private ]
{
  do groups.Insert(expectationManager)
}

Method VerifyExpectationManagerGroups(expectationManagerGroups As %ArrayOfObjects) As %Status [ Private ]
{
  
  try {   
    for i=1:1:expectationManagerGroups.Count() {
      set group = expectationManagerGroups.GetAt(i)
      do group.Verify()
    }
  } catch ex {
    return ex.AsStatus()
  }
  
  return $$$OK
}

Method Verify() As %Status
{
     
  $$$QuitOnError(..VerifyWithoutReset())
  do ..ResetMock()
  
  return $$$OK
}

Method VerifyWithoutReset() As %Status
{
  set sc = $$$OK
  
  try {
    $$$ThrowOnError(..VerifyExpectationManagerGroups(..MethodExpectationManagers))
  } catch ex {
    set sc = ex.AsStatus()
  }
  
  return sc
}

Method ResetMock()
{
  do ..GetStub().Reset()
  do ..MethodExpectationManagers.Clear()
}

Method ResetMethodExpectation(methodName As %String)
{
  do ..MethodExpectationManagers.RemoveAt(methodName) 
  set methodStub = ..GetStub().GetMethodStub(methodName)
  if $isobject(methodStub)  do methodStub.Reset()
}

}

