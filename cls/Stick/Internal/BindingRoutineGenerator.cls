Include stick

Class Stick.Internal.BindingRoutineGenerator Extends %RegisteredObject
{

Property TargetClass As %Dictionary.ClassDefinition [ Private ];

Property MethodImplementationCache As Stick.Internal.SubscriptedCache [ Private ];

Property Patcher As Stick.Internal.BindingRoutinePatcher [ Private ];

Property ExecutionContextCache As Stick.Internal.SubscriptedCache [ Private ];

Property RoutineCache As Stick.Internal.SubscriptedCache [ Private ];

Property BindingRoutine As %RegisteredObject [ Private ];

Method %OnNew(targetClass As %String) As %Status
{
  set ..TargetClass = ##class(%Dictionary.CompiledClass).%OpenId(targetClass)
  set ..Patcher = ##class(Stick.Internal.BindingRoutinePatcher).%New($this)
  set ..MethodImplementationCache = ##class(Stick.Internal.SubscriptedCache).%New()
  set ..ExecutionContextCache = ##class(Stick.Internal.SubscriptedCache).%New()
  set ..BindingRoutine = ..CreateBindingRoutine()
  return $$$OK
}

Method GetTargetClass() As %Dictionary.MethodDefinition
{
  return ..TargetClass
}

Method Generate(methodName As %String) As Stick.Internal.RoutineExecutionContext
{
  if ..ExecutionContextCache.Hit(methodName) {
    return ..ExecutionContextCache.Take(methodName)
  }
  
  set executionContext = ..Patcher.Apply(..BindingRoutine, methodName)
  
  $$$ThrowOnError(..BindingRoutine.%Save())
  $$$ThrowOnError(..BindingRoutine.Compile("/nodisplay/keepsource"))
      
  do ..ExecutionContextCache.Put(executionContext, methodName)  
  return executionContext
}

Method CreateBindingRoutine() As %Routine [ Private ]
{
  if $isobject(..BindingRoutine) return ..BindingRoutine
  
  set ..BindingRoutine = ##class(%Routine).%New(..GenerateRoutineName()_".mac")
  do ..BindingRoutine.Clear()
  return ..BindingRoutine
}

Method GenerateRoutineName() As %String [ Private ]
{
  return "Stick.BindingRoutine"_$$$lcase(##class(%xsd.hexBinary).LogicalToXSD($System.Encryption.SHA1Hash(..TargetClass.Name)))
}

Method GetMethodImplementationObject(methodName As %String) As Stick.Internal.MethodImplementationObject
{
  if ..MethodImplementationCache.Hit(methodName, "ImplementationObject") {
    return ..MethodImplementationCache.Take(methodName, "ImplementationObject")
  }    
  
  set descriptor = ##class(%Dictionary.CompiledMethod).%OpenId(..TargetClass.Name_"||"_methodName)
  set object = ##class(Stick.Internal.MethodImplementationObject).%New(descriptor)
  
  do ..MethodImplementationCache.Put(object, methodName, "ImplementationObject")  
  
  return object
}

Method %OnClose() As %Status
{
  if $isobject(..BindingRoutine) return ..BindingRoutine.Delete(..BindingRoutine.Name_".INT")
  return $$$OK
}

}

