module FeatureModel.Parsers.FeatureIDE.SkelFeatureIDE where

-- Haskell module generated by the BNF converter

import FeatureModel.Parsers.FeatureIDE.AbsFeatureIDE
import FeatureModel.Parsers.FeatureIDE.ErrM
type Result = Err String

failure :: Show a => a -> Result
failure x = Bad $ "Undefined case: " ++ show x

transFeatureModel :: FeatureModel -> Result
transFeatureModel x = case x of
  FeatureModel header featuretree tail  -> failure x


transHeader :: Header -> Result
transHeader x = case x of
  Header  -> failure x


transFeatureTree :: FeatureTree -> Result
transFeatureTree x = case x of
  FeatureTree feature  -> failure x


transFeature :: Feature -> Result
transFeature x = case x of
  Feature abstractfield mandatoryfield str  -> failure x
  AndFeature abstractfield mandatoryfield str features  -> failure x
  AltFeature abstractfield mandatoryfield str features  -> failure x
  OrFeature abstractfield mandatoryfield str features  -> failure x


transAbstractField :: AbstractField -> Result
transAbstractField x = case x of
  AbstractField booleanvalue  -> failure x
  NoAbstractFiel  -> failure x


transMandatoryField :: MandatoryField -> Result
transMandatoryField x = case x of
  MandatoryField booleanvalue  -> failure x
  NoMandatoryField  -> failure x


transBooleanValue :: BooleanValue -> Result
transBooleanValue x = case x of
  TrueValue  -> failure x
  FalseValue  -> failure x


transTail :: Tail -> Result
transTail x = case x of
  Tail  -> failure x


