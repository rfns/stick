Class Stick.Mock.PropertyValueToNotBeAnObjectExpectation Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Property, propertyName As %String) As %Status
{
 
	if '$isobject($get(spy.Sets(callIndex))) return $$$OK
	return $$$ERROR($$$GeneralError, $$$FormatText("Property '%1' SHOULD have a value that IS NOT AN OBJECT (got '%2' instead)", propertyName, spy.Sets(callIndex)))
}

}

