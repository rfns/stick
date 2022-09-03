Class Stick.Mock.PropertyValueToNotEqualsExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Property, propertyName As %String) As %Status
{
	if $get(spy.Sets(callIndex)) '= ..Value  return $$$OK
	return $$$ERROR($$$GeneralError, $$$FormatText("Property '%1' SHOULD NOT have a value that equals '%2' (value is '%3')", propertyName, ..Value, spy.Sets(callIndex)))
}

}

