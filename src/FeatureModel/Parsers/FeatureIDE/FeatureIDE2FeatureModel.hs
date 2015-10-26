-- Utility module for converting FeatureIDE feature models 
-- into Hephaestus FeatureModels.

module FeatureModel.Parsers.FeatureIDE.FeatureIDE2FeatureModel (featureIDEToFM) 
 where

import FeatureModel.Types

import qualified FeatureModel.Parsers.FeatureIDE.AbsFeatureIDE as P

featureIDEToFM :: P.FeatureModel -> FeatureModel
featureIDEToFM (P.FeatureModel _ (P.FeatureTree fRoot) _) = FeatureModel (featureToFeatureTree fRoot)  []

featureToFeatureTree :: P.Feature -> FeatureTree
featureToFeatureTree (P.Feature    _ mf name)    = Leaf (mapFeature mf BasicFeature name)
featureToFeatureTree (P.AndFeature _ mf name cs) = Root (mapFeature mf BasicFeature name) (map featureToFeatureTree cs)
featureToFeatureTree (P.OrFeature  _ mf name cs) = Root (mapFeature mf OrFeature name) (map featureToFeatureTree cs)
featureToFeatureTree (P.AltFeature _ mf name cs) = Root (mapFeature mf AlternativeFeature name)(map featureToFeatureTree cs)

mapFeature :: P.MandatoryField -> GroupType -> String -> Feature
mapFeature (P.NoMandatoryField) gt name          = Feature name name Optional name gt  [] 
mapFeature (P.MandatoryField P.TrueValue) gt name  = Feature name name Mandatory name gt []
mapFeature (P.MandatoryField P.FalseValue) gt name =Feature name name Optional name gt []
