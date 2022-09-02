Class Stick.MethodStub Extends %RegisteredObject
{

Property Behaviors As list Of Stick.StubBehavior [ Private ];

Property DefaultBehavior As Stick.StubBehavior [ Private ];

Method %OnNew() As %Status
{
	set ..DefaultBehavior = ##class(Stick.StubBehavior).%New()
	return $$$OK
}

Method WhenArguments(args...) As Stick.StubBehavior
{
				
	set behavior = ..GetMatchingBehavior(.args, 1)
	if $isobject(behavior) return behavior

	set behavior = ##class(Stick.StubBehavior).%New(.args)
	do ..Behaviors.Insert(behavior)
	
	return behavior
}

Method ThenReturn(value As %String)
{
	do ..DefaultBehavior.ThenReturn(value)
	return ..DefaultBehavior
}

Method ThenThrow(exception As %Exception.AbstractException)
{
	do ..DefaultBehavior.Throw(exception)
	return ..DefaultBehavior
}

Method CallWhileSpying(args...)
{
	
	set behavior = ..GetMatchingBehavior(.args)
	set exception = ""
	set returnValue = ""
	set uncaughtException = 0
	
	if behavior.HasReturnValue() {
		set returnValue = behavior.GetReturnValue()
	}
	
	if behavior.HasException() {
		set exception = behavior.GetException()
		// Try to throw the exception. The implementation is expected to catch it.
		// If catch block is executed, then something went wrong with the implementation so we force break the test.
		try {
			throw exception
		} catch ex {
			set uncaughtException = 1			
		}
	}
		
	do behavior.GetSpy().Record(.args, exception, returnValue)
	do behavior.IncrementCallCount()
	
	if uncaughtException = 1 {
		$$$ThrowStatus($$$EMBEDSC($$$ERROR($$$GeneralError, "An expected exception has not been caught"), ex.AsStatus()))
	}
	
	return returnValue
}

Method GetMatchingBehavior(ByRef args, exclusive As %Boolean = 0) As Stick.StubBehavior
{
	for i=1:1:..Behaviors.Count() {
		set behavior = ..Behaviors.GetAt(i)
		set behaviorArgs = behavior.Arguments
		merge behaviorArgs = behavior.Arguments
		
		if ##class(Stick.Helper).ArgumentCompare(.args, .behaviorArgs) {
			return behavior
		}
	}
	
	if 'exclusive  return ..DefaultBehavior
	return ""
}

Method GetMethodSpy(args...) As Stick.MethodSpy
{
	set behavior = ..GetMatchingBehavior(.args)
	if $isobject(behavior) return behavior.GetSpy()
	
	return ##class(Stick.MethodSpy).%New()
}

}

