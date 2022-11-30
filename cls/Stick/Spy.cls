Class Stick.Spy Extends %RegisteredObject
{

Property "__Properties__" [ MultiDimensional, Private ];

Property "__PropertySpies__" As Stick.Spy.Property [ MultiDimensional, Private ];

Property "__MethodSpies__" As Stick.Spy.Method [ MultiDimensional, Private ];

Property ReflectionMode As %Boolean [ InitialExpression = 0 ];

Method %DispatchMethod(methodName As %String, args...)
{
  set methodSpy = ..EnsureMethodSpyExists(methodName)
  do methodSpy.Record(.args)
  return ""
}

/// is used to set the value of an unknown property.
Method %DispatchSetProperty(propertyName As %String, value) [ ServerOnly = 1 ]
{
  
  set propertySpy = ..EnsurePropertySpyExists(propertyName) 
  
  if '..ReflectionMode {
    do propertySpy.RecordSetOperation(value)  
  } 
  
  set .."__Properties__"(propertyName) = value
}

/// Is used to get the value of an unknown property.
Method %DispatchGetProperty(propertyName As %String) [ ServerOnly = 1 ]
{
  set propertySpy = ..EnsurePropertySpyExists(propertyName)
  
  if '..ReflectionMode {    
    set value = $get(i%"__Properties__"(propertyName))
    do propertySpy.RecordGetOperation(value)
  }
  
  return $get(i%"__Properties__"(propertyName))
}

Method EnsurePropertySpyExists(propertyName As %String) As Stick.Spy.Property
{
  set spy = $get(i%"__PropertySpies__"(propertyName))
  if $isobject(spy) return spy
  
  set spy = ##class(Stick.Spy.Property).%New(propertyName)
  set i%"__PropertySpies__"(propertyName) = spy
  return spy
}

Method EnsureMethodSpyExists(methodName As %String) As Stick.Spy.Property
{
  set spy = $get(i%"__MethodSpies__"(methodName))
  if $isobject(spy) return spy
  
  set spy = ##class(Stick.Spy.Method).%New()
  set i%"__MethodSpies__"(methodName) = spy
  return spy
}

Method GetMethodSpy(methodName As %String) As Stick.Spy.Method
{
  return ..EnsureMethodSpyExists(methodName)
}

Method GetPropertySpy(propertyName As %String) As Stick.Spy.Property
{
  return ..EnsurePropertySpyExists(propertyName)
}

Method Reset()
{
  set ..LastException = ""
  set ..LastReturnedValue = ""
}

}

