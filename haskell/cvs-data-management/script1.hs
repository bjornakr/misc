#!/usr/bin/env stack
-- stack runghc --resolver lts-10.9 --install-ghc --package safe --package split

import Data.List
import Data.List.Split
import Safe
import Data.Either
import Control.Monad

data DataSet = DataSet HeaderRow [DataRow]
data HeaderRow = HeaderRow [HeaderVar]
data DataRow = DataRow [DataVar]
data Error = Error String deriving (Show)
data HeaderVar = HeaderVar String deriving (Eq)
data DataVar = DataVar String 

instance Show DataVar where
    show (DataVar s) = "D " ++ s
instance Show HeaderVar where
    show (HeaderVar s) = s

data Id = Id String deriving (Show)
data IdIndex = IdIndex Int deriving (Show)


idVar = "id"

dataz = [
            ["id", "var1", "v2", "v3"],
            ["100AA", "1", "2", "3"],
            ["200BB", "1", "2", "3"]
        ]


-- indexOf :: String -> [HeaderVar] -> Maybe Int
-- indexOf headerVars S = atMay headerVars s






-- ════════════════════════════════════════════════════════════════════════════════════
-- ░▒▓▄   DATA MANAGEMENT   ▀▓▒░
-- ════════════════════════════════════════════════════════════════════════════════════


idIndex :: [HeaderVar] -> Either Error IdIndex
idIndex hs = 
    case elemIndex (HeaderVar idVar) hs of
        Nothing -> Left $ Error ("Could not find index of id in header with variable name: " ++ idVar)
        Just i  -> Right $ IdIndex i

extractHeader :: [[String]] -> Either Error [HeaderVar]
extractHeader [] = Left $ Error "Extract header on empty list."
extractHeader (s:ss) = Right $ map HeaderVar s

extractDataForCase :: [[String]] -> IdIndex -> Id -> Either Error [DataVar]
extractDataForCase ds (IdIndex idx) (Id id0) =
    let filterF row = fmap (== id0) (atMay row idx) in
    
    let extractedCase = do
        k <- filterM filterF ds
        l <- headMay k
        return l    
        in

    case extractedCase of
        Nothing -> Left $ Error ("Could not find case with id " ++ (show id0) ++ " at index " ++ (show idx) ++ ".")
        Just h -> Right $ map DataVar h

        
selectVars :: [HeaderVar] -> [HeaderVar] -> [DataVar] -> Either Error [DataVar]
selectVars vars header data0 =
    let busque var = 
         case elemIndex var header of
            Nothing -> Left $ Error ("Variable does not exist: " ++ show var ++ ".")
            Just a -> Right a
    in
    
    let indexes = mapM busque vars in
    (fmap . map) (data0 !!) indexes


extractDataForCasexz = do
    h <- extractHeader dataz
    idx <- idIndex h
    d <- extractDataForCase dataz idx (Id "200BB")
    return d



header = Data.Either.fromRight [] (extractHeader dataz)

someCase = fromRight [] extractDataForCasexz





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


--something fileName = do
--    fileContents <- readFile fileName


--parse :: Handle -> IO [CbclRow]
--parse inHandle rows = do
--    readFile ""
--    isEof <- hIsEOF inHandle
--    if isEof
--    then 
--        return rows
--    else do
--        row <- hGetLine inHandle
--        parse inHandle ((splitRow row):rows)










main = do   
    let a = [1, 2, 3, 4]
    putStrLn "Hello world!"
