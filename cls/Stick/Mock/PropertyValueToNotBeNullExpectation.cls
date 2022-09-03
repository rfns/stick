Class Stick.Mock.PropertyValueToNotBeNullExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Property, propertyName As %String) As %Status
{
	if $get(spy.Sets(callIndex)) '= $$$NULLOREF  return $$$OK
	return $$$ERROR($$$GeneralError, $$$FormatText("Property '%1' SHOULD have a value that IS NOT NULL (got '%2' instead)", propertyName, spy.Sets(callIndex)))
}

}

