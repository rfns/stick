Class Stick.Stub.Behavior Extends %RegisteredObject
{

Property Storage As Stick.Stub.BehaviorStorage;

Property ReturnValue As %String;

Property Exception As %Exception.AbstractException;

Property HasReturnValue As %Boolean [ InitialExpression = 0 ];

Method %OnNew(storage As Stick.Stub.BehaviorStorage) As %Status
{
	set ..Storage = storage
	return $$$OK
}

Method AddCall() As Stick.Stub.Behavior
{
	return ..Storage.AddCall()
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

