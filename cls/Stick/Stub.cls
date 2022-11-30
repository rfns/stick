Class Stick.Stub Extends %RegisteredObject
{

Property "__ImplementationObject__" As %RegisteredObject [ Private ];

Property "__MethodStubs__" As Stick.Stub.Method [ MultiDimensional ];

Property Spy As Stick.Spy [ Private ];

Method %OnNew(object As %RegisteredObject = "") As %Status
{
  set ..Spy = ##class(Stick.Spy).%New()
  
  if $isobject(object) {
    set .."__ImplementationObject__" = object
    do ..CopyFromReflectedActual(object)
  }   
  
  return $$$OK
}

Method GetSpy() As Stick.Spy
{
  return ..Spy
}

Method When(methodName As %String) As Stick.Stub.Method
{
  set methodStub = ##class(Stick.Stub.Method).%New($this, methodName)
  set i%"__MethodStubs__"(methodName) = methodStub
  return methodStub
}

Method CopyFromReflectedActual(object As %RegisteredObject)
{
  
  set ..Spy.ReflectionMode = 1  
  do ##class(Stick.Helper).CopyProperties(object, ..Spy)
  set ..Spy.ReflectionMode = 0
}

Method %DispatchMethod(methodName As %String, args...)
{
  return ..GetMethodStub(methodName).ProxyMethodCallToSpy(.."__ImplementationObject__", args...)
}

/// is used to set the value of an unknown property.
Method %DispatchSetProperty(propertyName As %String, value) [ ServerOnly = 1 ]
{
  
  set $property(..Spy, propertyName) = value
}

/// Is used to get the value of an unknown property.
Method %DispatchGetProperty(propertyName As %String) [ ServerOnly = 1 ]
{
  return $property(..Spy, propertyName)
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

Method ClearStub()
{
  set .."__ImplementationObject__" = ""
  kill i%"__MethodStubs__"
}

Method ResetStub()
{
  set object = .."__ImplementationObject__"
  do ..ClearStub()
  if $isobject(object) do ..CopyFromReflectedActual(object)
}

Method ResetMethodStub(methodName As %String)
{
  set methodStub = ..GetMethodStub(methodName)
  if $isobject(methodStub) do methodStub.Reset()
}

}

