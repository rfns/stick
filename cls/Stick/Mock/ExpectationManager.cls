Class Stick.Mock.ExpectationManager Extends %RegisteredObject
{

Property Mock As Stick.Mock [ Private ];

Property MethodName As %String;

Property Expectations As list Of Stick.Mock.AbstractExpectation;

Method %OnNew(mock As Stick.Mock, methodName As %String) As %Status
{
	set ..Mock = mock
	set ..MethodName = methodName
	do ..Mock.AddExpectationManager($this)
	return $$$OK
}

Method ToBeCalledNTimes(n As %Integer) As Stick.Mock.ToBeCalledTimesExpectation
{
	return ..AddExpectation(##class(Stick.Mock.ToBeCalledTimesExpectation).Create($this, n))
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

Method ToUseArguments(args...) As Stick.Mock.ToUseArgumentsExpectation
{
	return ..AddExpectation(##class(Stick.Mock.ToUseArgumentsExpectation).Create($this, .args))
}

Method ToReturn(value = "") As Stick.Mock.ExpectationManager
{
	return ..AddExpectation(##class(Stick.Mock.ToReturnExpectation).Create($this, value))
}

Method ToThrow(exception As %Exception.StatusException) As Stick.Mock.ToThrowExpectation
{
	return ..AddExpectation(##class(Stick.Mock.ToThrowExpectation).Create($this, exception))
}

Method AddExpectation(expectation As Stick.Mock.AbstractExpectation) As Stick.Mock.AbstractExpectation
{
	do ..Expectations.Insert(expectation)
	return expectation
}

Method Verify(callIndex As %Integer)
{
	
	for i=1:1:..Expectations.Count() do ..Expectations.GetAt(i).DoAssert(callIndex)
}

Method GetSpy() As Stick.Spy
{
	return ..Mock.GetStub().GetMethodSpy(..MethodName)
}

Method GetMethodName() As %String
{
	return ..MethodName
}

Method GetStub() As Stick.Stub
{
	return ..Mock.GetStub()
}

}

