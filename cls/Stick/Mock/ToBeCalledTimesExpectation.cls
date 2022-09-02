Class Stick.Mock.ToBeCalledTimesExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.MethodSpy, methodName As %String) As %Status
{
	if spy.CallCount '= ..Value {
		return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have been called exactly %2 time(s) (got called %3)", methodName, ..Value, spy.CallCount))
	}
	
	return $$$OK
}

Method ToReturn(value = "")
{
	return ..ExpectationManager.ToReturn(value)
}

Method ToThrow(exception As %Exception.AbstractException)
{
	return ..ExpectationManager.ToThrow(exception)
}

Method ToUseArguments(args...)
{
	return ..ExpectationManager.ToUseArguments(args...)
}

}

