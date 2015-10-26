module Main where  -- identificar module com Main para o Criterion funcionar

import BasicTypes hiding (Success,Fail)
import Test.HUnit
import FeatureModel.Types
import FeatureModel.FMTypeChecker
import FeatureModel.FCTypeChecker 
import FeatureModel.Analysis
import FeatureModel.OBDD
import qualified Criterion.Main as Criterion
import Test.BenchPress

--inclusão para entrar com argumentos no módulo de teste
import FeatureModel.Main hiding (main)
import System.Environment



a=Feature "a" "a" Mandatory "" BasicFeature []
b=Feature "b" "b" Mandatory "" BasicFeature []
c=Feature "c" "c" Optional "" BasicFeature []
d=Feature "d" "d" Mandatory "" OrFeature []
d1=Feature "d1" "d1" Optional "" AlternativeFeature []
d2=Feature "d2" "d2" Optional "" BasicFeature []
d11=Feature "d11" "d11" Optional "" BasicFeature []
d12=Feature "d12" "d12" Optional "" BasicFeature []
e=Feature "e" "e" Mandatory "" BasicFeature []
f=Feature "f" "f" Optional "" BasicFeature []
g=Feature "g" "g" Optional "" BasicFeature []
h=Feature "h" "h" Mandatory "" OrFeature []
h1=Feature "h1" "h1" Optional "" BasicFeature []
h2=Feature "h2" "h2" Optional "" BasicFeature []
i = Feature "i" "i" Optional "" BasicFeature []


modelo1=FeatureModel{ --satisfativel
	fmTree=Root a[],
	fmConstraints=[]
}
config1= FeatureConfiguration{ -- instancia valida
	fcTree=Root a[]
}

config1_1=FeatureConfiguration{ -- nao e valida pois nao existe a feature b no modelo1
	fcTree=Root b[]
}

modelo2=FeatureModel{ --satisfativel
	fmTree=Root a[Leaf b],
	fmConstraints=[]
}
config2=FeatureConfiguration{
	fcTree=Root a[Leaf b]
}	
config2_1=FeatureConfiguration{ -- nao vale pois 'c' nao esta presente no modelo2
	fcTree=Root a[Leaf b, Leaf c]
}

modelo3=FeatureModel{
	fmTree=Root a[Leaf b,Leaf c], --satisfativel
	fmConstraints=[]
}

modelo4=FeatureModel{
	fmTree=Root a[Leaf b,Leaf c], --insatisfativel pois b e obrigatoria!
	fmConstraints=[Not (FeatureRef "b")]
}
config4=FeatureConfiguration{
	fcTree=Root a[Leaf b,Leaf d]
}

modelo5=FeatureModel{ -- e satisfativel, porem com dead feature ->c
	fmTree=Root a[Leaf b,Leaf c],
	fmConstraints=[Not (FeatureRef "c")]
}

modelo6= FeatureModel{ -- modelo e satisfativiel pois d2 e basica e, pela definicao 
	fmTree=Root a[Leaf b,Leaf c, Root d[Root d1[Leaf d11,Leaf d12], Leaf d2]],
	fmConstraints=[(FeatureRef "d1")|=>(FeatureRef "c")] -- relacao de dependencia entre d1 e c (ambas opcionais)
}
config6=FeatureConfiguration{ -- instancia valida
	fcTree=Root a[Leaf b, Leaf c, (Root d[Leaf d2])]
}
config6_1=FeatureConfiguration{ -- nao e instancia valida pois viola d1->c
	fcTree=Root a[Leaf b, (Root d[Leaf d1])]
}
config6_2=FeatureConfiguration{
	fcTree=Root a[Leaf b, Leaf c,Root d[Leaf d1,Leaf d2]]
}
config6_3=FeatureConfiguration{ -- esta configuracao nao esta de acordo com o modelo6 pois nesse modelo nao consta a feature 'e'
	fcTree=Root a[Leaf b,Root d[Leaf d2],Leaf e]
}

