Include stickmock

Class Stick.Mock.AbstractExpectation [ Abstract ]
{

Property Value [ MultiDimensional, Private ];

Property ExpectationManager As Stick.Mock.ExpectationManager [ Private ];

Method %OnNew(manager As Stick.Mock.ExpectationManager) As %Status
{
	set ..ExpectationManager = manager
	return $$$OK
}

ClassMethod Create(manager As Stick.Mock.ExpectationManager, ByRef value)
{
	set expectation = ..%New(manager)
	do expectation.SetValue(.value)
	
	do expectation.AddBehavior(manager.GetStub().GetMethodStub(manager.MethodName))
	
	return expectation
}

Method SetValue(ByRef value = "")
{
	if $data(value) = 1  set ..Value = value
	if $data(value) > 1  merge i%Value = value
}

Method DoAssert(callIndex As %Integer)
{
	
	set spy = ..ExpectationManager.GetSpy()
	set methodName = ..ExpectationManager.GetMethodName()
	
	if '$isobject(spy) || ($isobject(spy) && '$data(spy.Calls)) {
		$$$ThrowStatus($$$ERROR($$$GeneralError, $$$FormatText("Stubbed method '%1' doesn't seem to be called.", methodName)))
	}	
	
	$$$ThrowOnError(..OnEvaluate(callIndex, spy, methodName))
	
	return $$$OK
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.MethodSpy, methodName As %String)
{
}

Method AddBehavior(methodStub As Stick.MethodStub)
{
}

}

