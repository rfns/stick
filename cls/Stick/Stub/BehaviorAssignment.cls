Class Stick.Stub.BehaviorAssignment Extends %RegisteredObject
{

Property Behaviors As list Of Stick.Stub.Behavior [ Private ];

Property Spy As Stick.Spy.Method [ Private ];

Property CallIndex As %Integer [ InitialExpression = 1 ];

Property KeyArguments [ InitialExpression = 0, MultiDimensional ];

Method %OnNew(ByRef args = "") As %Status
{
  merge i%KeyArguments = args
  set ..Behaviors = ##class(%ListOfObjects).%New()
  set ..Spy = ##class(Stick.Spy.Method).%New()
  
  return $$$OK
}

Method GetSpy() As Stick.Spy.Method
{
  return ..Spy
}

Method IncrementCallCount()
{
  set ..CallIndex = ..CallIndex + 1
}

Method GetCurrentBehavior()
{
  return ..Behaviors.GetAt(..CallIndex)
}

Method AddBehavior() As %Status
{
  
  set behavior = ##class(Stick.Stub.Behavior).%New()
  do ..Behaviors.Insert(behavior)
  return behavior
}

Method ThenReturn(value = "")
{
  do ..AddBehavior().ThenReturn(value)
  return $this
}

Method ThenThrow(exception As %Exception.AbstractException)
{
  do ..AddBehavior().ThenThrow(exception)
  return $this
}

Method ThenPassthrough()
{
  do ..AddBehavior().ThenPassthrough()
  return $this
}

Method HasReturnValue() As %Boolean
{
  set behavior = ..GetCurrentBehavior()
  if '$isobject(behavior) return 0
  
  return behavior.HasReturnValue
}

Method HasException() As %Boolean
{
  set behavior = ..GetCurrentBehavior()
  if '$isobject(behavior) return 0
  
  return $isobject(behavior.Exception)
}

Method GetException() As %Exception.AbstractException
{
  return ..GetCurrentBehavior().Exception
}

Method GetReturnValue()
{
  return ..GetCurrentBehavior().ReturnValue
}

Method IsPassthrough()
{
  set behavior = ..GetCurrentBehavior()
  if '$isobject(behavior) return 0
  
  return behavior.Passthrough
}

}

