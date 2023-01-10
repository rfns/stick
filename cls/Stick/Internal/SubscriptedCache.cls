Include stick

Class Stick.Internal.SubscriptedCache Extends %RegisteredObject
{

Property Storage As %String [ MultiDimensional, Private ];

Method Put(value, keys...) As %Status
{
  $$$MultiAsSerial(keys, serializedSubs)  
  set @($$$FormatText("i%Storage(%1)", $lts(serializedSubs))) = value
  return $$$OK
}

Method Forget(keys...) As %Status
{
  $$$MultiAsSerial(keys, serializedSubs)
  kill @($$$FormatText("i%Storage(%1)", $lts(serializedSubs)))
  return $$$OK
}

Method Take(keys...) As %Status
{
  $$$MultiAsSerial(keys, serializedSubs)
  return $get(@($$$FormatText("i%Storage(%1)", $lts(serializedSubs))))
}

Method Hit(keys...) As %Boolean
{
  
  $$$IsValidMulti(keys)
  $$$MultiAsSerial(keys, serializedSubs)  
  return $data(@($$$FormatText("i%Storage(%1)", $lts(serializedSubs))))
}

Method Miss(keys...) As %Boolean
{
  return '..Hit(keys...)
}

}

