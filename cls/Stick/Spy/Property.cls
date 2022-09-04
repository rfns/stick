Class Stick.Spy.Property Extends (%RegisteredObject, Stick.Spy.ICommon)
{

Property GetCount As %Integer [ InitialExpression = 0 ];

Property SetCount As %Integer [ InitialExpression = 0 ];

Property Sets [ MultiDimensional ];

Property Gets [ MultiDimensional ];

Property LastSetValue;

Property LastGetValue;

Method IncreaseGetCount()
{
  set ..GetCount = ..GetCount + 1
}

Method IncreaseSetCount()
{
  set ..SetCount = ..SetCount + 1
}

Method RecordSetOperation(value As %String)
{
  if ..LastSetValue = value  return
  do ..IncreaseSetCount()
  
  set ..LastSetValue = value
  set i%Sets(..SetCount) = value
}

Method RecordGetOperation(value As %String)
{
 
  do ..IncreaseGetCount()
  
  set ..LastGetValue = value
  set i%SetCount(..GetCount) = value
}

}

