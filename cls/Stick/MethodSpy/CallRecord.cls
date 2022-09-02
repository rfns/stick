Class Stick.MethodSpy.CallRecord Extends %RegisteredObject
{

Property ExceptionThrown As %Exception.AbstractException [ ReadOnly ];

Property ReturnedValue As %String [ ReadOnly ];

Property Arguments As %String [ MultiDimensional, ReadOnly ];

Method %OnNew(ByRef args = "", exception As %Exception.AbstractException = "", returnValue = "") As %Status
{
	set i%ExceptionThrown = exception
	set i%ReturnedValue = returnValue
	
	merge i%Arguments = args
	
	return $$$OK
}

}

