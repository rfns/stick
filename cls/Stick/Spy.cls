Include (%occErrors, stick)

Class Stick.Spy Extends %RegisteredObject
{

Property "__Properties__" [ Internal, MultiDimensional, Private ];

Property "__MultiDimensionals__" [ Internal, MultiDimensional, Private ];

Property "__PropertySpies__" As Stick.Spy.Property [ Internal, MultiDimensional, Private ];

Property "__MethodSpies__" As Stick.Spy.Method [ Internal, MultiDimensional, Private ];

Property "__Stub__" As Stick.Stub [ Internal, Private ];

Property "__Generator__" As Stick.Internal.BindingRoutineGenerator [ Internal, Private ];

Property ReflectionMode As %Boolean [ InitialExpression = 0 ];

Property RealObject As %RegisteredObject [ Private ];

Method %OnNew(object As %String = "") As %Status
{
  if $isobject(object) {
    if object.%IsA($classname()) {
      $$$ThrowStatus($$$ERROR($$$GeneralError, "Spied object cannot be another spy."))
    }    
    
    set ..RealObject = object
    set .."__Generator__" = ##class(Stick.Internal.BindingRoutineGenerator).%New($classname(..RealObject))
    do .."_FillUsingRealObject"()
  }
    
  
  return $$$OK
}

Method UseThisStub(stub As Stick.Stub)
{
  set .."__Stub__" = stub
  return $this
}

Method "_FillUsingRealObject"() [ Internal, Private ]
{
  set ..ReflectionMode = 1
  do ##class(Stick.Helper).CopyProperties(..RealObject, $this)
  set ..ReflectionMode = 0
}

Method %DispatchMethod(methodName As %String, args...)
{
  
  if .."_MultiDimensionalExists"(methodName, .args) {
    return .."_GetMultiDimensionalValue"(methodName, .args)
  }
  
  return .."_DelegateMethodCall"(methodName, args...)
}

Method "_DelegateMethodCall"(methodName As %String, args...) [ Internal, Private ]
{
 
  set realMethodName = $$$RealMethodName(methodName)
  set shouldCallStub = (
    $isobject(.."__Stub__") &&
    .."__Stub__".IsMethodStubbed(realMethodName) &&
    '.."__Stub__".GetMethodStub(realMethodName).GetMatchingBehaviorAssignment(.args).IsPassthrough()
  )  
  
  if shouldCallStub {
    return .."__Stub__".GetMethodStub(methodName).CallMethod(args...)
  }
  
  if $isobject(..RealObject) {
    return .."_ForwardToImplementation"(realMethodName, args...)
  }
  
  do .."_EnsureMethodSpyExists"($$$RealMethodName(methodName)).Record(.args)
  return ""
}

Method "_ForwardToImplementation"(methodName As %String, args...) [ Internal, Private ]
{
  set returnValue = ""
  set exception = ""
  set realMethodName = $$$RealMethodName(methodName)
  
  try {
    set returnValue = .."__Generator__".Generate(methodName).Run($this, args...)
  } catch ex {
    set exception = ex
  }
  
  do .."_EnsureMethodSpyExists"(realMethodName).Record(.args, exception, returnValue)
  return returnValue
}

Method %DispatchSetProperty(propertyName As %String, value) [ ServerOnly = 1 ]
{
  
  set propertySpy = .."_EnsurePropertySpyExists"(propertyName) 
  
  if '..ReflectionMode {
    do propertySpy.RecordSetOperation(value)  
  } 
  
  set .."__Properties__"(propertyName) = value
}

Method %DispatchGetProperty(propertyName As %String)
{
 
  if .."_MultiDimensionalExists"(propertyName) {
    return .."_GetMultiDimensionalValue"(propertyName)
  }
  
  set propertySpy = .."_EnsurePropertySpyExists"(propertyName)
  set valueExists = $data(i%"__Properties__"(propertyName))
  
  set value = $get(i%"__Properties__"(propertyName)) 
  
  if 'valueExists {
    set value = ..%New()
    set i%"__Properties__"(propertyName) = value
  }
       
  if '..ReflectionMode do propertySpy.RecordGetOperation(value)
  
  return value
}

Method "_EnsurePropertySpyExists"(propertyName As %String) As Stick.Spy.Property [ Internal, Private ]
{
  set spy = $get(i%"__PropertySpies__"(propertyName))
  if $isobject(spy) return spy
  
  set spy = ##class(Stick.Spy.Property).%New(propertyName)
  set i%"__PropertySpies__"(propertyName) = spy
  return spy
}

Method "_EnsureMethodSpyExists"(methodName As %String) As Stick.Spy.Method [ Internal, Private ]
{
  set spy = $get(i%"__MethodSpies__"(methodName))
  if $isobject(spy) return spy
  
  set spy = ##class(Stick.Spy.Method).%New()
  set i%"__MethodSpies__"(methodName) = spy
  return spy
}

Method GetMethodSpy(methodName As %String) As Stick.Spy.Method
{
  return .."_EnsureMethodSpyExists"(methodName)
}

Method GetPropertySpy(propertyName As %String) As Stick.Spy.Property
{
  return .."_EnsurePropertySpyExists"(propertyName)
}

Method Clear()
{
  set ..ReflectionMode = 0
  
  kill i%"__Properties__"
  kill i%"__MethodSpies__"
  kill i%"__PropertySpies__"
  kill i%"__MultiDimensionals__"
  kill i%"__Generator__"    
  
  if $isobject(..RealObject) {
    set .."__Generator__" = ##class(Stick.Internal.BindingRoutineGenerator).%New($classname(..RealObject))
    do .."_FillUsingRealObject"()
  }
}

/// Is used to set the value of an unknown multidimensional property.
Method %DispatchSetMultidimProperty(property As %String, value, subscripts...)
{
  $$$MultiAsSerial(subscripts, serializedSubs)  
  set @($$$FormatText("i%""__MultiDimensionals__""(""%1"", %2)", property, $lts(serializedSubs))) = value
}

Method "_MultiDimensionalExists"(name As %String, ByRef subscripts = "") As %Boolean [ Internal, Private ]
{
  if subscripts = "" return 0
  $$$IsValidMulti(subscripts)
  $$$MultiAsSerial(subscripts, serializedSubs)  
  return $data(@($$$FormatText("i%""__MultiDimensionals__""(""%1"", %2)", name, $lts(serializedSubs))))
}

Method "_GetMultiDimensionalValue"(name As %String, ByRef subscripts = "") [ Internal, Private ]
{
  if '.."_MultiDimensionalExists"(name, .subscripts) return ""
  if subscripts < 1 $$$ThrowStatus($$$ERROR($$$GeneralError, "Listing multidimensional values is not allowed when using spy."))
  
  $$$MultiAsSerial(subscripts, serializedSubs)  
  return $get(@($$$FormatText("i%""__MultiDimensionals__""(""%1"", %2)", name, $lts(serializedSubs))))
}

Method "_KillMultiDimensional"(name) [ Internal ]
{
  kill i%"__MultiDimensionals__"(name)
}

}

