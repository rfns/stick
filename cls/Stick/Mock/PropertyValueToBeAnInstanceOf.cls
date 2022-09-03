Class Stick.Mock.PropertyValueToBeAnInstanceOf Extends (%RegisteredObject, Stick.Mock.AbstractExpectation)
{

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy.Property, propertyName As %String) As %Status
{
	if $isobject($get(spy.Sets(callIndex))) && spy.Sets(callIndex).%IsA(..Value)
	return $$$ERROR($$$GeneralError, $$$FormatText("Property '%1' SHOULD have a value that IS AN INSTANCE OF '%2' (got '%3' instead)", propertyName, ..Value, spy.Sets(callIndex)))
}

}

