Class Stick.Mock.Expectation Extends %RegisteredObject
{

Property Mock As Stick.Mock;

Property MethodName As %String;

Property Expectations As list Of Stick.Mock.AbstractExpectation;

Method %OnNew(mock As Stick.Mock, methodName As %String) As %Status
{
	set ..mock = mock
	do ..mock.AddExpectation($this)
	return $$$OK
}

Method ToBeCalledNTimes(n As %Integer) As Stick.Mock.ToBeCalledTimesExpectation
{
	set ..CallTimeExpectation = ##class(Stick.Mock.ToBeCalledTimesExpectation).Create(..Mock, n)
	return $this
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

Method UsingArguments(args...) As Stick.Mock.UsingArgumentsExpectation
{
	set ..UsingArgumentsExpectation = ##class(Stick.Mock.UsingArgumentsExpectation).Create(..Mock, .args)
	return ..UsingArgumentsExpectation
}

Method ToReturn(value = "") As Stick.Mock.Expectation
{
	set ..ToReturnExpectation = ##class(Stick.Mock.ToReturnExpectation)..Create(..Mock, value = "")
	return ..ToReturn
}

Method ToThrow(exception As %Exception.StatusException) As Stick.Mock.Expectation
{
	set ..ToThrowExpectation = ##class(Stick.Mock.ToThrowExpectation)..Create(..Mock, exception)
	return ..ToThrowExceptionExpectation
}

Method VerifyMethod()
{
	for i=1:1:..Expectations.Count() {
		do ..Expectations.GetAt(i).Assert(..mock)
	}
}

}

