Class Stick.Test Extends %UnitTest.TestCase
{

ClassMethod Test2()
{
  set mock = ##class(Stick.Mock).Create()
  do mock.ExpectsMethod("%Save").ToReceiveArguments("blah").AndReturn(0)
  do mock.ExpectsMethod("%Save").ToReceiveArguments("bleh").AndReturn(1)
  do mock.ExpectsMethod("%Saved").ToBeCalledOnce()
  do mock.ExpectsMethod("DefinirSenha").ToReceiveArguments("teste#A123").AndPassthrough()
  do mock.ExpectsProperty("senha").ToNotEquals("")
  
  set mock.senha = 123
  
  do mock.%Save("blah")
  do mock.%Save("bleh")
  do mock.%Saved()
  do mock.DefinirSenha("teste#A123")
  
  set sc = mock.Verify()
  zw sc 
  
  do mock.ExpectsMethod("DefinirSenha").ToReceiveArguments("teste#A123").AndPassthrough()
  do mock.DefinirSenha("teste#A123")
  do mock.DefinirSenha("aaaaaaaaaaaa")
  
  set sc = mock.Verify()
  zw sc
  //do $$$AssertStatusOK(mock.Verify(), "should have a working mock")
}

}

