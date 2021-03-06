

module FeatureModel.Parsers.FeatureIDE.AbsFeatureIDE where

-- Haskell module generated by the BNF converter




data FeatureModel =
   FeatureModel Header FeatureTree Tail
  deriving (Eq,Ord,Show,Read)

data Header =
   Header
  deriving (Eq,Ord,Show,Read)

data FeatureTree =
   FeatureTree Feature
  deriving (Eq,Ord,Show,Read)

data Feature =
   Feature AbstractField MandatoryField String
 | AndFeature AbstractField MandatoryField String [Feature]
 | AltFeature AbstractField MandatoryField String [Feature]
 | OrFeature AbstractField MandatoryField String [Feature]
  deriving (Eq,Ord,Show,Read)

data AbstractField =
   AbstractField BooleanValue
 | NoAbstractFiel
  deriving (Eq,Ord,Show,Read)

data MandatoryField =
   MandatoryField BooleanValue
 | NoMandatoryField
  deriving (Eq,Ord,Show,Read)

data BooleanValue =
   TrueValue
 | FalseValue
  deriving (Eq,Ord,Show,Read)

data Tail =
   Tail
  deriving (Eq,Ord,Show,Read)

