Class Stick.Mock.PropertyValueToBeLowerThanExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Property, propertyName As %String) As %Status
{
	if $get(spy.Sets(callIndex)) < ..Value  return $$$OK
	return $$$ERROR($$$GeneralError, $$$FormatText("Property '%1' SHOULD have a value that is LOWER THAN '%2' (got '%3' instead)", propertyName, ..Value, spy.Sets(callIndex)))
}

Method ToBeGreaterThan(value)
{
	return ..ExpectationManager.ToBeLowerThan(value)
}

}

