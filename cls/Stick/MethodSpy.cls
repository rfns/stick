Class Stick.MethodSpy Extends %RegisteredObject
{

Property CallCount As %Integer [ InitialExpression = 0 ];

Property Calls [ MultiDimensional ];

Property LastUsedArguments [ MultiDimensional ];

Property LastException As %Exception.AbstractException;

Property LastReturnedValue;

Method IncrementCallCount()
{
	set ..CallCount = ..CallCount + 1
}

Method Record(ByRef args = "", exception As %Exception.AbstractException = "", returnValue = "")
{
	merge i%LastUsedArguments = args
	set ..LastException = exception
	set ..LastReturnedValue = returnValue
	set i%Calls(..CallCount + 1) = ##class(Stick.MethodSpy.CallRecord).%New(.args, exception, returnValue)
}

}

