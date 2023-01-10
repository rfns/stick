Include stick

Class Stick.Stub.Method Extends %RegisteredObject
{

Property METHODNAME As %String;

Property Stub As Stick.Stub [ Private ];

Property Spy As Stick.Spy [ Private ];

Property BehaviorAssignments As list Of Stick.Stub.BehaviorAssignment [ Private ];

Property DefaultBehaviorAssignment As Stick.Stub.BehaviorAssignment [ Private ];

Property LastArguments [ MultiDimensional, Private ];

Property CallLimit As %Integer [ InitialExpression = 0, ReadOnly ];

Property LastCallLimitIncrease As %Integer [ InitialExpression = 1, ReadOnly ];

Method %OnNew(stub As Stick.Stub, methodName As %String) As %Status
{
  set ..Stub = stub
  set ..METHODNAME = $$$SubstituteMethodName(methodName)
  set ..DefaultBehaviorAssignment = ##class(Stick.Stub.BehaviorAssignment).%New()
  set ..Spy = stub.GetSpy()
  return $$$OK
}

Method SetCallLimit(newLimit As %Integer)
{
  set i%CallLimit = newLimit
}

Method CallWithArguments(args...) As Stick.Stub.BehaviorAssignment
{
       
  kill i%LastArguments
  merge i%LastArguments = args
  
  set assignment = ..GetMatchingBehaviorAssignment(.args, 1)
  if $isobject(assignment) return assignment

  set assignment = ##class(Stick.Stub.BehaviorAssignment).%New(.args)
  do ..BehaviorAssignments.Insert(assignment)
  
  return assignment
}

Method ThenReturn(value As %String)
{
  merge args = ..LastArguments
  return ..GetMatchingBehaviorAssignment(.args).ThenReturn(value)
}

Method ThenThrow(exception As %Exception.AbstractException)
{
  merge args = ..LastArguments
  return ..GetMatchingBehaviorAssignment(.args).ThenThrow(exception)
}

Method ThenPassthrough()
{
  return ..GetMatchingBehaviorAssignment(.args).ThenPassthrough()
}

Method CallMethod(args...)
{
    
  set assignment = ..GetMatchingBehaviorAssignment(.args)
  set exception = ""
  set returnValue = ""
  set mustThrow = 0
  
  if $isobject(assignment) {
    if assignment.IsPassthrough() {    
      return $method(..Spy, ..METHODNAME, args...)      
    }
  
    if 'assignment.IsPassthrough() && assignment.HasReturnValue() {
      set returnValue = assignment.GetReturnValue()
    }
    
    if 'assignment.IsPassthrough() && assignment.HasException() {
      set exception = assignment.GetException()
      set mustThrow = 1
    }
  }
  
  do ..Spy.GetMethodSpy($$$RealMethodName(..METHODNAME)).Record(.args, exception, returnValue)
      
  do assignment.IncrementCallCount()
  
  if mustThrow = 1 throw exception
  return returnValue
}

Method GetMatchingBehaviorAssignment(ByRef args, exclusive As %Boolean = 0) As Stick.Stub.BehaviorAssignment
{
  for i=1:1:..BehaviorAssignments.Count() {
    set assignment = ..BehaviorAssignments.GetAt(i)
    set behaviorArgs = assignment.KeyArguments
    merge behaviorArgs = assignment.KeyArguments
    
    if ##class(Stick.Helper).ArgumentCompare(.args, .behaviorArgs) {
      return assignment
    }
  }
  
  if 'exclusive return ..DefaultBehaviorAssignment
  return ""
}

Method GetMethodSpy() As Stick.Spy.Method
{
  set assignment = ..GetMatchingBehaviorAssignment()
  if $isobject(assignment) return assignment.GetSpy()
  
  return ##class(Stick.Spy.Method).%New()
}

Method Reset()
{
  set ..LastArguments = ""
  set ..DefaultBehaviorAssignment = ##class(Stick.Stub.BehaviorAssignment).%New()
  
  do ..BehaviorAssignments.Clear()
  do ..Spy.Reset()
}

}

