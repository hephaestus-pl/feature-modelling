\begin{code}
module FeatureModel.Parsers.FMPlugin.XmlFeatureParser where

import Text.XML.HXT.Core
import System.Environment

import qualified FeatureModel.Types as Base
import FeatureModel.Parsers.FMPlugin.XmlFeatureModel 

instance XmlPickler XmlFeature where
	xpickle = xpFeature

instance XmlPickler XmlGroupFeature where 
	xpickle = xpGroup 

instance XmlPickler XmlFeatureConfiguration where
        xpickle = xpFeatureConfiguration
	
uncurry5 :: (a -> b -> c -> d -> e -> f) -> (a, b, c, d, e) -> f
uncurry5 fn (a, b, c, d, e) = fn a b c d e 

uncurry6 :: (a -> b -> c -> d -> e -> f -> g) -> (a, b, c, d, e, f) -> g
uncurry6 fn (a, b, c, d, e, f) = fn a b c d e f

xpFeature :: PU XmlFeature
xpFeature =
	xpElem "feature" $
	xpWrap (\ (i,m1,m2,n, t, c,g) -> XmlFeature i m1 m2 n c g , 
                \t -> (featureId t, cmin t, cmax t, name t, "NONE", children t, group t)) $
	xp7Tuple (xpAttr "id" xpText)
	         (xpAttr "min" xpickle)
	         (xpAttr "max" xpickle)
                 (xpAttr "name" xpText)
                 (xpAttr "type" xpText) 
	         (xpOption (xpList xpFeature)) 
	         (xpOption (xpGroup))

			 
xpGroup :: PU XmlGroupFeature
xpGroup = 	
	xpElem "featureGroup" $
	xpWrap ( \(m1, m2, i, c) -> XmlGroupFeature m1 m2 c, \ (XmlGroupFeature cmin cmax options) -> (cmin, cmax, "id", options) ) $
	xp4Tuple ( xpAttr "min" xpickle ) 
	         ( xpAttr "max" xpickle ) 
                 ( xpAttr "id" xpText ) 	      
                 ( xpList xpFeature )

xpFeatureConfiguration :: PU XmlFeatureConfiguration
xpFeatureConfiguration = 
        xpElem "feature" $
        xpWrap (\(i, n, t, v, c) -> XmlFeatureConfiguration i n v c, 
                \ (XmlFeatureConfiguration cId cName cValue cChildren) -> (cId, cName, "NONE", cValue, cChildren)) $
        xp5Tuple ( xpAttr "id" xpText )
                 ( xpAttr "name" xpText )
                 ( xpAttr "type" xpText )
		 ( xpOption (xpAttr "value" xpText) )
                 ( xpOption (xpList xpFeatureConfiguration) )
        
\end{code}