Include stick

Class Stick.Stub Extends %RegisteredObject
{

Property "__ClassName__" As %RegisteredObject [ Private ];

Property "__MethodStubs__" As Stick.Stub.Method [ MultiDimensional, Private ];

Property Spy As Stick.Spy [ Private ];

Method %OnNew(className As %String = "", args...) As %Status [ Private ]
{
  set object = "" 
  set replayConstructor = $data(args)
  
  if className '= "" set object = $classmethod(className, "%New", args...) 
  set ..Spy = ##class(Stick.Spy).%New(object, replayConstructor).UseThisStub($this)
  
  return $$$OK
}

ClassMethod Create(className As %String = "", args...) As Stick.Stub
{
  return ..%New(className, args...)
}

Method GetSpy() As Stick.Spy
{
  return ..Spy
}

Method When(methodName As %String) As Stick.Stub.Method
{
  set realMethodName = $$$RealMethodName(methodName)
  
  set methodStub = ##class(Stick.Stub.Method).%New($this, methodName)  
  set i%"__MethodStubs__"(realMethodName) = methodStub
  return methodStub
}

Method GetMethodStub(methodName As %String) As Stick.Stub.Method
{
 
  set realMethodName = $$$RealMethodName(methodName)
  
  if '$isobject($get(i%"__MethodStubs__"(realMethodName))) $$$ThrowStatus($$$ERROR($$$GeneralError, "Unexpected dispatch for non-stubbed method: "_methodName))
  set methodStub = i%"__MethodStubs__"(realMethodName)
  
  return methodStub
}

Method IsMethodStubbed(methodName As %String) As %Boolean
{
  return $isobject($get(i%"__MethodStubs__"(methodName)))
}

Method Reset()
{
  do ..GetSpy().Clear()
  kill i%"__MethodStubs__"
}

Method ResetMethodStub(methodName As %String)
{
  set methodStub = ..GetMethodStub(methodName)
  if $isobject(methodStub) do methodStub.Reset()
}

}

