Class Stick.Mock.ToThrowExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method AddBehavior(methodStub As Stick.MethodStub)
{
	do methodStub.ThenThrow(..Value)
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.MethodSpy, methodName As %String)
{
	
	set expectedStatus = ..Value.AsStatus()
	set receivedStatus = $select($isobject(spy.Calls(callIndex).Exception) : spy.LastException.AsStatus(), 1: "")
	set expectedMessage = $System.Status.GetErrorText(expectedStatus)
	set receivedMessage = $select($$$ISERR(receivedStatus): $System.Status.GetErrorText(receivedStatus), 1: "")
	
	if expectedMessage '= receivedMessage {
		return $$$ERROR($$$GeneralError, $$$FormatText("Method '%1' should have thrown '%2' (but got '%3' instead)", methodName, expectedMessage, receivedMessage))
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

}

