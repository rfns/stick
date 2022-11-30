Class Stick.Mock.AbstractExpectation [ Abstract ]
{

Property Value [ MultiDimensional, Private ];

Property ExpectationManager As Stick.Mock.AbstractExpectationManager [ Private ];

Method %OnNew(manager As Stick.Mock.AbstractExpectationManager) As %Status
{
  set ..ExpectationManager = manager
  return $$$OK
}

ClassMethod Assign(manager As Stick.Mock.AbstractExpectationManager, ByRef value)
{
  set expectation = ..%New(manager)
  do expectation.SetValue(.value)
  
  if expectation.GetExpectationManager().%IsA("Stick.Mock.MethodExpectationManager") {
    do expectation.AddBehavior(manager.GetStub().GetMethodStub(manager.GroupKey))
  }
  
  return expectation
}

Method GetExpectationManager() As Stick.Mock.AbstractExpectationManager
{
  return ..ExpectationManager
}

Method SetValue(ByRef value = "")
{
  if $data(value) = 1  set ..Value = value
  if $data(value) > 1  merge i%Value = value
}

Method DoAssert(callIndex As %Integer, callsExpected As %Integer)
{
 
  set spy = ..ExpectationManager.GetSpy()
  set groupKey = ..ExpectationManager.GroupKey
  
  $$$QuitOnError(..ExpectationManager.PreEvaluate(callIndex, spy, groupKey, callsExpected))
  $$$ThrowOnError(..OnEvaluate(callIndex, spy, groupKey))
  
  return $$$OK
}

Method OnEvaluate(callIndex As %Integer, spy As Stick.Spy, groupKey As %String)
{
}

Method AddBehavior(methodStub As Stick.Stub.Method)
{
}

}

