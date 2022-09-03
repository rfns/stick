Class Stick.Mock.AbstractExpectationManager [ Abstract ]
{

Property Mock As Stick.Mock [ Private ];

Property Expectations As list Of Stick.Mock.AbstractExpectation [ Private ];

Property GroupKey As %String [ ReadOnly ];

Method %OnNew(mock As Stick.Mock, groupKey As %String) As %Status
{
	set ..Mock = mock
	set i%GroupKey = groupKey
	do ..Mock.AddExpectationManager($this)
	return $$$OK
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

Method GetStub() As Stick.Stub
{
	return ..Mock.GetStub()
}

Method GetSpy()
{
	return ..GetStub().GetSpy(..GroupKey)
}

Method GetPropertySpy() As Stick.Spy.ICommon
{
	return ..GetStub().GetPropertySpy(..GroupKey)
}

}

