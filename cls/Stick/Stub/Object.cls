Class Stick.Stub.Object Extends %RegisteredObject
{

Property "__Stub__" As Stick.Stub [ Private ];

Property Spy As Stick.Spy [ Private ];

Method %OnNew(stub As Stick.Stub, className As %String = "", args...) As %Status [ Private ]
{
  set object = ""  
  set .."__Stub__" = stub
  
  if className '= "" set object = $classmethod(className, "%New", args...)
  set ..Spy = ##class(Stick.Spy).%New(object).UseThisStub($this)
  
  return $$$OK
}

Method GetSpy() As Stick.Spy
{
  return ..Spy
}

Method %DispatchSetProperty(propertyName As %String, value) [ ServerOnly = 1 ]
{
  
  set $property(..Spy, propertyName) = value
}

/// Is used to get the value of an unknown property.
Method %DispatchGetProperty(propertyName As %String) [ ServerOnly = 1 ]
{
  return $property(..Spy, propertyName)
}

Method %DispatchMethod(methodName As %String, args...)
{
  return .."__Stub__".GetMethodStub(methodName).CallMethod(args...)
}

}

