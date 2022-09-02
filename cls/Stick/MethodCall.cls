Class Stick.MethodCall Extends %RegisteredObject
{

Property Behavior As Stick.StubBehavior;

Property ReturnValue As %String;

Property Exception As %Exception.AbstractException;

Property HasReturnValue As %Boolean [ InitialExpression = 0 ];

Method %OnNew(behavior As Stick.StubBehavior) As %Status
{
	set ..Behavior = behavior
	return $$$OK
}

Method AddCall() As Stick.MethodCall
{
	return ..Behavior.AddCall()
}

Method ThenReturn(value)
{
	if $isobject(..Exception) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Cannot return a value when stubbed method is supposed to throw."))
	}
	
	set ..HasReturnValue = 1
	set ..ReturnValue = value
}

Method ThenThrow(exception As %Exception.AbstractException)
{
	if ..HasReturnValue = 1 {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "Cannot throw when stubbed method has a return."))
	}
	
	set ..Exception = exception
}

}

