Class Stick.Mock.ToReturnExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method AddBehavior(methodStub As Stick.MethodStub)
{
	do methodStub.ThenReturn(..Value)
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.MethodSpy, methodName As %String) As %Status
{
	if spy.Calls(callIndex).ReturnedValue '= ..Value {
		return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have returned '%2' (returned '%3' instead)", methodName, ..Value, spy.LastReturnedValue))
	}
	
	return $$$OK
}

Method ToBeCalledNTimes(n As %Integer) As Stick.Mock.ToBeCalledTimesExpectation
{
	return ..ExpectationManager.ToBeCalledNTimes(n)
}

Method ToBeCalledOnce() As Stick.Mock.ToBeCalledTimesExpectation
{
	return ..ToBeCalledNTimes(1)
}

Method ToBeCalledTwice() As Stick.Mock.ToBeCalledTimesExpectation
{
	return ..ToBeCalledNTimes(2)
}

Method ToBeCalledThrice() As Stick.Mock.ToBeCalledTimesExpectation
{
	return ..ToBeCalledNTimes(3)
}

Method ToUseArguments(args...)
{
	return ..ExpectationManager.ToUseArguments(args...)
}

}

