Class Stick.Internal.MethodImplementationObject Extends %RegisteredObject
{

Property ArgumentList As %List [ Internal ];

Property ImplementationContent As %Stream.Object [ Private ];

Property DefaultArgumentValues As %String;

Method %OnNew(descriptor As %Dictionary.CompiledMethod) As %Status
{
  set ..ArgumentList = descriptor.FormalSpecParsed
  set ..ImplementationContent = descriptor.Implementation  
  
  do ..ParseDefaultArgumentValues(.defaultValues)
  
  set ..DefaultArgumentValues = defaultValues  
  return $$$OK
}

Method GetArgumentList() As %List
{
  return ..ArgumentList
}

Method GetContent() As %Stream.Object
{
  return ..ImplementationContent
}

Method ParseDefaultArgumentValues(Output defaultValues As %List = "") [ Private ]
{
  set argList = ..GetArgumentList()
  set defaultValues = ""
  
  for i=1:1:$ll(argList) {
    set formalSpecArg = $list(argList, i)
    set $list(defaultValues, i) = $listget(formalSpecArg, 4)    
  }
}

Method GetDefaultArgumentValues() As %List
{
  return ..DefaultArgumentValues
}

}