modelo7=FeatureModel{
	fmTree=Root a[Leaf b, Leaf c,(Root d[(Root d1[Leaf d11,Leaf d12]), (Root d2 [Leaf e])])],
	fmConstraints=[]
}
config7=FeatureConfiguration{ -- configuracao nao vale pois nao inclui a filha obrigatoria de d2 -> e (e<->d2)
	fcTree=Root a[Leaf b, (Root d [Leaf d2])]
}
config7_1=FeatureConfiguration{ -- configuracao valida
	fcTree=Root a[Leaf b, (Root d[Root d1[Leaf d11]])]
}

modelo8=FeatureModel{
	fmTree=Root a[Leaf b, Leaf f, Leaf g],
	fmConstraints=[]
}
modelo9=FeatureModel{
	fmTree=Root a[Leaf b, Leaf f, Leaf g], -- aqui gerou produtos com features unicas - f e g e nenhuma das duas, a homogeneidade r numero de produtos = 4, features unicas = 3, logo a homogeneidade=1-3/4=0,25.
	fmConstraints=[Not (And (FeatureRef "f") (FeatureRef "g"))] 
}

modelo10=FeatureModel{
	fmTree=Root a[Leaf b, Leaf c, Leaf i],
	fmConstraints=[(FeatureRef "i") |=> (FeatureRef "c")]
}


teste1=TestCase (assertEqual "Numero de modelos/produtos esperado" 1 (numberOfModels modelo1))
teste2=TestCase (assertEqual "Numero de modelos esperado " 1 (numberOfModels modelo2))
teste3=TestCase (assertEqual "Numero de modelos esperado " 2 (numberOfModels modelo3))

teste4=TestCase (assertBool "Homogeneidade modelo10 " ((0.666 - 0.1 < h) && (h < 0.666 + 0.1)))   
  where h = (homogeneity modelo10)

allTests=TestList [TestLabel "teste1" teste1, TestLabel "teste2" teste2, TestLabel "teste3" teste3, TestLabel "test4" teste4]


main::IO()
main = do
	fModel1 <-parseFeatureModel' $ Options {fmt ="fmp", cmd="bench", fm="/home/luiz/hephaestus/feature-modeling/samples/MobileMedia/fm-mobileMedia.xml",fc="/home/luiz/hephaestus/feature-modeling/samples/MobileMedia/schema_feature-model.rng"}
	fModel2 <-parseFeatureModel' $ Options {fmt="fmide", cmd="bench", fm="/home/luiz/hephaestus/feature-modeling/samples/bench10.m", fc =""}
	--fModel3 <-parseFeatureModel' $ Options {fmt="fmide", cmd="bench", fm="/home/luiz/hephaestus/feature-modeling/samples/bench100.m",fc=""}	
	--fModel4 <-parseFeatureModel' $ Options {fmt="fmide", cmd="bench", fm="/home/luiz/hephaestus/feature-modeling/samples/FeatureIDE/M10/10-299.m", fc =""} --ocorre erro no parse assim *** Exception: syntax error at line 5 before ; Err (Pn 79 7 1)
	fModel5 <-parseFeatureModel' $ Options {fmt="fmide", cmd="bench", fm="/home/luiz/hephaestus/feature-modeling/samples/berkley/model.m", fc =""}
	fModel6 <-parseFeatureModel' $ Options {fmt="fmide", cmd="bench", fm="/home/luiz/hephaestus/feature-modeling/samples/bench200.m", fc =""}	
	fModel7 <-parseFeatureModel' $ Options {fmt="fmide", cmd="bench", fm="/home/luiz/hephaestus/feature-modeling/samples/bench500.m", fc =""}		
	execSummary fModel6
	bench 100 $ print $ homogeneity fModel5
	--bench 100 $ print $ execNumberOfModels fModel6
	--bench 100 $ execCheck1 fModel7 -- testando primeiro modelo com fmTypeChecker (funsat)
	--bench 10 $ execCheck3 fModel7 -- testando primeiro modelo com SAT OBDD, com única repetição -}
	-- Da maneira acima o bench é realizado uma única vez, tentarei via ghci
