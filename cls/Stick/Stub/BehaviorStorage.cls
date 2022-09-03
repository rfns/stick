Class Stick.Stub.BehaviorStorage Extends %RegisteredObject
{

Property ExpectedCalls As list Of Stick.MethodCall [ Private ];

Property Spy As Stick.MethodSpy [ Private ];

Property CallIndex As %Integer [ InitialExpression = 1 ];

Property KeyArguments [ InitialExpression = 0, MultiDimensional ];

Method %OnNew(ByRef args = "") As %Status
{
	merge i%KeyArguments = args
	set ..ExpectedCalls = ##class(%ListOfObjects).%New()
	set ..Spy = ##class(Stick.MethodSpy).%New()	
	
	return $$$OK
}

Method GetSpy() As Stick.MethodSpy
{
	return ..Spy
}

Method IncrementCallCount()
{
	do ..GetSpy().IncrementCallCount()
	set ..CallIndex = ..CallIndex + 1
}

Method GetCurrentCall()
{
	return ..ExpectedCalls.GetAt(..CallIndex)
}

Method AddCall() As %Status
{
	
	set call = ##class(Stick.MethodCall).%New($this)
	do ..ExpectedCalls.Insert(call)
	return call
}

Method ThenReturn(value = "")
{
	do ..AddCall().ThenReturn(value)
	return $this
}

Method ThenThrow(exception As %Exception.AbstractException)
{
	do ..AddCall().ThenThrow(exception)
	return $this
}

Method HasReturnValue() As %Boolean
{
	set call = ..GetCurrentCall()
	if '$isobject(call) return 0
	
	return call.HasReturnValue
}

Method HasException() As %Boolean
{
	set call = ..GetCurrentCall()
	if '$isobject(call) return 0
	
	return $isobject(call.Exception)
}

Method GetException() As %Exception.AbstractException
{
	return ..GetCurrentCall().Exception
}

Method GetReturnValue()
{
	return ..GetCurrentCall().ReturnValue
}

Method IsAtEndOfCallStack() As %Boolean
{
	return '$isobject(..GetCurrentCall())
}

}

