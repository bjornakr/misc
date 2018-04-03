#!/usr/bin/env stack
-- stack runghc --resolver lts-11.0 --install-ghc --package safe --package split

import Data.List
import Data.List.Split
import Safe
import Data.Either
import Control.Monad
import System.Environment
import System.IO

data DataSet = DataSet HeaderRow [DataRow] deriving Show
data HeaderRow = HeaderRow [HeaderVar] deriving Show
data DataRow = DataRow [DataVar] deriving (Show, Eq)
data Error = Error String deriving (Show)
data HeaderVar = HeaderVar String deriving (Eq)
data DataVar = DataVar String deriving (Eq)

instance Show DataVar where
    show (DataVar s) = "D " ++ s
instance Show HeaderVar where
    show (HeaderVar s) = s

data Id = Id String deriving (Show)
data IdIndex = IdIndex Int deriving (Show)


idVar = "id"

testDataSet = 
    DataSet
        (HeaderRow [HeaderVar "id", HeaderVar "var1", HeaderVar "var2", HeaderVar "var3"])
        [
            DataRow [DataVar "100AA", DataVar "1", DataVar "2", DataVar "3"],
            DataRow [DataVar "200BB", DataVar "1", DataVar "2", DataVar "3"]
        ]


-- indexOf :: String -> [HeaderVar] -> Maybe Int
-- indexOf headerVars S = atMay headerVars s






-- ════════════════════════════════════════════════════════════════════════════════════
-- ░▒▓▄   DATA MANAGEMENT   ▀▓▒░
-- ════════════════════════════════════════════════════════════════════════════════════


idIndex :: HeaderRow -> Either Error IdIndex
idIndex (HeaderRow hVars) = 
    case elemIndex (HeaderVar idVar) hVars of
        Nothing -> Left $ Error ("Could not find index of id in header with variable name: " ++ idVar)
        Just i  -> Right $ IdIndex i

--extractHeader :: DataSet -> Either Error HeaderRow
--extractHeader (DataSet []) = Left $ Error "Extract header on empty data set."
--extractHeader (DataSet (s:ss)) = Right $ s

selectCase :: [DataRow] -> IdIndex -> Id -> Either Error DataRow
selectCase drs (IdIndex idx) (Id id0) =

    let 
        filterF :: DataRow -> Maybe Bool
        filterF (DataRow row) = fmap (== (DataVar id0)) (atMay row idx) in
    
    let extractedCase = do
        k <- filterM filterF drs
        l <- headMay k
        return l    
        in

    case extractedCase of
        Nothing -> Left $ Error ("Could not find case with id " ++ (show id0) ++ " at index " ++ (show idx) ++ ".")
        Just h -> Right $ h

        
selectVars :: [HeaderVar] -> [HeaderVar] -> [DataVar] -> Either Error [DataVar]
selectVars vars header data0 =
    let busque var = 
         case elemIndex var header of
            Nothing -> Left $ Error ("Variable does not exist: " ++ show var ++ ".")
            Just a -> Right a
    in
    
    let indexes = mapM busque vars in
    (fmap . map) (data0 !!) indexes


selectMegaCase :: Id -> DataSet -> Either Error DataRow
selectMegaCase id0 (DataSet headerRow dataRows) = do
    --h <- extractHeader data0
    idx <- idIndex headerRow
    d <- selectCase dataRows idx id0
    return d



-- header = fromRight [] (extractHeader dataz)
someCase :: DataRow
someCase = fromRight (error "Breakdown!") (selectMegaCase (Id "200BB") testDataSet)





-- ════════════════════════════════════════════════════════════════════════════════════
-- ░▒▓▄   PARSE DATA FROM FILE   ▀▓▒░
-- ────────────────────────────────────────────────────────────────────────────────────
-- Assuming csv-data with
-- * Separator: ';'
-- * Header row
-- * No quoted strings
-- * No semi-colon in strings
-- ════════════════════════════════════════════════════════════════════════════════════


toDataSet :: [[String]] -> Either Error DataSet
toDataSet [] = Left $ Error("Cannot create dataset: No source data.")
toDataSet (headerRow:dataRows) =    

    let 
        toDataRow :: [String] -> DataRow
        toDataRow s = DataRow (map DataVar s)

        proc :: [[String]] -> [DataRow]
        proc [] = []
        proc (a:as) = (toDataRow a) : proc(as)
    in
        Right $ DataSet (HeaderRow (map HeaderVar headerRow)) (proc dataRows)



parse :: String -> Either Error DataSet
parse s =
    let s1 = lines s
        s2 = map (splitOn ";") s1
    in
    toDataSet s2


testData = "id;var1;var2;var3\n100AA;1;2;3\n200BB;4;5;6"




-- processFile :: Handle -> IO DataSet
-- processFile h = ???






main = do
    --args <- getArgs
    --let handle = case args of
    --    [] -> putStrLn("Hello world")
    --    file:_ ->
    --        withFile file ReadMode 

    --let a = [1, 2, 3, 4]
    c <- hGetContents
    let case200 = do 
        ds <- parse c
        case0 <- selectMegaCase (Id "200BB") ds
        return case0
    case case200 of
        Left(Error msg) -> 
            putStrLn msg
        Right(val) -> 
            putStrLn $ show val
    
    -- let dataset = parse c >>= selectMegaCase (Id "200BB") dataset
 
    
