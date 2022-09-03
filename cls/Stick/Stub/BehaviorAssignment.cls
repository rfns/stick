Class Stick.Stub.BehaviorAssignment Extends %RegisteredObject
{

Property Behaviors As list Of Stick.Stub.Behavior [ Private ];

Property Spy As Stick.Spy [ Private ];

Property CallIndex As %Integer [ InitialExpression = 1 ];

Property KeyArguments [ InitialExpression = 0, MultiDimensional ];

Method %OnNew(ByRef args = "") As %Status
{
	merge i%KeyArguments = args
	set ..Behaviors = ##class(%ListOfObjects).%New()
	set ..Spy = ##class(Stick.Spy).%New()	
	
	return $$$OK
}

Method GetSpy() As Stick.Spy
{
	return ..Spy
}

Method IncrementCallCount()
{
	do ..GetSpy().IncrementCallCount()
	set ..CallIndex = ..CallIndex + 1
}

Method GetCurrentBehavior()
{
	return ..Behaviors.GetAt(..CallIndex)
}

Method AddBehavior() As %Status
{
	
	set behavior = ##class(Stick.Stub.Behavior).%New($this)
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

}

