\begin{code}

module FeatureModel.Parsers.FMPlugin.XmlFeatureModel  where

import CommonUtils

import FeatureModel.Types

type Value =  String
type CMin = Int
type CMax = Int 
type XmlChildren = [XmlFeature]
type XmlGroupOptions = XmlChildren 


data XmlFeature = XmlFeature {
		featureId :: Id,
		cmin :: CMin,
		cmax :: CMax, 
		name :: Name, 
		children :: Maybe XmlChildren,
		group :: Maybe XmlGroupFeature 
	}
	deriving(Show)  
	
data XmlGroupFeature = XmlGroupFeature {
		gmin :: CMin,
		gmax :: CMax, 
		options :: XmlGroupOptions
	}
	deriving(Show)  	

data XmlFeatureConfiguration = XmlFeatureConfiguration {
                cId :: Id,
                cName :: Name, 
                cValue :: Maybe Value,
                cChildren :: Maybe [XmlFeatureConfiguration] 
       } 
       deriving(Show)
	
xmlFeature2FeatureTree :: XmlFeature -> FeatureTree	
xmlFeature2FeatureTree (XmlFeature fid cmin cmax name children group) = 
 case cs of
     Nothing -> Leaf f 
     Just t  -> Root f t  
 where 
  f  =   Feature fid name cardinality value' group' []
  cs =  (childrenFromXmlFeatureList children group)
  cardinality = (featureTypeFromCardinality cmin)
  value' = ""
  group' = (groupTypeFromXmlGroup group)

 

xml2FeatureConfiguration :: XmlFeatureConfiguration -> FeatureConfiguration 
xml2FeatureConfiguration (XmlFeatureConfiguration i n v c) = 
 let 
   f = Feature i n Optional (xmlValue v) BasicFeature [] 
 in case c of   
  Nothing -> FeatureConfiguration (Leaf f)
  Just cs -> FeatureConfiguration (Root f (map xml2Feature cs))

xml2Feature :: XmlFeatureConfiguration -> FeatureTree
xml2Feature (XmlFeatureConfiguration i n v c) = 
 let 
   f = Feature i n Optional (xmlValue v) BasicFeature [] 
 in case c of   
  Nothing -> (Leaf f)
  Just cs -> (Root f (map xml2Feature cs)) 
 
featureTypeFromCardinality :: CMin -> FeatureType	
featureTypeFromCardinality cmin = 
	if (cmin == 0) 
	 then Optional 
	 else Mandatory
	 
groupTypeFromXmlGroup :: (Maybe XmlGroupFeature) -> GroupType
groupTypeFromXmlGroup Nothing = BasicFeature
groupTypeFromXmlGroup (Just (XmlGroupFeature cmin cmax options) )= 
	if (cmin == 1)
	 then AlternativeFeature
	 else OrFeature
	
childrenFromXmlFeatureList :: Maybe XmlChildren -> Maybe XmlGroupFeature -> Maybe [FeatureTree]
childrenFromXmlFeatureList (Just ([]))  Nothing = Nothing 
childrenFromXmlFeatureList _  (Just (XmlGroupFeature _ _ options)) = Just [xmlFeature2FeatureTree x | x <- options] 
childrenFromXmlFeatureList (Just cs) Nothing = Just [xmlFeature2FeatureTree x | x <- cs] 

xmlValue :: Maybe String -> String
xmlValue (Just v) = v
xmlValue (Nothing) = ""
	 
\end{code}	 
 	 
