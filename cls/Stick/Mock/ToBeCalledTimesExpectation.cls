Class Stick.Mock.ToBeCalledTimesExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Method, methodName As %String) As %Status
{
	if spy.CallCount '= ..Value {
		return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have been called exactly %2 time(s) (got called %3)", methodName, ..Value, spy.CallCount))
	}
	
	return $$$OK
}

Method ToReturn(value = "") As Stick.Mock.ToReturnExpectation
{
	return ..ExpectationManager.ToReturn(value)
}

Method ToThrow(exception As %Exception.AbstractException) As Stick.Mock.ToThrowExpectation
{
	return ..ExpectationManager.ToThrow(exception)
}

Method ToUseArguments(args...) As Stick.Mock.ToUseArgumentsExpectation
{
	return ..ExpectationManager.ToUseArguments(args...)
}

Method ToPassthrough() As Stick.Mock.ToPassthroughExpectation
{
	return ..ExpectationManager.ToPassthrough()
}

}

