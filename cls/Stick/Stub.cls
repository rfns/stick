Class Stick.Stub Extends %RegisteredObject
{

Property "__MethodStubs__" As Stick.Stub.Method [ MultiDimensional ];

Property "__Properties__" [ MultiDimensional ];

Method %OnNew(object As %RegisteredObject = "") As %Status
{
	if $isobject(object) do ..CopyFromReflectedActual(object)
	return $$$OK
}

Method Method(methodName As %String) As Stick.Stub.Method
{
	set methodStub = ##class(Stick.Stub.Method).%New()
	set i%"__MethodStubs__"(methodName) = methodStub
	return methodStub
}

Method CopyFromReflectedActual(object As %RegisteredObject)
{
	if object = "" return
	if '$isobject(object) $$$ThrowStatus($$$ERROR($$$GeneralError, "Object to be mocked is not really an object."))
	set classname = $classname(object)
	
	set classDefinition = ##class(%Dictionary.ClassDefinition).%OpenId(classname)
	
	if '$isobject(classDefinition) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Class definition for the provided object is not available or is invalid."))
	}
	
	for i=1:1:classDefinition.Properties.Count() {
		set property = classDefinition.Properties.GetAt(i)
		set propertyName = property.Name
		
		if 'property.Private {
			set $property($this, propertyName) = $property(object, propertyName)
		} else {
			set $property($this, propertyName) = property.InitialExpression
		}
	}
	
	for i=1:1:classDefinition.Methods.Count() {
		set method = classDefinition.Methods.GetAt(i)
		set methodName = method.Name
		
		if 'method.Private {
			do ..Method(methodName)
		}
	}
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

Method GetMethodStub(methodName As %String) As Stick.Stub.Method
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

