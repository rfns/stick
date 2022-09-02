Class Stick.Stub Extends %RegisteredObject
{

Property "__MethodStubs__" As Stick.MethodStub [ MultiDimensional ];

Property "__Properties__" [ MultiDimensional ];

Method Method(methodName As %String) As Stick.MethodStub
{
	set methodStub = ##class(Stick.MethodStub).%New()
	set i%"__MethodStubs__"(methodName) = methodStub
	return methodStub
}

Method %OnNew() As %Status
{
	return $$$OK
}

/// Is used to implement an unknown method call.  It is also used
/// to resolve an unknown multidimensional property reference (to get the value
/// of a property) because that syntax is identical to a method call.
Method %DispatchMethod(methodName As %String, args...) [ ServerOnly = 1 ]
{
	if '$isobject($get(i%"__MethodStubs__"(methodName))) $$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid method dispatch: "_methodName))
	set methodStub = i%"__MethodStubs__"(methodName)
	
	return methodStub.CallWhileSpying(args...)
}

/// is used to set the value of an unknown property.
Method %DispatchSetProperty(propertyName As %String, value) [ ServerOnly = 1 ]
{
	set i%"__Properties__"(propertyName) = value
}

/// Is used to get the value of an unknown property.
Method %DispatchGetProperty(propertyName As %String) [ ServerOnly = 1 ]
{
	return $get(i%"__Properties__"(propertyName))
}

Method GetMethodStub(methodName As %String) As Stick.MethodStub
{
	if '$isobject($get(i%"__MethodStubs__"(methodName))) $$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid method dispatch: "_methodName))
	set methodStub = i%"__MethodStubs__"(methodName)
	
	return methodStub
}

Method IsMethodStubbed(methodName As %String) As %Boolean
{
	return $isobject($get(i%"__MethodStubs__"(methodName)))
}

Method GetMethodSpy(methodName, ByRef args = "")
{
	return ..GetMethodStub(methodName).GetMethodSpy(.args)
}

Method Clear()
{
	kill i%"__MethodStubs__"
	kill i%"__Properties__"
}

}

