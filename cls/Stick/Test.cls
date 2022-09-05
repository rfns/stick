Class Stick.Test Extends %UnitTest.TestCase
{

ClassMethod Test2()
{
  
  set stub = ##class(Stick.Stub).%New()
  
  do stub.When("%Save").CallWithArguments(1,2,3).ThenReturn(1).ThenReturn(2)
  
  write stub.%Save(1,2,3)
  write stub.%Save(1,2,3)
  
  write stub.GetMethodSpy("%Save", 1,2,3).CallCount
  
  set impl = ##class(Dev.Implementacao).%New()    
  
  set mock = ##class(Stick.Mock).Create(##class(Qualix.RCUsuario).%New())
  do mock.ExpectsMethod("%Save").ToNotReceiveArguments().ToBeCalledOnce().AndThrow(##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError, "it threw")))
  do mock.ExpectsMethod("DefinirSenha").ToBeCalledOnce().ToPassthrough().AndReturn(1)
  
  do impl.FazAlgumaCoisa(mock)
  
  write mock.senha
  
  set sc = mock.Verify()
  zw sc 
    
  //do $$$AssertStatusOK(mock.Verify(), "should have a working mock")
}

}

