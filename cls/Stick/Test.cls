Class Stick.Test Extends %UnitTest.TestCase
{

ClassMethod Test2()
{
	set mock = ##class(Stick.Mock).Create()
	do mock.ExpectsMethod("%Save").ToBeCalledOnce().ToUseArguments(1,2,3).ToReturn(1)
	do mock.ExpectsMethod("%Saved").ToBeCalledOnce()
	do mock.ExpectsMethod("DefinirSenha").ToUseArguments("teste#A123").ToBeCalledOnce().ToPassthrough().ToReturn(0)
	do mock.ExpectsProperty("senha").ToNotBeAnObject()
	
	set mock.senha = 123
	
	do mock.%Save(1,2,3)
	do mock.%Saved()
	do mock.DefinirSenha("teste#A123")
	
	do mock.ResetMethodExpectation("DefinirSenha")
	
	do mock.ExpectsMethod("DefinirSenha").ToUseArguments("teste#A123").ToBeCalledOnce().ToPassthrough().ToReturn(1)	
	do mock.DefinirSenha("teste#A123")
	
	set sc = mock.Verify()
	zw sc
	//do $$$AssertStatusOK(mock.Verify(), "should have a working mock")
}

}

