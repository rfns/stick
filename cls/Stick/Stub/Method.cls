Class Stick.Stub.Method Extends %RegisteredObject
{

Property BehaviorAssignments As list Of Stick.Stub.BehaviorAssignment [ Private ];

Property DefaultBehaviorAssignment As Stick.Stub.BehaviorAssignment [ Private ];

Method %OnNew() As %Status
{
	set ..DefaultBehaviorAssignment = ##class(Stick.Stub.BehaviorAssignment).%New()
	return $$$OK
}

Method WhenArguments(args...) As Stick.Stub.BehaviorAssignment
{
				
	set assignment = ..GetMatchingBehaviorAssignment(.args, 1)
	if $isobject(assignment) return assignment

	set assignment = ##class(Stick.Stub.BehaviorAssignment).%New(.args)
	do ..BehaviorAssignments.Insert(assignment)
	
	return behavior
}

Method ThenReturn(value As %String)
{
	do ..DefaultBehaviorAssignment.ThenReturn(value)
	return ..DefaultBehaviorAssignment
}

Method ThenThrow(exception As %Exception.AbstractException)
{
	do ..DefaultBehaviorAssignment.Throw(exception)
	return ..DefaultBehaviorAssignment
}

Method CallWhileSpying(args...)
{
	
	set assignment = ..GetMatchingBehaviorAssignment(.args)
	set exception = ""
	set returnValue = ""
	set uncaughtException = 0
	
	if assignment.HasReturnValue() {
		set returnValue = assignment.GetReturnValue()
	}
	
	if assignment.HasException() {
		set exception = assignment.GetException()
		// Try to throw the exception. The implementation is expected to catch it.
		// If catch block is executed, then something went wrong with the implementation so we force break the test.
		try {
			throw exception
		} catch ex {
			set uncaughtException = 1			
		}
	}
		
	do assignment.GetSpy().Record(.args, exception, returnValue)
	do assignment.IncrementCallCount()
	
	if uncaughtException = 1 {
		$$$ThrowStatus($$$EMBEDSC($$$ERROR($$$GeneralError, "An expected exception has not been caught"), ex.AsStatus()))
	}
	
	return returnValue
}

Method GetMatchingBehaviorAssignment(ByRef args, exclusive As %Boolean = 0) As Stick.Stub.BehaviorAssignment [ Private ]
{
	for i=1:1:..BehaviorAssignments.Count() {
		set assignment = ..BehaviorAssignments.GetAt(i)
		set behaviorArgs = assignment.KeyArguments
		merge behaviorArgs = assignment.KeyArguments
		
		if ##class(Stick.Helper).ArgumentCompare(.args, .behaviorArgs) {
			return storage
		}
	}
	
	if 'exclusive  return ..DefaultBehaviorAssignment
	return ""
}

Method GetMethodSpy(args...) As Stick.Spy
{
	set assignment = ..GetMatchingBehaviorAssignment(.args)
	if $isobject(assignment) return assignment.GetSpy()
	
	return ##class(Stick.Spy).%New()
}

}

