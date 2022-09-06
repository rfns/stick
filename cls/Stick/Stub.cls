Class Stick.Stub Extends %RegisteredObject
{

Property "__ImplementationObject__" As %RegisteredObject [ Private ];

Property "__MethodStubs__" As Stick.Stub.Method [ MultiDimensional ];

Property "__Properties__" [ MultiDimensional ];

Property "__PropertySpies__" As array Of Stick.Spy.Property [ MultiDimensional ];

Property IsReflecting As %Boolean [ InitialExpression = 0, Private ];

Method %OnNew(object As %RegisteredObject = "") As %Status
{
  if $isobject(object) {
    set .."__ImplementationObject__" = object
    do ..CopyFromReflectedActual(object)
  }
  return $$$OK
}

Method When(methodName As %String) As Stick.Stub.Method
{
  set methodStub = ##class(Stick.Stub.Method).%New($this)
  set i%"__MethodStubs__"(methodName) = methodStub
  return methodStub
}

Method CopyFromReflectedActual(object As %RegisteredObject)
{

  set ..IsReflecting = 1

  do ##class(Stick.Helper).CopyProperties(object, $this)

  set ..IsReflecting = 0
}

/// Is used to implement an unknown method call.  It is also used
/// to resolve an unknown multidimensional property reference (to get the value
/// of a property) because that syntax is identical to a method call.
Method %DispatchMethod(methodName As %String, args...) [ ServerOnly = 1 ]
{
  if '$isobject($get(i%"__MethodStubs__"(methodName))) $$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid method dispatch: "_methodName))
  set methodStub = i%"__MethodStubs__"(methodName)

  return methodStub.CallWhileSpying(.."__ImplementationObject__", methodName, args...)
}

/// is used to set the value of an unknown property.
Method %DispatchSetProperty(propertyName As %String, value) [ ServerOnly = 1 ]
{

  set propertySpy = ..EnsurePropertySpyExists(propertyName)

  if '..IsReflecting {
    do propertySpy.RecordSetOperation(value)
  }

  set i%"__Properties__"(propertyName) = value
}

/// Is used to get the value of an unknown property.
Method %DispatchGetProperty(propertyName As %String) [ ServerOnly = 1 ]
{
  set propertySpy = ..EnsurePropertySpyExists(propertyName)

  if '..IsReflecting {
    set value = $get(i%"__Properties__"(propertyName))
    do propertySpy.RecordGetOperation(value)
  }

  return $get(i%"__Properties__"(propertyName))
}

Method GetMethodStub(methodName As %String) As Stick.Stub.Method
{
  if '$isobject($get(i%"__MethodStubs__"(methodName))) $$$ThrowStatus($$$ERROR($$$GeneralError, "Invalid method dispatch: "_methodName))
  set methodStub = i%"__MethodStubs__"(methodName)

  return methodStub
}

Method GetPropertySpy(propertyName As %String) As Stick.Spy.Property
{
  return $get(i%"__PropertySpies__"(propertyName))
}

Method EnsurePropertySpyExists(propertyName As %String) As Stick.Spy.Property
{
  set spy = $get(i%"__PropertySpies__"(propertyName))
  if $isobject(spy) return spy

  set spy = ##class(Stick.Spy.Property).%New(propertyName)
  set i%"__PropertySpies__"(propertyName) = spy
  return spy
}

Method IsMethodStubbed(methodName As %String) As %Boolean
{
  return $isobject($get(i%"__MethodStubs__"(methodName)))
}

Method GetMethodSpy(methodName, args...) As Stick.Spy.Method
{
  return ..GetMethodStub(methodName).GetMethodSpy(args...)
}

Method ClearStub()
{
  set .."__ImplementationObject__" = ""
  kill i%"__MethodStubs__"
  kill i%"__Properties__"
  kill i%"__PropertySpies__"
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

