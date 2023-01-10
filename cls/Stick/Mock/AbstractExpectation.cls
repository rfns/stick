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
  
  do expectation.AddBehavior(manager.GetStub().GetMethodStub(manager.GroupKey))
  do expectation.SetSharedExpectation(manager)
  
  return expectation
}

Method GetExpectationManager() As Stick.Mock.AbstractExpectationManager
{
  return ..ExpectationManager
}

Method SetSharedExpectation(manager As Stick.Mock.AbstractExpectationManager)
{
}

Method SetValue(ByRef value = "")
{
  if $data(value) = 1  set ..Value = value
  if $data(value) > 1  merge i%Value = value
}

Method Met()
{
 
  set spy = ..ExpectationManager.GetSpy()
  set groupKey = ..ExpectationManager.GroupKey
  set callIndex = ..ExpectationManager.CallsExpected
  
  $$$ThrowOnError(..ExpectationManager.PreEvaluate(spy))
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

