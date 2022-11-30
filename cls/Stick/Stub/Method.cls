Class Stick.Stub.Method Extends %RegisteredObject
{

Property METHODNAME As %String;

Property Stub As Stick.Stub [ Private ];

Property Spy As Stick.Spy.Method [ Private ];

Property BehaviorAssignments As list Of Stick.Stub.BehaviorAssignment [ Private ];

Property DefaultBehaviorAssignment As Stick.Stub.BehaviorAssignment [ Private ];

Property LastArguments [ MultiDimensional, Private ];

Method %OnNew(stub As Stick.Stub, methodName As %String) As %Status
{
  set ..Stub = stub
  set ..METHODNAME = methodName
  set ..DefaultBehaviorAssignment = ##class(Stick.Stub.BehaviorAssignment).%New()
  set ..Spy = stub.GetSpy()
  return $$$OK
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
  do ..DefaultBehaviorAssignment.ThenReturn(value)
  return ..DefaultBehaviorAssignment
}

Method ThenThrow(exception As %Exception.AbstractException)
{
  do ..DefaultBehaviorAssignment.ThenThrow(exception)
  return ..DefaultBehaviorAssignment
}

Method ThenPassthrough()
{
  do ..DefaultBehaviorAssignment.ThenPassthrough()
  return ..DefaultBehaviorAssignment
}

Method ProxyMethodCallToSpy(implementationObject As %RegisteredObject = "", args...)
{
  set assignment = ..GetMatchingBehaviorAssignment(.args)
  set exception = ""
  set returnValue = ""
  set mustThrow = 0

  if $isobject(assignment) {
    if assignment.IsPassthrough() && $isobject(implementationObject) {
      try {
        set returnValue = $method(implementationObject, ..METHODNAME, args...)
        do ##class(Stick.Helper).CopyProperties(implementationObject, ..Spy)
      } catch ex {
        if $system.Status.GetErrorText(ex.AsStatus()) '[ "<COMMAND>" {
          set exception = ex
        }
      }
    }

    if 'assignment.IsPassthrough() && assignment.HasReturnValue() {
      set returnValue = assignment.GetReturnValue()
    }

    if 'assignment.IsPassthrough() && assignment.HasException() {
      set exception = assignment.GetException()
      set mustThrow = 1
    }
  }

  do ..Spy.GetMethodSpy(..METHODNAME).Record(.args, exception, returnValue)

  do assignment.IncrementCallCount()

  if mustThrow = 1 throw exception
  return returnValue
}

Method GetMatchingBehaviorAssignment(ByRef args, exclusive As %Boolean = 0) As Stick.Stub.BehaviorAssignment [ Private ]
{
  for i=1:1:..BehaviorAssignments.Count() {
    set assignment = ..BehaviorAssignments.GetAt(i)
    set behaviorArgs = assignment.KeyArguments
    merge behaviorArgs = assignment.KeyArguments

    if ##class(Stick.Helper).ArgumentCompare(.args, .behaviorArgs) {
      return assignment
    }
  }

  if 'exclusive  return ..DefaultBehaviorAssignment
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
  set ..DefaultBehaviorAssignment = ##class(Stick.Stub.BehaviorAssignment).%New()
  do ..BehaviorAssignments.Clear()
}

}

