Class Stick.Mock Extends %RegisteredObject
{

Property Stub As Stick.Stub [ Private ];

Property ExpectationManagers As array Of Stick.Mock.ExpectationManager [ Private ];

Method %OnNew() As %Status
{
	set ..Stub = ##class(Stick.Stub).%New()
	return $$$OK
}

ClassMethod Create() As Stick.Mock
{
	return ..%New()
}

Method EnsureMethodStub(methodName As %String) [ Private ]
{
	if '..Stub.IsMethodStubbed(methodName) {
		do ..Stub.Method(methodName)
	}
}

/// Is used to implement an unknown method call.  It is also used
/// to resolve an unknown multidimensional property reference (to get the value
/// of a property) because that syntax is identical to a method call.
Method %DispatchMethod(methodName As %String, args...) [ ServerOnly = 1 ]
{
	do ..EnsureMethodStub(methodName)
	do $method(..Stub, methodName, args...)
	return $this
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

Method Expects(methodName As %String) As Stick.Mock.ExpectationManager
{
	do ..EnsureMethodStub(methodName)
	return ##class(Stick.Mock.ExpectationManager).%New($this, methodName)
}

Method GetStub() As Stick.Stub
{
	return ..Stub
}

Method AddExpectationManager(expectationManager As Stick.Mock.ExpectationManager)
{
	set group = ##class(%ListOfObjects).%New()
	
	if ..ExpectationManagers.IsDefined(expectationManager.MethodName) {		
		set group = ..ExpectationManagers.GetAt(expectationManager.MethodName)		
	}
	
	do group.Insert(expectationManager)
	do ..ExpectationManagers.SetAt(group, expectationManager.MethodName)
}

Method Verify()
{
	set key = ""
	
	try {		
		while 1 {
			set managerGroup = ..ExpectationManagers.GetNext(.key)
			quit:(key = "" || (managerGroup=""))
		
			for i=1:1:managerGroup.Count()  do managerGroup.GetAt(i).Verify(i)
		
			do managerGroup.Clear()
		}
		do ..ExpectationManagers.Clear()
	} catch ex {
		return ex.AsStatus()
	}
	
	return $$$OK
}

}

