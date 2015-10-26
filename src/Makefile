all:
	happy -gca FeatureModel/Parsers/FeatureIDE/ParFeatureIDE.y
	alex -g FeatureModel/Parsers/FeatureIDE/LexFeatureIDE.x
	ghc --make FeatureModel/Parsers/FeatureIDE/TestFeatureIDE.hs -o FeatureModel/Parsers/FeatureIDE/TestFeatureIDE

clean:
	-rm -f FeatureModel/Parsers/FeatureIDE/*.log FeatureModel/Parsers/FeatureIDE/*.aux FeatureModel/Parsers/FeatureIDE/*.hi FeatureModel/Parsers/FeatureIDE/*.o FeatureModel/Parsers/FeatureIDE/*.dvi
	-rm -f FeatureModel/Parsers/FeatureIDE/DocFeatureIDE.ps

distclean: clean
	-rm -f FeatureModel/Parsers/FeatureIDE/DocFeatureIDE.* FeatureModel/Parsers/FeatureIDE/LexFeatureIDE.* FeatureModel/Parsers/FeatureIDE/ParFeatureIDE.* FeatureModel/Parsers/FeatureIDE/LayoutFeatureIDE.* FeatureModel/Parsers/FeatureIDE/SkelFeatureIDE.* FeatureModel/Parsers/FeatureIDE/PrintFeatureIDE.* FeatureModel/Parsers/FeatureIDE/TestFeatureIDE.* FeatureModel/Parsers/FeatureIDE/AbsFeatureIDE.* FeatureModel/Parsers/FeatureIDE/TestFeatureIDE FeatureModel/Parsers/FeatureIDE/ErrM.* FeatureModel/Parsers/FeatureIDE/SharedString.* FeatureModel/Parsers/FeatureIDE/ComposOp.* FeatureModel/Parsers/FeatureIDE/FeatureIDE.dtd FeatureModel/Parsers/FeatureIDE/XMLFeatureIDE.* Makefile*
		-rmdir -p FeatureModel/Parsers/FeatureIDE/

