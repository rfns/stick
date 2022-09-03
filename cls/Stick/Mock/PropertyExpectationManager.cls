Class Stick.Mock.PropertyExpectationManager Extends (%RegisteredObject, Stick.Mock.AbstractExpectationManager)
{

Method ToEquals(value As %String)
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToEqualsExpectation).Assign($this, value))
}

Method ToNotEquals(value As %String)
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToNotEqualsExpectation).Assign($this, value))
}

Method ToBeLowerThan(value As %String)
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToBeLowerThanExpectation).Assign($this, value))
}

Method ToBeGreaterThan(value As %String)
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToBeGreaterThanExpectation).Assign($this, value))
}

Method ToBeAnObject()
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToBeAnObjectExpectation).Assign($this))
}

Method ToNotBeAnObject()
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToNotBeAnObjectExpectation).Assign($this))
}

Method ToBeNull()
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToBeNullExpectation).Assign($this))
}

Method ToNotBeNull()
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToNotBeNullExpectation).Assign($this))
}

Method ToBeAnInstanceOf(value As %String)
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToBeAnInstanceOf).Assign($this, value))
}

Method ToNotBeAnInstanceOf(value As %String)
{
	return ..AddExpectation(##class(Stick.Mock.PropertyValueToNotBeAnInstanceOfExpectation).Assign($this, value))
}

Method GetSpy() As Stick.Spy.Property
{
	return ..GetStub().GetPropertySpy(..GroupKey)
}

}

