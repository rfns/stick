Class Stick.Stub.Behavior Extends %RegisteredObject
{

Property ReturnValue As %String;

Property Exception As %Exception.AbstractException;

Property HasReturnValue As %Boolean [ InitialExpression = 0 ];

Property HasException As %Boolean [ InitialExpression = 0 ];

Property Passthrough As %Boolean [ InitialExpression = 0 ];

Method %OnNew() As %Status
{
	return $$$OK
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

Method ThenPassthrough()
{
	if '..HasReturnValue && '..HasException {
		set ..Passthrough = 1
	} else {
		$$$ThrowStatus($$$ERROR($$$GeneralError, "cannot passthrough when stub is already supposed to return or throw."))
	}
}

}

