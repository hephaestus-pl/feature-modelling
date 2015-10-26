{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
module FeatureModel.Parsers.FMIde.PrintFMIde where

-- pretty-printer generated by the BNF converter

import FeatureModel.Parsers.FMIde.AbsFMIde
import Data.Char


-- the top-level printing method
printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : "," :ts -> showString t . space "," . rend i ts
    t  : ")" :ts -> showString t . showChar ')' . rend i ts
    t  : "]" :ts -> showString t . showChar ']' . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else (' ':s))

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- the printer class does the job
class Print a where
  prt :: Int -> a -> Doc
  prtList :: [a] -> Doc
  prtList = concatD . map (prt 0)

instance Print a => Print [a] where
  prt _ = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j<i then parenth else id


instance Print Integer where
  prt _ x = doc (shows x)


instance Print Double where
  prt _ x = doc (shows x)


instance Print Ident where
  prt _ (Ident i) = doc (showString ( i))



instance Print Grammar where
  prt i e = case e of
   TGrammar productions expressions -> prPrec i 0 (concatD [prt 0 productions , prt 0 expressions])


instance Print Production where
  prt i e = case e of
   TBaseProduction baseprod terms prodname -> prPrec i 0 (concatD [prt 0 baseprod , prt 0 terms , doc (showString "::") , prt 0 prodname , doc (showString ";")])
   TAltProduction altprod options -> prPrec i 0 (concatD [prt 0 altprod , prt 0 options , doc (showString ";")])

  prtList es = case es of
   [] -> (concatD [])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print BaseProd where
  prt i e = case e of
   TBaseProd id -> prPrec i 0 (concatD [prt 0 id , doc (showString ":")])


instance Print AltProd where
  prt i e = case e of
   TAltProd id -> prPrec i 0 (concatD [prt 0 id , doc (showString "|")])


instance Print ProdName where
  prt i e = case e of
   TProdName id -> prPrec i 0 (concatD [prt 0 id])
   TProdNameL id -> prPrec i 0 (concatD [doc (showString "_") , prt 0 id])
   TProdNameR id -> prPrec i 0 (concatD [prt 0 id , doc (showString "_")])


instance Print Term where
  prt i e = case e of
   TTerm id -> prPrec i 0 (concatD [prt 0 id])
   TOptionalTerm id -> prPrec i 0 (concatD [doc (showString "[") , prt 0 id , doc (showString "]")])
   TOrTerm id -> prPrec i 0 (concatD [prt 0 id , doc (showString "+")])
   TXorTerm id -> prPrec i 0 (concatD [prt 0 id , doc (showString "*")])

  prtList es = case es of
   [] -> (concatD [])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print Option where
  prt i e = case e of
   TOption id -> prPrec i 0 (concatD [prt 0 id])

  prtList es = case es of
   [] -> (concatD [])
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , doc (showString "|") , prt 0 xs])

instance Print Expression where
  prt i e = case e of
   BasicExp id -> prPrec i 0 (concatD [prt 0 id])
   OrExp expression0 expression -> prPrec i 0 (concatD [prt 0 expression0 , doc (showString "or") , prt 0 expression])
   AndExp expression0 expression -> prPrec i 0 (concatD [prt 0 expression0 , doc (showString "and") , prt 0 expression])
   NotExp expression -> prPrec i 0 (concatD [doc (showString "not") , prt 0 expression])
   ImpliesExp expression0 expression -> prPrec i 0 (concatD [prt 0 expression0 , doc (showString "implies") , prt 0 expression])

  prtList es = case es of
   [] -> (concatD [])
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , doc (showString ";") , prt 0 xs])

