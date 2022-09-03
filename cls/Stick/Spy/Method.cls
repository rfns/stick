Class Stick.Spy.Method Extends (%RegisteredObject, Stick.Spy.ICommon)
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
	set i%Calls(..CallCount + 1) = ##class(Stick.Spy.CallRecord).%New(.args, exception, returnValue)
}

Method Reset()
{
	set ..LastException = ""
	set ..LastReturnedValue = ""
	kill i%Class
}

}

