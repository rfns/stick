Class Stick.Mock Extends %RegisteredObject
{

Property Stub As Stick.Stub [ Private ];

Property MethodExpectationManagers As array Of Stick.Mock.MethodExpectationManager [ Private ];

Property PropertyExpectationManagers As array Of Stick.Mock.PropertyExpectationManager [ Private ];

Method %OnNew(object As %RegisteredObject = "") As %Status
{
  set ..Stub = ##class(Stick.Stub).%New(object)
  return $$$OK
}

ClassMethod Create(object As %RegisteredObject = "") As Stick.Mock
{
  return ..%New(object)
}

Method EnsureMethodStubExists(methodName As %String) [ Private ]
{
  if '..Stub.IsMethodStubbed(methodName) {
    do ..Stub.When(methodName)
  }
}

/// Is used to implement an unknown method call.  It is also used
/// to resolve an unknown multidimensional property reference (to get the value
/// of a property) because that syntax is identical to a method call.
Method %DispatchMethod(methodName As %String, args...) [ ServerOnly = 1 ]
{
  do ..EnsureMethodStubExists(methodName)
  return $method(..Stub, methodName, args...)
}

/// Is used to get the value of an unknown property.
Method %DispatchGetProperty(propertyName As %String) [ ServerOnly = 1 ]
{
  return $property(..Stub, propertyName)
}

/// is used to set the value of an unknown property.
Method %DispatchSetProperty(propertyName As %String, value) [ ServerOnly = 1 ]
{
  set $property(..Stub, propertyName) = value
}

Method ExpectsMethod(methodName As %String) As Stick.Mock.MethodExpectationManager
{
  do ..EnsureMethodStubExists(methodName)  
  return ##class(Stick.Mock.MethodExpectationManager).%New($this, methodName)
}

Method ExpectsProperty(propertyName) As Stick.Mock.PropertyExpectationManager
{
  return ##class(Stick.Mock.PropertyExpectationManager).%New($this, propertyName)
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
  if expectationManager.%IsA("Stick.Mock.PropertyExpectationManager") {
    do ..AddPropertyExpectationManager(expectationManager)
  }
}

Method AddMethodExpectationManager(expectationManager As Stick.Mock.MethodExpectationManager)
{
  do ..AddToExpectationManagerGroups(..MethodExpectationManagers, expectationManager)
}

Method AddPropertyExpectationManager(expectationManager As Stick.Mock.PropertyExpectationManager)
{
  do ..AddToExpectationManagerGroups(..PropertyExpectationManagers, expectationManager)
}

Method AddToExpectationManagerGroups(groups As %ArrayOfObjects, expectationManager As Stick.Mock.AbstractExpectationManager) [ Private ]
{
  set group = ##class(%ListOfObjects).%New()
  
  if groups.IsDefined(expectationManager.GroupKey) {    
    set group = groups.GetAt(expectationManager.GroupKey)   
  }
  
  do group.Insert(expectationManager)
  do groups.SetAt(group, expectationManager.GroupKey)
}

Method VerifyExpectationManagerGroups(expectationManagerGroups As %ArrayOfObjects) As %Status [ Private ]
{
  set key = ""
  
  try {   
    while 1 {
      set managerGroup = expectationManagerGroups.GetNext(.key)
      quit:(key = "" || (managerGroup=""))
    
      set expectationGroupCount = managerGroup.Count()
      for i=1:1:expectationGroupCount  do managerGroup.GetAt(i).Verify(i, expectationGroupCount)
    }
  } catch ex {
    return ex.AsStatus()
  }
  
  return $$$OK
}

Method Verify() As %Status
{
  set sc = $$$OK
  
  try {
    $$$ThrowOnError(..VerifyExpectationManagerGroups(..MethodExpectationManagers))
    $$$ThrowOnError(..VerifyExpectationManagerGroups(..PropertyExpectationManagers))
  } catch ex {
    set sc = ex.AsStatus()
  }   
  
  do ..ResetMock()
  return sc
}

Method ResetMock()
{
  do ..GetStub().ResetStub()
  do ..MethodExpectationManagers.Clear()
  do ..PropertyExpectationManagers.Clear()
}

Method ResetMethodExpectation(methodName As %String)
{
  do ..MethodExpectationManagers.RemoveAt(methodName) 
  set methodStub = ..GetStub().GetMethodStub(methodName)
  if $isobject(methodStub)  do methodStub.Reset()
}

Method ResetPropertyExpectation(methodName As %String)
{
  do ..PropertyExpectationManagers.RemoveAt(methodName) 
  set methodStub = ..GetStub().GetMethodStub(methodName)
  if $isobject(methodStub)  do methodStub.Reset()
}

}

